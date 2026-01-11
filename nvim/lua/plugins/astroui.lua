-- ========================================
-- AstroUI Configuration
-- ========================================
-- UI/UX settings and theming

return {
	"AstroNvim/astroui",
	---@type AstroUIOpts
	opts = {
		-- ========================================
		-- Colorscheme
		-- ========================================
		colorscheme = "tokyonight-night",

		-- ========================================
		-- Font (for GUI)
		-- ========================================
		-- Moralerspace: https://github.com/yuru7/moralerspace
		-- Note: This is for GUI Neovim (e.g., Neovide)
		-- Terminal font is configured in terminal settings
		-- vim.opt.guifont = "Moralerspace Neon:h12"

		-- ========================================
		-- Highlights
		-- ========================================
		highlights = {
			init = {
				-- Custom highlight groups
				Normal = { bg = "NONE" },
				NormalNC = { bg = "NONE" },
				SignColumn = { bg = "NONE" },
				NormalFloat = { bg = "NONE" },
				FloatBorder = { bg = "NONE" },
			},
		},

		-- ========================================
		-- Icons
		-- ========================================
		icons = {
			-- LSP symbols
			ActiveLSP = "",
			ActiveTS = "",
			ArrowLeft = "",
			ArrowRight = "",
			Bookmarks = "",
			BufferClose = "󰅖",
			DapBreakpoint = "",
			DapBreakpointCondition = "",
			DapBreakpointRejected = "",
			DapLogPoint = ".>",
			DapStopped = "󰁕",
			Debugger = "",
			DefaultFile = "󰈙",
			Diagnostic = "󰒡",
			DiagnosticError = "",
			DiagnosticHint = "󰌵",
			DiagnosticInfo = "󰋼",
			DiagnosticWarn = "",
			Ellipsis = "…",
			FileNew = "",
			FileModified = "",
			FileReadOnly = "",
			FoldClosed = "",
			FoldOpened = "",
			FoldSeparator = " ",
			FolderClosed = "",
			FolderEmpty = "",
			FolderOpen = "",
			Git = "󰊢",
			GitAdd = "",
			GitBranch = "",
			GitChange = "",
			GitConflict = "",
			GitDelete = "",
			GitIgnored = "◌",
			GitRenamed = "➜",
			GitSign = "▎",
			GitStaged = "✓",
			GitUnstaged = "✗",
			GitUntracked = "★",
			LSPLoaded = "",
			LSPLoading1 = "",
			LSPLoading2 = "󰀚",
			LSPLoading3 = "",
			MacroRecording = "",
			Package = "󰏖",
			Paste = "󰅌",
			Refresh = "",
			Search = "",
			Selected = "❯",
			Session = "󱂬",
			Sort = "󰒺",
			Spellcheck = "󰓆",
			Tab = "󰓩",
			TabClose = "󰅙",
			Terminal = "",
			Window = "",
			WordFile = "󰈭",
		},

		-- ========================================
		-- Status
		-- ========================================
		status = {
			-- Separator styles: "none", "left", "right", "center", "thick", "thin", "slant", "round", "arrow"
			separators = {
				left = { "", "" },
				right = { "", "" },
				tab = { "", "" },
			},

			-- Colors for status line components
			colors = function(hl)
				local get_hlgroup = require("astroui").get_hlgroup
				local normal = get_hlgroup("Normal")
				local fg, bg = normal.fg, normal.bg
				local bg_alt = get_hlgroup("Visual").bg
				local green = get_hlgroup("String").fg
				local red = get_hlgroup("Error").fg
				return {
					fg = fg,
					bg = bg,
					section_fg = fg,
					section_bg = bg_alt,
					git_branch_fg = green,
					mode_fg = bg,
					treesitter_fg = green,
					scrollbar = red,
					git_added = green,
					git_changed = get_hlgroup("Number").fg,
					git_removed = red,
					diag_ERROR = get_hlgroup("DiagnosticError").fg,
					diag_WARN = get_hlgroup("DiagnosticWarn").fg,
					diag_INFO = get_hlgroup("DiagnosticInfo").fg,
					diag_HINT = get_hlgroup("DiagnosticHint").fg,
					winbar_fg = fg,
					winbar_bg = bg,
					tabline_bg = bg,
					tabline_fg = fg,
					buffer_fg = fg,
					buffer_path_fg = get_hlgroup("Comment").fg,
					buffer_close_fg = red,
					buffer_bg = bg_alt,
					buffer_active_fg = fg,
					buffer_active_path_fg = get_hlgroup("Comment").fg,
					buffer_active_close_fg = red,
					buffer_active_bg = bg,
					buffer_visible_fg = fg,
					buffer_visible_path_fg = get_hlgroup("Comment").fg,
					buffer_visible_close_fg = red,
					buffer_visible_bg = bg_alt,
					buffer_overflow_fg = get_hlgroup("Comment").fg,
					buffer_overflow_bg = bg_alt,
					buffer_picker_fg = red,
					tab_close_fg = red,
					tab_close_bg = bg_alt,
					tab_fg = fg,
					tab_bg = bg_alt,
					tab_active_fg = fg,
					tab_active_bg = bg,
				}
			end,

			-- Attributes for status line components
			attributes = {
				buffer_active = { bold = true, italic = false },
				buffer_picker = { bold = true },
				macro_recording = { bold = true },
				git_branch = { bold = true },
				git_diff = { bold = true },
			},

			-- Icon highlights
			icon_highlights = {
				file_icon = {
					tabline = function(self)
						return self.is_active or self.is_visible
					end,
					statusline = true,
				},
			},
		},
	},
}
