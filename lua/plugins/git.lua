local has_git = vim.fn.executable "git" == 1

return {
  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    cond = has_git,
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "‾" },
        changedelete = { text = "≃" },
        untracked = { text = "?" },
      },
      signs_staged = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "‾" },
        changedelete = { text = "≃" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -----------------------------------------------------------------------------
  -- Tabpage interface for cycling through diffs
  {
    "sindrets/diffview.nvim",
    cond = has_git,
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gD", "<cmd>DiffviewFileHistory %<CR>", desc = "Diff File" },
      { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Diff View" },
    },
    opts = function()
      local actions = require "diffview.actions"
      vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("rafi.diffview", {}),
        pattern = "diffview:///panels/*",
        callback = function()
          vim.opt_local.cursorline = true
          vim.opt_local.winhighlight = "CursorLine:WildMenu"
        end,
      })

      return {
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        keymaps = {
          view = {
            { "n", "q", actions.close },
            { "n", "<Tab>", actions.select_next_entry },
            { "n", "<S-Tab>", actions.select_prev_entry },
            { "n", "<localleader>a", actions.focus_files },
            { "n", "<localleader>e", actions.toggle_files },
          },
          file_panel = {
            { "n", "q", actions.close },
            { "n", "h", actions.prev_entry },
            { "n", "o", actions.focus_entry },
            { "n", "gf", actions.goto_file },
            { "n", "sg", actions.goto_file_split },
            { "n", "st", actions.goto_file_tab },
            { "n", "<C-r>", actions.refresh_files },
            { "n", "<localleader>e", actions.toggle_files },
          },
          file_history_panel = {
            { "n", "q", "<cmd>DiffviewClose<CR>" },
            { "n", "o", actions.focus_entry },
            { "n", "O", actions.options },
          },
        },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- Magit clone for Neovim
  {
    "NeogitOrg/neogit",
    cond = has_git,
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
    },
    -- See: https://github.com/TimUntersberger/neogit#configuration
    opts = {
      disable_signs = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      signs = {
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = true,
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Git blame visualizer
  {
    "FabijanZulj/blame.nvim",
    cond = has_git,
    cmd = "ToggleBlame",
		-- stylua: ignore
		keys = {
			{ '<leader>gb', '<cmd>BlameToggle virtual<CR>', desc = 'Git blame' },
			{ '<leader>gB', '<cmd>BlameToggle window<CR>', desc = 'Git blame (window)' },
		},
    opts = {
      date_format = "%Y-%m-%d %H:%M",
      merge_consecutive = false,
      max_summary_width = 30,
      mappings = {
        commit_info = "K",
        stack_push = ">",
        stack_pop = "<",
        show_commit = "<CR>",
        close = { "<Esc>", "q" },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Pleasant editing on Git commit messages
  {
    "rhysd/committia.vim",
    cond = has_git,
    event = "BufReadPre COMMIT_EDITMSG",
    init = function()
      -- See: https://github.com/rhysd/committia.vim#variables
      vim.g.committia_min_window_width = 30
      vim.g.committia_edit_window_width = 75
    end,
    config = function()
      vim.g.committia_hooks = {
        edit_open = function()
          vim.cmd.resize(10)
          local opts = {
            buffer = vim.api.nvim_get_current_buf(),
            silent = true,
          }
          local function map(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, opts)
          end
          map("n", "q", "<cmd>quit<CR>")
          map("i", "<C-d>", "<Plug>(committia-scroll-diff-down-half)")
          map("i", "<C-u>", "<Plug>(committia-scroll-diff-up-half)")
          map("i", "<C-f>", "<Plug>(committia-scroll-diff-down-page)")
          map("i", "<C-b>", "<Plug>(committia-scroll-diff-up-page)")
          map("i", "<C-j>", "<Plug>(committia-scroll-diff-down)")
          map("i", "<C-k>", "<Plug>(committia-scroll-diff-up)")
        end,
      }
    end,
  },

  {
    "isakbm/gitgraph.nvim",
    opts = {
      git_cmd = "git",
      symbols = {
        merge_commit = "◆", -- diamond
        commit = "●", -- bullet
        merge_commit_end = "◈",
        commit_end = "○",

        -- Advanced
        GVER = "│", -- vertical
        GHOR = "─", -- horizontal
        GCLD = "╭", -- corner left-down
        GCRD = "╮", -- corner right-down
        GCLU = "╰", -- corner left-up
        GCRU = "╯", -- corner right-up
        GLRU = "┐",
        GLRD = "┌",
        GLUD = "┴",
        GRUD = "┬",
        GFORKU = "╨",
        GFORKD = "╥",
      },
      format = {
        timestamp = "%H:%M:%S %d-%m-%Y",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        on_select_commit = function(commit)
          print("selected commit:", commit.hash)
        end,
        on_select_range_commit = function(from, to)
          print("selected range:", from.hash, to.hash)
        end,
      },
    },
    keys = {
      {
        "<leader>gl",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph - Draw",
      },
    },
  },
}
