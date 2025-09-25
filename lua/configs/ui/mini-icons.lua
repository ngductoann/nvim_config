-- ~/.config/nvim/lua/configs/ui/mini-icons.lua
local M = {}

-- ==========================
-- Options cho mini.icons
-- ==========================
M.opts = {
  file = {
    [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
    ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
  },
  filetype = {
    dotenv = { glyph = "", hl = "MiniIconsYellow" },
  },
}

-- ==========================
-- Init: chỉ mock devicons khi buffer đầu tiên được đọc
-- ==========================
M.init = function()
  vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function()
      local mini_icons = require "mini.icons" -- chỉ require khi BufReadPre
      package.preload["nvim-web-devicons"] = function()
        mini_icons.mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  })
end

return M
