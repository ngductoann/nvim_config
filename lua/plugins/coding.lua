return {
  -- Auto pairs
  -- Automatically inserts a matching closing character
  -- when you type an opening character like `"`, `[`, or `(`.
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = require("configs.coding.mini-pairs").opts,
    config = require("configs.coding.mini-pairs").config,
  },

  -- Improves comment syntax, lets Neovim handle multiple
  -- types of comments for a single language, and relaxes rules
  -- for uncommenting.
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Extends the a & i text objects, this adds the ability to select
  -- arguments, function calls, text within quotes and brackets, and to
  -- repeat those selections to select an outer text object.
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = require("configs.coding.mini-ai").opts,
    config = require("configs.coding.mini-ai").config,
  },

  -- Configures LuaLS to support auto-completion and type checking
  -- while editing your Neovim configuration.
  -- {
  --   "folke/lazydev.nvim",
  --   ft = "lua",
  --   cmd = "LazyDev",
  --   opts = {
  --     library = {
  --       { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  --       { path = "LazyVim", words = { "LazyVim" } },
  --       { path = "lazy.nvim", words = { "LazyVim" } },
  --     },
  --   },
  -- },

  -- add luasnip
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = (not LazyVim.is_win())
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load { paths = { vim.fn.stdpath "config" .. "/snippets" } }
        end,
      },
    },
    opts = require("configs.coding.luasnip").opts,
  },

  {
    "saghen/blink.cmp",
    version = not vim.g.lazyvim_blink_main and "*",
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- add blink.compat to dependencies
      {
        "saghen/blink.compat",
        opts = {},
        version = not vim.g.lazyvim_blink_main and "*",
      },
    },
    event = { "InsertEnter", "CmdlineEnter" },
    opts = require("configs.coding.blink").opts,
    config = require("configs.coding.blink").config,
  },

  {
    "nvim-mini/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },

  {
    "nvim-mini/mini.surround",
    opts = require("configs.coding.mini-surround").opts,
    keys = require("configs.coding.mini-surround").keys,
  },
}
