local autocmd = vim.api.nvim_create_autocmd

-- user event that loads after UIEnter + only if file buf is there
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name "NvFilePost"

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})

-- lua/colors/vscode_dark.lua

-- lua/colors/vscode_modern_dark.lua
local palette = {
  dark_01 = "#000000",
  dark_02 = "#080a0e",
  dark_03 = "#131313",
  dark_04 = "#171717",
  dark_05 = "#181818",
  dark_06 = "#1f1f1f",

  grey_01 = "#252526",
  grey_02 = "#262626",
  grey_03 = "#282828",
  grey_04 = "#2a2d2e",
  grey_05 = "#333333",
  grey_06 = "#3b3b3b",
  grey_07 = "#3c3c3c",
  grey_08 = "#404040",
  grey_09 = "#424548",
  grey_10 = "#484848",
  grey_11 = "#4d4d4d",
  grey_12 = "#515052",
  grey_13 = "#515151",
  grey_14 = "#6e7681",
  grey_15 = "#707070",
  grey_16 = "#808080",
  grey_17 = "#848484",
  grey_18 = "#858585",
  grey_19 = "#888888",
  grey_20 = "#8c8c8c",
  grey_21 = "#8e8e90",
  grey_22 = "#939393",
  grey_23 = "#969696",
  grey_24 = "#979797",
  grey_25 = "#999999",

  light_01 = "#a6a6a6",
  light_02 = "#a9a9a9",
  light_03 = "#aeafad",
  light_04 = "#c1c1c1",
  light_05 = "#c5c5c5",
  light_06 = "#c6c6c6",
  light_07 = "#cccccc",
  light_08 = "#d3d3d3",
  light_09 = "#d5d5d5",
  light_10 = "#e5e5e5",
  light_11 = "#e5efe5",
  light_12 = "#e8e8e8",
  light_13 = "#ebebeb",
  light_14 = "#eeeeee",
  light_15 = "#f8f8f8",
  light_16 = "#fafafa",
  light_17 = "#ffffff",

  -- green
  green_01 = "#007100",
  green_02 = "#008000",
  green_03 = "#098658",
  green_04 = "#2ea043",
  green_05 = "#329171",
  green_06 = "#383e2a",
  green_07 = "#4c5a2c",
  green_08 = "#4ec9b0",
  green_09 = "#587c0c",
  green_10 = "#6a9955",
  green_11 = "#73c991",
  green_12 = "#81b88b",
  green_13 = "#b5cea8",
  green_14 = "#d7e7b3",
  green_15 = "#ebf1dd",

  -- yellow
  yellow_01 = "#795e26",
  yellow_02 = "#895503",
  yellow_03 = "#bf8803",
  yellow_04 = "#c09553",
  yellow_05 = "#cca700",
  yellow_06 = "#d7ba7d",
  yellow_07 = "#dcdcaa",
  yellow_08 = "#e2c08d",
  yellow_09 = "#ffcc00",

  -- brown
  brown_01 = "#613214",

  -- purple
  purple_01 = "#af00db",
  purple_02 = "#b180d7",
  purple_03 = "#c586c0",

  -- magenta
  magenta_01 = "#d16d9e",

  -- blue
  blue_01 = "#0000ff",
  blue_02 = "#001080",
  blue_03 = "#005fb8",
  blue_04 = "#0066bf",
  blue_05 = "#0070c1",
  blue_06 = "#0078d4",
  blue_07 = "#007acc",
  blue_08 = "#04395e",
  blue_09 = "#093e5b",
  blue_10 = "#0e639c",
  blue_11 = "#171184",
  blue_12 = "#1a85ff",
  blue_13 = "#212e3a",
  blue_14 = "#264f78",
  blue_15 = "#267f99",
  blue_16 = "#2aaaff",
  blue_17 = "#3375c0",
  blue_18 = "#3794ff",
  blue_19 = "#3ba9f2",
  blue_20 = "#4fc1ff",
  blue_21 = "#569cd6",
  blue_22 = "#729db3",
  blue_23 = "#75beff",
  blue_24 = "#88bce2",
  blue_25 = "#9cdcfe",
  blue_26 = "#add6ff",
  blue_27 = "#e6f3ff",
  blue_28 = "#c3d8e6",

  -- orange
  orange_01 = "#ce9178",
  orange_02 = "#ee9d28",
  orange_03 = "#f8c9ab",
  orange_04 = "#fc6d26",

  -- red
  red_01 = "#4c1919",
  red_02 = "#a31515",
  red_03 = "#ad0707",
  red_04 = "#c74e39",
  red_05 = "#d16969",
  red_06 = "#e51400",
  red_07 = "#ee0000",
  red_08 = "#f14c4c",
  red_09 = "#f85149",
  red_10 = "#ffcccc",

  none = "NONE",
}

