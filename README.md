# NaviVim

The in-terminal IDE for **Navi Linux**. Hand-rolled Neovim, no distro
framework — just `lazy.nvim` and one file per feature.

> Close the world. Open the Wired.

## Install (Debian base)

```bash
git clone <your-NaviVim-remote> ~/NaviVim
cd ~/NaviVim
./install.sh                  # full setup: apt deps, Neovim 0.11+, plugins
./install.sh --no-apt         # skip apt (deps already present)
./install.sh --system         # Navi distro installer (as root): system-wide
                              # install, /etc/skel seed, default editor
```

The script installs Neovim from the upstream release tarball (Debian
stable's 0.10 is too old), links this repo to `~/.config/nvim`, seeds the
`nightshadeNeon` theme, and syncs plugins headlessly. Language servers and
formatters install via `:Mason` on first launch.

## Docs

- **`HANDBOOK.md`** — the user guide. Start here.
- **`AGENTS.md`** — the contract for contributors, AI agents, and distro
  integration (layout, keymaps, packaging, rules).

## Layout

```
init.lua               -> loads config.options, keymaps, autocmds, lazy
lua/config/            -> options (vimrc migration), keymaps, autocmds, lazy.nvim bootstrap
lua/plugins/           -> one file per feature (sidebar, completion, search, lsp, ...)
colors/nightshadeNeon.lua -> Navi house colorscheme
after/                 -> transparency trigger, uxntal syntax (ported from vim)
install.sh             -> Debian installer (user or system-wide)
lazy-lock.json         -> pinned plugin versions for reproducible builds
```

## The 30-second tour

| Keys | What |
|---|---|
| `Ctrl+n` / `Space e` | File explorer sidebar |
| `Space ua` | Autocomplete on/off |
| `/` then `Esc` | Search in file, clear highlight |
| `Space ff` / `Space fg` | Find files / grep project |
| `Space` then wait | which-key shows everything |

Leader is **Space**, tapped in sequence, never held.
