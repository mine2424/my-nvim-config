-- ========================================
-- LazyVim Core Configuration Override
-- ========================================
-- Override LazyVim's default settings

return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- Disable LazyVim's default colorscheme (tokyonight)
      colorscheme = function()
        -- Use Neovim's built-in colorscheme instead
        vim.cmd([[colorscheme habamax]])
      end,
    },
  },
}
