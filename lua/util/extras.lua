---@class lazyvim.util.extras
local M = {}

---@alias WantsOpts {ft?: string|string[], root?: string|string[]}

---@param opts WantsOpts
---@return boolean
function M.wants(opts)
  local buf = vim.api.nvim_get_current_buf()

  -- If both ft and root are specified, both must match
  if opts.ft and opts.root then
    -- Check filetype condition
    local ft_match = false
    opts.ft = type(opts.ft) == "string" and { opts.ft } or opts.ft
    for _, f in ipairs(opts.ft) do
      if vim.bo[buf].filetype == f then
        ft_match = true
        break
      end
    end

    -- Check root condition
    local root_match = false
    if ft_match then -- Only check root if filetype matches
      opts.root = type(opts.root) == "string" and { opts.root } or opts.root
      local roots = LazyVim.root.detectors.pattern(buf, opts.root)
      root_match = #roots > 0
    end

    return ft_match and root_match
  end

  -- If only ft is specified
  if opts.ft then
    opts.ft = type(opts.ft) == "string" and { opts.ft } or opts.ft
    for _, f in ipairs(opts.ft) do
      if vim.bo[buf].filetype == f then
        return true
      end
    end
    return false
  end

  -- If only root is specified
  if opts.root then
    opts.root = type(opts.root) == "string" and { opts.root } or opts.root
    local roots = LazyVim.root.detectors.pattern(buf, opts.root)
    return #roots > 0
  end

  -- If neither is specified, return false (safer default)
  return false
end

return M
