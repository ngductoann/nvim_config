return {
  { "nvim-tree/nvim-web-devicons", opts = {} },
  {
    "echasnovski/mini.notify",
    event = { "User LazyUIEnter", "LspAttach" },
    config = function()
      local win_config = function()
        local has_statusline = vim.o.laststatus > 0
        local bottom_space = vim.o.cmdheight + (has_statusline and 1 or 0)
        return {
          border = "single",
          anchor = "SE",
          col = vim.o.columns,
          row = vim.o.lines - bottom_space,
        }
      end

      require("mini.notify").setup {
        lsp_progress = {
          enable = false,
        },
        window = {
          config = win_config,
          winblend = 20,
        },
      }

      local mini_notify = require("mini.notify").make_notify {}

      -- bọc notify để lọc message rác
      vim.notify = function(msg, level, opts)
        if type(msg) == "string" and msg:match "No signature help available" then
          return
        end
        return mini_notify(msg, level, opts)
      end

      vim.api.nvim_create_user_command("Notifyhistory", function()
        require("mini.notify").show_history()
      end, {
        desc = "Show mini notify history",
      })
    end,
  },
}
