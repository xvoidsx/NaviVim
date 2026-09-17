# AGENTS.md — Navi in-terminal IDE (Neovim)

> Share this file with humans and AI agents working on Navi Linux.
> It is the contract for our default terminal IDE experience.
> Source of truth: the **NaviVim repo** (`~/NaviVim`, live at `~/.config/nvim`
> via symlink). Edit the repo, never the symlink target directly.

## 1. What this is

- **Navi** is a Debian-based Linux distro. Target user includes people coming from **vanilla Vim** and **VSCode**.
- The default in-terminal IDE is **hand-rolled Neovim 0.11+** with `lazy.nvim`. No distro framework (no LazyVim / NvChad / LunarVim).
- Doctrine: **editor-first, tmux-enhanced**. Neovim must be fully usable standalone; it shines inside tmux.
- Classic `vim` (9.1) stays installed as fallback. Legacy `~/.vimrc` (11 lines: number, mouse, hlsearch, incsearch, wrap, autoindent, cursorline) is preserved conceptually in `lua/config/options.lua`.

## 2. Layout

```
~/.config/nvim/
  init.lua                        -> requires config.options, config.keymaps, config.autocmds, config.lazy
  lua/config/options.lua          -> vimrc migration + IDE defaults
  lua/config/keymaps.lua          -> all user keymaps (leader = <Space>)
  lua/config/autocmds.lua         -> yank-hl, resize, no-autocomment, transparency re-apply
  lua/config/lazy.lua             -> lazy.nvim bootstrap, spec = { import = "plugins" }
  lua/plugins/sidebar.lua         -> nvim-tree (toggleable file explorer)
  lua/plugins/completion.lua      -> blink.cmp + LuaSnip (toggleable autocomplete)
  lua/plugins/search.lua          -> telescope + fzf-native, flash, hlslens, which-key
  lua/plugins/lsp.lua             -> mason + native vim.lsp.config/enable + fidget + conform + nvim-lint
  lua/plugins/treesitter.lua      -> syntax + indent, polyglot parsers
  lua/plugins/ui.lua              -> lualine, bufferline, alpha dashboard, indent-blankline
                                  (dashboard: 8 shortcut buttons, random tip-of-day footer,
                                   boot reveal + neon header cycling when nightshadeNeon is active)
  lua/plugins/git.lua             -> gitsigns + lazygit
  lua/plugins/editing.lua         -> Comment, autopairs, surround, todo-comments
  lua/plugins/terminal.lua        -> toggleterm + vim-tmux-navigator + persistence
  lua/plugins/theme.lua           -> reads ~/.config/omaterm/nvim.theme, default nightshadeNeon
  colors/nightshadeNeon.lua       -> Navi house colorscheme (#ff10f0 #39ff14 #00ffff #ff3131 #ffffff on #000000)
  after/plugin/transparency.lua   -> startup transparency trigger
  after/syntax/uxntal.vim         -> ported from ~/.vim/pack/plugins/start/uxntal.vim
  after/ftdetect/uxntal.vim       -> ported uxntal filetype detection
  after/ftdetect/gemtext.vim      -> belt-and-braces .gmi detection (syntax itself
                                     ships with Neovim; nightshadeNeon styles its
                                     Heading/LinkURL/Quote/List groups)
```

## 3. Key UX contract (do not break)

Leader is **Space**, tapped in sequence (e.g. `<leader>ff` = Space, f, f).
Pressing Space and waiting shows which-key with every option.

| Feature | Keys | Notes |
|---|---|---|
| Sidebar toggle | `<C-n>`, `<leader>e`, focus `<leader>o` | nvim-tree, 32 cols left |
| Autocomplete toggle | `<leader>ua` | flips `vim.g.navi_completion_enabled`, blink.cmp `enabled()` respects it |
| Search in file | `/`, `n`/`N` centered, `<Esc>` clears | `ignorecase+smartcase`, hlslens counts, `s` flash-jump |
| Project find/grep | `<leader>ff` files, `<leader>fg` grep, `<leader>fb` buffers, `<leader>/` buffer-fuzzy | Telescope + ripgrep + fd |
| Save/quit | `<C-s>` / `<leader>w`, `<leader>q` | VSCode muscle memory |
| Splits | `<leader>\|`, `<leader>-`, `<C-h/j/k/l>` | tmux-aware via vim-tmux-navigator |
| Buffers | `<S-h>` / `<S-l>`, `<leader>bd` | bufferline |
| LSP | `gd gr K <leader>rn <leader>ca [d ]d` | attached via LspAttach autocmd |
| Format toggle | `<leader>uf` | conform.nvim, default ON |
| Git | `<leader>gg` lazygit, `<leader>gp`/`gb`, `[h`/`]h` | gitsigns gutter |
| Terminal | `<leader>tt` or `<C-\>`, `<Esc><Esc>` exits term mode | toggleterm |
| Session | `<leader>qs` restore | persistence.nvim |
| Relative numbers | `<leader>un` toggles | default ON with number |

