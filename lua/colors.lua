-- ~/.config/nvim/lua/colors.lua
local M = {}

-- Cache highlight function for performance
local hl = vim.api.nvim_set_hl

function M.setup()
  local palette = LazyVim.icons.palette

  -- Batch highlight definitions for better performance
  local highlights = {
    -- Editor / UI
    Normal = { fg = palette.light_08, bg = palette.dark_06 },
    NormalFloat = { fg = palette.light_08, bg = palette.grey_04 },
    CursorLine = { bg = palette.grey_02 },
    Visual = { bg = palette.blue_14 },
    LineNr = { fg = palette.grey_14 },
    CursorLineNr = { fg = palette.yellow_07, bold = true },
    VertSplit = { fg = palette.grey_05 },
    WinSeparator = { fg = palette.grey_05 },
    ColorColumn = { bg = palette.grey_03 },
    Conceal = { fg = palette.grey_14 },
    Directory = { fg = palette.blue_21, bold = true },
    EndOfBuffer = { fg = palette.grey_05 },

    -- Statusline
    StatusLine = { fg = palette.light_08, bg = palette.grey_02 },
    StatusLineNC = { fg = palette.grey_05, bg = palette.grey_02 },
    StatusLineNormal = { fg = palette.dark_06, bg = palette.blue_21, bold = true },
    StatusLineInsert = { fg = palette.dark_06, bg = palette.green_10, bold = true },
    StatusLineVisual = { fg = palette.dark_06, bg = palette.purple_03, bold = true },
    StatusLineReplace = { fg = palette.dark_06, bg = palette.red_06, bold = true },
    StatusLineCommand = { fg = palette.dark_06, bg = palette.yellow_07, bold = true },
    StatusLineFile = { fg = palette.blue_21, bg = palette.grey_02, bold = true },
    StatusLineFileinfo = { fg = palette.yellow_07, bg = palette.grey_02 },
    StatusLineDiagError = { fg = palette.red_06, bg = palette.grey_02 },
    StatusLineDiagWarn = { fg = palette.yellow_07, bg = palette.grey_02 },
    StatusLineDiagInfo = { fg = palette.blue_21, bg = palette.grey_02 },
    StatusLineDiagHint = { fg = palette.green_08, bg = palette.grey_02 },
    StatusLinePercent = { fg = palette.dark_06, bg = palette.blue_21, bold = true },

    -- Tabline
    TabLine = { fg = palette.light_08, bg = palette.grey_02 },
    TabLineSel = { fg = palette.light_08, bg = palette.blue_14, bold = true },
    TabLineFill = { bg = palette.grey_02 },

    -- Syntax (essential only)
    Comment = { fg = palette.green_10, italic = true },
    String = { fg = palette.orange_01 },
    Number = { fg = palette.orange_01 },
    Boolean = { fg = palette.blue_21 },
    Function = { fg = palette.blue_21 },
    Keyword = { fg = palette.purple_03, bold = true },
    Type = { fg = palette.yellow_07 },
    Operator = { fg = palette.light_08 },

    -- Treesitter (essential)
    ["@comment"] = { fg = palette.green_10, italic = true },
    ["@string"] = { fg = palette.orange_01 },
    ["@number"] = { fg = palette.orange_01 },
    ["@boolean"] = { fg = palette.blue_21 },
    ["@function"] = { fg = palette.blue_21 },
    ["@keyword"] = { fg = palette.purple_03, bold = true },
    ["@type"] = { fg = palette.yellow_07 },

    -- Diagnostics
    DiagnosticError = { fg = palette.red_06 },
    DiagnosticWarn = { fg = palette.yellow_07 },
    DiagnosticInfo = { fg = palette.blue_21 },
    DiagnosticHint = { fg = palette.green_08 },

    -- Winbar
    WinBar = { fg = palette.light_08, bg = palette.grey_02 },
    WinBarNC = { fg = palette.grey_14, bg = palette.grey_02 },
    WinBarFile = { fg = palette.blue_21, bg = palette.grey_02, bold = true },
    WinBarPath = { fg = palette.grey_21, bg = palette.grey_02 },

    -- Navic (breadcrumbs)
    NavicIconsFile = { fg = palette.light_08, bg = "NONE" },
    NavicIconsModule = { fg = palette.blue_21, bg = "NONE" },
    NavicIconsNamespace = { fg = palette.purple_03, bg = "NONE" },
    NavicIconsPackage = { fg = palette.orange_01, bg = "NONE" },
    NavicIconsClass = { fg = palette.yellow_07, bg = "NONE" },
    NavicIconsMethod = { fg = palette.blue_21, bg = "NONE" },
    NavicIconsProperty = { fg = palette.green_08, bg = "NONE" },
    NavicIconsField = { fg = palette.green_08, bg = "NONE" },
    NavicIconsConstructor = { fg = palette.blue_16, bg = "NONE" },
    NavicIconsEnum = { fg = palette.orange_01, bg = "NONE" },
    NavicIconsInterface = { fg = palette.purple_03, bg = "NONE" },
    NavicIconsFunction = { fg = palette.blue_21, bg = "NONE" },
    NavicIconsVariable = { fg = palette.light_08, bg = "NONE" },
    NavicIconsConstant = { fg = palette.orange_01, bg = "NONE" },
    NavicIconsString = { fg = palette.orange_01, bg = "NONE" },
    NavicIconsNumber = { fg = palette.orange_01, bg = "NONE" },
    NavicIconsBoolean = { fg = palette.blue_21, bg = "NONE" },
    NavicIconsArray = { fg = palette.blue_16, bg = "NONE" },
    NavicIconsObject = { fg = palette.yellow_07, bg = "NONE" },
    NavicIconsKey = { fg = palette.red_06, bg = "NONE" },
    NavicIconsNull = { fg = palette.light_08, bg = "NONE" },
    NavicIconsEnumMember = { fg = palette.orange_01, bg = "NONE" },
    NavicIconsStruct = { fg = palette.purple_03, bg = "NONE" },
    NavicIconsEvent = { fg = palette.blue_21, bg = "NONE" },
    NavicIconsOperator = { fg = palette.light_08, bg = "NONE" },
    NavicIconsTypeParameter = { fg = palette.yellow_07, bg = "NONE" },
    NavicText = { fg = palette.light_08, bg = "NONE" },
    NavicSeparator = { fg = palette.grey_14, bg = "NONE" },

    -- GitSigns
    GitSignsAdd = { fg = palette.green_10 },
    GitSignsChange = { fg = palette.blue_21 },
    GitSignsDelete = { fg = palette.red_06 },
    DiffAdd = { bg = "#203022" },
    DiffChange = { bg = "#203040" },
    DiffDelete = { bg = "#402020" },
    DiffText = { bg = "#305050" },
  }

  -- Apply all highlights in batch
  for group, opts in pairs(highlights) do
    hl(0, group, opts)
  end
end

-- Auto-apply colors after UI is ready
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = M.setup,
})

return M
