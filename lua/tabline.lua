-- ~/.config/nvim/lua/tabline.lua
local M = {}

-- Rút ngắn path nếu trùng tên
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

-- Lấy label hiển thị cho buffer
local function buf_label(buf_id)
  local name = vim.api.nvim_buf_get_name(buf_id)
  if name == "" then
    return "[No Name]"
  end

  local filename = vim.fn.fnamemodify(name, ":t")
  local rel_path = vim.fn.fnamemodify(name, ":.")

  -- Kiểm tra duplicate
  local duplicate = false
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted then
      local other = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ":t")
      if other == filename and b ~= buf_id then
        duplicate = true
        break
      end
    end
  end

  local display = duplicate and short_path(rel_path) or filename

  -- Icon filetype
  local ft = vim.bo[buf_id].filetype
  local icon = ""
  local ok, mini_icons = pcall(require, "mini.icons")
  if ok and ft ~= "" then
    icon = mini_icons.get("filetype", ft)
    if type(icon) ~= "string" then
      icon = ""
    end
  end

  -- Modified / readonly
  local modified = vim.bo[buf_id].modified and " [+]" or ""
  local readonly = (not vim.bo[buf_id].modifiable or vim.bo[buf_id].readonly) and " " or ""

  -- Format: | ICON PATH [+/]
  return string.format("| %s %s%s%s ", icon, display, modified, readonly)
end

-- Render tabline
function M.render_tabline()
  local s = ""
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and vim.bo[buf].buftype == "" then
      -- Highlight active buffer
      local hl = (buf == vim.api.nvim_get_current_buf()) and "%#TabLineSel#" or "%#TabLine#"
      local label = buf_label(buf)
      s = s .. hl .. label
    end
  end
  return s .. "%#TabLineFill#"
end

-- Cấu hình Vim
vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.require'tabline'.render_tabline()"

return M
