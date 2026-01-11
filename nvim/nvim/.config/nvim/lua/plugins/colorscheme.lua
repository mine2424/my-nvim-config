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
  
  -- Alternative: Catppuccin
  -- Uncomment to use Catppuccin instead
  --[[
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
        },
        telescope = true,
        gitsigns = true,
        nvimtree = true,
        mason = true,
        cmp = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
  --]]
}
