# 統合キーバインディングガイド

## 📋 概要

このドキュメントでは、Neovim、Tmux、WezTermの統一されたキーバインディング設計を説明します。
3つのツール間で一貫性のある操作感を実現し、効率的な開発環境を提供します。

## 🎯 設計原則

### 1. 一貫性
- **同じ操作は同じキー**: ペイン移動は常に `Ctrl+h/j/k/l`
- **階層的な設計**: WezTerm → Tmux → Neovim の順で処理
- **衝突の回避**: 各レイヤーで適切にキーを使い分け

### 2. 直感性
- **Vim風**: `h/j/k/l` による方向指定
- **覚えやすい**: Leader + 意味のある文字（`f` = find, `g` = git）
- **モード明確**: どのツールが反応するか明確

### 3. 効率性
- **最小キーストローク**: よく使う操作は短いキーで
- **ホームポジション**: 手を動かさずに操作可能
- **モディファイアキーの統一**: `Ctrl`, `Alt`, `Leader` の使い分け

## 🔑 キー配置の全体像

```
┌─────────────────────────────────────────────────────────────┐
│ WezTerm (最外層)                                             │
│ - タブ管理: Ctrl+Shift+[数字/T/W]                            │
│ - ペイン分割: Ctrl+Shift+[|/-]                               │
│ - 設定: Ctrl+Shift+,                                         │
│                                                              │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ Tmux (中間層)                                            │ │
│ │ - Prefix: Ctrl+A                                         │ │
│ │ - ウィンドウ管理: Prefix + [c/n/p/数字]                  │ │
│ │ - ペイン分割: Prefix + [|/-]                             │ │
│ │ - セッション: Prefix + [s/d]                             │ │
│ │                                                          │ │
│ │ ┌────────────────────────────────────────────────────┐  │ │
│ │ │ Neovim (最内層)                                     │  │ │
│ │ │ - Leader: Space                                     │  │ │
│ │ │ - ファイル操作: Leader + f[f/g/b/r]                │  │ │
│ │ │ - Git操作: Leader + g[s/c/p/b]                     │  │ │
│ │ │ - LSP: gd/gr/K/Leader+[ca/rn/f]                    │  │ │
│ │ │ - ウィンドウ: Leader + [s/w][v/h/e/x]              │  │ │
│ │ └────────────────────────────────────────────────────┘  │ │
│ └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘

統合ナビゲーション: Ctrl+h/j/k/l (全レイヤーで共通)
```

---

## 🖥️ WezTerm キーバインディング

### 基本設定

