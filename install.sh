#!/usr/bin/env bash
# NaviVim installer — Debian base (Navi Linux).
#
# What it does:
#   1. Installs system deps via apt (needs root; skipped with --no-apt).
#   2. Installs Neovim 0.11+ from the upstream release tarball.
#      Default is user-space (~/.local, no root needed).
#   3. Links this repo as ~/.config/nvim (when run from elsewhere).
#   4. Sets the default theme and syncs plugins headlessly.
#   5. With --system (Navi distro installer): system-wide install under
#      PREFIX (/usr/local), seeds /etc/skel for new users, and registers
#      NaviVim as the default editor.
#
# Usage:
#   ./install.sh                  # user install, everything to ~/.local
#   ./install.sh --no-apt         # skip apt (deps already present)
#   ./install.sh --system         # distro install (run as root in Navi installer)
#
# Env knobs:
#   NVIM_VERSION=x.y.z   install a specific version (default: latest stable)
#   PREFIX=...           install prefix (default: $HOME/.local, or /usr/local with --system)
#   NVIM_TARBALL=path    use a local neovim release tarball instead of
#                        downloading one (distro installers staging it offline)
#   NAVIVIM_SKIP_NVIM=1  skip the neovim tarball install entirely (binary
#                        already in place — makes re-runs cheap/idempotent)
#   NAVIVIM_SKIP_PLUGINS=1
#                        skip the headless plugin restore/sync (offline
#                        installs; plugins sync on first nvim launch)
#
# Navi ISO integration: call `./install.sh --system` (as root, with network)
# from the distro's initial installer script. Per-user plugin sync and Mason
# servers install automatically on first launch.

set -euo pipefail

PREFIX="${PREFIX:-}"
NVIM_VERSION="${NVIM_VERSION:-stable}"
NVIM_TARBALL="${NVIM_TARBALL:-}"
NAVIVIM_SKIP_NVIM="${NAVIVIM_SKIP_NVIM:-0}"
NAVIVIM_SKIP_PLUGINS="${NAVIVIM_SKIP_PLUGINS:-0}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DO_APT=1
SYSTEM=0
for arg in "$@"; do
  case "$arg" in
    --no-apt) DO_APT=0 ;;
    --system) SYSTEM=1 ;;
    *) echo "Unknown arg: $arg" >&2; exit 1 ;;
  esac
done

if [ "$SYSTEM" -eq 1 ]; then
  PREFIX="${PREFIX:-/usr/local}"
  [ "$(id -u)" -eq 0 ] || { echo "--system requires root (Navi installer context)." >&2; exit 1; }
else
  PREFIX="${PREFIX:-$HOME/.local}"
fi

log() { printf '==> %s\n' "$*"; }

# 1. System deps -----------------------------------------------------------
# Privilege escalation: Navi uses `doas` by default, plain Debian uses
# `sudo`, and the distro installer already runs as root (no helper needed).
# Non-interactive throughout so this runs unattended inside the Navi installer.
if [ "$(id -u)" -eq 0 ]; then
  PRIV=""
elif command -v doas >/dev/null 2>&1; then
  PRIV="doas"
elif command -v sudo >/dev/null 2>&1; then
  PRIV="sudo"
else
  echo "Need root, doas, or sudo for the apt step (or re-run with --no-apt)." >&2
  exit 1
fi
if [ "$DO_APT" -eq 1 ]; then
  log "Installing system packages..."
  export DEBIAN_FRONTEND=noninteractive
  $PRIV apt update
  # git/curl/tar: fetching. ripgrep/fd-find: Telescope. gcc/make: fzf-native
  # + treesitter parsers. python3/nodejs: providers. shellcheck/tmux: lint + IDE.
  # doas itself: Navi's privilege helper (no-op if already present).
  # lazygit is best-effort (absent on some Debian releases).
  $PRIV apt install -y git curl tar ripgrep fd-find build-essential \
    python3 python3-pip nodejs npm shellcheck tmux doas
  $PRIV apt install -y lazygit || log "lazygit not in apt, skipping (optional)."
else
  log "Skipping apt (--no-apt)."
fi

for cmd in git curl tar rg gcc make python3 node; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Missing required tool: $cmd" >&2; exit 1; }
done

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) NVIM_ARCH="x86_64" ;;
  aarch64|arm64) NVIM_ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

