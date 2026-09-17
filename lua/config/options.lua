-- Navi options: migrated from ~/.vimrc + IDE-sane defaults.
-- Original vimrc preserved: number, mouse=a, hlsearch, incsearch,
-- wrap, autoindent, cursorline, cursorlineopt=number, filetype indent on, syntax enable.

local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

-- From vimrc
opt.number = true
opt.mouse = "a"
opt.hlsearch = true
opt.incsearch = true
opt.wrap = true
opt.autoindent = true
opt.cursorline = true
opt.cursorlineopt = "number"
vim.cmd("filetype indent on")
vim.cmd("syntax enable")

-- IDE defaults (VSCode-convert friendly)
opt.relativenumber = true -- easy motion math; toggle with <leader>un
opt.ignorecase = true
opt.smartcase = true -- makes / search wonderful
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.undofile = true -- persistent undo
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.clipboard = "unnamedplus" -- system clipboard always (vimrc had no clipboard; tmux shim removed)
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes" -- stable gutter for LSP/git
opt.updatetime = 250
opt.timeoutlen = 400 -- snappier which-key
opt.termguicolors = true
opt.pumheight = 12 -- completion popup height
opt.showmode = false -- lualine shows it
opt.confirm = true -- confirm before quitting dirty buffer
opt.wildmode = "longest:full,full"
opt.completeopt = "menu,menuone,noselect"

-- Netrw off: we use nvim-tree as the toggleable sidebar
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Completion master switch (toggled by <leader>ua, see completion.lua)
g.navi_completion_enabled = true
