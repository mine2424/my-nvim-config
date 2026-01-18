-- ========================================
-- Telescope Configuration
-- ========================================
-- LazyVim includes telescope, but we can override/extend its configuration here

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = {
      -- Additional keymaps beyond LazyVim defaults
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find word" },
      { "<leader>fS", "<cmd>Telescope git_stash<cr>", desc = "Git stash" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = {
            -- Navigation
            ["<C-n>"] = "move_selection_next",
            ["<C-p>"] = "move_selection_previous",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            
            -- Scroll preview
            ["<C-u>"] = "preview_scrolling_up",
            ["<C-d>"] = "preview_scrolling_down",
            
            -- Close
            ["<C-c>"] = "close",
            ["<Esc>"] = "close",
            
            -- Select
            ["<CR>"] = "select_default",
            ["<C-x>"] = "select_horizontal",
            ["<C-v>"] = "select_vertical",
            ["<C-t>"] = "select_tab",
          },
          n = {
            ["q"] = "close",
            ["<Esc>"] = "close",
          },
        },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist/",
          "build/",
          "target/",
          "*.pyc",
          "__pycache__",
          ".venv/",
          "venv/",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden", "--glob", "!.git/*" }
          end,
        },
        buffers = {
          sort_lastused = true,
          mappings = {
            i = {
              ["<C-d>"] = "delete_buffer",
            },
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      
      -- Load extensions
      telescope.load_extension("fzf")
    end,
  },
}
