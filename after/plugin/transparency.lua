-- Transparency applied on startup too (ColorScheme autocmd in config/autocmds.lua
-- handles theme switches; this covers the very first load).
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name or "*" })
  end,
})
