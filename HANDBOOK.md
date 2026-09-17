# NaviVim Handbook

> Your in-terminal IDE. Close the world. Open the Wired.

New here? This guide takes you from zero to comfortable. Looking for
contributor/agent docs instead? See `~/AGENTS.md`.

## 0. The one thing to learn first: `<leader>`

Almost every shortcut in this book starts with `<leader>`. That's just a
name for a **prefix key** — and in NaviVim it's the **Space bar**.

- You **tap** it, you don't hold it (unlike Ctrl).
- So `<leader>ff` means: tap **Space**, tap `f`, tap `f`.
- `<leader>ua` means: tap **Space**, tap `u`, tap `a`.
- Stuck? Tap **Space** and wait half a second — a menu pops up showing
  every shortcut available from there. You never have to memorize.

## 1. First launch

```bash
nvim
```

You'll land on the NaviVim dashboard — the logo boots up line by line,
then cycles through the neon palette in celebration of the Wired.
From there:

| Key | What it does                |
|-----|-----------------------------|
| `f` | Find a file by name         |
| `e` | Open the file explorer      |
| `g` | Search text in your project |
| `b` | Switch between open buffers |
| `t` | Open a terminal             |
| `m` | Manage language servers (`:Mason`) |
| `p` | Manage plugins (`:Lazy`)    |
| `q` | Quit                        |

Each visit also shows a random **tip of the day** at the bottom —
little shortcuts worth learning one at a time.

On first launch, also run `:Mason` to install language servers
(Python, JavaScript, Rust, Go, C, Lua, and more). Pick what you use —
everything else is optional.

## 2. The sidebar (file explorer)

| Key          | What it does              |
|--------------|---------------------------|
| `Ctrl+n`     | Toggle the sidebar        |
| `Space e`    | Toggle the sidebar (backup if `Ctrl+n` is swallowed by tmux) |
| `Space o`    | Jump to your current file in the tree |

Inside the tree:

| Key       | What it does              |
|-----------|---------------------------|
| `j` / `k` | Move up / down            |
| `Enter`/`l` | Open file / expand folder |
| `h`       | Collapse folder           |
| `a`       | Create file / folder      |
| `d`       | Delete                    |
| `r`       | Rename                    |
| `x` `c` `p` | Cut, copy, paste        |
| `R`       | Refresh                   |
| `?`       | Full help overlay         |
| `q`       | Close the sidebar         |

## 3. Searching

- `/` — search inside the current file (`n` / `N` jump between hits,
  `Esc` clears the highlight).
- `s` — flash-jump: labels appear on screen, type one to teleport.
- `Space ff` — find files by name across the project.
- `Space fg` — grep text across the whole project.
- `Space /` — fuzzy-find inside the current file.
- `Space fb` — switch between open buffers.

## 4. Everyday editing

| Key              | What it does              |
|------------------|---------------------------|
| `Ctrl+s` / `Space w` | Save                  |
| `Space q`        | Quit                    |
| `gcc`            | Comment / uncomment a line (`gc` works on selections too) |
| `Alt+j` / `Alt+k` | Move line / selection down / up |
| `<` / `>` (visual) | Indent, staying selected |
| `Space un`       | Toggle relative line numbers |

Autocomplete appears as you type in insert mode. Full toggle below.

## 5. The three toggles

These are the heart of NaviVim — flip behaviors on and off at will:

| Key        | What it does                              |
|------------|-------------------------------------------|
| `Space ua` | Autocomplete on / off                     |
| `Space uf` | Format-on-save on / off                   |
| `Space un` | Relative line numbers on / off            |

## 6. Code intelligence (LSP)

With a language server installed via `:Mason`, you get:

| Key        | What it does              |
|------------|---------------------------|
| `gd`       | Go to definition          |
| `gr`       | Find references           |
| `K`        | Hover documentation       |
| `Space rn` | Rename symbol             |
| `Space ca` | Code actions              |
| `[d` / `]d` | Previous / next problem  |

## 7. Splits, buffers, terminal

- `Space |` / `Space -` — vertical / horizontal split.
- `Ctrl+h/j/k/l` — move between splits (tmux-aware).
- `Shift+h` / `Shift+l` — previous / next buffer. `Space bd` closes one.
- `Space tt` (or `Ctrl+\`) — floating terminal. `Esc Esc` gets you back out.
- `Space qs` — restore your last session.

## 8. Git

The gutter shows `+` added, `~` changed, `_` deleted lines.

| Key        | What it does              |
|------------|---------------------------|
| `Space gg` | Open LazyGit (full UI)    |
| `Space gp` | Preview the hunk under your cursor |
| `Space gb` | Blame the current line    |
| `]h` / `[h` | Next / previous change   |

## 9. Theme

NaviVim ships with **nightshadeNeon** — neon pink `#ff10f0`,
neon green `#39ff14`, cyan `#00ffff`, neon red `#ff3131`,
white on black. To try something else:

```bash
echo "tokyonight" > ~/.config/omaterm/nvim.theme
```

Delete the file (or write `nightshadeNeon` into it) to come home.

## 10. Troubleshooting

- **`Ctrl+n` does nothing** — your terminal or tmux ate it. Use `Space e`.
- **No autocomplete / squiggles in a language** — run `:Mason`, install
  that language's server, restart.
- **Something looks broken** — run `:checkhealth`, then
  `nvim --headless "+Lazy! sync" +qa` from your shell to reinstall plugins.
- **Lost?** — press `Space` and wait half a second. A popup lists
  everything you can do from there.

---

*Present day. Present time. Happy hacking.*