```lua
-- ~/.config/wezterm/wezterm.lua

local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- ========================================
-- OS検出
-- ========================================
local is_macos = wezterm.target_triple:find("apple") ~= nil
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil

-- OS別のモディファイアキー設定
-- macOS: Command, Windows/Linux: Ctrl
local tab_mod = is_macos and "CMD" or "CTRL"
local tab_mod_shift = is_macos and "CMD|SHIFT" or "CTRL|SHIFT"

-- Leaderキーの設定（Tmuxと競合しないように）
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  -- ========================================
  -- タブ管理（macOS: Cmd, Windows/Linux: Ctrl）
  -- ========================================
  
  -- 新規タブ
  { key = "t", mods = tab_mod, action = act.SpawnTab("CurrentPaneDomain") },
  
  -- タブを閉じる
  { key = "w", mods = tab_mod, action = act.CloseCurrentTab({ confirm = true }) },
  
  -- タブ切り替え（数字）
  { key = "1", mods = tab_mod, action = act.ActivateTab(0) },
  { key = "2", mods = tab_mod, action = act.ActivateTab(1) },
  { key = "3", mods = tab_mod, action = act.ActivateTab(2) },
  { key = "4", mods = tab_mod, action = act.ActivateTab(3) },
  { key = "5", mods = tab_mod, action = act.ActivateTab(4) },
  { key = "6", mods = tab_mod, action = act.ActivateTab(5) },
  { key = "7", mods = tab_mod, action = act.ActivateTab(6) },
  { key = "8", mods = tab_mod, action = act.ActivateTab(7) },
  { key = "9", mods = tab_mod, action = act.ActivateTab(-1) },
  
  -- タブ移動
  { key = "Tab", mods = tab_mod, action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = tab_mod_shift, action = act.ActivateTabRelative(-1) },
  
  -- タブの順序変更
  { key = "PageUp", mods = tab_mod_shift, action = act.MoveTabRelative(-1) },
  { key = "PageDown", mods = tab_mod_shift, action = act.MoveTabRelative(1) },
  
  -- ========================================
  -- ペイン管理
  -- ========================================
  
  -- ペイン分割
  { key = "|", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "_", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  
  -- ペインを閉じる
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  
  -- ペインズーム
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  
  -- ペインリサイズモード
  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "resize_pane",
      one_shot = false,
    }),
  },
  
  -- ========================================
  -- ナビゲーション（Tmux/Neovim統合）
  -- ========================================
  
  -- Ctrl+h/j/k/l でペイン移動（Tmux/Neovimと統合）
  { key = "h", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "CTRL", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "CTRL", action = act.ActivatePaneDirection("Right") },
  
  -- ========================================
  -- コピーモード
  -- ========================================
  
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "v", mods = "LEADER", action = act.ActivateCopyMode },
  
  -- ========================================
  -- その他
  -- ========================================
  
  -- 設定リロード
  { key = "r", mods = tab_mod_shift, action = act.ReloadConfiguration },
  
  -- コマンドパレット
  { key = "p", mods = tab_mod_shift, action = act.ActivateCommandPalette },
  
  -- デバッグオーバーレイ（開発用）
  { key = "l", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },
  
  -- フォントサイズ（macOS: Cmd+/-/0, Windows/Linux: Ctrl+/-/0）
  { key = "+", mods = tab_mod, action = act.IncreaseFontSize },
  { key = "=", mods = tab_mod, action = act.IncreaseFontSize }, -- Shift不要版
  { key = "-", mods = tab_mod, action = act.DecreaseFontSize },
  { key = "0", mods = tab_mod, action = act.ResetFontSize },
  
  -- 検索
  { key = "f", mods = tab_mod, action = act.Search("CurrentSelectionOrEmptyString") },
}

-- ========================================
-- キーテーブル（モード）
-- ========================================

config.key_tables = {
  -- ペインリサイズモード
  resize_pane = {
    { key = "h", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 5 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 5 }) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter", action = "PopKeyTable" },
  },
  
  -- コピーモード
  copy_mode = {
    { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
    { key = "q", mods = "NONE", action = act.CopyMode("Close") },
    
    -- 移動
    { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
    { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
    { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
    { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
    
    -- 単語移動
    { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
    { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
    
    -- 行移動
    { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
    { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
    
    -- ページ移動
    { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
    { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
    { key = "d", mods = "CTRL", action = act.CopyMode("PageDown") },
    { key = "u", mods = "CTRL", action = act.CopyMode("PageUp") },
    
    -- 選択
    { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
    { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
    { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
    
    -- コピー
    { key = "y", mods = "NONE", action = act.Multiple({
      { CopyTo = "ClipboardAndPrimarySelection" },
      { CopyMode = "Close" },
    })},
  },
}

return config
```

### WezTerm キーバインド一覧

> **💡 OS別のキー**: macOSは`Cmd`、Windows/Linuxは`Ctrl`を使用

| カテゴリ | キー (macOS) | キー (Win/Linux) | 動作 |
|---------|-------------|-----------------|------|
| **タブ管理** |
| | `Cmd+T` | `Ctrl+T` | 新規タブ |
| | `Cmd+W` | `Ctrl+W` | タブを閉じる |
| | `Cmd+[1-9]` | `Ctrl+[1-9]` | タブ切り替え |
| | `Cmd+Tab` | `Ctrl+Tab` | 次のタブ |
| | `Cmd+Shift+Tab` | `Ctrl+Shift+Tab` | 前のタブ |
| | `Cmd+Shift+PageUp/Down` | `Ctrl+Shift+PageUp/Down` | タブ順序変更 |
| **ペイン管理** |
| | `Ctrl+Shift+\|` | 垂直分割 |
| | `Ctrl+Shift+_` | 水平分割 |
| | `Leader x` | ペインを閉じる |
| | `Leader z` | ペインズーム |
| | `Leader r` | リサイズモード |
| **ナビゲーション** |
| | `Ctrl+h/j/k/l` | ペイン移動 |
| **コピーモード** |
| | `Leader [` または `Leader v` | `Leader [` または `Leader v` | コピーモード開始 |
| | `v` | `v` | 選択開始 |
| | `V` | `V` | 行選択 |
| | `Ctrl+v` | `Ctrl+v` | 矩形選択 |
| | `y` | `y` | コピーして終了 |
| | `Esc` または `q` | `Esc` または `q` | コピーモード終了 |
| **その他** |
| | `Cmd+Shift+R` | `Ctrl+Shift+R` | 設定リロード |
| | `Cmd+Shift+P` | `Ctrl+Shift+P` | コマンドパレット |
| | `Cmd+F` | `Ctrl+F` | 検索 |
| | `Cmd++/-/0` | `Ctrl++/-/0` | フォントサイズ調整 |

