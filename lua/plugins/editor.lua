return {
  {
    "echasnovski/mini.bufremove",
    version = false,
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)",
      },
    },
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
  -- {
  --   "folke/todo-comments.nvim",
  --   cmd = { "TodoTrouble", "TodoTelescope" },
  --   event = "User FilePost",
  --   opts = require("configs.editor.todo-comments").opts,
  --   keys = require("configs.editor.todo-comments").keys,
  -- },

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
