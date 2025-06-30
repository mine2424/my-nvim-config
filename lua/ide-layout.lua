-- ===============================================
-- IDE風レイアウト設定
-- ===============================================

local M = {}

-- ===============================================
-- IDE風レイアウトの作成
-- ===============================================

function M.start_ide_layout()
  -- 現在のタブをクリア（新しいバッファがない場合のみ）
  if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' and vim.fn.expand('%') == '' then
    vim.cmd('enew')
  end

  -- 左側にファイルツリー（netrw）を開く
  vim.cmd('Lexplore')

  -- ファイルツリーのサイズを調整（幅35列）
  vim.cmd('vertical resize 35')

  -- メインエディタエリアに移動
  vim.cmd('wincmd l')

  -- 右側にターミナルを開く（垂直分割）
  vim.cmd('vsplit')
  vim.cmd('vertical resize 120')
  vim.cmd('terminal')

  -- メインエディタにフォーカス
  vim.cmd('wincmd h')
  
  -- Copilotを自動起動
  local copilot_ok, _ = pcall(function()
    vim.cmd('Copilot enable')
  end)
  if copilot_ok then
    print('IDE layout activated with Copilot enabled!')
  else
    print('IDE layout activated!')
  end
end

-- ===============================================
-- シンプルなIDE風レイアウト（ターミナルなし）
-- ===============================================

function M.start_simple_ide()
  -- 現在のタブをクリア
  if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' and vim.fn.expand('%') == '' then
    vim.cmd('enew')
  end

  -- 左側にファイルツリー（netrw）を開く
  vim.cmd('Lexplore')

  -- ファイルツリーのサイズを調整
  vim.cmd('vertical resize 35')

  -- メインエディタエリアに移動
  vim.cmd('wincmd l')
  
  -- Copilotを自動起動
  local copilot_ok, _ = pcall(function()
    vim.cmd('Copilot enable')
  end)
  if copilot_ok then
    print('Simple IDE layout activated with Copilot enabled!')
  else
    print('Simple IDE layout activated!')
  end
end

-- ===============================================
-- Flutter開発用レイアウト
-- ===============================================

function M.start_flutter_ide()
  -- 現在のタブをクリア
  if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' and vim.fn.expand('%') == '' then
    vim.cmd('enew')
  end

  -- 左側にファイルツリー
  vim.cmd('Lexplore')
  vim.cmd('vertical resize 35')

  -- メインエディタエリアに移動
  vim.cmd('wincmd l')

  -- 右側にFlutter用ターミナル（垂直分割）
  vim.cmd('vsplit')
  vim.cmd('vertical resize 120')
  vim.cmd('terminal')

  -- メインエディタにフォーカス
  vim.cmd('wincmd h')
  
  -- Copilotを自動起動
  local copilot_ok, _ = pcall(function()
    vim.cmd('Copilot enable')
  end)
  
  -- Flutter プロジェクト検出とメッセージ
  local flutter_dir = vim.fn.findfile('pubspec.yaml', '.;')
  if flutter_dir ~= '' then
    if copilot_ok then
      print('Flutter IDE layout activated with Copilot enabled! Use <Leader>Fr to start flutter run.')
    else
      print('Flutter IDE layout activated! Use <Leader>Fr to start flutter run.')
    end
  else
    if copilot_ok then
      print('Flutter IDE layout activated with Copilot enabled!')
    else
      print('Flutter IDE layout activated!')
    end
  end
end

-- ===============================================
-- レイアウトリセット
-- ===============================================

function M.reset_layout()
  -- 全てのウィンドウを閉じて新しいバッファを開く
  vim.cmd('only')
  vim.cmd('enew')
end

-- ===============================================
-- netrwの設定調整
-- ===============================================

function M.setup_netrw()
  -- netrwの表示スタイル（ツリー表示）
  vim.g.netrw_liststyle = 3

  -- netrwのウィンドウサイズ
  vim.g.netrw_winsize = 25

  -- netrwでディレクトリを開いた時の動作
  vim.g.netrw_browse_split = 0

  -- netrwのバナーを非表示
  vim.g.netrw_banner = 0

  -- netrwで隠しファイルを非表示
  vim.g.netrw_hide = 1
  vim.g.netrw_list_hide = [[^\.\.\=/\=$,^\./$]]

  -- netrwで削除したファイルをゴミ箱に移動（macOS）
  if vim.fn.has('macunix') == 1 then
    vim.g.netrw_localrmdir = 'trash'
  end
end

-- ===============================================
-- 自動コマンドの設定
-- ===============================================

function M.setup_autocmds()
  local augroup = vim.api.nvim_create_augroup('IDELayout', { clear = true })

  -- netrwウィンドウでのキーマップ設定
  vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = 'netrw',
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      -- netrwでの便利なキーマップ
      vim.keymap.set('n', 'l', '<CR>', { buffer = buf, desc = 'Open file/directory' })
      vim.keymap.set('n', 'h', '-', { buffer = buf, desc = 'Go up directory' })
      vim.keymap.set('n', 'R', '<F5>', { buffer = buf, desc = 'Refresh' })
    end,
    desc = 'Setup netrw keymaps'
  })

  -- ターミナルウィンドウの設定
  vim.api.nvim_create_autocmd('TermOpen', {
    group = augroup,
    pattern = '*',
    callback = function()
      -- ターミナルでは行番号を非表示
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.signcolumn = 'no'
    end,
    desc = 'Terminal window settings'
  })
end

-- ===============================================
-- プロジェクトタイプの検出
-- ===============================================

function M.detect_project_type()
  local cwd = vim.fn.getcwd()

  -- Flutter/Dartプロジェクト
  if vim.fn.filereadable(cwd .. '/pubspec.yaml') == 1 then
    return 'flutter'
  end

  -- Node.jsプロジェクト
  if vim.fn.filereadable(cwd .. '/package.json') == 1 then
    return 'nodejs'
  end

  -- Pythonプロジェクト
  if vim.fn.filereadable(cwd .. '/requirements.txt') == 1 or
     vim.fn.filereadable(cwd .. '/pyproject.toml') == 1 then
    return 'python'
  end

  -- Rustプロジェクト
  if vim.fn.filereadable(cwd .. '/Cargo.toml') == 1 then
    return 'rust'
  end

  return 'general'
end

-- ===============================================
-- スマートIDE起動（プロジェクトタイプに応じて最適なレイアウト）
-- ===============================================

function M.start_smart_ide()
  local project_type = M.detect_project_type()

  if project_type == 'flutter' then
    M.start_flutter_ide()
  else
    M.start_ide_layout()
  end
end

-- ===============================================
-- セットアップ関数
-- ===============================================

function M.setup()
  -- netrwの設定
  M.setup_netrw()

  -- 自動コマンドの設定
  M.setup_autocmds()

  -- ユーザーコマンドの登録
  vim.api.nvim_create_user_command('StartIDE', M.start_ide_layout, { desc = 'Start IDE layout' })
  vim.api.nvim_create_user_command('StartSimpleIDE', M.start_simple_ide, { desc = 'Start simple IDE layout' })
  vim.api.nvim_create_user_command('StartFlutterIDE', M.start_flutter_ide, { desc = 'Start Flutter IDE layout' })
  vim.api.nvim_create_user_command('StartSmartIDE', M.start_smart_ide, { desc = 'Start smart IDE layout based on project type' })
  vim.api.nvim_create_user_command('ResetLayout', M.reset_layout, { desc = 'Reset window layout' })
end

return M
