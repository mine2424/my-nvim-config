-- ===============================================
-- キーマップ設定
-- ===============================================
local keymap = vim.keymap

-- リーダーキー設定
vim.g.mapleader = ' '      -- スペースキーをリーダーに設定

-- ===============================================
-- 基本操作
-- ===============================================

-- ESC代替キーマップ
keymap.set('i', 'jj', '<ESC>', { desc = 'Insert mode escape' })
keymap.set('i', 'kk', '<ESC>', { desc = 'Insert mode escape alternative' })

-- 検索ハイライト解除
keymap.set('n', '<ESC><ESC>', ':nohl<Return>', { desc = 'Clear search highlight' })

-- 保存・終了
keymap.set('n', '<Leader>w', ':w<Return>', { desc = 'Save file' })
keymap.set('n', '<Leader>Q', ':q<Return>', { desc = 'Quit' })
keymap.set('n', '<Leader>wq', ':wq<Return>', { desc = 'Save and quit' })

-- IDE全体を一発で閉じる
keymap.set('n', '<Leader>qq', ':qa<Return>', { desc = 'Quit all windows' })
keymap.set('n', '<Leader>qa', ':qa!<Return>', { desc = 'Force quit all windows' })
keymap.set('n', '<Leader>wqa', ':wqa<Return>', { desc = 'Save all and quit' })

-- ===============================================
-- ウィンドウ・タブ操作
-- ===============================================

-- ウィンドウ分割
keymap.set('n', 'ss', ':split<Return><C-w>w', { desc = 'Horizontal split' })
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { desc = 'Vertical split' })

-- ウィンドウ移動（Tmuxとの連携を考慮）
keymap.set('n', '<Leader><Space>', '<C-w>w', { desc = 'Switch window' })
keymap.set('n', 'sh', '<C-w>h', { desc = 'Move to left window' })
keymap.set('n', 'sk', '<C-w>k', { desc = 'Move to upper window' })
keymap.set('n', 'sj', '<C-w>j', { desc = 'Move to lower window' })
keymap.set('n', 'sl', '<C-w>l', { desc = 'Move to right window' })


-- タブ操作
keymap.set('n', '<Leader>tn', ':tabnew<Return>', { desc = 'New tab' })
keymap.set('n', '<Leader>tc', ':tabclose<Return>', { desc = 'Close tab' })
keymap.set('n', '<Leader>t]', ':tabnext<Return>', { desc = 'Next tab' })
keymap.set('n', '<Leader>t[', ':tabprev<Return>', { desc = 'Previous tab' })

-- ===============================================
-- バッファ操作
-- ===============================================

-- バッファ移動（Tab/S-Tabをシンプルなバッファ切り替えに）
keymap.set('n', '<Tab>', ':bnext<Return>', { desc = 'Next buffer' })
keymap.set('n', '<S-Tab>', ':bprev<Return>', { desc = 'Previous buffer' })
keymap.set('n', '<Leader>b[', ':bprev<Return>', { desc = 'Previous buffer' })
keymap.set('n', '<Leader>b]', ':bnext<Return>', { desc = 'Next buffer' })
keymap.set('n', '<Leader>bd', ':bdelete<Return>', { desc = 'Delete buffer' })
keymap.set('n', '<Leader>bl', ':buffers<Return>', { desc = 'List buffers' })

-- ===============================================
-- 編集操作
-- ===============================================

-- 行の移動
keymap.set('v', 'J', ":m '>+1<Return>gv=gv", { desc = 'Move selection down' })
keymap.set('v', 'K', ":m '<-2<Return>gv=gv", { desc = 'Move selection up' })

-- インデント調整（ビジュアルモードで選択を保持）
keymap.set('v', '<', '<gv', { desc = 'Decrease indent and keep selection' })
keymap.set('v', '>', '>gv', { desc = 'Increase indent and keep selection' })

-- 行の複製
keymap.set('n', '<Leader>d', ':t.<Return>', { desc = 'Duplicate line' })

-- 全選択
keymap.set('n', '<Leader>a', 'ggVG', { desc = 'Select all' })

-- ===============================================
-- 検索・置換
-- ===============================================

-- 現在の単語を検索
keymap.set('n', '*', '*N', { desc = 'Search current word forward' })
keymap.set('n', '#', '#N', { desc = 'Search current word backward' })

-- 置換（現在の単語）
keymap.set('n', '<Leader>r', ':%s/<C-r><C-w>//g<Left><Left>', { desc = 'Replace current word' })

-- ===============================================
-- ファイル操作
-- ===============================================

-- 新しいファイル
keymap.set('n', '<Leader>n', ':enew<Return>', { desc = 'New file' })

-- ファイル保存（フォーマット付き）
keymap.set('n', '<Leader>wf', ':w<Return>:!prettier --write %<Return>', { desc = 'Save and format' })

-- ===============================================
-- ターミナル
-- ===============================================

-- ターミナルを開く
keymap.set('n', '<Leader>T', ':terminal<Return>', { desc = 'Open terminal' })
keymap.set('t', '<ESC>', '<C-\\><C-n>', { desc = 'Terminal normal mode' })

-- ===============================================
-- ユーティリティ
-- ===============================================

-- 現在のファイルパスをコピー
keymap.set('n', '<Leader>cp', ':let @+ = expand("%:p")<Return>', { desc = 'Copy file path' })

