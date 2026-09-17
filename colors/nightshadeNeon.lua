-- nightshadeNeon: Navi's house colorscheme.
-- Palette from rav3ndust.xyz/wiki/nightshadeNeon.html
--   pink  #ff10f0  primary: headings, keywords, active UI
--   green #39ff14  primary: strings, links, borders, success
--   cyan  #00ffff  contrast: functions, types, info
--   red   #ff3131  alerts, errors, deleted/inactive
--   white #ffffff  main text
--   black #000000  background

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "nightshadeNeon"
vim.o.background = "dark"
vim.o.termguicolors = true

local c = {
  pink = "#ff10f0",
  green = "#39ff14",
  cyan = "#00ffff",
  red = "#ff3131",
  white = "#ffffff",
  black = "#000000",
  -- derived dark-mode supports (shades of the palette, never new hues)
  bg_alt = "#0d0d0d",
  bg_float = "#111111",
  bg_sel = "#2a0a28", -- pink-tinted selection
  gray = "#8a8a8a", -- comments, subtle text (dimmed white)
  gray_dark = "#3a3a3a", -- gutters, inactive borders
  pink_dim = "#a00a9e",
  green_dim = "#1d7a0a",
  cyan_dim = "#0a7a7a",
}

local hl = vim.api.nvim_set_hl
local G = function(name, opts)
  hl(0, name, opts)
end

-- base UI ---------------------------------------------------------------
G("Normal", { fg = c.white, bg = c.black })
G("NormalFloat", { fg = c.white, bg = c.bg_float })
G("FloatBorder", { fg = c.green, bg = c.bg_float })
G("SignColumn", { fg = c.white, bg = c.black })
G("LineNr", { fg = c.gray_dark, bg = c.black })
G("CursorLineNr", { fg = c.pink, bg = c.black, bold = true })
G("CursorLine", { bg = c.bg_alt })
G("CursorColumn", { bg = c.bg_alt })
G("ColorColumn", { bg = c.bg_alt })
G("Visual", { bg = c.bg_sel })
G("Search", { fg = c.black, bg = c.green })
G("IncSearch", { fg = c.black, bg = c.pink })
G("CurSearch", { fg = c.black, bg = c.pink })
G("Pmenu", { fg = c.white, bg = c.bg_float })
G("PmenuSel", { fg = c.black, bg = c.green, bold = true })
G("PmenuSbar", { bg = c.bg_alt })
G("PmenuThumb", { bg = c.green_dim })
G("StatusLine", { fg = c.white, bg = c.bg_alt })
G("StatusLineNC", { fg = c.gray, bg = c.bg_alt })
G("TabLine", { fg = c.gray, bg = c.bg_alt })
G("TabLineSel", { fg = c.pink, bg = c.black, bold = true })
G("TabLineFill", { bg = c.black })
G("WinSeparator", { fg = c.green_dim, bg = c.black })
G("VertSplit", { fg = c.green_dim, bg = c.black })
G("Folded", { fg = c.cyan, bg = c.bg_alt })
G("FoldColumn", { fg = c.gray_dark, bg = c.black })
G("EndOfBuffer", { fg = c.gray_dark, bg = c.black })
G("NonText", { fg = c.gray_dark })
G("Whitespace", { fg = c.gray_dark })
G("MatchParen", { fg = c.pink, bold = true, underline = true })
G("Directory", { fg = c.cyan })
G("Title", { fg = c.pink, bold = true })
G("Question", { fg = c.green })
G("MoreMsg", { fg = c.green })
G("ModeMsg", { fg = c.green, bold = true })
G("ErrorMsg", { fg = c.red, bold = true })
G("WarningMsg", { fg = c.red })
G("WildMenu", { fg = c.black, bg = c.green })
G("Conceal", { fg = c.gray })

-- syntax ----------------------------------------------------------------
G("Comment", { fg = c.gray, italic = true })
G("Constant", { fg = c.cyan })
G("String", { fg = c.green })
G("Character", { fg = c.green })
G("Number", { fg = c.green })
G("Boolean", { fg = c.pink })
G("Float", { fg = c.green })
G("Identifier", { fg = c.white })
G("Function", { fg = c.cyan })
G("Statement", { fg = c.pink })
G("Conditional", { fg = c.pink })
G("Repeat", { fg = c.pink })
G("Label", { fg = c.pink })
G("Operator", { fg = c.white })
G("Keyword", { fg = c.pink })
G("Exception", { fg = c.red })
G("PreProc", { fg = c.cyan })
G("Include", { fg = c.pink })
G("Define", { fg = c.pink })
G("Macro", { fg = c.pink })
G("Type", { fg = c.cyan })
G("StorageClass", { fg = c.pink })
G("Structure", { fg = c.cyan })
G("Typedef", { fg = c.cyan })
G("Special", { fg = c.cyan })
G("SpecialComment", { fg = c.green })
G("Underlined", { fg = c.green, underline = true })
G("Todo", { fg = c.black, bg = c.pink, bold = true })
G("Error", { fg = c.red, bold = true })
G("Debug", { fg = c.red })

