-- Toggleable sidebar: VSCode-like file tree.
return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Sidebar: toggle file tree" },
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Sidebar: toggle file tree" },
      { "<leader>o", "<cmd>NvimTreeFocus<CR>", desc = "Sidebar: focus file tree" },
    },
    opts = {
      view = { width = 32, side = "left" },
      renderer = { group_empty = true, highlight_git = true },
      filters = { dotfiles = false },
      git = { enable = true },
      actions = { open_file = { quit_on_open = false } },
      update_focused_file = { enable = true },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
}
