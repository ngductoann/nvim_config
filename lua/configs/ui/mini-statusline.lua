-- helper: git branch + diff
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

local function get_relative_path()
  local filename = vim.fn.fnamemodify(vim.fn.expand "%:p", ":.")
  if string.len(filename) > 40 then
    filename = short_path(filename)
  end
  return filename
end

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
    table.insert(parts, "E" .. counts.E)
  end
  if counts.W > 0 then
    table.insert(parts, "W" .. counts.W)
  end
  if counts.H > 0 then
    table.insert(parts, "H" .. counts.H)
  end
  if counts.I > 0 then
    table.insert(parts, "I" .. counts.I)
  end

  return table.concat(parts, " ")
end

return {
  opts = {
    set_vim_settings = false,
    content = {
      active = function()
        local MiniStatusline = require "mini.statusline"
        local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }

        local git = git_sign_with_diff()
        local diagnostics = diagnostics_summary()
        local filename = get_relative_path()
        local filetype = vim.bo.filetype ~= ""
            and (require("mini.icons").get("filetype", vim.bo.filetype) .. " " .. vim.bo.filetype)
          or ""

        return MiniStatusline.combine_groups {
          { hl = mode_hl, strings = { mode:upper() } },
          { hl = "MiniStatuslineDevinfo", strings = { git } },
          "%<",
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=",
          { hl = "MiniStatuslineFileinfo", strings = { diagnostics, filetype } },
          { hl = mode_hl, strings = { "%p%%" } },
        }
      end,
    },
  },
}
