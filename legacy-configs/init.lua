-- ===============================================
-- Neovim Configuration Entry Point
-- ===============================================

-- Core settings
require('base')
require('maps')
require('autocmds')

-- Flutter development with DAP (main configuration)
require('flutter-dev-with-dap')

-- IDE layout setup
require('ide-layout').setup()

-- Simple IDE enhancements
require('simple-ide').setup()

