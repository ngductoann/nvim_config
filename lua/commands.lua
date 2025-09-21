-- mason, write correct names only
vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd "MasonInstall css-lsp html-lsp lua-language-server typescript-language-server stylua prettier"
end, {})

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

-- paste vào config lua của bạn
local lsp_links = {
  ["@lsp.type.namespace"] = "Identifier",
  ["@lsp.type.type"] = "Type",
  ["@lsp.type.class"] = "Type",
  ["@lsp.type.enum"] = "Type",
  ["@lsp.type.interface"] = "Type",
  ["@lsp.type.struct"] = "Type",
  ["@lsp.type.parameter"] = "Identifier",
  ["@lsp.type.variable"] = "Identifier",
  ["@lsp.type.property"] = "Identifier",
  ["@lsp.type.enumMember"] = "Constant",
  ["@lsp.type.function"] = "Function",
  ["@lsp.type.method"] = "Function",
  ["@lsp.type.keyword"] = "Keyword",
  ["@lsp.type.modifier"] = "Keyword",
  ["@lsp.type.comment"] = "Comment",
  ["@lsp.type.string"] = "String",
  ["@lsp.type.number"] = "Number",
  ["@lsp.type.operator"] = "Operator",
}

local function link_lsp_semantics()
  for grp, link in pairs(lsp_links) do
    pcall(vim.api.nvim_set_hl, 0, grp, { link = link })
  end
end

-- Chạy khi colorscheme thay đổi (load lần đầu) và khi LSP attach
vim.api.nvim_create_autocmd({ "ColorScheme", "LspAttach" }, {
  callback = link_lsp_semantics,
})

local colors = require("icons").colors

local navic_colors = {
  NavicIconsFile = colors.base05,
  NavicIconsModule = colors.base0C,
  NavicIconsNamespace = colors.base08,
  NavicIconsPackage = colors.base09,
  NavicIconsClass = colors.base0A,
  NavicIconsMethod = colors.base0E,
  NavicIconsProperty = colors.base0B,
  NavicIconsField = colors.base0B,
  NavicIconsConstructor = colors.base0D,
  NavicIconsEnum = colors.base0B,
  NavicIconsInterface = colors.base0E,
  NavicIconsFunction = colors.base0D,
  NavicIconsVariable = colors.base08,
  NavicIconsConstant = colors.base09,
  NavicIconsString = colors.base0A,
  NavicIconsNumber = colors.base09,
  NavicIconsBoolean = colors.base09,
  NavicIconsArray = colors.base0C,
  NavicIconsObject = colors.base0A,
  NavicIconsKey = colors.base08,
  NavicIconsNull = colors.base03,
  NavicIconsEnumMember = colors.base0B,
  NavicIconsStruct = colors.base0C,
  NavicIconsEvent = colors.base0A,
  NavicIconsOperator = colors.base0B,
  NavicIconsTypeParameter = colors.base0E,
  NavicText = colors.base05,
  NavicSeparator = colors.base04,
}

for name, fg in pairs(navic_colors) do
  vim.api.nvim_set_hl(0, name, { default = true, bg = colors.base00, fg = fg })
end
