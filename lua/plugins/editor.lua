return {
  {
    "echasnovski/mini.bufremove",
    version = false,
    lazy = true, -- plugin chỉ load khi nhấn key
    keys = {
      { "<leader>bd", desc = "Delete current buffer" },
      { "<leader>bD", desc = "Delete current buffer (force)" },
      { "<leader>bo", desc = "Delete other buffers" },
      { "<leader>ba", desc = "Delete all buffers" },
    },
    config = function()
      local map = vim.keymap.set

      -- Lấy danh sách buffer "listed"
      local function listed_buffers()
        return vim.tbl_filter(function(buf)
          return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
        end, vim.api.nvim_list_bufs())
      end

      -- Xoá buffer hiện tại
      local function delete_current(force)
        local bufremove = require "mini.bufremove"
        bufremove.delete(0, force or false)
      end

      -- Xoá tất cả buffer trừ buffer hiện tại
      local function delete_other(force)
        local bufremove = require "mini.bufremove"
        local cur = vim.api.nvim_get_current_buf()
        for _, buf in ipairs(listed_buffers()) do
          if buf ~= cur then
            bufremove.delete(buf, force or false)
          end
        end
      end

      -- Xoá toàn bộ buffer
      local function delete_all(force)
        local bufremove = require "mini.bufremove"
        for _, buf in ipairs(listed_buffers()) do
          bufremove.delete(buf, force or false)
        end
      end

      -- Mapping keymap
      map("n", "<leader>bd", function()
        delete_current(false)
      end, { desc = "Delete buffer" })
      map("n", "<leader>bD", function()
        delete_current(true)
      end, { desc = "Delete buffer (force)" })
      map("n", "<leader>bo", function()
        delete_other(false)
      end, { desc = "Delete other buffers" })
      map("n", "<leader>ba", function()
        delete_all(false)
      end, { desc = "Delete all buffers" })
    end,
  },

  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    init = require("configs.editor.fzf-lua").init,
    opts = require("configs.editor.fzf-lua").opts,
    config = require("configs.editor.fzf-lua").config,
    keys = require("configs.editor.fzf-lua").keys,
  },

  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = require("configs.editor.which-key").opts,
    config = require("configs.editor.which-key").config,
    keys = require("configs.editor.which-key").keys,
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = require("configs.editor.trouble").opts,
    keys = require("configs.editor.trouble").keys,
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "User FilePost",
    opts = require("configs.editor.todo-comments").opts,
    keys = require("configs.editor.todo-comments").keys,
  },

  {
    "nvim-mini/mini.files",
    opts = require("configs.editor.mini-files").opts,
    config = require("configs.editor.mini-files").config,
    keys = require("configs.editor.mini-files").keys,
  },

  {
    "RRethy/vim-illuminate",
    event = "User FilePost",
    opts = require("configs.editor.vim-illuminate").opts,
    config = require("configs.editor.vim-illuminate").config,
    keys = require("configs.editor.vim-illuminate").keys,
  },

  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = require("configs.editor.navic").init,
    opts = require("configs.editor.navic").opts,
  },

  -- {
  --   "SmiteshP/nvim-navbuddy",
  --   dependencies = {
  --     "SmiteshP/nvim-navic",
  --     "MunifTanjim/nui.nvim",
  --   },
  --   opts = require("configs.editor.nvim-navbuddy").opts,
  --   keys = require("configs.editor.nvim-navbuddy").keys,
  -- },
}
