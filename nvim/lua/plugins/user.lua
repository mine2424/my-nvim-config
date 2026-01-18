-- ========================================
-- User Custom Plugins
-- ========================================
-- Custom plugins that are not included in LazyVim
-- Note: LazyVim already includes many plugins like:
-- - telescope, gitsigns, trouble, mini.nvim, nvim-notify, etc.
-- Only add plugins that are NOT in LazyVim here

return {
	-- ========================================
	-- Code Completion (GitHub Copilot)
	-- ========================================

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<M-l>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			panel = { enabled = false },
			filetypes = {
				yaml = true,
				markdown = true,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
			},
		},
	},
}