## 4. Dependencies (for Navi packaging)

- Must: `neovim>=0.11`, `git`, `ripgrep`, `fd-find` (binary `fd`; shim `fdfind` if needed), `node`, `python3`, `make`/`gcc` (telescope-fzf-native, treesitter), Nerd Font.
- Neovim source: Debian stable ships 0.10 (too old — mason-lspconfig v2 and
  friends need 0.11+). Do NOT pin Neovim to Debian testing (testing libc on a
  stable base). Instead use `NaviVim/install.sh`, which installs the
  upstream release tarball (user-space `~/.local` by default,
  `PREFIX=/usr/local` as root for system-wide/ISO use; privilege escalation
  prefers `doas`, falling back to `sudo`).
- Optional but expected: `tmux`, `lazygit`, language servers via `:Mason` (lua_ls, pyright, ts_ls, rust_analyzer, gopls, clangd, bashls, jsonls, yamlls), formatters (stylua, shfmt, black/isort, prettier), linters (flake8, shellcheck).
- Seed path for ISO: `/etc/skel/.config/nvim` (copy of this config). Theme override: `/etc/skel/.config/omaterm/nvim.theme`.
  `install.sh --system` (run as root from the Navi installer) handles the whole
  distro install: tarball to `/usr/local`, skel seed, `editor`/`vi` alternatives,
  `EDITOR`/`VISUAL` via `/etc/profile.d`, and a deterministic `Lazy! restore`
  from `lazy-lock.json` as a build-time smoke test. User mode (`./install.sh`)
  rolls forward with `Lazy! sync` — commit the updated lockfile.
- uxntal rule: keep `~/.vim/pack/plugins/start/uxntal.vim` AND `after/syntax|ftdetect/uxntal.vim` in sync.
- Version pins: `nvim-treesitter/*` stays on `branch = "master"` (legacy `configs` API; migrating to `main` needs a config rewrite). All other 0.10-era pins are dropped now that Navi requires 0.11+.

## 5. Commands agents should use

```bash
# install / sync plugins (headless)
nvim --headless "+Lazy! sync" +qa
# health
nvim --headless "+checkhealth" +qa
# LSP servers UI
nvim "+Mason"
# smoke test toggles (manual)
nvim -c "NvimTreeToggle" -c "Telescope find_files"
```

Test matrix before shipping: open `.py .js .ts .lua .c .md .tal` files, toggle sidebar (`<C-n>`), toggle completion (`<leader>ua` then type in insert mode), `/` search + `Esc`, `:Telescope live_grep`, `:checkhealth` clean (except optional clipboard warnings outside tmux).

## 6. Rules for contributors / agents

1. Hand-rolled only — do NOT reintroduce LazyVim/NvChad as a dependency.
2. Every new plugin gets its own `lua/plugins/*.lua` file + keymaps with `desc` (which-key discoverable).
3. Every toggle (completion, format, tree) must have a `<leader>u*` or documented key and persist via `vim.g.navi_*`.
4. Keep standalone-nvim working; tmux integration must degrade gracefully (see `vim-tmux-navigator` fallback to `<C-w>` maps).
5. Keep transparency behavior: `ColorScheme` autocmd in `config/autocmds.lua` + startup trigger. Add new float groups there, not inline.
6. Theme changes go through `plugins/theme.lua` + `omaterm/nvim.theme`, never hardcoded `colorscheme` elsewhere.
7. Run `stylua` (2-space, 120 col per `stylua.toml`) on Lua edits.

## 7. Roadmap / ideas (not yet built)

- `nvim-dap + nvim-dap-ui` for debugging (Python/JS/C first).
- Migrate `nvim-treesitter` from `master` to `main` branch (new API).
- `snacks.picker` or `fzf-lua` evaluation if Telescope feels slow on Navi hardware.
- Navi `tmux.conf` with matching `C-h/j/k/l` + session-restore + statusline theme sync.
- `:NaviWelcome` command linking to distro docs.
