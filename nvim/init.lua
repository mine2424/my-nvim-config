-- ========================================
-- AstroNvim Configuration Entry Point
-- ========================================
-- Bootstrap lazy.nvim and load AstroNvim

-- Set leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy.nvim and plugins
require("lazy").setup({
	-- AstroNvim
	{
		"AstroNvim/AstroNvim",
		version = "^4",
		import = "astronvim.plugins",
		opts = {},
	},

	-- Import user plugins
	{ import = "plugins" },
}, {
	-- Lazy.nvim configuration
	defaults = { lazy = true },
	install = { colorscheme = { "astrodark", "habamax" } },
	checker = { enabled = true, notify = false },
	performance = {
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
})