local hl = vim.api.nvim_set_hl

-- ======================
-- Editor
-- ======================
hl(0, "Normal", { fg = palette.light_08, bg = palette.dark_06 })
hl(0, "NormalFloat", { fg = palette.light_08, bg = palette.grey_04 })
hl(0, "CursorLine", { bg = palette.grey_02 })
hl(0, "Visual", { bg = palette.blue_14 })

-- Line numbers
hl(0, "LineNr", { fg = palette.grey_14 })
hl(0, "CursorLineNr", { fg = palette.yellow_07, bold = true })

-- ======================
-- Statusline
-- ======================
hl(0, "StatusLine", { fg = palette.light_08, bg = palette.grey_02 })
hl(0, "StatusLineNC", { fg = palette.grey_05, bg = palette.grey_02 })
hl(0, "StatusLineNormal", { fg = palette.dark_06, bg = palette.blue_21, bold = true })
hl(0, "StatusLineInsert", { fg = palette.dark_06, bg = palette.green_10, bold = true })
hl(0, "StatusLineVisual", { fg = palette.dark_06, bg = palette.purple_03, bold = true })
hl(0, "StatusLineReplace", { fg = palette.dark_06, bg = palette.red_06, bold = true })
hl(0, "StatusLineCommand", { fg = palette.dark_06, bg = palette.yellow_07, bold = true })
hl(0, "StatusLineGit", { fg = palette.orange_01, bg = palette.grey_02 })
hl(0, "StatusLineFile", { fg = palette.light_08, bg = palette.grey_02 })
hl(0, "StatusLineLSP", { fg = palette.blue_21, bg = palette.grey_02 })
hl(0, "StatusLineDiagError", { fg = palette.red_06, bg = palette.grey_02 })
hl(0, "StatusLineDiagWarn", { fg = palette.yellow_07, bg = palette.grey_02 })
hl(0, "StatusLineDiagInfo", { fg = palette.blue_21, bg = palette.grey_02 })
hl(0, "StatusLineDiagHint", { fg = palette.green_08, bg = palette.grey_02 })

-- ======================
-- Tabline
-- ======================
hl(0, "TabLine", { fg = palette.light_08, bg = palette.grey_02 })
hl(0, "TabLineSel", { fg = palette.light_08, bg = palette.blue_14, bold = true })
hl(0, "TabLineFill", { bg = palette.grey_02 })

-- ======================
-- Splits
-- ======================
hl(0, "VertSplit", { fg = palette.grey_05 })
hl(0, "WinSeparator", { fg = palette.grey_05 })

-- ======================
-- Popup menu
-- ======================
hl(0, "Pmenu", { fg = palette.light_08, bg = palette.grey_02 })
hl(0, "PmenuSel", { fg = palette.light_08, bg = palette.blue_14 })

-- ======================
-- Search
-- ======================
hl(0, "Search", { bg = palette.orange_01, fg = palette.dark_06 })
hl(0, "IncSearch", { bg = palette.yellow_07, fg = palette.dark_06 })

-- ======================
-- Syntax
-- ======================
hl(0, "Comment", { fg = palette.green_10, italic = true })
hl(0, "Constant", { fg = palette.green_08 })
hl(0, "String", { fg = palette.orange_01 })
hl(0, "Identifier", { fg = palette.light_08 })
hl(0, "Function", { fg = palette.blue_21 })
hl(0, "Statement", { fg = palette.purple_03 })
hl(0, "Keyword", { fg = palette.purple_03, bold = true })
hl(0, "Type", { fg = palette.yellow_07 })
hl(0, "Number", { fg = palette.orange_01 })
hl(0, "Boolean", { fg = palette.blue_21 })
hl(0, "Operator", { fg = palette.light_08 })
hl(0, "PreProc", { fg = palette.purple_03 })
hl(0, "Special", { fg = palette.cyan or palette.blue_16 })

