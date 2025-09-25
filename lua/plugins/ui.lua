return {
  -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = require("configs.ui.noice").opts,
    config = require("configs.ui.noice").config,
    keys = require("configs.ui.noice").keys,
  },

  -- icons
  {
    "nvim-mini/mini.icons",
    lazy = true, -- lazy-load
    init = function()
      require("configs.ui.mini-icons").init() -- chỉ chuẩn bị mock, không setup plugin
    end,
    config = function()
      local opts = require("configs.ui.mini-icons").opts
      require("mini.icons").setup(opts) -- setup plugin 1 lần
    end,
  },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "nvim-mini/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "VeryLazy",
    init = require("configs.ui.mini-indentscope").init,
    opts = require("configs.ui.mini-indentscope").opts,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblIndent", tab_char = "│" },
      scope = { enabled = false },
    },
    config = function(_, opts)
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)
    end,
  },
}