---

## 🪟 Tmux キーバインディング

### 基本設定

```bash
# ~/.tmux.conf

# ========================================
# Prefix設定
# ========================================

# Prefixキーを Ctrl+A に変更
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# ========================================
# 基本設定
# ========================================

# マウス操作有効化
set -g mouse on

# ウィンドウ番号を1から開始
set -g base-index 1
setw -g pane-base-index 1

# ウィンドウ番号を詰める
set -g renumber-windows on

# エスケープ遅延なし（Neovim用）
set -sg escape-time 0

# 履歴行数
set -g history-limit 50000

# ステータス更新間隔
set -g status-interval 5

# フォーカスイベント有効化
set -g focus-events on

# True color対応
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# クリップボード統合
set -g set-clipboard on

# ========================================
# キーバインディング
# ========================================

# 設定リロード
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# ========================================
# ペイン分割
# ========================================

# 垂直分割（|）
bind | split-window -h -c "#{pane_current_path}"

# 水平分割（-）
bind - split-window -v -c "#{pane_current_path}"

# デフォルトのキーを無効化
unbind '"'
unbind %

# ========================================
# ペイン移動（vim-tmux-navigator統合）
# ========================================

# Ctrl+h/j/k/l でNeovimとシームレスに移動
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

bind -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"

# Ctrl+\ で前のペインへ
bind -n 'C-\' if-shell "$is_vim" "send-keys 'C-\\'" "select-pane -l"

# Prefixモードでも移動可能
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Ctrl+Lでクリア（上書きされるため再設定）
bind C-l send-keys 'C-l'

# ========================================
# ペインリサイズ
# ========================================

bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# ========================================
# ペイン操作
# ========================================

# ペイン操作
bind x kill-pane
bind z resize-pane -Z
bind q display-panes
bind Space next-layout

# ========================================
# ウィンドウ管理
# ========================================

# 新規ウィンドウ（カレントディレクトリで）
bind c new-window -c "#{pane_current_path}"

# ウィンドウ移動
bind n next-window
bind p previous-window

# ウィンドウ番号で移動（Prefix + 数字）
bind 0 select-window -t :=0
bind 1 select-window -t :=1
bind 2 select-window -t :=2
bind 3 select-window -t :=3
bind 4 select-window -t :=4
bind 5 select-window -t :=5
bind 6 select-window -t :=6
bind 7 select-window -t :=7
bind 8 select-window -t :=8
bind 9 select-window -t :=9

# ウィンドウを閉じる
bind & kill-window

# ウィンドウ一覧
bind w choose-window

# ウィンドウ名変更
bind , command-prompt -I "#W" "rename-window '%%'"

# ========================================
# セッション管理
# ========================================

# セッション一覧
bind s choose-session

# デタッチ
bind d detach-client

# セッション名変更
bind '$' command-prompt -I "#S" "rename-session '%%'"

# ========================================
# コピーモード（vi風）
# ========================================

# コピーモード設定
setw -g mode-keys vi

# コピーモード開始
bind [ copy-mode

# ペースト
bind ] paste-buffer

# コピーモード内のキーバインド
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi V send -X select-line
bind -T copy-mode-vi C-v send -X rectangle-toggle
bind -T copy-mode-vi y send -X copy-selection-and-cancel
bind -T copy-mode-vi Y send -X copy-line

# マウスドラッグでコピー
bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-selection-and-cancel

```