-- diagnostics -----------------------------------------------------------
G("DiagnosticError", { fg = c.red })
G("DiagnosticWarn", { fg = c.pink })
G("DiagnosticInfo", { fg = c.cyan })
G("DiagnosticHint", { fg = c.green })
G("DiagnosticOk", { fg = c.green })
G("DiagnosticUnderlineError", { sp = c.red, undercurl = true })
G("DiagnosticUnderlineWarn", { sp = c.pink, undercurl = true })
G("DiagnosticUnderlineInfo", { sp = c.cyan, undercurl = true })
G("DiagnosticUnderlineHint", { sp = c.green, undercurl = true })

-- diff / git ------------------------------------------------------------
G("DiffAdd", { fg = c.green, bg = c.bg_alt })
G("DiffChange", { fg = c.cyan, bg = c.bg_alt })
G("DiffDelete", { fg = c.red, bg = c.bg_alt })
G("DiffText", { fg = c.black, bg = c.cyan })
G("GitSignsAdd", { fg = c.green })
G("GitSignsChange", { fg = c.cyan })
G("GitSignsDelete", { fg = c.red })

-- treesitter ------------------------------------------------------------
G("@comment", { link = "Comment" })
G("@string", { link = "String" })
G("@number", { link = "Number" })
G("@keyword", { link = "Keyword" })
G("@function", { link = "Function" })
G("@type", { link = "Type" })
G("@variable", { fg = c.white })
G("@property", { fg = c.cyan })
G("@operator", { link = "Operator" })
G("@punctuation", { fg = c.white })

-- gemtext (.gmi, Neovim runtime syntax) ------------------------------------
-- Wiki roles: headings pink (primary), links green (hyperlinks).
G("Heading", { fg = c.pink, bold = true })
G("LinkURL", { fg = c.green, underline = true })
G("Quote", { fg = c.gray, italic = true })
G("List", { fg = c.cyan })
-- (Preformatted keeps Identifier/white.)

-- telescope -------------------------------------------------------------
G("TelescopeNormal", { fg = c.white, bg = c.black })
G("TelescopeBorder", { fg = c.green, bg = c.black })
G("TelescopePromptBorder", { fg = c.pink, bg = c.black })
G("TelescopePromptTitle", { fg = c.pink, bold = true })
G("TelescopePreviewTitle", { fg = c.cyan })
G("TelescopeResultsTitle", { fg = c.green })
G("TelescopeSelection", { bg = c.bg_sel, bold = true })
G("TelescopeMatching", { fg = c.pink, bold = true })

-- nvim-tree -------------------------------------------------------------
G("NvimTreeNormal", { fg = c.white, bg = c.black })
G("NvimTreeVertSplit", { fg = c.green_dim, bg = c.black })
G("NvimTreeEndOfBuffer", { fg = c.black, bg = c.black })
G("NvimTreeRootFolder", { fg = c.pink, bold = true })
G("NvimTreeFolderIcon", { fg = c.cyan })
G("NvimTreeOpenedFolderName", { fg = c.cyan })
G("NvimTreeGitNew", { fg = c.green })
G("NvimTreeGitDirty", { fg = c.pink })
G("NvimTreeGitDeleted", { fg = c.red })

-- completion / misc plugins --------------------------------------------
G("BlinkCmpMenu", { link = "Pmenu" })
G("BlinkCmpMenuSelection", { link = "PmenuSel" })
G("BlinkCmpDoc", { link = "NormalFloat" })
G("WhichKeyFloat", { fg = c.white, bg = c.bg_float })
G("WhichKey", { fg = c.pink })
G("WhichKeyDesc", { fg = c.cyan })
G("FlashLabel", { fg = c.black, bg = c.pink, bold = true })
G("HlSearchLens", { fg = c.gray, bg = c.bg_alt })
G("HlSearchLensNear", { fg = c.black, bg = c.green })
G("TodoFgTODO", { fg = c.pink, bold = true })
G("TodoFgFIX", { fg = c.red, bold = true })
G("TodoFgNOTE", { fg = c.cyan, bold = true })
G("TodoFgHACK", { fg = c.pink, bold = true })
G("TodoFgWARN", { fg = c.red, bold = true })
G("TodoFgPERF", { fg = c.green, bold = true })
G("FidgetTitle", { fg = c.green })
G("FidgetTask", { fg = c.white })

-- terminal palette ------------------------------------------------------
vim.g.terminal_color_0 = c.black
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.green
vim.g.terminal_color_4 = c.cyan
vim.g.terminal_color_5 = c.pink
vim.g.terminal_color_6 = c.cyan
vim.g.terminal_color_7 = c.white
vim.g.terminal_color_8 = c.gray_dark
vim.g.terminal_color_9 = c.red
vim.g.terminal_color_10 = c.green
vim.g.terminal_color_11 = c.green
vim.g.terminal_color_12 = c.cyan
vim.g.terminal_color_13 = c.pink
vim.g.terminal_color_14 = c.cyan
vim.g.terminal_color_15 = c.white
