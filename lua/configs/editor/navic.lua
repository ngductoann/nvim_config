-- shorten path: src/handlers/main.go -> s/h/main.go
local function shorten_path(path)
  local parts = vim.split(path, "/", { plain = true })
  if #parts <= 2 then
    return path -- ngắn thì giữ nguyên
  end

  for i = 1, #parts - 1 do
    local name = parts[i]
    if #name > 1 then
      parts[i] = name:sub(1, 1) -- chỉ giữ chữ đầu
    end
  end

  return table.concat(parts, "/")
end

-- helper: lấy icon + short path + tên file
local function get_file_icon_and_name(bufnr)
  bufnr = bufnr or 0

  local icon = "󰈚"
  local name = ""

  local path = vim.api.nvim_buf_get_name(bufnr)
  local buftype = vim.bo[bufnr].buftype

  if buftype == "nofile" or path == "" then
    name = vim.fn.expand "%:t"
  else
    -- path tương đối từ cwd/home
    local relpath = vim.fn.fnamemodify(path, ":~:.")
    if #relpath > 30 then
      relpath = shorten_path(relpath)
    end
    name = relpath ~= "" and relpath or vim.fn.fnamemodify(path, ":t")
  end

  if name == "" then
    name = "Empty"
  end

  local ok, mini_icons = pcall(require, "mini.icons")
  if ok and path ~= "" then
    local filename = vim.fn.fnamemodify(path, ":t")
    local ext = vim.fn.fnamemodify(path, ":e")

    icon = mini_icons.get("extension", ext) or mini_icons.get("file", filename) or icon
  end

  return icon, name
end

-- helper: filter navic theo ft/bt
local function should_show_navic(buf)
  local ft = vim.bo[buf].filetype
  local bt = vim.bo[buf].buftype

  local exclude_ft = {
    "neo-tree",
    "NvimTree",
    "fzf",
    "toggleterm",
    "help",
    "gitcommit",
    "alpha",
  }

  local exclude_bt = {
    "terminal",
    "nofile",
    "prompt",
  }

  return not vim.tbl_contains(exclude_ft, ft) and not vim.tbl_contains(exclude_bt, bt)
end

return {
  init = function()
    vim.g.navic_silence = true

    -- setup navic + winbar
    local function setup_winbar(client, buffer)
      if client:supports_method "textDocument/documentSymbol" then
        if should_show_navic(buffer) then
          local icon, name = get_file_icon_and_name(buffer)
          require("nvim-navic").attach(client, buffer)
          vim.api.nvim_set_option_value(
            "winbar",
            vim.trim(icon .. " " .. name .. "  " .. "%{%v:lua.require'nvim-navic'.get_location()%}"),
            { scope = "local", win = 0 }
          )
        else
          vim.api.nvim_set_option_value("winbar", nil, { scope = "local", win = 0 })
        end
      end
    end

    -- gắn vào LSP
    LazyVim.lsp.on_attach(setup_winbar)

    -- 🔄 reload winbar khi mở file mới
    vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost" }, {
      callback = function(args)
        local bufnr = args.buf
        local clients = vim.lsp.get_clients { bufnr = bufnr }
        for _, client in ipairs(clients) do
          setup_winbar(client, bufnr)
        end
      end,
    })
  end,
  opts = function()
    return {
      separator = "  ",
      highlight = true,
      depth_limit = 5,
      icons = require("icons").icons_vscode,
      lazy_update_context = true,
    }
  end,
}