### Tmux キーバインド一覧

| カテゴリ | キー | 動作 | 覚え方 |
|---------|------|------|--------|
| **Prefix** | `Ctrl+A` | Prefixキー | - |
| **基本操作** |
| | `Prefix r` | 設定リロード | Reload |
| | `Prefix d` | デタッチ | Detach |
| | `Prefix ?` | キーバインド一覧 | (デフォルト) |
| | `Prefix :` | コマンドプロンプト | (デフォルト) |
| **ペイン分割** |
| | `Prefix \|` | 垂直分割 | `\|`の形 |
| | `Prefix -` | 水平分割 | `-`の形 |
| **ペイン移動** |
| | `Ctrl+h/j/k/l` | ペイン移動（Neovim統合） | Vim風 |
| | `Prefix h/j/k/l` | ペイン移動 | Vim風 |
| | `Prefix q` | ペイン番号表示 | Quick |
| **ペインリサイズ** |
| | `Prefix H/J/K/L` | リサイズ（繰り返し可） | 大文字 |
| **ペイン操作** |
| | `Prefix x` | ペインを閉じる | eXit |
| | `Prefix z` | ペインズーム | Zoom |
| | `Prefix Space` | レイアウト変更 | - |
| **ウィンドウ管理** |
| | `Prefix c` | 新規ウィンドウ | Create |
| | `Prefix n` | 次のウィンドウ | Next |
| | `Prefix p` | 前のウィンドウ | Previous |
| | `Prefix w` | ウィンドウ一覧 | Window |
| | `Prefix ,` | ウィンドウ名変更 | - |
| | `Prefix &` | ウィンドウを閉じる | - |
| | `Prefix [0-9]` | ウィンドウ番号で移動 | - |
| **セッション管理** |
| | `Prefix s` | セッション一覧 | Session |
| | `Prefix $` | セッション名変更 | - |
| **コピーモード** |
| | `Prefix [` | コピーモード開始 | - |
| | `v` (コピーモード内) | 選択開始 | Vim風 |
| | `V` (コピーモード内) | 行選択 | Vim風 |
| | `Ctrl+v` (コピーモード内) | 矩形選択 | Vim風 |
| | `y` (コピーモード内) | コピーして終了 | Yank |
| | `Prefix ]` | ペースト | - |

---

## 📝 Neovim キーバインディング

### 基本設定

