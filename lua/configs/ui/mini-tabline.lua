local function short_path(path)
  local parts = vim.split(path, "/")
  if #parts <= 2 then
    return path
  end

  for i = 1, #parts - 1 do
    local p = parts[i]
    if p ~= "" then
      parts[i] = string.sub(p, 1, 1) -- lấy chữ cái đầu
    end
  end

  return table.concat(parts, "/")
end

return {
  opts = {
    format = function(buf_id, label)
      local name = vim.api.nvim_buf_get_name(buf_id)
      if name == "" then
        return "[No Name]"
      end

      local filename = vim.fn.fnamemodify(name, ":t") -- chỉ tên file
      local rel_path = vim.fn.fnamemodify(name, ":.") -- full relative path

      -- kiểm tra có trùng filename không
      local duplicate = false
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(b) and b ~= buf_id then
          local other = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ":t")
          if other == filename then
            duplicate = true
            break
          end
        end
      end

      -- chọn hiển thị path rút gọn nếu bị trùng
      local display = duplicate and short_path(rel_path) or filename

      -- filetype + icon
      local ft = vim.bo[buf_id].filetype
      local icon = ""
      if ft ~= "" then
        local ok, mini_icons = pcall(require, "mini.icons")
        if ok then
          icon = mini_icons.get("filetype", ft) or ""
        end
      end

      -- modified flag
      local modified = vim.bo[buf_id].modified and " [+]" or ""

      -- readonly flag
      local readonly = (not vim.bo[buf_id].modifiable or vim.bo[buf_id].readonly) and " " or ""

      return string.format("|%s %s %s%s ", modified, icon, display, readonly)
    end,
  },
}
