-- ===============================================
-- 基本設定 (エンコーディング)
-- ===============================================
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- ===============================================
-- 表示設定
-- ===============================================
vim.wo.number = true              -- 行番号表示
vim.wo.relativenumber = true      -- 相対行番号表示（vim操作効率化）
vim.opt.title = true              -- タイトル表示
vim.opt.showcmd = true            -- コマンド表示
vim.opt.laststatus = 2            -- ステータスライン常時表示
vim.opt.showmode = false          -- モード表示を無効化（ステータスラインで表示）
vim.opt.ruler = true              -- カーソル位置表示
vim.opt.cursorline = true         -- カーソル行をハイライト
vim.opt.signcolumn = 'yes'        -- サインカラム常時表示（LSP/Git用）
vim.opt.colorcolumn = '80'        -- 80文字ガイドライン表示

-- ===============================================
-- インデント・タブ設定
-- ===============================================
vim.opt.autoindent = true         -- 自動インデント
vim.opt.smartindent = true        -- スマートインデント
vim.opt.expandtab = true          -- タブをスペースに変換
vim.opt.shiftwidth = 2            -- インデント幅
vim.opt.tabstop = 2               -- タブ文字の表示幅
vim.opt.softtabstop = 2           -- タブキー押下時のスペース数
vim.opt.smarttab = true           -- 行頭でのタブ挿入をshiftwidthに合わせる

-- ===============================================
-- 検索設定
-- ===============================================
vim.opt.hlsearch = true           -- 検索結果をハイライト
vim.opt.incsearch = true          -- インクリメンタル検索
vim.opt.ignorecase = true         -- 大文字小文字を無視
vim.opt.smartcase = true          -- 大文字が含まれている場合は大文字小文字を区別

-- ===============================================
-- 編集・操作設定
-- ===============================================
vim.opt.backup = false            -- バックアップファイルを作成しない
vim.opt.swapfile = false          -- スワップファイルを作成しない
vim.opt.undofile = true           -- アンドゥファイルを作成（永続化）
vim.opt.wrap = false              -- 行の折り返し無効
vim.opt.backspace = { 'start', 'eol', 'indent' }  -- バックスペースの動作設定
vim.opt.whichwrap = 'b,s,h,l,<,>,[,],~'  -- カーソル移動で行を跨ぐ
vim.opt.virtualedit = 'onemore'   -- 行末の一文字先までカーソルを移動可能

-- ===============================================  
-- 表示・UI設定
-- ===============================================
vim.opt.list = true               -- 不可視文字を表示
vim.opt.listchars = {             -- 不可視文字の表示設定
  tab = '▸ ',
  trail = '·',
  extends = '»',
  precedes = '«',
  nbsp = '⦸'
}
vim.opt.pumheight = 10            -- 補完メニューの最大高さ
vim.opt.winblend = 10             -- フローティングウィンドウの透明度
vim.opt.pumblend = 10             -- 補完メニューの透明度

-- ===============================================
-- ファイル・バッファ設定
-- ===============================================
vim.opt.hidden = true             -- バッファを隠す
vim.opt.autoread = true           -- 外部でファイルが変更された時自動読み込み
vim.opt.confirm = true            -- 未保存ファイルがある時に確認ダイアログ表示

-- ===============================================
-- スクロール・移動設定
-- ===============================================
vim.opt.scrolloff = 8             -- スクロール時の余白行数
vim.opt.sidescrolloff = 16        -- 横スクロール時の余白列数
vim.opt.sidescroll = 1            -- 横スクロールの最小列数

-- ===============================================
-- パフォーマンス設定
-- ===============================================
vim.opt.updatetime = 300          -- スワップファイル書き込み間隔（LSP用）
vim.opt.timeoutlen = 500          -- キーマップタイムアウト
vim.opt.ttimeoutlen = 50          -- キーコードタイムアウト

-- ===============================================
-- ターミナル設定
-- ===============================================
vim.opt.shell = 'zsh'             -- デフォルトシェル
vim.opt.termguicolors = true      -- True Color対応

-- ===============================================
-- マウス設定
-- ===============================================
vim.opt.mouse = 'a'               -- 全モードでマウス有効

-- ===============================================
-- クリップボード設定
-- ===============================================
vim.opt.clipboard:append { 'unnamedplus' }  -- システムクリップボード連携