-- ======================
-- Diagnostics
-- ======================
hl(0, "DiagnosticError", { fg = palette.red_06 })
hl(0, "DiagnosticWarn", { fg = palette.yellow_07 })
hl(0, "DiagnosticInfo", { fg = palette.blue_21 })
hl(0, "DiagnosticHint", { fg = palette.green_08 })

-- ======================
-- LSP Semantic Tokens
-- ======================
local lsp_links = {
  -- Table/Namespace/Type
  ["@lsp.type.namespace"] = palette.blue_16,
  ["@lsp.type.type"] = palette.yellow_07,
  ["@lsp.type.class"] = palette.purple_03,
  ["@lsp.type.enum"] = palette.purple_03,
  ["@lsp.type.interface"] = palette.purple_03,
  ["@lsp.type.struct"] = palette.purple_03,
  ["@lsp.type.typeParameter"] = palette.yellow_07,

  -- Functions/Methods
  ["@lsp.type.function"] = palette.blue_21,
  ["@lsp.type.method"] = palette.blue_21,
  ["@lsp.type.constructor"] = palette.blue_16,

  -- Variables/Properties
  ["@lsp.type.parameter"] = palette.orange_01,
  ["@lsp.type.variable"] = palette.light_08,
  ["@lsp.type.property"] = palette.green_08,
  ["@lsp.type.property.readonly"] = palette.green_08,
  ["@lsp.type.enumMember"] = palette.orange_01,

  -- Keywords/Modifiers
  ["@lsp.type.keyword"] = palette.purple_03,
  ["@lsp.type.modifier"] = palette.purple_03,
  ["@lsp.type.operator"] = palette.light_08,

  -- Literals
  ["@lsp.type.string"] = palette.orange_01,
  ["@lsp.type.number"] = palette.orange_01,
  ["@lsp.type.boolean"] = palette.blue_21,

  -- Comments/Decorators
  ["@lsp.type.comment"] = palette.green_10,
  ["@lsp.type.decorator"] = palette.purple_03,
}

local function link_lsp_semantics()
  for token, color in pairs(lsp_links) do
    hl(0, token, { fg = color })
  end
end

vim.api.nvim_create_autocmd({ "ColorScheme", "LspAttach" }, {
  callback = link_lsp_semantics,
})

--------------------------------------------------------------------------------
-- Navic (breadcrumbs) colors
--------------------------------------------------------------------------------
local navic_colors = {
  NavicIconsFile = palette.fg,
  NavicIconsModule = palette.blue,
  NavicIconsNamespace = palette.purple,
  NavicIconsPackage = palette.orange,
  NavicIconsClass = palette.yellow,
  NavicIconsMethod = palette.blue,
  NavicIconsProperty = palette.green,
  NavicIconsField = palette.green,
  NavicIconsConstructor = palette.blue,
  NavicIconsEnum = palette.orange,
  NavicIconsInterface = palette.purple,
  NavicIconsFunction = palette.blue,
  NavicIconsVariable = palette.fg,
  NavicIconsConstant = palette.orange,
  NavicIconsString = palette.orange,
  NavicIconsNumber = palette.orange,
  NavicIconsBoolean = palette.blue,
  NavicIconsArray = palette.cyan,
  NavicIconsObject = palette.yellow,
  NavicIconsKey = palette.red,
  NavicIconsNull = palette.grey,
  NavicIconsEnumMember = palette.orange,
  NavicIconsStruct = palette.cyan,
  NavicIconsEvent = palette.yellow,
  NavicIconsOperator = palette.green,
  NavicIconsTypeParameter = palette.purple,
  NavicText = palette.fg,
  NavicSeparator = palette.grey,
}

for name, fg in pairs(navic_colors) do
  vim.api.nvim_set_hl(0, name, { default = true, bg = palette.bg, fg = fg })
end
