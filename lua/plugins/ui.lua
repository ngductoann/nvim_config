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

  -- {
  --   "nvim-mini/mini.starter",
  --   version = false,
  --   event = "VimEnter",
  --   opts = function()
  --     local logo = table.concat({
  --       [[         _   _                 _                   ]],
  --       [[        | \ | | ___  _____   _(_)_ __ ___          ]],
  --       [[        |  \| |/ _ \/ _ \ \ / / | '_ ` _ \         ]],
  --       [[        | |\  |  __/ (_) \ V /| | | | | | |        ]],
  --       [[        |_| \_|\___|\___/ \_/ |_|_| |_| |_|        ]],
  --     }, "\n")
  --
  --     local pad = string.rep(" ", 22)
  --     local new_section = function(name, action, section)
  --       return { name = name, action = action, section = pad .. section }
  --     end
  --
  --     local starter = require "mini.starter"
  --   -- stylua: ignore
  --   local config = {
  --     evaluate_single = true,
  --     header = logo,
  --     items = {
  --       new_section("Find file",       "FzfLua files",              "fzf-lua"),
  --       new_section("New file",        "ene | startinsert",         "Built-in"),
  --       new_section("Recent files",    "FzfLua oldfiles",           "fzf-lua"),
  --       new_section("Find text",       "FzfLua live_grep",          "fzf-lua"),
  --       new_section("Config",          "FzfLua files cwd=~/.config/nvim", "Config"),
  --       new_section("Restore session", [[lua require("persistence").load()]], "Session"),
  --       new_section("Lazy Extras",     "LazyExtras",                "Config"),
  --       new_section("Lazy",            "Lazy",                      "Config"),
  --       new_section("Quit",            "qa",                        "Built-in"),
  --     },
  --     content_hooks = {
  --       starter.gen_hook.adding_bullet(pad .. "░ ", false),
  --       starter.gen_hook.aligning("center", "center"),
  --     },
  --   }
  --     return config
  --   end,
  --   config = function(_, config)
  --     if vim.o.filetype == "lazy" then
  --       vim.cmd.close()
  --       vim.api.nvim_create_autocmd("User", {
  --         pattern = "MiniStarterOpened",
  --         callback = function()
  --           require("lazy").show()
  --         end,
  --       })
  --     end
  --
  --     local starter = require "mini.starter"
  --     starter.setup(config)
  --
  --     vim.api.nvim_create_autocmd("User", {
  --       pattern = "LazyVimStarted",
  --       callback = function(ev)
  --         local stats = require("lazy").stats()
  --         local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
  --         local pad_footer = string.rep(" ", 8)
  --         starter.config.footer = pad_footer .. "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
  --         if vim.bo[ev.buf].filetype == "ministarter" then
  --           pcall(starter.refresh)
  --         end
  --       end,
  --     })
  --   end,
  -- },
}
