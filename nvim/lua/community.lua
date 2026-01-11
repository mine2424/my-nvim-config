-- ========================================
-- AstroCommunity Plugin Configuration
-- ========================================
-- Import community plugins and packs

return {
	"AstroNvim/astrocommunity",

	-- ========================================
	-- Language Packs
	-- ========================================

	-- Web Development
	{ import = "astrocommunity.pack.typescript" },
	{ import = "astrocommunity.pack.html-css" },
	{ import = "astrocommunity.pack.json" },
	{ import = "astrocommunity.pack.yaml" },
	{ import = "astrocommunity.pack.tailwindcss" },

	-- Systems Programming
	{ import = "astrocommunity.pack.rust" },
	{ import = "astrocommunity.pack.go" },

	-- Scripting
	{ import = "astrocommunity.pack.python" },
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.pack.bash" },

	-- Mobile Development
	{ import = "astrocommunity.pack.dart" },

	-- Configuration
	{ import = "astrocommunity.pack.toml" },
	{ import = "astrocommunity.pack.markdown" },

	-- ========================================
	-- Colorschemes
	-- ========================================

	{ import = "astrocommunity.colorscheme.tokyonight-nvim" },
	{ import = "astrocommunity.colorscheme.catppuccin" },
	{ import = "astrocommunity.colorscheme.nord-nvim" },

	-- ========================================
	-- Utilities
	-- ========================================

	-- Git integration
	{ import = "astrocommunity.git.neogit" },
	{ import = "astrocommunity.git.diffview-nvim" },

	-- File management
	{ import = "astrocommunity.file-explorer.oil-nvim" },

	-- Editing enhancements
	{ import = "astrocommunity.editing-support.todo-comments-nvim" },
	{ import = "astrocommunity.editing-support.vim-move" },
	{ import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },

	-- Motion
	{ import = "astrocommunity.motion.flash-nvim" },
	{ import = "astrocommunity.motion.mini-surround" },

	-- Diagnostics
	{ import = "astrocommunity.diagnostics.trouble-nvim" },

	-- Completion
	{ import = "astrocommunity.completion.copilot-lua-cmp" },
}
