-- ============================================================================
-- Telescope Configuration for AstroNvim
-- ============================================================================
-- Enhanced file search and navigation with Telescope.nvim

return {
  -- Main Telescope plugin
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-media-files.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "debugloop/telescope-undo.nvim",
    },
    cmd = "Telescope",
    opts = function()
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      
      return {
        defaults = {
          prompt_prefix = " 🔍 ",
          selection_caret = "  ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
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
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "dist/",
            "build/",
            "%.lock",
            ".pub-cache/",
            ".dart_tool/",
            "__pycache__/",
            "%.pyc",
          },
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          use_less = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-/>"] = actions.which_key,
              ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
              ["<C-w>"] = { "<c-s-w>", type = "command" },
              ["<C-r><C-w>"] = actions.insert_original_cword,
              ["<C-r><C-a>"] = actions.insert_original_cWORD,
              ["<C-r><C-f>"] = actions.insert_original_cfile,
              ["<C-r><C-l>"] = actions.insert_original_cline,
              ["<C-e>"] = action_layout.toggle_preview,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["?"] = actions.which_key,
              ["<C-e>"] = action_layout.toggle_preview,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
          live_grep = {
            theme = "ivy",
            additional_args = function()
              return { "--hidden" }
            end,
          },
          grep_string = {
            theme = "ivy",
            additional_args = function()
              return { "--hidden" }
            end,
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
          oldfiles = {
            theme = "dropdown",
            previewer = false,
          },
          help_tags = {
            theme = "ivy",
          },
          colorscheme = {
            enable_preview = true,
          },
          lsp_references = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_definitions = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_implementations = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_type_definitions = {
            theme = "dropdown",
            initial_mode = "normal",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = {
            theme = "dropdown",
            hijack_netrw = false,
            mappings = {
              ["i"] = {
                ["<A-c>"] = require("telescope._extensions.file_browser.actions").create,
                ["<S-CR>"] = require("telescope._extensions.file_browser.actions").create_from_prompt,
                ["<A-r>"] = require("telescope._extensions.file_browser.actions").rename,
                ["<A-m>"] = require("telescope._extensions.file_browser.actions").move,
                ["<A-y>"] = require("telescope._extensions.file_browser.actions").copy,
                ["<A-d>"] = require("telescope._extensions.file_browser.actions").remove,
                ["<C-o>"] = require("telescope._extensions.file_browser.actions").open,
                ["<C-g>"] = require("telescope._extensions.file_browser.actions").goto_parent_dir,
                ["<C-e>"] = require("telescope._extensions.file_browser.actions").goto_home_dir,
                ["<C-w>"] = require("telescope._extensions.file_browser.actions").goto_cwd,
                ["<C-t>"] = require("telescope._extensions.file_browser.actions").change_cwd,
                ["<C-f>"] = require("telescope._extensions.file_browser.actions").toggle_browser,
                ["<C-h>"] = require("telescope._extensions.file_browser.actions").toggle_hidden,
                ["<C-s>"] = require("telescope._extensions.file_browser.actions").toggle_all,
                ["<bs>"] = require("telescope._extensions.file_browser.actions").backspace,
              },
              ["n"] = {
                ["c"] = require("telescope._extensions.file_browser.actions").create,
                ["r"] = require("telescope._extensions.file_browser.actions").rename,
                ["m"] = require("telescope._extensions.file_browser.actions").move,
                ["y"] = require("telescope._extensions.file_browser.actions").copy,
                ["d"] = require("telescope._extensions.file_browser.actions").remove,
                ["o"] = require("telescope._extensions.file_browser.actions").open,
                ["g"] = require("telescope._extensions.file_browser.actions").goto_parent_dir,
                ["e"] = require("telescope._extensions.file_browser.actions").goto_home_dir,
                ["w"] = require("telescope._extensions.file_browser.actions").goto_cwd,
                ["t"] = require("telescope._extensions.file_browser.actions").change_cwd,
                ["f"] = require("telescope._extensions.file_browser.actions").toggle_browser,
                ["h"] = require("telescope._extensions.file_browser.actions").toggle_hidden,
                ["s"] = require("telescope._extensions.file_browser.actions").toggle_all,
              },
            },
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              winblend = 10,
              previewer = false,
            }),
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }),
              },
            },
          },
          undo = {
            use_delta = true,
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.8,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      
      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("ui-select")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("undo")
      telescope.load_extension("project")
      
      -- Try to load notify extension if available
      pcall(telescope.load_extension, "notify")
    end,
  },
  
  -- Override AstroCore mappings for Telescope
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      
      -- File search mappings
      maps.n["<leader>f"] = { desc = "Find" }
      maps.n["<leader>ff"] = { "<cmd>Telescope find_files<cr>", desc = "Find files" }
      maps.n["<leader>fa"] = { "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", desc = "Find all files" }
      maps.n["<leader>fw"] = { "<cmd>Telescope live_grep<cr>", desc = "Find words" }
      maps.n["<leader>fW"] = { "<cmd>Telescope live_grep_args<cr>", desc = "Find words (args)" }
      maps.n["<leader>fb"] = { "<cmd>Telescope buffers<cr>", desc = "Find buffers" }
      maps.n["<leader>fh"] = { "<cmd>Telescope help_tags<cr>", desc = "Find help" }
      maps.n["<leader>fm"] = { "<cmd>Telescope marks<cr>", desc = "Find marks" }
      maps.n["<leader>fo"] = { "<cmd>Telescope oldfiles<cr>", desc = "Find oldfiles" }
      maps.n["<leader>fz"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in current buffer" }
      maps.n["<leader>fc"] = { "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor" }
      maps.n["<leader>fC"] = { "<cmd>Telescope commands<cr>", desc = "Find commands" }
      maps.n["<leader>fr"] = { "<cmd>Telescope resume<cr>", desc = "Resume last search" }
      maps.n["<leader>fk"] = { "<cmd>Telescope keymaps<cr>", desc = "Find keymaps" }
      maps.n["<leader>fR"] = { "<cmd>Telescope registers<cr>", desc = "Find registers" }
      maps.n["<leader>fp"] = { "<cmd>Telescope project<cr>", desc = "Find projects" }
      maps.n["<leader>ft"] = { "<cmd>Telescope colorscheme<cr>", desc = "Find themes" }
      maps.n["<leader>fu"] = { "<cmd>Telescope undo<cr>", desc = "Find undo history" }
      maps.n["<leader>fe"] = { "<cmd>Telescope file_browser<cr>", desc = "File browser" }
      maps.n["<leader>fE"] = { "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "File browser (current dir)" }
      
      -- Git mappings
      maps.n["<leader>g"] = maps.n["<leader>g"] or { desc = "Git" }
      maps.n["<leader>gc"] = { "<cmd>Telescope git_commits<cr>", desc = "Git commits" }
      maps.n["<leader>gC"] = { "<cmd>Telescope git_bcommits<cr>", desc = "Git buffer commits" }
      maps.n["<leader>gb"] = { "<cmd>Telescope git_branches<cr>", desc = "Git branches" }
      maps.n["<leader>gs"] = { "<cmd>Telescope git_status<cr>", desc = "Git status" }
      maps.n["<leader>gS"] = { "<cmd>Telescope git_stash<cr>", desc = "Git stash" }
      
      -- LSP mappings
      maps.n["<leader>l"] = maps.n["<leader>l"] or { desc = "LSP" }
      maps.n["<leader>ls"] = { "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" }
      maps.n["<leader>lS"] = { "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" }
      maps.n["<leader>lr"] = { "<cmd>Telescope lsp_references<cr>", desc = "References" }
      maps.n["<leader>ld"] = { "<cmd>Telescope lsp_definitions<cr>", desc = "Definitions" }
      maps.n["<leader>lt"] = { "<cmd>Telescope lsp_type_definitions<cr>", desc = "Type definitions" }
      maps.n["<leader>li"] = { "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" }
      maps.n["<leader>lD"] = { "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" }
      
      -- Additional useful mappings
      maps.n["<leader>s"] = { desc = "Search" }
      maps.n["<leader>sa"] = { "<cmd>Telescope autocommands<cr>", desc = "Autocommands" }
      maps.n["<leader>sb"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer fuzzy find" }
      maps.n["<leader>sc"] = { "<cmd>Telescope command_history<cr>", desc = "Command history" }
      maps.n["<leader>sC"] = { "<cmd>Telescope commands<cr>", desc = "Commands" }
      maps.n["<leader>sh"] = { "<cmd>Telescope search_history<cr>", desc = "Search history" }
      maps.n["<leader>sH"] = { "<cmd>Telescope highlights<cr>", desc = "Highlights" }
      maps.n["<leader>sj"] = { "<cmd>Telescope jumplist<cr>", desc = "Jumplist" }
      maps.n["<leader>sl"] = { "<cmd>Telescope loclist<cr>", desc = "Location list" }
      maps.n["<leader>sm"] = { "<cmd>Telescope man_pages<cr>", desc = "Man pages" }
      maps.n["<leader>sM"] = { "<cmd>Telescope marks<cr>", desc = "Marks" }
      maps.n["<leader>so"] = { "<cmd>Telescope vim_options<cr>", desc = "Vim options" }
      maps.n["<leader>sq"] = { "<cmd>Telescope quickfix<cr>", desc = "Quickfix list" }
      maps.n["<leader>sR"] = { "<cmd>Telescope reloader<cr>", desc = "Reload modules" }
      maps.n["<leader>ss"] = { "<cmd>Telescope spell_suggest<cr>", desc = "Spell suggestions" }
      maps.n["<leader>st"] = { "<cmd>Telescope filetypes<cr>", desc = "Filetypes" }
      
      -- Quick access mappings
      maps.n["<C-p>"] = { "<cmd>Telescope find_files<cr>", desc = "Find files" }
      maps.n["<C-S-p>"] = { "<cmd>Telescope commands<cr>", desc = "Command palette" }
      maps.n["<C-f>"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in buffer" }
      
      -- Visual mode mappings
      maps.v["<leader>f"] = { desc = "Find" }
      maps.v["<leader>fw"] = { "<cmd>Telescope grep_string<cr>", desc = "Find selection" }
      
      return opts
    end,
  },
}