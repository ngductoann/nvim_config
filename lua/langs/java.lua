return {
  -- 1. Filetype / root detection
  recommended = function()
    return LazyVim.extras.wants {
      ft = "java",
      root = {
        "build.gradle",
        "build.gradle.kts",
        "build.xml", -- Ant
        "pom.xml",
        "settings.gradle",
        "settings.gradle.kts", -- Gradle / Maven
      },
    }
  end,

  -- 2. Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "java" } },
  },

  -- 3. DAP (optional)
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require "dap"
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }
    end,
  },

  -- 4. Mason packages
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "jdtls",
        "java-debug-adapter",
        "java-test",
        "google-java-format",
        "vscode-spring-boot-tools",
      },
    },
  },

  -- 5. Formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = { java = { "google-java-format" } },
      formatters = {
        ["google-java-format"] = { prepend_args = { "--aosp" } },
      },
    },
  },

  -- 6. LSP setup (only ensure mason installs it)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { jdtls = {} },
      setup = {
        jdtls = function()
          return true
        end,
      }, -- avoid duplicate
    },
  },

  -- 7. jdtls
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = { "mfussenegger/nvim-dap", "folke/which-key.nvim" },
    opts = function()
      local mason_bin = vim.fn.stdpath "data" .. "/mason/bin/jdtls"
      local cmd = { mason_bin }

      -- Lombok
      local lombok = vim.fn.stdpath "data" .. "/mason/share/jdtls/lombok.jar"
      if vim.fn.filereadable(lombok) == 1 then
        table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok))
      end

      return {
        cmd = cmd,
        root_dir = function(path)
          return vim.fs.root(path, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
        end,
        full_cmd = function(opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local root_dir = opts.root_dir(fname)
          local project_name = root_dir and vim.fs.basename(root_dir) or "default"
          local c = vim.deepcopy(opts.cmd)
          vim.list_extend(c, {
            "-configuration",
            vim.fn.stdpath "cache" .. "/jdtls/" .. project_name .. "/config",
            "-data",
            vim.fn.stdpath "cache" .. "/jdtls/" .. project_name .. "/workspace",
          })
          return c
        end,
        settings = {
          java = {
            eclipse = { downloadSources = false },
            maven = { downloadSources = false },
            configuration = { updateBuildConfiguration = "disabled" },
            references = { includeDecompiledSources = false },
            implementationsCodeLens = { enabled = false },
            referencesCodeLens = { enabled = false },
            signatureHelp = { enabled = true },
            format = { enabled = true },
            inlayHints = { parameterNames = { enabled = "none" } },
          },
        },
        dap = { hotcodereplace = "auto" },
        dap_main = {},
        test = true,
      }
    end,
    config = function(_, opts)
      local bundles = {}
      local mr = require "mason-registry"

      -- Java Debug
      if mr.is_installed "java-debug-adapter" then
        vim.list_extend(
          bundles,
          vim.split(
            vim.fn.glob(
              vim.fn.stdpath "data" .. "/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar"
            ),
            "\n"
          )
        )
      end

      -- Java Test
      if mr.is_installed "java-test" then
        vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fn.stdpath "data" .. "/mason/share/java-test/*.jar"), "\n"))
      end

      -- Spring Boot
      if mr.is_installed "vscode-spring-boot-tools" then
        vim.list_extend(
          bundles,
          vim.split(vim.fn.glob(vim.fn.stdpath "data" .. "/mason/share/vscode-spring-boot-tools/*.jar"), "\n")
        )
      end

      -- Attach jdtls
      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

        require("jdtls").start_or_attach {
          cmd = opts.full_cmd(opts),
          root_dir = opts.root_dir(fname),
          settings = opts.settings,
          capabilities = capabilities,
          init_options = { bundles = bundles },
          handlers = { ["$/progress"] = function() end },
        }
      end

      -- FileType autocmd
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "java" },
        callback = attach_jdtls,
      })

      -- LspAttach autocmd
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "jdtls" then
            local wk = require "which-key"

            -- Refactor keymaps
            wk.add {
              {
                mode = "n",
                buffer = args.buf,
                { "<leader>cx", group = "extract" },
                { "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable" },
                { "<leader>cxc", require("jdtls").extract_constant, desc = "Extract Constant" },
                { "<leader>cgs", require("jdtls").super_implementation, desc = "Goto Super" },
                { "<leader>co", require("jdtls").organize_imports, desc = "Organize Imports" },
              },
              {
                mode = "v",
                buffer = args.buf,
                { "<leader>cx", group = "extract" },
                { "<leader>cxm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], desc = "Extract Method" },
              },
            }

            -- Debug + Test
            if #bundles > 0 then
              require("jdtls").setup_dap(opts.dap)
              require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)

              if opts.test then
                wk.add {
                  {
                    mode = "n",
                    buffer = args.buf,
                    { "<leader>t", group = "test" },
                    {
                      "<leader>tt",
                      function()
                        require("jdtls.dap").test_class()
                      end,
                      desc = "Run All Tests",
                    },
                    {
                      "<leader>tr",
                      function()
                        require("jdtls.dap").test_nearest_method()
                      end,
                      desc = "Run Nearest Test",
                    },
                    { "<leader>tT", require("jdtls.dap").pick_test, desc = "Pick Test" },
                  },
                }
              end
            end
          end
        end,
      })

      attach_jdtls()
    end,
  },
}
