local diagnostics = vim.g.lazyvim_rust_diagnostics or "rust-analyzer"

return {
  recommended = function()
    return LazyVim.extras.wants {
      ft = "rust",
      root = { "Cargo.toml", "rust-project.json" },
    }
  end,

  -- LSP cho Cargo.toml
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { crates = { enabled = true } },
      lsp = { enabled = true, actions = true, completion = true, hover = true },
    },
  },

  -- Treesitter cho Rust
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "rust", "ron" } },
  },

  -- Rust Analyzer LSP setup
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
            checkOnSave = diagnostics == "rust-analyzer",
            diagnostics = { enable = diagnostics == "rust-analyzer" },
            procMacro = { enable = true },
            files = {
              excludeDirs = {
                ".direnv",
                ".git",
                ".github",
                ".gitlab",
                "bin",
                "node_modules",
                "target",
                "venv",
                ".venv",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
      if vim.fn.executable "rust-analyzer" == 0 then
        LazyVim.error(
          "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
          { title = "rustaceanvim" }
        )
      end
    end,
  },

  -- Setup lspconfig cho Rust
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bacon_ls = { enabled = diagnostics == "bacon-ls" },
        rust_analyzer = { enabled = true },
      },
    },
  },
}
