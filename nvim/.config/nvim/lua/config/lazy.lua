-- ========================================
-- lazy.nvim Bootstrap and Setup
-- ========================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  -- Clone lazy.nvim if not installed
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Import plugin specifications from lua/plugins/
  { import = "plugins" },
}, {
  -- lazy.nvim configuration
  defaults = {
    lazy = true,  -- Default to lazy loading
    version = false,  -- Use latest git commit (version = "*" for releases)
  },
  
  -- Installation settings
  install = {
    colorscheme = { "tokyonight", "habamax" },
  },
  
  -- Update checker
  checker = {
    enabled = true,  -- Check for updates
    notify = false,  -- Don't notify on startup
    frequency = 3600,  -- Check every hour
  },
  
  -- Change detection
  change_detection = {
    enabled = true,  -- Detect config file changes
    notify = false,  -- Don't notify
  },
  
  -- Performance optimizations
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = {},
      -- Disable built-in plugins
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
  
  -- UI settings
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
