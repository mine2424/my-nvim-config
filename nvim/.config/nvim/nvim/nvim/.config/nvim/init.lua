-- ========================================
-- Neovim Configuration Entry Point
-- ========================================
-- Simple, performant Neovim setup with lazy.nvim
-- Designed for parallel development with Claude Code (Cursor)

-- Set leader keys before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Load configuration modules
require("config.options")   -- Neovim options
require("config.lazy")      -- lazy.nvim setup
require("config.keymaps")   -- Key mappings
require("config.autocmds")  -- Auto commands