```lua
-- ~/.config/nvim/lua/config/keymaps.lua

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ========================================
-- Leader キー設定
-- ========================================

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- ========================================
-- 基本操作
-- ========================================

-- 保存
keymap("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
keymap("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- 終了
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>q!<cr>", { desc = "Force quit" })

-- 全て保存して終了
keymap("n", "<leader>x", "<cmd>xa<cr>", { desc = "Save all and quit" })

-- インサートモード脱出
keymap("i", "jk", "<Esc>", { desc = "Exit insert mode" })
keymap("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- ========================================
-- クリップボード
-- ========================================

-- システムクリップボードへヤンク
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
keymap("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- システムクリップボードからペースト
keymap({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
keymap({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste before from system clipboard" })

-- 削除時にレジスタを汚さない
keymap({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- ========================================
-- ナビゲーション
-- ========================================

-- スクロール（画面中央維持）
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

-- 検索結果移動（画面中央維持）
keymap("n", "n", "nzzzv", { desc = "Next search result" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result" })

-- 行頭・行末
keymap({ "n", "v" }, "H", "^", { desc = "Go to line start" })
keymap({ "n", "v" }, "L", "$", { desc = "Go to line end" })

-- ========================================
-- ウィンドウ移動（Tmux統合）
-- ========================================

-- vim-tmux-navigatorを使用
-- Ctrl+h/j/k/l でNeovim/Tmux間をシームレスに移動
keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate left" })
keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate down" })
keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate up" })
keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate right" })
keymap("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "Navigate previous" })

-- ========================================
-- ウィンドウ管理
-- ========================================

-- ウィンドウ分割
keymap("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split vertically" })
keymap("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equal window size" })
keymap("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close window" })

-- ウィンドウリサイズ
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

-- ========================================
-- バッファ管理
-- ========================================

-- バッファ切り替え
keymap("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- バッファを閉じる
keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
keymap("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Force delete buffer" })

-- 他のバッファを全て閉じる
keymap("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete other buffers" })

-- ========================================
-- テキスト編集
-- ========================================

-- インデント（ビジュアルモードで連続可能）
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- 行移動
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- 行複製
keymap("n", "<leader>j", "<cmd>t.<cr>", { desc = "Duplicate line down" })
keymap("n", "<leader>k", "<cmd>t.-1<cr>", { desc = "Duplicate line up" })

-- 検索ハイライト解除
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
keymap("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- ========================================
-- ファイル・検索（Telescope）
-- ========================================

keymap("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Commands" })
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
keymap("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find word under cursor" })

-- ========================================
-- ファイルツリー（nvim-tree）
-- ========================================

keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
keymap("n", "<leader>o", "<cmd>NvimTreeFocus<cr>", { desc = "Focus file tree" })

-- ========================================
-- LSP
-- ========================================

-- 定義・参照
keymap("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
keymap("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
keymap("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
keymap("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })

-- ホバー・シグネチャ
keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
keymap("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
keymap("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })

-- コードアクション
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
keymap("v", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- リネーム
keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })

-- フォーマット
keymap("n", "<leader>f", vim.lsp.buf.format, { desc = "Format" })
keymap("v", "<leader>f", vim.lsp.buf.format, { desc = "Format selection" })

-- 診断
keymap("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", { desc = "List diagnostics" })

-- ========================================
-- Git（Gitsigns）
-- ========================================

-- Git status/commits/branches（Telescope）
keymap("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })

-- Hunk操作（Gitsignsで設定）
keymap("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next hunk" })
keymap("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous hunk" })
keymap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
keymap("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
keymap("n", "<leader>gS", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
keymap("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo stage hunk" })
keymap("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Reset buffer" })
keymap("n", "<leader>gB", "<cmd>Gitsigns blame_line<cr>", { desc = "Blame line" })
keymap("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff this" })

-- ========================================
-- ターミナル（Toggleterm）
-- ========================================

keymap("n", "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
keymap("t", "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float terminal" })
keymap("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
keymap("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Vertical terminal" })

-- ========================================
-- その他
-- ========================================

-- コメント（Comment.nvim）
-- gc: ノーマル/ビジュアルモードでコメントトグル
-- gb: ブロックコメントトグル

-- 診断（Trouble）
keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
keymap("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
keymap("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
keymap("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })

-- lazy.nvim
keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
keymap("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "Lazy update" })
keymap("n", "<leader>ls", "<cmd>Lazy sync<cr>", { desc = "Lazy sync" })
```

### Neovim キーバインド一覧

