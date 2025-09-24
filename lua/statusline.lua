-- lua/statusline.lua

-- Git branch + diff
local function git_sign_with_diff()
  local dict = vim.b.gitsigns_status_dict
  if not dict or not dict.head or dict.head == "" then
    return "" -- Không có branch => không hiện gì cả
  end

  local parts = { " " .. dict.head }

  for _, key in ipairs { "added", "changed", "removed" } do
    local val = dict[key]
    if val and val > 0 then
      local hl = ({ added = "GitSignsAdd", changed = "GitSignsChange", removed = "GitSignsDelete" })[key]
      local sign = ({ added = "+", changed = "~", removed = "-" })[key]
      table.insert(parts, "%#" .. hl .. "#" .. sign .. val .. "%*")
    end
  end

  return table.concat(parts, " ")
end

local function get_relative_path()
  local filename = vim.fn.fnamemodify(vim.fn.expand "%:p", ":.")
  if #filename > 40 then
    filename = LazyVim.short_path(filename)
  end
  return filename
end

-- Diagnostics
local function diagnostics_summary()
  if not vim.diagnostic.is_enabled() then
    return ""
  end
  local counts = {}
  for sev, char in pairs { ERROR = "E", WARN = "W", HINT = "H", INFO = "I" } do
    counts[char] = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[sev] })
  end

  local parts = {}
  for sev, hl in pairs {
    E = "StatusLineDiagError",
    W = "StatusLineDiagWarn",
    H = "StatusLineDiagHint",
    I = "StatusLineDiagInfo",
  } do
    if counts[sev] > 0 then
      table.insert(parts, "%#" .. hl .. "#" .. sev .. counts[sev] .. "%*")
    end
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
  local entry = mode_map[m]
  return (entry and entry[1] or m), (entry and entry[2] or "StatusLine")
end

-- Safe filetype string
local function get_filetype()
  local ft = vim.bo.filetype
  if ft == "" then
    return ""
  end
  local ok, icons = pcall(require, "mini.icons")
  if ok and icons.get then
    return (icons.get("filetype", ft) or "") .. " " .. ft
  end
  return ft
end

local function join_nonempty(tbl, sep)
  local result = {}
  for _, v in ipairs(tbl) do
    if v and v ~= "" then
      table.insert(result, v)
    end
  end
  return table.concat(result, sep or " ")
end

-- Build statusline
function Statusline()
  local m, hl = mode_info()
  local items = {
    "%#" .. hl .. "# " .. m .. " %*",
    git_sign_with_diff(),
    "%<%#StatusLineFile# " .. get_relative_path() .. " %*",
    "%=",
    diagnostics_summary(),
    "%#StatusLineFileinfo# " .. get_filetype() .. " %*",
    "%#" .. hl .. "# %p%% %*",
  }
  return join_nonempty(items, " ")
end

vim.o.statusline = "%!v:lua.Statusline()"

local hl = vim.api.nvim_set_hl
local p = LazyVim.icons.palette

local status_hl = {
  StatusLine = { fg = p.light_08, bg = p.grey_02 },
  StatusLineNC = { fg = p.grey_05, bg = p.grey_02 },

  StatusLineNormal = { fg = p.dark_06, bg = p.blue_21, bold = true },
  StatusLineInsert = { fg = p.dark_06, bg = p.green_10, bold = true },
  StatusLineVisual = { fg = p.dark_06, bg = p.purple_03, bold = true },
  StatusLineReplace = { fg = p.dark_06, bg = p.red_06, bold = true },
  StatusLineCommand = { fg = p.dark_06, bg = p.yellow_07, bold = true },

  StatusLineFile = { fg = p.light_08, bg = p.grey_02 },
  StatusLineFileinfo = { fg = p.light_05, bg = p.grey_03 },

  StatusLineGit = { fg = p.orange_01, bg = p.grey_02 },

  StatusLineDiagError = { fg = p.red_06, bg = p.grey_02 },
  StatusLineDiagWarn = { fg = p.yellow_07, bg = p.grey_02 },
  StatusLineDiagInfo = { fg = p.blue_21, bg = p.grey_02 },
  StatusLineDiagHint = { fg = p.green_08, bg = p.grey_02 },
}

for name, opts in pairs(status_hl) do
  hl(0, name, opts)
end
