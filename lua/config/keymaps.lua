-- Navi keymaps: VSCode-convert friendly, all discoverable via which-key.
local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Sidebar toggle (nvim-tree)
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", vim.tbl_extend("force", opts, { desc = "Sidebar: toggle file tree" }))
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", vim.tbl_extend("force", opts, { desc = "Sidebar: toggle file tree" }))
map("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", vim.tbl_extend("force", opts, { desc = "Sidebar: focus file tree" }))

-- Completion toggle (blink.cmp master switch, see plugins/completion.lua)
map("n", "<leader>ua", function()
  vim.g.navi_completion_enabled = not vim.g.navi_completion_enabled
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    if vim.g.navi_completion_enabled then
      blink.show()
    else
      blink.hide()
    end
  end
  vim.notify(
    "Completion " .. (vim.g.navi_completion_enabled and "ENABLED" or "DISABLED"),
    vim.log.levels.INFO
  )
end, { desc = "Toggle autocomplete", silent = true })

-- Wonderful / search: Esc clears highlight, n/N keep centered, * stays put
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", vim.tbl_extend("force", opts, { desc = "Clear search highlight" }))
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- VSCode muscle memory
map({ "n", "v", "i" }, "<C-s>", "<Esc><cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "Save file" }))
map("n", "<leader>w", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "Save file" }))
map("n", "<leader>q", "<cmd>q<CR>", vim.tbl_extend("force", opts, { desc = "Quit" }))
map("n", "<leader>Q", "<cmd>qa!<CR>", vim.tbl_extend("force", opts, { desc = "Quit all (force)" }))

-- Splits + navigation (works with vim-tmux-navigator when in tmux)
map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Go to left window" }))
map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Go to lower window" }))
map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Go to upper window" }))
map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Go to right window" }))
map("n", "<leader>|", "<cmd>vsplit<CR>", vim.tbl_extend("force", opts, { desc = "Split vertical" }))
map("n", "<leader>-", "<cmd>split<CR>", vim.tbl_extend("force", opts, { desc = "Split horizontal" }))

-- Buffers (bufferline)
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", vim.tbl_extend("force", opts, { desc = "Prev buffer" }))
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", vim.tbl_extend("force", opts, { desc = "Next buffer" }))
map("n", "<leader>bd", "<cmd>bdelete<CR>", vim.tbl_extend("force", opts, { desc = "Delete buffer" }))

-- Pickers (Telescope, see plugins/search.lua)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", vim.tbl_extend("force", opts, { desc = "Find files" }))
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", vim.tbl_extend("force", opts, { desc = "Grep project" }))
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", vim.tbl_extend("force", opts, { desc = "Find buffers" }))
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", vim.tbl_extend("force", opts, { desc = "Help tags" }))
map("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", vim.tbl_extend("force", opts, { desc = "Fuzzy find in buffer" }))

-- Terminal
map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", vim.tbl_extend("force", opts, { desc = "Toggle terminal" }))
map("t", "<Esc><Esc>", [[<C-\><C-n>]], vim.tbl_extend("force", opts, { desc = "Exit terminal mode" }))

-- Number niceties
map("n", "<leader>un", "<cmd>set relativenumber!<CR>", vim.tbl_extend("force", opts, { desc = "Toggle relative numbers" }))

-- Better indenting in visual mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move lines up/down (VSCode Alt-Up/Down feel)
map("n", "<A-j>", "<cmd>m .+1<CR>==", vim.tbl_extend("force", opts, { desc = "Move line down" }))
map("n", "<A-k>", "<cmd>m .-2<CR>==", vim.tbl_extend("force", opts, { desc = "Move line up" }))
map("v", "<A-j>", ":m '>+1<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection down" }))
map("v", "<A-k>", ":m '<-2<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection up" }))
