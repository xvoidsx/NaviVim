-- Terminal + tmux: editor-first, tmux-enhanced (Navi doctrine).
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    },
    opts = {
      size = 14,
      open_mapping = [[<c-\>]],
      direction = "horizontal",
    },
  },
  {
    -- Seamless C-h/j/k/l between nvim splits and tmux panes
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      local m = vim.keymap.set
      local o = { silent = true }
      m("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", vim.tbl_extend("force", o, { desc = "Left (tmux aware)" }))
      m("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", vim.tbl_extend("force", o, { desc = "Down (tmux aware)" }))
      m("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", vim.tbl_extend("force", o, { desc = "Up (tmux aware)" }))
      m("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", vim.tbl_extend("force", o, { desc = "Right (tmux aware)" }))
    end,
  },
  {
    -- Remember last place + session continuity
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Stop session save" },
    },
  },
}
