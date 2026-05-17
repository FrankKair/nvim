-- gruber-darker.lua
-- Port of gruber-darker-theme.el from Emacs to Neovim

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "gruber-darker"

local c = {
  fg         = "#e4e4ef",
  fg_plus1   = "#f4f4ff",
  fg_plus2   = "#f5f5f5",
  white      = "#ffffff",
  black      = "#000000",
  bg_minus1  = "#101010",
  bg         = "#181818",
  bg_plus1   = "#282828",
  bg_plus2   = "#453d41",
  bg_plus3   = "#484848",
  bg_plus4   = "#52494e",
  red_minus1 = "#c73c3f",
  red        = "#f43841",
  red_plus1  = "#ff4f58",
  green      = "#73c936",
  green2     = "#c0ffdd",
  yellow     = "#ffdd33",
  brown      = "#cc8c3c",
  quartz     = "#95a99f",
  niagara2   = "#303540",
  niagara1   = "#565f73",
  niagara    = "#96a6c8",
  wisteria   = "#9e95c7",
  comment    = "#808080",
}

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Core
hl("Normal",          { fg = c.fg, bg = c.bg })
hl("Cursor",          { fg = c.bg, bg = c.yellow })
hl("CursorLine",      { bg = c.bg_plus1 })
hl("CursorColumn",    { bg = c.bg_plus1 })
hl("ColorColumn",     { bg = c.bg_plus2 })
hl("LineNr",          { fg = c.bg_plus4 })
hl("CursorLineNr",    { fg = c.yellow })
hl("SignColumn",      { bg = c.bg })
hl("VertSplit",       { fg = c.bg_plus2, bg = c.bg })
-- UI
hl("Pmenu", 	      { fg = c.fg, bg = c.bg_plus1 })
hl("PmenuSel", 	      { fg = c.fg, bg = c.bg_plus3, bold = true })
hl("PmenuSbar",       { bg = c.bg_plus2 })
hl("PmenuThumb",      { bg = c.bg_plus3 })
hl("StatusLine",      { fg = c.white, bg = c.bg_plus1 })
hl("StatusLineNC",    { fg = c.quartz, bg = c.bg_plus1 })
hl("TabLine", 	      { fg = c.bg_plus4, bg = c.bg_plus1 })
hl("TabLineSel",      { fg = c.yellow, bg = c.bg })
hl("Title", 	      { fg = c.niagara })
hl("Directory",       { fg = c.niagara })
hl("ErrorMsg",        { fg = c.red_plus1, bg = c.bg })
hl("WarningMsg",      { fg = c.brown, bg = c.bg })
-- Syntax
hl("Comment",  	      { fg = c.comment })
hl("Constant",        { fg = c.quartz })
hl("String", 	      { fg = c.green })
hl("Character",       { fg = c.green })
hl("Number", 	      { fg = c.wisteria })
hl("Boolean",         { fg = c.wisteria })
hl("Float",           { fg = c.wisteria })
hl("Identifier",      { fg = c.fg_plus1 })
hl("Function", 	      { fg = c.niagara })
hl("Statement",       { fg = c.yellow, bold = true })
hl("Conditional",     { fg = c.yellow })
hl("Repeat",          { fg = c.yellow })
hl("Label",           { fg = c.quartz })
hl("Operator",        { fg = c.fg })
hl("Keyword",         { fg = c.yellow, bold = true })
hl("PreProc",         { fg = c.quartz })
hl("Type", 	      { fg = c.quartz })
hl("Special", 	      { fg = c.niagara })
hl("Underline",       { fg = c.niagara, underline = true })
hl("Todo", 	      { fg = c.yellow, bg = c.bg_plus2, bold = true })
-- Diff
hl("DiffAdd",         { fg = c.green, bg = c.bg })
hl("DiffChange",      { fg = c.niagara, bg = c.bg })
hl("DiffDelete",      { fg = c.red_plus1, bg = c.bg })
hl("DiffText",        { fg = c.yellow, bg = c.bg_plus2 })
-- Search / Visual
hl("Search",          { fg = c.black, bg = c.fg_plus2 })
hl("IncSearch",       { fg = c.black, bg = c.fg_plus1 })
hl("Visual",          { bg = c.bg_plus3 })
-- Git / Misc
hl("GitGutterAdd",    { fg = c.green })
hl("GitGutterChange", { fg = c.niagara })
hl("GitGutterDelete", { fg = c.red })
-- Terminal ANSI colors
vim.g.terminal_color_0  = c.bg_plus3
vim.g.terminal_color_1  = c.red
vim.g.terminal_color_2  = c.green
vim.g.terminal_color_3  = c.yellow
vim.g.terminal_color_4  = c.niagara
vim.g.terminal_color_5  = c.wisteria
vim.g.terminal_color_6  = c.quartz
vim.g.terminal_color_7  = c.fg
vim.g.terminal_color_8  = c.bg_plus1
vim.g.terminal_color_9  = c.red_plus1
vim.g.terminal_color_10 = c.green
vim.g.terminal_color_11 = c.yellow
vim.g.terminal_color_12 = c.niagara
vim.g.terminal_color_13 = c.wisteria
vim.g.terminal_color_14 = c.quartz
vim.g.terminal_color_15 = c.white

return {
  colors = c,
}
