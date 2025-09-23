return {
  recommended = function()
    return LazyVim.extras.wants {
      ft = { "cs", "vb" },
      root = { "*.sln", "*.csproj", "omnisharp.json", "function.json" },
    }
  end,

  -- Omnisharp extended LSP
  { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },

  -- Treesitter cho C#
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c_sharp" } },
  },

  -- Null-ls / Conform để format
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require "null-ls"
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.csharpier)
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
      formatters = {
        csharpier = {
          command = "dotnet-csharpier",
          args = { "--write-stdout" },
        },
      },
    },
  },

  -- Mason đảm bảo cài formatter
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "csharpier" } },
  },

  -- LSP Config cho Omnisharp
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = {
          handlers = {
            ["textDocument/definition"] = function(...)
              return require("omnisharp_extended").handler(...)
            end,
          },
          keys = {
            {
              "gd",
              LazyVim.has "telescope.nvim" and function()
                require("omnisharp_extended").telescope_lsp_definitions()
              end or function()
                require("omnisharp_extended").lsp_definitions()
              end,
              desc = "Goto Definition",
            },
          },
          enable_roslyn_analyzers = true,
          organize_imports_on_format = true,
          enable_import_completion = true,
        },
      },
    },
  },
}