-- 現在の行をコピー
keymap.set('n', '<Leader>cl', ':let @+ = getline(".")<Return>', { desc = 'Copy current line' })

-- ファイル内容を整形（Vim標準）
keymap.set('n', '<Leader>=', 'gg=G', { desc = 'Format entire file (Vim)' })

-- QuickFixリスト
keymap.set('n', '<Leader>qo', ':copen<Return>', { desc = 'Open quickfix' })
keymap.set('n', '<Leader>qc', ':cclose<Return>', { desc = 'Close quickfix' })
keymap.set('n', '<Leader>qn', ':cnext<Return>', { desc = 'Next quickfix item' })
keymap.set('n', '<Leader>qp', ':cprev<Return>', { desc = 'Previous quickfix item' })

-- ===============================================
-- Flutter開発専用キーマップ
-- ===============================================

-- Flutter プロジェクト管理
keymap.set('n', '<Leader>Fr', ':!flutter run<Return>', { desc = 'Flutter run' })
keymap.set('n', '<Leader>Fh', ':!flutter run --hot-reload<Return>', { desc = 'Flutter hot reload' })
keymap.set('n', '<Leader>Fc', ':!flutter clean<Return>', { desc = 'Flutter clean' })
keymap.set('n', '<Leader>Fb', ':!flutter build apk<Return>', { desc = 'Flutter build APK' })
keymap.set('n', '<Leader>Ft', ':!flutter test<Return>', { desc = 'Flutter test' })
keymap.set('n', '<Leader>Fd', ':!flutter devices<Return>', { desc = 'Flutter devices' })
keymap.set('n', '<Leader>Fe', ':!flutter emulators<Return>', { desc = 'Flutter emulators' })

-- Dart分析・フォーマット
keymap.set('n', '<Leader>Da', ':!dart analyze<Return>', { desc = 'Dart analyze' })
keymap.set('n', '<Leader>Df', ':!dart format .<Return>', { desc = 'Dart format' })
keymap.set('n', '<Leader>Dp', ':!dart pub get<Return>', { desc = 'Dart pub get' })
keymap.set('n', '<Leader>Du', ':!dart pub upgrade<Return>', { desc = 'Dart pub upgrade' })

-- Flutter開発用ターミナル
keymap.set('n', '<Leader>FT', ':tabnew | terminal flutter run<Return>', { desc = 'Flutter run in new tab' })
keymap.set('n', '<Leader>FL', ':split | terminal flutter logs<Return>', { desc = 'Flutter logs in split' })

-- ===============================================
-- LSP (Language Server Protocol)
-- ===============================================
-- Note: LSPキーマップはLspAttach自動コマンドで動的に設定されるため、
-- ここではLSP管理コマンドのみを定義します

-- LSP Info
keymap.set('n', '<Leader>li', ':LspInfo<Return>', { desc = 'LSP information' })
keymap.set('n', '<Leader>lr', ':LspRestart<Return>', { desc = 'Restart LSP' })
keymap.set('n', '<Leader>ls', ':LspStart<Return>', { desc = 'Start LSP' })
keymap.set('n', '<Leader>lS', ':LspStop<Return>', { desc = 'Stop LSP' })

-- ===============================================
-- GitHub Copilot
-- ===============================================

-- Copilot suggestions (インサートモードで動作)
-- Note: これらのキーマップはcopilot.luaの設定で自動的に設定されますが、
-- リファレンスのためにここにも記載しています
-- <M-l> (Alt+l): 提案を受け入れる
-- <M-]> (Alt+]): 次の提案
-- <M-[> (Alt+[): 前の提案
-- <C-]> (Ctrl+]): 提案を却下

-- Copilot管理コマンド
keymap.set('n', '<Leader>Cs', ':Copilot status<Return>', { desc = 'Copilot status' })
keymap.set('n', '<Leader>Ce', ':Copilot enable<Return>', { desc = 'Copilot enable' })
keymap.set('n', '<Leader>Cd', ':Copilot disable<Return>', { desc = 'Copilot disable' })
keymap.set('n', '<Leader>Ca', ':Copilot auth<Return>', { desc = 'Copilot authenticate' })
keymap.set('n', '<Leader>Cp', ':Copilot panel<Return>', { desc = 'Copilot suggestions panel' })

-- ===============================================
-- Markdown
-- ===============================================

-- Markdown rendering toggle
keymap.set('n', '<Leader>mr', ':RenderMarkdown toggle<Return>', { desc = 'Toggle markdown rendering' })

-- ===============================================
-- IDE風レイアウト
-- ===============================================

-- IDE風レイアウト起動
keymap.set('n', '<Leader>ide', ':StartSmartIDE<Return>', { desc = 'Start smart IDE layout' })
keymap.set('n', '<Leader>I', ':StartIDE<Return>', { desc = 'Start full IDE layout' })
keymap.set('n', '<Leader>is', ':StartSimpleIDE<Return>', { desc = 'Start simple IDE layout' })
keymap.set('n', '<Leader>if', ':StartFlutterIDE<Return>', { desc = 'Start Flutter IDE layout' })
keymap.set('n', '<Leader>ir', ':ResetLayout<Return>', { desc = 'Reset window layout' })

