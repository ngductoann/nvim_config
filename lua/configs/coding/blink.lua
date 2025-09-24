local M = {}

local menu_cols = { { "kind_icon" }, { "label" }, { "kind" } }

M.components = {
  kind_icon = {
    text = function(ctx)
      local icons = LazyVim.icons.lspkinds
      local icon = (icons[ctx.kind] or "󰈚")

      return vim.trim(icon)
    end,
  },

  kind = {
    highlight = function(ctx)
      return vim.trim(ctx.kind)
    end,
  },
}

M.menu = {
  scrollbar = false,
  border = "single",
  draw = {
    padding = { 1, 1 },
    columns = menu_cols,
    components = M.components,
  },
}

return {
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- tăng tốc fuzzy matching (ưu tiên Rust)
    fuzzy = { implementation = "prefer_rust" },

    snippets = {
      preset = "luasnip",
      expand = function(snippet, _)
        return LazyVim.cmp.expand(snippet)
      end,
    },

    appearance = {
      nerd_font_variant = "normal",
    },

    completion = {
      accept = {
        auto_brackets = { enabled = true },
      },
      menu = {
        border = "single",
        scrollbar = false,
        draw = {
          padding = { 1, 1 },
          columns = { { "kind_icon" }, { "label" }, { "kind" } },
          components = {
            kind_icon = {
              text = function(ctx)
                local icons = LazyVim.icons.lspkinds
                return vim.trim(icons[ctx.kind] or "󰈚")
              end,
            },
            kind = {
              highlight = function(ctx)
                return vim.trim(ctx.kind)
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 150,
        window = { border = "single" },
      },
      ghost_text = { enabled = vim.g.ai_cmp or false },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    cmdline = {
      enabled = true,
      keymap = { preset = "cmdline" },
      completion = {
        list = { selection = { preselect = false } },
        menu = {
          auto_show = function()
            return vim.fn.getcmdtype() == ":"
          end,
        },
      },
    },

    keymap = {
      preset = "enter",
      ["<C-y>"] = { "select_and_accept" },
      ["<Tab>"] = {
        LazyVim.cmp.map { "snippet_forward", "ai_accept" },
        "fallback",
      },
    },
  },
}
