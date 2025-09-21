return {
  {
    "echasnovski/mini.notify",
    event = { "User LazyUIEnter", "LspAttach" },
    config = function()
      local win_config = function()
        local has_statusline = vim.o.laststatus > 0
        local bottom_space = vim.o.cmdheight + (has_statusline and 1 or 0)
        return { border = "single", anchor = "SE", col = vim.o.columns, row = vim.o.lines - bottom_space }
        -- return { border = "single", anchor = "SE", col = vim.o.columns, row = bottom_space }
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
      local opts = {}
      vim.notify = require("mini.notify").make_notify(opts)
      vim.api.nvim_create_user_command("Notifyhistory", function()
        require("mini.notify").show_history()
      end, {
        desc = "Show mini notify history",
      })
    end,
  },
}
