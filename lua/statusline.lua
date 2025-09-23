-- lua/statusline.lua

-- Git branch + diff
local function git_sign_with_diff()
  local dict = vim.b.gitsigns_status_dict
  if not dict or not dict.head or dict.head == "" then
    return ""
  end
  local parts = { " " .. dict.head }
  if dict.added and dict.added > 0 then
    table.insert(parts, "%#GitSignsAdd#+" .. dict.added .. "%*")
  end
  if dict.changed and dict.changed > 0 then
    table.insert(parts, "%#GitSignsChange#~" .. dict.changed .. "%*")
  end
  if dict.removed and dict.removed > 0 then
    table.insert(parts, "%#GitSignsDelete#-" .. dict.removed .. "%*")
  end
  return table.concat(parts, " ")
end

-- Shorten path
local function short_path(path)
  local parts = vim.split(path, "/")
  if #parts <= 2 then
    return path
  end
  for i = 1, #parts - 1 do
    if parts[i] ~= "" then
      parts[i] = string.sub(parts[i], 1, 1)
    end
  end
  return table.concat(parts, "/")
end

local function get_relative_path()
  local filename = vim.fn.fnamemodify(vim.fn.expand "%:p", ":.")
  if string.len(filename) > 40 then
    filename = short_path(filename)
  end
  return filename or ""
end

-- Diagnostics
local function diagnostics_summary()
  if not vim.diagnostic.is_enabled() then
    return ""
  end
  local counts = {
    E = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
    W = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
    H = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }),
    I = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
  }
  local parts = {}
  if counts.E > 0 then
    table.insert(parts, "%#StatusLineDiagError#E" .. counts.E .. "%*")
  end
  if counts.W > 0 then
    table.insert(parts, "%#StatusLineDiagWarn#W" .. counts.W .. "%*")
  end
  if counts.H > 0 then
    table.insert(parts, "%#StatusLineDiagHint#H" .. counts.H .. "%*")
  end
  if counts.I > 0 then
    table.insert(parts, "%#StatusLineDiagInfo#I" .. counts.I .. "%*")
  end
  return table.concat(parts, " ")
end

-- Mode highlight
local mode_map = {
  n = { "NORMAL", "StatusLineNormal" },
  i = { "INSERT", "StatusLineInsert" },
  v = { "VISUAL", "StatusLineVisual" },
  V = { "V-LINE", "StatusLineVisual" },
  [""] = { "V-BLOCK", "StatusLineVisual" },
  R = { "REPLACE", "StatusLineReplace" },
  c = { "COMMAND", "StatusLineCommand" },
}
local function mode_info()
  local m = vim.api.nvim_get_mode().mode
  local entry = mode_map[m] or { m, "StatusLine" }
  return entry[1], entry[2]
end

-- Safe filetype string
local function get_filetype()
  if vim.bo.filetype == "" then
    return ""
  end
  local ok, icons = pcall(require, "mini.icons")
  if ok and icons and icons.get then
    local icon = icons.get("filetype", vim.bo.filetype)
    return tostring(icon or "") .. " " .. vim.bo.filetype
  end
  return vim.bo.filetype
end

-- Build statusline
function Statusline()
  local m, hl = mode_info()
  local git = git_sign_with_diff()
  local diagnostics = diagnostics_summary()
  local filename = get_relative_path()
  local filetype = get_filetype()

  local items = {
    "%#",
    hl or "StatusLine",
    "# " .. tostring(m) .. " %*",
  }
  if git ~= "" then
    table.insert(items, " " .. tostring(git) .. " ")
  end
  table.insert(items, "%<%#StatusLineFile# " .. tostring(filename) .. " %*")
  table.insert(items, "%=")
  if diagnostics ~= "" then
    table.insert(items, " " .. tostring(diagnostics) .. " ")
  end
  if filetype ~= "" then
    table.insert(items, "%#StatusLineFileinfo# " .. tostring(filetype) .. " %*")
  end
  table.insert(items, "%#" .. (hl or "StatusLine") .. "# %p%% %*")

  return table.concat(items, "")
end

vim.o.statusline = "%!v:lua.Statusline()"

-- Highlights
vim.api.nvim_set_hl(0, "StatusLineNormal", { fg = "#ffffff", bg = "#005f5f", bold = true })
vim.api.nvim_set_hl(0, "StatusLineInsert", { fg = "#ffffff", bg = "#5f0000", bold = true })
vim.api.nvim_set_hl(0, "StatusLineVisual", { fg = "#ffffff", bg = "#5f00af", bold = true })
vim.api.nvim_set_hl(0, "StatusLineReplace", { fg = "#ffffff", bg = "#870000", bold = true })
vim.api.nvim_set_hl(0, "StatusLineCommand", { fg = "#ffffff", bg = "#875f00", bold = true })

vim.api.nvim_set_hl(0, "StatusLineFile", { fg = "#ffffff", bg = "#303030" })
vim.api.nvim_set_hl(0, "StatusLineFileinfo", { fg = "#d0d0d0", bg = "#262626" })

vim.api.nvim_set_hl(0, "StatusLineDiagError", { fg = "#ff5f5f", bg = "#262626" })
vim.api.nvim_set_hl(0, "StatusLineDiagWarn", { fg = "#ffaf00", bg = "#262626" })
vim.api.nvim_set_hl(0, "StatusLineDiagHint", { fg = "#5fd7ff", bg = "#262626" })
vim.api.nvim_set_hl(0, "StatusLineDiagInfo", { fg = "#5fff87", bg = "#262626" })
