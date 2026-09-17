-- Treesitter: better syntax + indent for every language.
-- Pinned to `master` (legacy `configs` API): the new `main` branch needs a
-- config rewrite, so that migration is tracked as a roadmap item in AGENTS.md.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash", "c", "cpp", "css", "go", "html", "javascript",
        "json", "jsonc", "lua", "markdown", "markdown_inline",
        "python", "query", "regex", "rust", "tsx", "typescript",
        "vim", "vimdoc", "yaml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "master",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  },
}
