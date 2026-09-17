-- Themes: Navi reads ~/.config/omaterm/nvim.theme, falls back to nightshadeNeon.
-- nightshadeNeon is our house colorscheme (colors/nightshadeNeon.lua, no plugin needed).
-- Ported from the old LazyVim setup, minus the LazyVim dependency.
local function navi_theme()
  local theme_file = vim.fn.expand("~/.config/omaterm/nvim.theme")
  local theme = "nightshadeNeon"
  local ok, lines = pcall(vim.fn.readfile, theme_file)
  if ok and #lines > 0 and lines[1]:match("%S") then
    theme = vim.trim(lines[1])
  end
  return theme
end

return {
  { "ribru17/bamboo.nvim", lazy = true, priority = 1000 },
  { "catppuccin/nvim", name = "catppuccin", lazy = true, priority = 1000 },
  { "sainnhe/everforest", lazy = true, priority = 1000 },
  { "kepano/flexoki-neovim", lazy = true, priority = 1000 },
  { "ellisonleao/gruvbox.nvim", lazy = true, priority = 1000 },
  { "rebelot/kanagawa.nvim", lazy = true, priority = 1000 },
  { "loctvl842/monokai-pro.nvim", lazy = true, priority = 1000 },
  { "shaunsingh/nord.nvim", lazy = true, priority = 1000 },
  { "rose-pine/neovim", name = "rose-pine", lazy = true, priority = 1000 },
  { "xero/miasma.nvim", lazy = true, priority = 1000 },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme " .. navi_theme())
    end,
  },
}
