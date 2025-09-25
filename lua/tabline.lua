-- ~/.config/nvim/lua/tabline.lua
local M = {}

-- Cache mini.icons (lazy load)
local ok_icons, mini_icons
local function get_mini_icons()
  if ok_icons == nil then
    ok_icons, mini_icons = pcall(require, "mini.icons")
  end
  return ok_icons and mini_icons or nil
end

-- ======================
-- Helper functions
-- ======================

-- Get file icon
local function get_icon(buf_id)
  local icons = get_mini_icons()
  if not icons then
    return ""
  end
  local ft = vim.bo[buf_id].filetype
  if ft == "" then
    return ""
  end
  local ic = icons.get("filetype", ft)
  return type(ic) == "string" and ic or ""
end

-- Get display name (handle duplicates)
local function get_display_name(buf_id, counts)
  local name = vim.api.nvim_buf_get_name(buf_id)
  if name == "" then
    return "[No Name]"
  end

  local filename = vim.fn.fnamemodify(name, ":t")
  local rel_path = vim.fn.fnamemodify(name, ":.")
  return (counts[filename] or 0) > 1 and LazyVim.short_path(rel_path) or filename
end

-- Get marks: modified / readonly
local function get_marks(buf_id)
  local modified = vim.bo[buf_id].modified and " [+]" or ""
  local readonly = (not vim.bo[buf_id].modifiable or vim.bo[buf_id].readonly) and " " or ""
  return modified .. readonly
end

-- Build label for buffer
local function buf_label(buf_id, counts)
  return string.format("| %s %s%s ", get_icon(buf_id), get_display_name(buf_id, counts), get_marks(buf_id))
end

-- Collect visible buffers and counts
local function get_visible_buffers()
  local bufs, counts = {}, {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and vim.bo[buf].buftype == "" then
      local name = vim.api.nvim_buf_get_name(buf)
      local filename = vim.fn.fnamemodify(name, ":t")
      counts[filename] = (counts[filename] or 0) + 1
      table.insert(bufs, buf)
    end
  end
  return bufs, counts
end

-- ======================
-- Render tabline
-- ======================
function M.render_tabline()
  local bufs, counts = get_visible_buffers()
  local parts = {}
  local current = vim.api.nvim_get_current_buf()

  for _, buf in ipairs(bufs) do
    local hl = (buf == current) and "%#TabLineSel#" or "%#TabLine#"
    table.insert(parts, hl .. buf_label(buf, counts))
  end

  table.insert(parts, "%#TabLineFill#")
  return table.concat(parts, "")
end

-- ======================
-- Vim config
-- ======================
vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.require'tabline'.render_tabline()"

return M
