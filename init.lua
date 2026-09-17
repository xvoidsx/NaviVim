-- Navi hand-rolled Neovim entry point (no LazyVim distro).
-- Order matters: options -> keymaps -> autocmds -> plugin manager.
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
