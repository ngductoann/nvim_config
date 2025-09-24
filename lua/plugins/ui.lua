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
    lazy = true,
    init = require("configs.ui.mini-icons").init,
    config = require("configs.ui.mini-icons").config,
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
}