# Debian names the fd binary `fdfind`; Telescope wants `fd`. Shim it.
mkdir -p "$PREFIX/bin"
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$PREFIX/bin/fd"
  log "Shimmed fdfind -> $PREFIX/bin/fd"
fi

# No privilege helper / no fd? Grab upstream's static binary (musl, runs anywhere).
if ! command -v fd >/dev/null 2>&1; then
  case "$ARCH" in
    x86_64) FD_ARCH="x86_64-unknown-linux-musl" ;;
    *) FD_ARCH="aarch64-unknown-linux-musl" ;;
  esac
  FD_TAG="$(curl -fsSL -o /dev/null -w '%{url_effective}' \
    https://github.com/sharkdp/fd/releases/latest | grep -o '[^/]*$')"
  log "Fetching fd $FD_TAG (static binary)..."
  curl -fsSL -o "$TMPDIR/fd.tar.gz" \
    "https://github.com/sharkdp/fd/releases/download/${FD_TAG}/fd-${FD_TAG}-${FD_ARCH}.tar.gz"
  tar -xzf "$TMPDIR/fd.tar.gz" -C "$TMPDIR"
  cp -a "$TMPDIR"/fd-"${FD_TAG}"-"${FD_ARCH}"/fd "$PREFIX/bin/fd"
  chmod +x "$PREFIX/bin/fd"
fi
command -v fd >/dev/null 2>&1 || { echo "Missing required tool: fd (fd-find)" >&2; exit 1; }

# 2. Neovim 0.11+ from upstream --------------------------------------------
# Debian stable ships 0.10 (too old: mason-lspconfig v2, gitsigns, and
# nvim-lspconfig now need 0.11+). Pinning Neovim to Debian testing would
# drag testing libc onto a stable base — the tarball avoids that entirely.
if [ "$NAVIVIM_SKIP_NVIM" = "1" ]; then
  log "Skipping Neovim install (NAVIVIM_SKIP_NVIM=1) — binary already in place."
