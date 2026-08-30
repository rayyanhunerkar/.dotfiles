-- organization-xiii — generated from .config/kitty/themes/organization-xiii.conf
-- Do not edit by hand: `set-theme` copies this over colors/dotfiles.lua.
local c = {
  bg = "#0b0b0d",
  fg = "#e8e8ec",
  bg_alt = "#19191b",
  bg_hl = "#232325",
  bg_sel = "#7fb0c9",
  border = "#404042",
  comment = "#848487",
  subtle = "#58585b",
  black = "#1c1c20",
  grey = "#2a2a30",
  red = "#c8102e",
  red_b = "#e8395a",
  green = "#7a9c8a",
  green_b = "#9dbfae",
  yellow = "#8a7f6a",
  yellow_b = "#a89880",
  blue = "#2e5c8a",
  blue_b = "#4d7cad",
  magenta = "#7a6a75",
  magenta_b = "#9c8a95",
  cyan = "#7fb0c9",
  cyan_b = "#a8cfe0",
  white = "#b8bcc4",
  white_b = "#e8e8ec",
  diff_add = "#1e2523",
  diff_del = "#2d0b12",
  diff_chg = "#10171f",
  diff_txt = "#152332",
  sel_search = "#37332d",
}

local hi = vim.api.nvim_set_hl
vim.cmd "highlight clear"
if vim.fn.exists "syntax_on" == 1 then vim.cmd "syntax reset" end
vim.o.background = "dark"
vim.g.colors_name = "dotfiles"

