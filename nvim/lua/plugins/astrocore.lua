-- ========================================
-- AstroCore Configuration
-- ========================================
-- Core options, mappings, and autocmds

return {
	"AstroNvim/astrocore",
	---@type AstroCoreOpts
	opts = {
		-- ========================================
		-- Features
		-- ========================================
		features = {
			large_buf = { size = 1024 * 100, lines = 10000 }, -- 100KB
			autopairs = true,
			cmp = true,
			diagnostics_mode = 3, -- 0=off, 1=only show in status line, 2=virtual text off, 3=all on
			highlighturl = true,
			notifications = true,
		},

		-- ========================================
		-- Diagnostics Configuration
		-- ========================================
		diagnostics = {
			virtual_text = true,
			signs = true,
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			float = {
				focused = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		},

		-- ========================================
		-- Vim Options
		-- ========================================
		options = {
			opt = {
				-- General
				clipboard = "unnamedplus", -- Use system clipboard
				mouse = "a", -- Enable mouse support
				undofile = true, -- Enable persistent undo
				swapfile = false, -- Disable swap files
				backup = false, -- Disable backup files

				-- UI
				number = true, -- Show line numbers
				relativenumber = true, -- Show relative line numbers
				signcolumn = "yes", -- Always show sign column
				cursorline = true, -- Highlight current line
				wrap = false, -- Disable line wrap
				scrolloff = 8, -- Minimal number of screen lines to keep above and below cursor
				sidescrolloff = 8, -- Minimal number of screen columns to keep to the left and right of cursor
				colorcolumn = "120", -- Show column at 120 characters

				-- Indentation
				expandtab = true, -- Use spaces instead of tabs
				shiftwidth = 2, -- Size of an indent
				tabstop = 2, -- Number of spaces tabs count for
				softtabstop = 2, -- Number of spaces that a <Tab> counts for while performing editing operations
				smartindent = true, -- Insert indents automatically
				shiftround = true, -- Round indent to multiple of shiftwidth

				-- Search
				ignorecase = true, -- Ignore case when searching
				smartcase = true, -- Don't ignore case with capitals
				hlsearch = true, -- Highlight search results
				incsearch = true, -- Show search results as you type

				-- Splits
				splitbelow = true, -- Put new windows below current
				splitright = true, -- Put new windows right of current

				-- Completion
				completeopt = "menu,menuone,noselect", -- Completion options
				pumheight = 10, -- Maximum number of entries in a popup

				-- Performance
				updatetime = 300, -- Faster completion
				timeoutlen = 300, -- Time to wait for a mapped sequence to complete
				lazyredraw = false, -- Don't redraw while executing macros

				-- Formatting
				formatoptions = "jcroqlnt", -- Format options
				conceallevel = 2, -- Hide concealed text unless it has a custom replacement character
			},
			g = {
				-- Disable built-in plugins
				loaded_netrw = 1,
				loaded_netrwPlugin = 1,
				loaded_matchit = 1,
				loaded_matchparen = 1,

				-- Leader keys
				mapleader = " ",
				maplocalleader = ",",
			},
		},

		-- ========================================
		-- Key Mappings
		-- ========================================
		mappings = {
			-- Normal mode
			n = {
				-- Better window navigation
				["<C-h>"] = { "<C-w>h", desc = "Move to left window" },
				["<C-j>"] = { "<C-w>j", desc = "Move to bottom window" },
				["<C-k>"] = { "<C-w>k", desc = "Move to top window" },
				["<C-l>"] = { "<C-w>l", desc = "Move to right window" },

				-- Resize windows
				["<C-Up>"] = { "<cmd>resize +2<cr>", desc = "Increase window height" },
				["<C-Down>"] = { "<cmd>resize -2<cr>", desc = "Decrease window height" },
				["<C-Left>"] = { "<cmd>vertical resize -2<cr>", desc = "Decrease window width" },
				["<C-Right>"] = { "<cmd>vertical resize +2<cr>", desc = "Increase window width" },

				-- Buffer navigation
				["<S-h>"] = { "<cmd>bprevious<cr>", desc = "Previous buffer" },
				["<S-l>"] = { "<cmd>bnext<cr>", desc = "Next buffer" },
				["<leader>bd"] = { "<cmd>bdelete<cr>", desc = "Delete buffer" },
				["<leader>bD"] = { "<cmd>bdelete!<cr>", desc = "Force delete buffer" },

				-- Clear search highlighting
				["<Esc>"] = { "<cmd>nohlsearch<cr>", desc = "Clear search highlighting" },

				-- Better indenting
				["<"] = { "<<", desc = "Indent left" },
				[">"] = { ">>", desc = "Indent right" },

				-- Move lines
				["<A-j>"] = { "<cmd>m .+1<cr>==", desc = "Move line down" },
				["<A-k>"] = { "<cmd>m .-2<cr>==", desc = "Move line up" },

				-- Quick save
				["<C-s>"] = { "<cmd>w<cr>", desc = "Save file" },

				-- Quick quit
				["<leader>q"] = { "<cmd>q<cr>", desc = "Quit" },
				["<leader>Q"] = { "<cmd>qa<cr>", desc = "Quit all" },

				-- Split windows
				["<leader>wv"] = { "<cmd>vsplit<cr>", desc = "Vertical split" },
				["<leader>wh"] = { "<cmd>split<cr>", desc = "Horizontal split" },
				["<leader>wc"] = { "<cmd>close<cr>", desc = "Close window" },
				["<leader>wo"] = { "<cmd>only<cr>", desc = "Close other windows" },

				-- Terminal
				["<leader>tt"] = { "<cmd>terminal<cr>", desc = "Open terminal" },
			},

			-- Visual mode
			v = {
				-- Better indenting
				["<"] = { "<gv", desc = "Indent left" },
				[">"] = { ">gv", desc = "Indent right" },

				-- Move lines
				["<A-j>"] = { ":m '>+1<cr>gv=gv", desc = "Move selection down" },
				["<A-k>"] = { ":m '<-2<cr>gv=gv", desc = "Move selection up" },

				-- Paste without yanking
				["p"] = { '"_dP', desc = "Paste without yanking" },
			},

			-- Insert mode
			i = {
				-- Quick save
				["<C-s>"] = { "<Esc><cmd>w<cr>a", desc = "Save file" },

				-- Move cursor
				["<C-h>"] = { "<Left>", desc = "Move left" },
				["<C-l>"] = { "<Right>", desc = "Move right" },
				["<C-j>"] = { "<Down>", desc = "Move down" },
				["<C-k>"] = { "<Up>", desc = "Move up" },
			},

			-- Terminal mode
			t = {
				-- Exit terminal mode
				["<Esc>"] = { "<C-\\><C-n>", desc = "Exit terminal mode" },
				["<C-h>"] = { "<C-\\><C-n><C-w>h", desc = "Move to left window" },
				["<C-j>"] = { "<C-\\><C-n><C-w>j", desc = "Move to bottom window" },
				["<C-k>"] = { "<C-\\><C-n><C-w>k", desc = "Move to top window" },
				["<C-l>"] = { "<C-\\><C-n><C-w>l", desc = "Move to right window" },
			},
		},

		-- ========================================
		-- Autocommands
		-- ========================================
		autocmds = {
			-- Highlight on yank
			highlight_yank = {
				{
					event = "TextYankPost",
					desc = "Highlight yanked text",
					callback = function()
						vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
					end,
				},
			},

			-- Remove trailing whitespace on save
			trim_whitespace = {
				{
					event = "BufWritePre",
					desc = "Remove trailing whitespace",
					callback = function()
						local save_cursor = vim.fn.getpos(".")
						vim.cmd([[%s/\s\+$//e]])
						vim.fn.setpos(".", save_cursor)
					end,
				},
			},

			-- Auto create directories when saving a file
			auto_create_dir = {
				{
					event = "BufWritePre",
					desc = "Auto create directories",
					callback = function(event)
						local file = vim.loop.fs_realpath(event.match) or event.match
						vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
					end,
				},
			},

			-- Restore cursor position
			restore_cursor = {
				{
					event = "BufReadPost",
					desc = "Restore cursor position",
					callback = function()
						local mark = vim.api.nvim_buf_get_mark(0, '"')
						local lcount = vim.api.nvim_buf_line_count(0)
						if mark[1] > 0 and mark[1] <= lcount then
							pcall(vim.api.nvim_win_set_cursor, 0, mark)
						end
					end,
				},
			},

			-- Close some filetypes with <q>
			close_with_q = {
				{
					event = "FileType",
					desc = "Close with q",
					pattern = {
						"help",
						"lspinfo",
						"man",
						"notify",
						"qf",
						"query",
						"startuptime",
						"checkhealth",
					},
					callback = function(event)
						vim.bo[event.buf].buflisted = false
						vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
					end,
				},
			},
		},
	},
}
