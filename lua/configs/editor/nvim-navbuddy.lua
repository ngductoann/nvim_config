return {
  opts = function()
    return {
      lsp = { auto_attach = true },
      window = {
        border = "single",
        size = { height = "40%", width = "60%" }, -- Or table format example: { height = "40%", width = "100%"}
        position = { row = "0%", col = "100%" }, -- Or table format example: { row = "100%", col = "0%"}
        sections = {
          left = {
            size = "25%",
            border = nil,
          },
          mid = {
            size = "25%",
            border = nil,
          },
          right = {
            size = "50%",
            border = nil,
          },
        },
      },

      -- VSCode icons
      icons = LazyVim.icons.icons_vscode,
    }
  end,
  keys = {
    {
      "<leader>cb",
      function()
        require("nvim-navbuddy").open()
      end,
      desc = "Jump to symbol",
    },
  },
}
