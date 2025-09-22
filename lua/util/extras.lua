---@class util.extras
local M = {}

---@alias WantsOpts {ft?: string|string[]}

---@param opts WantsOpts
---@return boolean
function M.wants(opts)
  local buf = 0 -- current buffer
  if opts.ft then
    opts.ft = type(opts.ft) == "string" and { opts.ft } or opts.ft
    for _, f in ipairs(opts.ft) do
      if vim.bo[buf].filetype == f then
        return true
      end
    end
  end
  return false
end

return M
