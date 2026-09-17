-- Navi autocmds: small quality-of-life, no distro magic.
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank (VSCode flash feel)
autocmd("TextYankPost", {
  group = augroup("NaviYankHl", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Resize splits when terminal window resizes
autocmd("VimResized", {
  group = augroup("NaviResize", { clear = true }),
  command = "tabdo wincmd =",
})

-- No auto-continuing comments on o/O (keeps editing predictable)
autocmd("FileType", {
  group = augroup("NaviNoAutoComment", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Transparency: re-apply after any colorscheme loads (ported from old LazyVim setup)
autocmd("ColorScheme", {
  group = augroup("NaviTransparency", { clear = true }),
  callback = function()
    local groups = {
      "Normal", "NormalFloat", "FloatBorder", "Pmenu", "Terminal",
      "EndOfBuffer", "FoldColumn", "Folded", "SignColumn",
      "NormalNC", "WhichKeyFloat",
      "TelescopeBorder", "TelescopeNormal", "TelescopePromptBorder", "TelescopePromptTitle",
      "NvimTreeNormal", "NvimTreeVertSplit", "NvimTreeEndOfBuffer",
    }
    for _, name in ipairs(groups) do
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
      if ok then
        hl.bg = nil
        vim.api.nvim_set_hl(0, name, hl)
      end
    end
  end,
})
