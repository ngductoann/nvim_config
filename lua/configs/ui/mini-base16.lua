return {
  opts = {
    palette = require("icons").colors,
    use_cterm = true,
    plugins = { default = false, ["nvim-mini/mini.nvim"] = true },
  },
  config = function(_, opts)
    require("mini.base16").setup(opts)
    local p = opts.palette

    local function apply_winbar_hl()
      -- đảm bảo Normal.bg = nền chính nếu bạn muốn "một màu" cho winbar
      vim.api.nvim_set_hl(0, "Normal", { bg = p.base00 })
      vim.api.nvim_set_hl(0, "WinBar", { bg = p.base00, fg = p.base05 })
      vim.api.nvim_set_hl(0, "WinBarNC", { bg = p.base00, fg = p.base04 })
      -- nếu dùng nvim-navic (hoặc plugin winbar khác) override navic groups
      vim.api.nvim_set_hl(0, "NavicText", { bg = p.base00, fg = p.base05 })
      vim.api.nvim_set_hl(0, "NavicSeparator", { bg = p.base00, fg = p.base03 })
      -- (thêm các group khác nếu plugin bạn dùng tạo ra chúng)
    end

    -- reapply mỗi lần ColorScheme chạy (an toàn khi theme bị apply lại)
    vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_winbar_hl })

    -- apply ngay bây giờ
    vim.schedule(apply_winbar_hl)
  end,
}
