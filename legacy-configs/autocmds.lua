-- ===============================================
-- Consolidated Auto Commands
-- ===============================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ===============================================
-- File Type Specific Settings
-- ===============================================

-- Programming languages
autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'json', 'dart' },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
  desc = 'JS/TS/Dart 2-space indentation'
})

autocmd('FileType', {
  pattern = { 'python' },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
  desc = 'Python 4-space indentation'
})

-- Git commit settings
autocmd('FileType', {
  pattern = 'gitcommit',
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.colorcolumn = '50,72'
  end,
  desc = 'Git commit settings'
})

-- Markdown settings
autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.conceallevel = 2
    -- Enable treesitter for markdown (required by render-markdown.nvim)
    -- vim.bo.syntax = 'markdown'  -- Commented out to use treesitter
    -- vim.cmd('TSDisable highlight')  -- Commented out to use treesitter
  end,
  desc = 'Markdown settings'
})

-- ===============================================
-- File Management
-- ===============================================

-- Auto reload files when changed externally
autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  pattern = '*',
  command = 'if mode() != "c" | checktime | endif',
  desc = 'Auto reload files'
})

-- Remove trailing whitespace on save (exclude specific filetypes)
autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    local ft = vim.bo.filetype
    -- Skip for filetypes where trailing whitespace might be significant
    if ft ~= 'markdown' and ft ~= 'diff' then
      local save_cursor = vim.fn.getpos(".")
      vim.cmd([[%s/\s\+$//e]])
      vim.fn.setpos(".", save_cursor)
    end
  end,
  desc = 'Remove trailing whitespace on save'
})

-- Restore cursor position
autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line('$') then
      vim.cmd('normal! g`"')
    end
  end,
  desc = 'Restore cursor position'
})

-- ===============================================
-- Terminal Settings
-- ===============================================

-- Terminal mode configuration
autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
  end,
  desc = 'Terminal settings'
})

-- ===============================================
-- Visual Enhancements
-- ===============================================

-- Highlight yanked text
autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 300 })
  end,
  desc = 'Highlight yanked text'
})

-- Search highlight management
autocmd('CmdlineEnter', {
  pattern = { '/', '?' },
  command = 'set hlsearch',
  desc = 'Enable search highlight'
})
