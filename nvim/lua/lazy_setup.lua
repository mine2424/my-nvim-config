-- ========================================
-- Lazy.nvim Setup Configuration
-- ========================================

return {
	-- Configure lazy.nvim behavior
	defaults = {
		lazy = true, -- Lazy load plugins by default
		version = nil, -- Use latest git commit
	},

	-- Installation settings
	install = {
		missing = true, -- Install missing plugins on startup
		colorscheme = { "astrodark", "tokyonight", "habamax" },
	},

	-- Checker settings
	checker = {
		enabled = true, -- Check for plugin updates
		notify = false, -- Don't notify about updates
		frequency = 3600, -- Check every hour
	},

	-- UI settings
	ui = {
		size = { width = 0.8, height = 0.8 },
		border = "rounded",
		icons = {
			cmd = " ",
			config = "",
			event = "",
			ft = " ",
			init = " ",
			import = " ",
			keys = " ",
			lazy = "󰒲 ",
			loaded = "●",
			not_loaded = "○",
			plugin = " ",
			runtime = " ",
			source = " ",
			start = "",
			task = "✔ ",
			list = {
				"●",
				"➜",
				"★",
				"‒",
			},
		},
	},

	-- Performance optimizations
	performance = {
		cache = {
			enabled = true,
		},
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},

	-- Development settings
	dev = {
		path = "~/projects",
		patterns = {},
		fallback = false,
	},
}