| カテゴリ | キー | 動作 |
|---------|------|------|
| **Leader** | `Space` | Leader キー |
| **基本操作** |
| | `Ctrl+S` | 保存 |
| | `<leader>w` | 保存 |
| | `<leader>q` | 終了 |
| | `<leader>Q` | 強制終了 |
| | `<leader>x` | 全て保存して終了 |
| | `jk` または `jj` | インサートモード脱出 |
| **クリップボード** |
| | `<leader>y` | システムクリップボードへヤンク |
| | `<leader>p` | システムクリップボードからペースト |
| | `<leader>d` | 削除（レジスタを汚さない） |
| **ナビゲーション** |
| | `Ctrl+d/u` | 半ページスクロール（中央維持） |
| | `n/N` | 検索結果移動（中央維持） |
| | `H/L` | 行頭/行末 |
| **ウィンドウ移動** |
| | `Ctrl+h/j/k/l` | ウィンドウ/ペイン移動（Tmux統合） |
| **ウィンドウ管理** |
| | `<leader>sv` | 垂直分割 |
| | `<leader>sh` | 水平分割 |
| | `<leader>se` | サイズ均等化 |
| | `<leader>sx` | ウィンドウを閉じる |
| | `Ctrl+矢印` | ウィンドウリサイズ |
| **バッファ管理** |
| | `Tab` | 次のバッファ |
| | `Shift+Tab` | 前のバッファ |
| | `<leader>bd` | バッファを閉じる |
| | `<leader>bo` | 他のバッファを全て閉じる |
| **テキスト編集** |
| | `</>` (ビジュアル) | インデント |
| | `Alt+j/k` | 行移動 |
| | `<leader>j/k` | 行複製 |
| | `Esc` または `<leader>h` | 検索ハイライト解除 |
| **ファイル・検索** |
| | `<leader><leader>` | ファイル検索 |
| | `<leader>ff` | ファイル検索 |
| | `<leader>fg` | テキスト検索 |
| | `<leader>fb` | バッファ検索 |
| | `<leader>fr` | 最近のファイル |
| | `<leader>fh` | ヘルプ検索 |
| | `<leader>fc` | コマンド検索 |
| | `<leader>fk` | キーマップ検索 |
| | `<leader>fw` | カーソル下の単語を検索 |
| **ファイルツリー** |
| | `<leader>e` | ファイルツリートグル |
| | `<leader>o` | ファイルツリーにフォーカス |
| **LSP** |
| | `gd` | 定義へジャンプ |
| | `gD` | 宣言へジャンプ |
| | `gi` | 実装へジャンプ |
| | `gr` | 参照検索 |
| | `gt` | 型定義へジャンプ |
| | `K` | ホバー情報 |
| | `Ctrl+K` | シグネチャヘルプ |
| | `<leader>ca` | コードアクション |
| | `<leader>rn` | リネーム |
| | `<leader>f` | フォーマット |
| | `<leader>d` | 診断表示 |
| | `[d` / `]d` | 前/次の診断 |
| | `<leader>dl` | 診断一覧 |
| **Git** |
| | `<leader>gs` | Git status |
| | `<leader>gc` | Git commits |
| | `<leader>gb` | Git branches |
| | `[h` / `]h` | 前/次のHunk |
| | `<leader>gp` | Hunkプレビュー |
| | `<leader>gr` | Hunkリセット |
| | `<leader>gS` | Hunkステージ |
| | `<leader>gu` | Hunkステージ取り消し |
| | `<leader>gB` | Blame表示 |
| | `<leader>gd` | Diff表示 |
| **ターミナル** |
| | `Ctrl+\` | ターミナルトグル |
| | `<leader>tf` | フローティングターミナル |
| | `<leader>th` | 水平ターミナル |
| | `<leader>tv` | 垂直ターミナル |
| | `Esc` (ターミナル内) | ノーマルモードへ |
| **その他** |
| | `gc` | コメントトグル |
| | `gb` | ブロックコメントトグル |
| | `<leader>xx` | 診断一覧（Trouble） |
| | `<leader>l` | Lazy UI |
| | `<leader>lu` | Lazy update |

---

## 🔄 統合ナビゲーション

### Ctrl+h/j/k/l の動作フロー

```
キー入力: Ctrl+h
    ↓
WezTermがキャッチ
    ↓
Tmuxペインが存在？
    ├─ Yes → Tmuxへ転送
    │         ↓
    │    Neovimが実行中？
    │         ├─ Yes → Neovimへ転送
    │         │         ↓
    │         │    Neovimウィンドウが存在？
    │         │         ├─ Yes → Neovimウィンドウ移動
    │         │         └─ No  → Tmuxペイン移動
    │         └─ No  → Tmuxペイン移動
    └─ No  → WezTermペイン移動
