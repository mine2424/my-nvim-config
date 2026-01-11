-- ========================================
-- Color Scheme
-- ========================================

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,  -- Show background (WezTerm handles transparency)
      terminal_colors = true,  -- Set terminal colors (Neovim controls colors)
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help", "terminal", "packer" },
      dim_inactive = false,
      lualine_bold = false,
      
      -- Language-specific highlights
      on_highlights = function(hl, c)
        -- TypeScript/JavaScript
        hl.TSConstructor = { fg = c.blue }
        hl.TSKeywordFunction = { fg = c.magenta, style = { italic = true } }
        
        -- Rust
        hl.RustLifetime = { fg = c.orange }
        hl.RustMacro = { fg = c.cyan }
        
        -- Go
        hl.GoImport = { fg = c.blue }
        hl.GoPackage = { fg = c.magenta }
        
        -- Python
        hl.PythonDecorator = { fg = c.yellow }
        
        -- Dart/Flutter
        hl.DartKeyword = { fg = c.magenta, style = { italic = true } }
        
        -- Better contrast for LSP
        hl.DiagnosticError = { fg = c.error }
        hl.DiagnosticWarn = { fg = c.warning }
        hl.DiagnosticInfo = { fg = c.info }
        hl.DiagnosticHint = { fg = c.hint }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
