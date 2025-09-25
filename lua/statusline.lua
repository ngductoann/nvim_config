-- lua/statusline.lua
local M = {}
local cache = { git = "", diag = "", file = "" }

local function hl(group, text)
  return "%#" .. group .. "#" .. text .. "%*"
end

local function join_nonempty(parts, sep)
  local res = {}
  sep = sep or " "
  for _, p in ipairs(parts) do
    if p and p ~= "" then
      table.insert(res, p)
    end
  end
  return table.concat(res, sep)
end

-- ==================
-- Segments
-- ==================
local mode_map = {
  n = { "NORMAL", "StatusLineNormal" },
  i = { "INSERT", "StatusLineInsert" },
  v = { "VISUAL", "StatusLineVisual" },
  V = { "V-LINE", "StatusLineVisual" },
  [""] = { "V-BLOCK", "StatusLineVisual" },
  R = { "REPLACE", "StatusLineReplace" },
  c = { "COMMAND", "StatusLineCommand" },
}

local function mode_segment()
  local m = vim.api.nvim_get_mode().mode
  local e = mode_map[m] or { m, "StatusLine" }
  local label, group = e[1], e[2]
  return hl(group, " " .. label .. " ")
end

local function git_segment()
  local g = vim.b.gitsigns_status_dict
  if not g or not g.head or g.head == "" then
    return ""
  end
  local parts = { " " .. g.head }
  if g.added and g.added > 0 then
    table.insert(parts, hl("GitSignsAdd", "+" .. g.added))
  end
  if g.changed and g.changed > 0 then
    table.insert(parts, hl("GitSignsChange", "~" .. g.changed))
  end
  if g.removed and g.removed > 0 then
    table.insert(parts, hl("GitSignsDelete", "-" .. g.removed))
  end
  return table.concat(parts, " ")
end

local function file_path_segment()
  local name = vim.fn.fnamemodify(vim.fn.expand "%:p", ":.")
  if name == "" then
    name = "[No Name]"
  end
  if #name > 40 and LazyVim and LazyVim.short_path then
    name = LazyVim.short_path(name)
  end
  return name
end

local function diagnostics_segment()
  if not vim.diagnostic.is_enabled() then
    return ""
  end
  local parts = {}
  local sevmap = {
    { vim.diagnostic.severity.ERROR, "E", "StatusLineDiagError" },
    { vim.diagnostic.severity.WARN, "W", "StatusLineDiagWarn" },
    { vim.diagnostic.severity.INFO, "I", "StatusLineDiagInfo" },
    { vim.diagnostic.severity.HINT, "H", "StatusLineDiagHint" },
  }
  for _, s in ipairs(sevmap) do
    local count = #vim.diagnostic.get(0, { severity = s[1] })
    if count > 0 then
      table.insert(parts, hl(s[3], s[2] .. count))
    end
  end
  return table.concat(parts, " ")
end

local function filetype_segment()
  local ft = vim.bo.filetype
  if ft == "" then
    return ""
  end
  local icon = ""
  pcall(function()
    local icons = require "mini.icons"
    icon = icons.get("filetype", ft) or ""
  end)
  return (icon ~= "" and icon .. " " or "") .. ft
end

-- ==================
-- Cache updates
-- ==================
-- cache git khi BufEnter, BufWritePost hoặc khi Gitsigns update
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  callback = function()
    cache.git = git_segment()
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "GitSignsUpdate",
  callback = function()
    cache.git = git_segment()
  end,
})

-- cache diagnostics khi thay đổi
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    cache.diag = diagnostics_segment()
  end,
})

-- cache filename khi vào buffer
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    cache.file = file_path_segment()
  end,
})

-- ==================
-- Renderer
-- ==================
function Statusline()
  local mode = mode_segment()
  local ft = filetype_segment()
  local items = {
    mode,
    cache.git,
    "%<%#StatusLineFile# " .. cache.file .. " %*",
    "%=",
    cache.diag,
    "%#StatusLineFileinfo# " .. ft .. " %*",
    "%#StatusLine# %p%% %*",
  }
  return join_nonempty(items, " ")
end

vim.o.statusline = "%!v:lua.Statusline()"

return M
