return {
  -- 1. Filetype / root detection
  recommended = function()
    return LazyVim.extras.wants {
      ft = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      root = { "tsconfig.json", "package.json", "jsconfig.json" },
    }
  end,

  -- 2. Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "javascript", "typescript", "tsx", "jsx" } },
  },

  -- 3. LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            typescript = { inlayHints = { parameterNames = { enabled = "literals" } } },
            javascript = { inlayHints = { parameterNames = { enabled = "literals" } } },
            vtsls = { enableMoveToFileCodeAction = true, autoUseWorkspaceTsdk = true },
          },
        },
      },
      setup = {
        vtsls = function(_, opts)
          -- copy minimal TypeScript settings to JavaScript
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
      },
    },
  },

  -- 4. Filetype icons
  {
    "nvim-mini/mini.icons",
    opts = {
      file = {
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
      },
    },
  },
}