else
  if [ -n "$NVIM_TARBALL" ]; then
    # distro installers stage the tarball offline: use it, don't download.
    [ -f "$NVIM_TARBALL" ] || { echo "NVIM_TARBALL not found: $NVIM_TARBALL" >&2; exit 1; }
    log "Using staged Neovim tarball: $NVIM_TARBALL"
    cp -a "$NVIM_TARBALL" "$TMPDIR/nvim.tar.gz"
  else
    if [ "$NVIM_VERSION" = "stable" ]; then
      NVIM_TAG="$(curl -fsSL -o /dev/null -w '%{url_effective}' \
        https://github.com/neovim/neovim/releases/latest | grep -o '[^/]*$')"
    else
      NVIM_TAG="$NVIM_VERSION"
    fi
    log "Neovim release: $NVIM_TAG ($NVIM_ARCH) -> $PREFIX"

    curl -fsSL -o "$TMPDIR/nvim.tar.gz" \
      "https://github.com/neovim/neovim/releases/download/${NVIM_TAG}/nvim-linux-${NVIM_ARCH}.tar.gz"
  fi
  tar -xzf "$TMPDIR/nvim.tar.gz" -C "$TMPDIR"
  [ -d "$TMPDIR/nvim-linux-${NVIM_ARCH}" ] \
    || { echo "tarball arch mismatch: expected nvim-linux-${NVIM_ARCH}" >&2; exit 1; }
  mkdir -p "$PREFIX"
  # Tarball extracts to nvim-linux-<arch>/; merge its bin/lib/share into PREFIX.
  cp -a "$TMPDIR"/nvim-linux-"${NVIM_ARCH}"/* "$PREFIX"/
  mkdir -p "$PREFIX/bin"
  log "Neovim version installed:"
  "$PREFIX/bin/nvim" --version | head -n 1
fi

case ":$PATH:" in
  *":$PREFIX/bin:"*) ;;
  *) log "NOTE: add to your shell rc: export PATH=\"$PREFIX/bin:\$PATH\"" ;;
esac

# 3. Link config (user installs only) --------------------------------------
# In --system mode there is no user to link for; new users get the config
# from /etc/skel (see section 5). Running as root, $HOME is root's home,
# so linking here would only pollute the root account: skip it.
if [ "$SYSTEM" -eq 1 ]; then
  log "System mode: skipping \$HOME link (seeding /etc/skel instead)."
else
  # Compare resolved paths so re-running from the live config (or through the
  # ~/.config/nvim symlink itself) is a harmless no-op.
  REPO_REAL="$(readlink -f "$REPO_DIR")"
  NVIM_REAL="$(readlink -f "$HOME/.config/nvim" 2>/dev/null || true)"
  if [ "$REPO_REAL" != "$NVIM_REAL" ]; then
    log "Linking $REPO_DIR -> ~/.config/nvim"
    mkdir -p "$HOME/.config"
    if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
      BACKUP="$HOME/nvim-backup-$(date +%Y%m%d-%H%M%S)"
      log "Backing up existing config to $BACKUP"
      mv "$HOME/.config/nvim" "$BACKUP"
    fi
    ln -sfn "$REPO_DIR" "$HOME/.config/nvim"
  else
    log "$HOME/.config/nvim already points here, skipping link."
  fi

  # 4. Theme default (user installs only; system mode seeds /etc/skel) -------
  mkdir -p "$HOME/.config/omaterm"
  if [ ! -f "$HOME/.config/omaterm/nvim.theme" ]; then
    echo "nightshadeNeon" > "$HOME/.config/omaterm/nvim.theme"
    log "Default theme: nightshadeNeon"
  fi
fi

# Plugin install -------------------------------------------------------------
# User mode rolls forward (sync = latest, updates lazy-lock.json — commit it).
# System/ISO mode restores exactly the locked versions for reproducible builds,
# against a throwaway config pointing at the repo (never touches $HOME).
# Offline installs skip this step entirely — first nvim launch syncs.
if [ "$NAVIVIM_SKIP_PLUGINS" = "1" ]; then
  log "Skipping plugin restore (NAVIVIM_SKIP_PLUGINS=1) — first launch syncs."
elif [ "$SYSTEM" -eq 1 ]; then
  log "Restoring locked plugins (build-time smoke test)..."
  SMOKE_HOME="$(mktemp -d)"
  ln -s "$REPO_DIR" "$SMOKE_HOME/nvim"
  XDG_CONFIG_HOME="$SMOKE_HOME" "$PREFIX/bin/nvim" --headless "+Lazy! restore" +qa
  rm -rf "$SMOKE_HOME"
else
  log "Syncing plugins (headless)..."
  "$PREFIX/bin/nvim" --headless "+Lazy! sync" +qa
fi

# 5. Distro defaults (--system only) ------------------------------------------
# Makes NaviVim the default editor for every current and future user:
#   - /etc/skel seeds the config + theme into each new home directory
#   - update-alternatives points editor/vi at NaviVim
#   - /etc/profile.d exports EDITOR/VISUAL
if [ "$SYSTEM" -eq 1 ]; then
  log "Seeding /etc/skel for new users..."
  mkdir -p /etc/skel/.config /etc/skel/.config/omaterm
  rm -rf /etc/skel/.config/nvim
  cp -a "$REPO_DIR" /etc/skel/.config/nvim
  # The seed is a pristine copy: drop machine-local state if ever present.
  rm -rf /etc/skel/.config/nvim/.git
  if [ ! -f /etc/skel/.config/omaterm/nvim.theme ]; then
    echo "nightshadeNeon" > /etc/skel/.config/omaterm/nvim.theme
  fi

  log "Registering NaviVim as the default editor..."
  update-alternatives --install /usr/bin/editor editor "$PREFIX/bin/nvim" 100
  update-alternatives --install /usr/bin/vi vi "$PREFIX/bin/nvim" 100
  update-alternatives --set editor "$PREFIX/bin/nvim"
  update-alternatives --set vi "$PREFIX/bin/nvim"
  cat > /etc/profile.d/navivim.sh <<EOF
# NaviVim: default terminal IDE on Navi Linux.
export EDITOR="$PREFIX/bin/nvim"
export VISUAL="\$EDITOR"
EOF
  log "System install complete: editor/vi -> $PREFIX/bin/nvim, skel seeded."
fi

log "Done. Next steps:"
log "  1. Run: nvim  (dashboard greets you)"
log "  2. Inside nvim run :Mason to install language servers"
log "  3. Read the handbook: ~/.config/nvim/HANDBOOK.md"
