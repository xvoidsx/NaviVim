-- Toggleable autocomplete: blink.cmp with <leader>ua master switch.
-- Respects vim.g.navi_completion_enabled (default true, see options.lua).
return {
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      { "L3MON4D3/LuaSnip", version = "v2.*" },
    },
    event = "InsertEnter",
    opts = {
      keymap = {
        preset = "enter", -- Enter accepts, arrows/C-n/C-p navigate (VSCode feel)
        ["<C-Space>"] = { "show", "hide" },
        ["<C-e>"] = { "hide" },
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = false } },
        menu = { border = "rounded" },
        documentation = { window = { border = "rounded" } },
      },
      snippets = { preset = "luasnip" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      enabled = function()
        return vim.g.navi_completion_enabled ~= false
      end,
    },
  },
}
