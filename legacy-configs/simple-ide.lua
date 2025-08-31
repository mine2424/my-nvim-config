-- ===============================================
-- シンプルIDE設定 - よりクリーンでミニマルなUI
-- ===============================================

local M = {}

-- ===============================================
-- 起動時の自動レイアウト設定
-- ===============================================

function M.setup_auto_layout()
  -- プロジェクトタイプを検出してレイアウトを自動起動
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      -- ファイルが指定されていない場合のみ自動レイアウト
      if vim.fn.argc() == 0 then
        vim.defer_fn(function()
          -- 3分割レイアウトを起動
          require('ide-layout').start_simple_ide()
        end, 100)
      end
    end,
    desc = "Auto start 3-pane IDE layout"
  })
end

-- ===============================================
-- UI設定の簡素化
-- ===============================================

function M.setup_minimal_ui()
  -- 不要なUI要素を非表示
  vim.opt.showtabline = 0  -- タブラインを常に非表示
  vim.opt.laststatus = 2   -- ステータスラインは最下部のみ
  
  -- より落ち着いた色設定
  vim.cmd([[
    highlight VertSplit guifg=#3e4452 guibg=NONE
    highlight StatusLineNC guifg=#5c6370 guibg=NONE
    highlight NvimTreeNormal guibg=NONE
    highlight NvimTreeEndOfBuffer guibg=NONE
  ]])
end

-- ===============================================
-- バッファ管理の簡素化
-- ===============================================

function M.setup_buffer_management()
  -- バッファを閉じる際の挙動を改善
  vim.api.nvim_create_user_command('BufOnly', function()
    vim.cmd('%bdelete|edit#|bdelete#')
  end, { desc = 'Close all buffers except current' })
  
  -- より便利なバッファ切り替え
  vim.keymap.set('n', '<leader>bb', '<cmd>Telescope buffers<cr>', { desc = 'Buffer list (Telescope)' })
  vim.keymap.set('n', '<leader>bn', '<cmd>enew<cr>', { desc = 'New buffer' })
end

-- ===============================================
-- ウィンドウ管理の改善
-- ===============================================

function M.setup_window_management()
  -- ウィンドウ間の移動をより直感的に
  vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
  vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
  vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })
  
  -- ウィンドウサイズ調整
  vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
  vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
  vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
  vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })
  
  -- 3分割レイアウト用の便利なキーマップ
  vim.keymap.set('n', '<leader>w1', '<cmd>1wincmd w<cr>', { desc = 'Go to window 1 (file tree)' })
  vim.keymap.set('n', '<leader>w2', '<cmd>2wincmd w<cr>', { desc = 'Go to window 2 (main editor)' })
  vim.keymap.set('n', '<leader>w3', '<cmd>3wincmd w<cr>', { desc = 'Go to window 3 (second editor)' })
  
  -- ウィンドウのバランスを再調整
  vim.keymap.set('n', '<leader>w=', function()
    vim.cmd('wincmd =')  -- 均等化
    vim.cmd('1wincmd w')  -- ファイルツリーに移動
    vim.cmd('vertical resize 30')  -- ファイルツリーを30列に
    vim.cmd('2wincmd w')  -- メインエディタに戻る
  end, { desc = 'Rebalance windows (file tree 30 cols)' })
  
  -- 右側のエディタに現在のバッファを複製
  vim.keymap.set('n', '<leader>wd', function()
    local current_buf = vim.api.nvim_get_current_buf()
    vim.cmd('wincmd l')  -- 右側のウィンドウに移動
    vim.api.nvim_set_current_buf(current_buf)
    vim.cmd('wincmd h')  -- 元のウィンドウに戻る
  end, { desc = 'Duplicate buffer to right window' })
end

-- ===============================================
-- セットアップ関数
-- ===============================================

function M.setup()
  -- UIの簡素化
  M.setup_minimal_ui()
  
  -- バッファ管理
  M.setup_buffer_management()
  
  -- ウィンドウ管理
  M.setup_window_management()
  
  -- 自動レイアウト
  M.setup_auto_layout()
  
  -- シンプルなコマンド
  vim.api.nvim_create_user_command('SimpleIDE', function()
    require('ide-layout').start_simple_ide()
  end, { desc = 'Start simple IDE layout' })
end

return M