```

### 設定の優先順位

1. **WezTerm**: 最外層、タブ・ペイン管理
2. **Tmux**: 中間層、セッション・ウィンドウ・ペイン管理
3. **Neovim**: 最内層、エディタ内のウィンドウ管理

---

## 📚 クイックリファレンス

### よく使うキーバインド Top 20

| 順位 | キー | 動作 | レイヤー |
|-----|------|------|---------|
| 1 | `Ctrl+h/j/k/l` | ペイン/ウィンドウ移動 | 全て |
| 2 | `<leader>ff` | ファイル検索 | Neovim |
| 3 | `<leader>fg` | テキスト検索 | Neovim |
| 4 | `Ctrl+S` | 保存 | Neovim |
| 5 | `gd` | 定義へジャンプ | Neovim |
| 6 | `<leader>e` | ファイルツリー | Neovim |
| 7 | `Prefix \|` | 垂直分割 | Tmux |
| 8 | `Prefix -` | 水平分割 | Tmux |
| 9 | `<leader>gs` | Git status | Neovim |
| 10 | `K` | ホバー情報 | Neovim |
| 11 | `Tab` / `Shift+Tab` | バッファ切り替え | Neovim |
| 12 | `<leader>ca` | コードアクション | Neovim |
| 13 | `Prefix c` | 新規ウィンドウ | Tmux |
| 14 | `Prefix s` | セッション一覧 | Tmux |
| 15 | `Ctrl+\` | ターミナルトグル | Neovim |
| 16 | `<leader>rn` | リネーム | Neovim |
| 17 | `gc` | コメントトグル | Neovim |
| 18 | `Prefix z` | ペインズーム | Tmux |
| 19 | `[d` / `]d` | 診断移動 | Neovim |
| 20 | `Cmd/Ctrl+T` | 新規タブ | WezTerm |

---

## 🎓 学習のヒント

### 段階的な習得

**Week 1: 基本ナビゲーション**
- `Ctrl+h/j/k/l` でペイン移動
- `Prefix |/-` でペイン分割
- `<leader>ff` でファイル検索

**Week 2: エディタ操作**
- `gd/gr` でコード移動
- `<leader>ca` でコードアクション
- `gc` でコメント

**Week 3: Git統合**
- `<leader>gs` でGit status
- `]h/[h` でHunk移動
- `<leader>gp` でHunkプレビュー

**Week 4: 高度な機能**
- Tmuxセッション管理
- WezTermタブ管理
- カスタムキーバインド追加

### 練習方法

1. **チートシートを印刷**: 手元に置いて参照
2. **1日3個**: 新しいキーバインドを覚える
3. **実際のプロジェクトで使用**: 実践が最良の学習
4. **カスタマイズ**: 自分に合わせて調整

---

## 🚀 クイック起動コマンド

### dev コマンド

Neovim + Tmuxを一発で起動するコマンド。Claude Codeとの併用を考慮した複数のレイアウトを提供。

#### 基本的な使い方

```bash
# カレントディレクトリで起動
dev

# セッション名を指定
dev myproject

# ディレクトリを指定
dev myproject ~/code/myapp

# レイアウトを指定
dev --layout claude    # Claude Code併用（デフォルト）
dev --layout split     # 分割レイアウト
dev --layout full      # フルスクリーン
```

#### レイアウト

**claude（デフォルト）**: Claude Code併用レイアウト
```
┌──────────┬──────┐
│          │ Git  │
│ Neovim   ├──────┤
│ (60%)    │ Term │
└──────────┴──────┘
```

**split**: エディタ + ターミナル分割
```
┌─────────────────┐
│ Neovim (70%)    │
├─────────────────┤
│ Terminal (30%)  │
└─────────────────┘
```

**full**: エディタフルスクリーン
```
┌─────────────────┐
│                 │
│ Neovim (100%)   │
│                 │
└─────────────────┘
```

#### インストール

```bash
# スクリプトをダウンロード（dotfilesリポジトリから）
cp scripts/dev ~/.local/bin/dev
chmod +x ~/.local/bin/dev

# または手動作成
# 詳細は docs/requirements/neovim-tmux-claude-parallel-dev.md を参照
```

#### Claude Code併用のワークフロー

1. **WezTermで2タブ構成**
   - タブ1: `dev --layout claude` でNeovim起動
   - タブ2: `cursor .` でClaude Code起動

2. **OS標準のウィンドウ分割**
   - 左半分: WezTerm (Neovim + Tmux)
   - 右半分: Claude Code

3. **外部モニター使用時**
   - モニター1: WezTerm (フルスクリーン)
   - モニター2: Claude Code (フルスクリーン)

---

## 🔧 カスタマイズガイド

### 自分用のキーバインドを追加

**Neovim**
```lua
-- ~/.config/nvim/lua/config/keymaps.lua
keymap("n", "<leader>custom", "<cmd>YourCommand<cr>", { desc = "Your description" })
```

**Tmux**
```bash
# ~/.tmux.conf
bind custom-key your-command
```

**WezTerm**
```lua
-- ~/.config/wezterm/wezterm.lua
{ key = "key", mods = "MODS", action = act.YourAction }
```

---

**このドキュメントは随時更新されます。新しいキーバインドを追加したら、このファイルも更新してください。**
