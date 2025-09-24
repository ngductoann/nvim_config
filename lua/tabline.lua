-- ~/.config/nvim/lua/tabline.lua
local M = {}

-- Cache mini.icons
local ok_icons, mini_icons = pcall(require, "mini.icons")

-- Lấy label hiển thị cho buffer
local function buf_label(buf_id, counts)
  local name = vim.api.nvim_buf_get_name(buf_id)
  if name == "" then
    return "[No Name]"
  end

  local filename = vim.fn.fnamemodify(name, ":t")
  local rel_path = vim.fn.fnamemodify(name, ":.")
  local display = (counts[filename] or 0) > 1 and LazyVim.short_path(rel_path) or filename

  -- Icon filetype
  local ft = vim.bo[buf_id].filetype
  local icon = ""
  if ok_icons and ft ~= "" then
    local ic = mini_icons.get("filetype", ft)
    icon = type(ic) == "string" and ic or ""
  end

  -- Modified / readonly
  local modified = vim.bo[buf_id].modified and " [+]" or ""
  local readonly = (not vim.bo[buf_id].modifiable or vim.bo[buf_id].readonly) and " " or ""

  return string.format("| %s %s%s%s ", icon, display, modified, readonly)
end

-- Render tabline
function M.render_tabline()
  local bufs, counts, parts = {}, {}, {}

  -- Collect buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and vim.bo[buf].buftype == "" then
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
      counts[filename] = (counts[filename] or 0) + 1
      table.insert(bufs, buf)
    end
  end

  -- Render
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(bufs) do
    local hl = (buf == current) and "%#TabLineSel#" or "%#TabLine#"
    table.insert(parts, hl .. buf_label(buf, counts))
  end

  table.insert(parts, "%#TabLineFill#")
  return table.concat(parts, "")
end

-- Cấu hình Vim
vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.require'tabline'.render_tabline()"

return M
