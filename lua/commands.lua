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

-- lua/colors/vscode_modern_dark.lua
local hl = vim.api.nvim_set_hl
local palette = LazyVim.icons.palette

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
  NavicIconsFile = palette.light_08,
  NavicIconsModule = palette.blue_21,
  NavicIconsNamespace = palette.purple_03,
  NavicIconsPackage = palette.orange_01,
  NavicIconsClass = palette.yellow_07,
  NavicIconsMethod = palette.blue_21,
  NavicIconsProperty = palette.green_08,
  NavicIconsField = palette.green_08,
  NavicIconsConstructor = palette.blue_16,
  NavicIconsEnum = palette.orange_01,
  NavicIconsInterface = palette.purple_03,
  NavicIconsFunction = palette.blue_21,
  NavicIconsVariable = palette.light_08,
  NavicIconsConstant = palette.orange_01,
  NavicIconsString = palette.orange_01,
  NavicIconsNumber = palette.orange_01,
  NavicIconsBoolean = palette.blue_21,
  NavicIconsArray = palette.blue_16,
  NavicIconsObject = palette.yellow_07,
  NavicIconsKey = palette.red_06,
  NavicIconsNull = palette.light_08,
  NavicIconsEnumMember = palette.orange_01,
  NavicIconsStruct = palette.purple_03,
  NavicIconsEvent = palette.blue_21,
  NavicIconsOperator = palette.light_08,
  NavicIconsTypeParameter = palette.yellow_07,

  NavicText = palette.light_08,
  NavicSeparator = palette.grey_14,
}

for group, color in pairs(navic_colors) do
  hl(0, group, { fg = color, bg = "NONE" })
end

--------------------------------------------------------------------------------
-- Winbar colors
--------------------------------------------------------------------------------
-- Tương tự statusline nhưng hơi nhạt hơn để phân biệt
hl(0, "WinBar", { fg = palette.light_08, bg = palette.grey_02 })
hl(0, "WinBarNC", { fg = palette.grey_14, bg = palette.grey_02 })
hl(0, "WinBarFile", { fg = palette.blue_21, bg = palette.grey_02, bold = true })
hl(0, "WinBarPath", { fg = palette.grey_21, bg = palette.grey_02 })
