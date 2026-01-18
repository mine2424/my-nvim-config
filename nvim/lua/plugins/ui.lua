-- ========================================
-- UI Plugins
-- ========================================

return {
  -- LazyVim uses neo-tree by default instead of nvim-tree
  -- If you want to use nvim-tree instead, uncomment and configure below:
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
  --   keys = {
  --     { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
  --     { "<leader>o", "<cmd>NvimTreeFocus<cr>", desc = "Focus file tree" },
  --   },
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   opts = {
  --     disable_netrw = true,
  --     hijack_netrw = true,
  --     sync_root_with_cwd = true,
  --     view = {
  --       width = 30,
  --       side = "left",
  --     },
  --     renderer = {
  --       group_empty = true,
  --       highlight_git = true,
  --       icons = {
  --         show = {
  --           file = true,
  --           folder = true,
  --           folder_arrow = true,
  --           git = true,
  --         },
  --       },
  --     },
  --     filters = {
  --       dotfiles = false,
  --       custom = { ".git", "node_modules", ".cache" },
  --     },
  --     git = {
  --       enable = true,
  --       ignore = false,
  --     },
  --   },
  -- },

  -- lualine: Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        theme = "auto",  -- LazyVimのデフォルトテーマを使用
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- which-key: Key binding helper
  -- LazyVim includes which-key, but we can extend its configuration here
  {
    "folke/which-key.nvim",
    opts = {
      -- LazyVimのデフォルト設定を拡張
      window = {
        border = "rounded",
      },
    },
  },

  -- indent-blankline: Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },

  -- nvim-web-devicons: File icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- dressing.nvim: Better UI for inputs
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        border = "rounded",
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
      },
    },
  },

  -- nvim-notify: Better notifications
  -- LazyVim includes nvim-notify, but we can override/extend its configuration here
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      render = "compact",
      stages = "fade_in_slide_out",
    },
  },
}
