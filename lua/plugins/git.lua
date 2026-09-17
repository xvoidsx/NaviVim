-- Git gutter + lazygit (IDE-grade version control).
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
      },
    },
    keys = {
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
      { "<leader>gb", "<cmd>Gitsigns blame_line<CR>", desc = "Blame line" },
      { "]h", "<cmd>Gitsigns next_hunk<CR>", desc = "Next hunk" },
      { "[h", "<cmd>Gitsigns prev_hunk<CR>", desc = "Prev hunk" },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "LazyGit",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
  },
}