local groups = {
  -- editor
  Normal        = { fg = c.fg, bg = c.bg },
  NormalNC      = { fg = c.fg, bg = c.bg },
  NormalFloat   = { fg = c.fg, bg = c.bg_alt },
  FloatBorder   = { fg = c.border, bg = c.bg_alt },
  FloatTitle    = { fg = c.cyan, bg = c.bg_alt, bold = true },
  Cursor        = { fg = c.bg, bg = c.fg },
  CursorLine    = { bg = c.bg_hl },
  CursorColumn  = { bg = c.bg_hl },
  ColorColumn   = { bg = c.bg_alt },
  CursorLineNr  = { fg = c.yellow, bold = true },
  LineNr        = { fg = c.subtle },
  SignColumn    = { bg = c.bg },
  Folded        = { fg = c.comment, bg = c.bg_alt },
  FoldColumn    = { fg = c.subtle, bg = c.bg },
  VertSplit     = { fg = c.border },
  WinSeparator  = { fg = c.border },
  Visual        = { bg = c.bg_sel, fg = c.bg },
  Search        = { bg = c.sel_search, fg = c.fg },
  IncSearch     = { bg = c.yellow, fg = c.bg },
  CurSearch     = { bg = c.yellow, fg = c.bg, bold = true },
  MatchParen    = { fg = c.yellow, bold = true, underline = true },
  NonText       = { fg = c.border },
  Whitespace    = { fg = c.border },
  SpecialKey    = { fg = c.border },
  Directory     = { fg = c.blue, bold = true },
  Title         = { fg = c.cyan, bold = true },
  Question      = { fg = c.green },
  MoreMsg       = { fg = c.green },
  ModeMsg       = { fg = c.fg, bold = true },
  ErrorMsg      = { fg = c.red, bold = true },
  WarningMsg    = { fg = c.yellow },
  Conceal       = { fg = c.subtle },
  StatusLine    = { fg = c.fg, bg = c.bg_alt },
  StatusLineNC  = { fg = c.subtle, bg = c.bg_alt },
  TabLine       = { fg = c.subtle, bg = c.bg_alt },
  TabLineSel    = { fg = c.bg, bg = c.cyan, bold = true },
  TabLineFill   = { bg = c.bg_alt },
  WinBar        = { fg = c.subtle, bg = c.bg },
  WinBarNC      = { fg = c.subtle, bg = c.bg },
  Pmenu         = { fg = c.fg, bg = c.bg_alt },
  PmenuSel      = { fg = c.bg, bg = c.cyan, bold = true },
  PmenuSbar     = { bg = c.bg_alt },
  PmenuThumb    = { bg = c.border },
  QuickFixLine  = { bg = c.bg_hl, bold = true },

  -- syntax
  Comment       = { fg = c.comment, italic = true },
  Constant      = { fg = c.magenta },
  String        = { fg = c.green },
  Character     = { fg = c.green },
  Number        = { fg = c.magenta },
  Boolean       = { fg = c.magenta, bold = true },
  Float         = { fg = c.magenta },
  Identifier    = { fg = c.fg },
  Function      = { fg = c.blue, bold = true },
  Statement     = { fg = c.red },
  Conditional   = { fg = c.red },
  Repeat        = { fg = c.red },
  Label         = { fg = c.red },
  Operator      = { fg = c.cyan },
  Keyword       = { fg = c.red, italic = true },
  Exception     = { fg = c.red },
  PreProc       = { fg = c.yellow },
  Include       = { fg = c.red, italic = true },
  Define        = { fg = c.yellow },
  Macro         = { fg = c.yellow },
  Type          = { fg = c.yellow },
  StorageClass  = { fg = c.yellow },
  Structure     = { fg = c.yellow },
  Typedef       = { fg = c.yellow },
  Special       = { fg = c.cyan },
  SpecialChar   = { fg = c.cyan },
  Delimiter     = { fg = c.subtle },
  Tag           = { fg = c.red },
  Underlined    = { fg = c.blue, underline = true },
  Error         = { fg = c.red, bold = true },
  Todo          = { fg = c.bg, bg = c.yellow, bold = true },

  -- treesitter
  ["@variable"]             = { fg = c.fg },
  ["@variable.builtin"]     = { fg = c.red, italic = true },
  ["@variable.parameter"]   = { fg = c.magenta_b },
  ["@variable.member"]      = { fg = c.cyan },
  ["@constant"]             = { fg = c.magenta },
  ["@constant.builtin"]     = { fg = c.magenta, bold = true },
  ["@module"]               = { fg = c.yellow },
  ["@string"]               = { fg = c.green },
  ["@string.escape"]        = { fg = c.cyan_b },
  ["@character"]            = { fg = c.green },
  ["@number"]               = { fg = c.magenta },
  ["@boolean"]              = { fg = c.magenta, bold = true },
  ["@function"]             = { fg = c.blue, bold = true },
  ["@function.builtin"]     = { fg = c.cyan, bold = true },
  ["@function.method"]      = { fg = c.blue },
  ["@constructor"]          = { fg = c.yellow },
  ["@operator"]             = { fg = c.cyan },
  ["@keyword"]              = { fg = c.red, italic = true },
  ["@keyword.function"]     = { fg = c.red, italic = true },
  ["@keyword.return"]       = { fg = c.red, bold = true },
  ["@punctuation.delimiter"]= { fg = c.subtle },
  ["@punctuation.bracket"]  = { fg = c.subtle },
  ["@punctuation.special"]  = { fg = c.cyan },
  ["@type"]                 = { fg = c.yellow },
  ["@type.builtin"]         = { fg = c.yellow, italic = true },
  ["@attribute"]            = { fg = c.magenta_b },
  ["@property"]             = { fg = c.cyan },
  ["@tag"]                  = { fg = c.red },
  ["@tag.attribute"]        = { fg = c.magenta_b },
  ["@tag.delimiter"]        = { fg = c.subtle },
  ["@comment"]              = { fg = c.comment, italic = true },
  ["@markup.heading"]       = { fg = c.cyan, bold = true },
  ["@markup.link"]          = { fg = c.blue, underline = true },
  ["@markup.raw"]           = { fg = c.green },
  ["@markup.list"]          = { fg = c.red },
  ["@markup.strong"]        = { bold = true },
  ["@markup.italic"]        = { italic = true },
  ["@diff.plus"]            = { fg = c.green },
  ["@diff.minus"]           = { fg = c.red },

  -- diagnostics
  DiagnosticError            = { fg = c.red },
  DiagnosticWarn             = { fg = c.yellow },
  DiagnosticInfo             = { fg = c.blue },
  DiagnosticHint             = { fg = c.cyan },
  DiagnosticOk               = { fg = c.green },
  DiagnosticUnderlineError   = { sp = c.red, undercurl = true },
  DiagnosticUnderlineWarn    = { sp = c.yellow, undercurl = true },
  DiagnosticUnderlineInfo    = { sp = c.blue, undercurl = true },
  DiagnosticUnderlineHint    = { sp = c.cyan, undercurl = true },
  DiagnosticVirtualTextError = { fg = c.red, bg = c.diff_del },
  DiagnosticVirtualTextWarn  = { fg = c.yellow },
  DiagnosticVirtualTextInfo  = { fg = c.blue },
  DiagnosticVirtualTextHint  = { fg = c.cyan },

  -- lsp
  LspReferenceText  = { bg = c.bg_hl },
  LspReferenceRead  = { bg = c.bg_hl },
  LspReferenceWrite = { bg = c.bg_hl, underline = true },
  LspInlayHint      = { fg = c.subtle, bg = c.bg_alt, italic = true },
  LspSignatureActiveParameter = { fg = c.yellow, bold = true },

  -- diff
  DiffAdd    = { bg = c.diff_add },
  DiffChange = { bg = c.diff_chg },
  DiffDelete = { bg = c.diff_del, fg = c.red },
  DiffText   = { bg = c.diff_txt, bold = true },
  Added      = { fg = c.green },
  Changed    = { fg = c.blue },
  Removed    = { fg = c.red },

  -- gitsigns
  GitSignsAdd    = { fg = c.green },
  GitSignsChange = { fg = c.blue },
  GitSignsDelete = { fg = c.red },

  -- telescope
  TelescopeNormal       = { fg = c.fg, bg = c.bg_alt },
  TelescopeBorder       = { fg = c.border, bg = c.bg_alt },
  TelescopeTitle        = { fg = c.bg, bg = c.cyan, bold = true },
  TelescopePromptNormal = { fg = c.fg, bg = c.bg_hl },
  TelescopePromptBorder = { fg = c.bg_hl, bg = c.bg_hl },
  TelescopePromptTitle  = { fg = c.bg, bg = c.red, bold = true },
  TelescopeSelection    = { bg = c.bg_hl, fg = c.fg, bold = true },
  TelescopeMatching     = { fg = c.yellow, bold = true },

  -- neo-tree
  NeoTreeNormal       = { fg = c.fg, bg = c.bg_alt },
  NeoTreeNormalNC     = { fg = c.fg, bg = c.bg_alt },
  NeoTreeWinSeparator = { fg = c.border, bg = c.bg_alt },
  NeoTreeDirectoryName= { fg = c.blue },
  NeoTreeDirectoryIcon= { fg = c.blue },
  NeoTreeGitModified  = { fg = c.yellow },
  NeoTreeGitAdded     = { fg = c.green },
  NeoTreeGitDeleted   = { fg = c.red },
  NeoTreeIndentMarker = { fg = c.border },
  NeoTreeRootName     = { fg = c.cyan, bold = true },

  -- misc plugins
  IndentBlanklineChar      = { fg = c.border },
  IblIndent                = { fg = c.border },
  IblScope                 = { fg = c.cyan },
  NotifyINFOBorder         = { fg = c.blue },
  NotifyWARNBorder         = { fg = c.yellow },
  NotifyERRORBorder        = { fg = c.red },
  WhichKey                 = { fg = c.cyan },
  WhichKeyGroup            = { fg = c.blue },
  WhichKeyDesc             = { fg = c.fg },
  WhichKeyFloat            = { bg = c.bg_alt },
  BlinkCmpMenu             = { fg = c.fg, bg = c.bg_alt },
  BlinkCmpMenuBorder       = { fg = c.border, bg = c.bg_alt },
  BlinkCmpMenuSelection    = { bg = c.bg_hl, bold = true },
  BlinkCmpLabelMatch       = { fg = c.yellow, bold = true },
}

for group, spec in pairs(groups) do
  hi(0, group, spec)
end

-- terminal colours inside :terminal
vim.g.terminal_color_0  = c.black
vim.g.terminal_color_1  = c.red
vim.g.terminal_color_2  = c.green
vim.g.terminal_color_3  = c.yellow
vim.g.terminal_color_4  = c.blue
vim.g.terminal_color_5  = c.magenta
vim.g.terminal_color_6  = c.cyan
vim.g.terminal_color_7  = c.white
vim.g.terminal_color_8  = c.grey
vim.g.terminal_color_9  = c.red_b
vim.g.terminal_color_10 = c.green_b
vim.g.terminal_color_11 = c.yellow_b
vim.g.terminal_color_12 = c.blue_b
vim.g.terminal_color_13 = c.magenta_b
vim.g.terminal_color_14 = c.cyan_b
vim.g.terminal_color_15 = c.white_b
