# Neovim + Tmux セットアップガイド

## 📋 概要

このガイドでは、Neovim + Tmux + Claude Code並列開発環境のセットアップ方法を説明します。

## 🎯 前提条件

### 必須

- **Git**: バージョン管理
- **Bash/Zsh**: シェル
- **インターネット接続**: パッケージダウンロード用

### 推奨

- **Nerd Font**: アイコン表示用（JetBrains Mono Nerd Font推奨）
- **WezTerm**: ターミナルエミュレータ
- **ripgrep, fd, fzf**: 検索ツール

## 🚀 クイックスタート

### 1. 自動セットアップ（推奨）

```bash
cd ~/development/dotfiles
./scripts/install-neovim-tmux.sh
```

このスクリプトは以下を実行します：
- Neovim、Tmuxのインストール
- 必要なツール（ripgrep, fd, fzf等）のインストール
- 設定ファイルのシンボリックリンク作成
- プラグインの自動インストール
- devコマンドのインストール

### 2. 手動セットアップ

#### Step 1: Neovimのインストール

**macOS:**
```bash
brew install neovim
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install neovim
```

**Linux (Arch):**
```bash
sudo pacman -S neovim
```

#### Step 2: Tmuxのインストール

**macOS:**
```bash
brew install tmux
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install tmux
```

**Linux (Arch):**
```bash
sudo pacman -S tmux
```

#### Step 3: 必要なツールのインストール

**macOS:**
```bash
brew install ripgrep fd fzf lazygit git-delta bat eza
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install ripgrep fd-find fzf
```

#### Step 4: 設定ファイルのリンク

```bash
# Neovim
mkdir -p ~/.config
ln -sf ~/development/dotfiles/nvim/.config/nvim ~/.config/nvim

# Tmux
ln -sf ~/development/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# TPMのインストール
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# devコマンド
mkdir -p ~/.local/bin
cp ~/development/dotfiles/scripts/dev ~/.local/bin/dev
chmod +x ~/.local/bin/dev
```

#### Step 5: PATHの設定

```bash
# ~/.zshrc または ~/.bashrc に追加
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

#### Step 6: プラグインのインストール

**Neovim:**
```bash
# 初回起動時に自動インストールされます
nvim

# または手動で
nvim --headless "+Lazy! sync" +qa
```

**Tmux:**
```bash
# Tmuxを起動
tmux

# Prefix (Ctrl+A) + I でプラグインをインストール
# Ctrl+A を押してから I を押す
```

## ✅ セットアップの確認

### 1. Neovimの確認

```bash
# バージョン確認
nvim --version

# Health check
nvim
:checkhealth

# Lazy UI
:Lazy

# LSPサーバーの確認
:Mason
```

### 2. Tmuxの確認

```bash
# バージョン確認
tmux -V

# Tmux起動
tmux

# プラグイン一覧
# Prefix (Ctrl+A) + ?
```

### 3. 統合ナビゲーションの確認

```bash
# 1. Tmuxを起動
tmux

# 2. ペインを分割
# Prefix (Ctrl+A) + |

# 3. Neovimを起動
nvim

# 4. Neovimでウィンドウを分割
# :vsplit

# 5. Ctrl+h/j/k/l でシームレスに移動できることを確認
```

## 🎨 カラースキームの設定

### Neovim

デフォルトでTokyo Night Nightが設定されています。

```vim
" カラースキーム変更
:colorscheme tokyonight

" 利用可能なカラースキーム一覧
:Telescope colorscheme
" または
<leader>cs
```

### WezTerm

`wezterm/.config/wezterm/wezterm.lua`でNeovimと統合されています。

詳細は [docs/colorscheme-integration.md](colorscheme-integration.md) を参照。

## 🔑 基本的な使い方

### devコマンド

```bash
# カレントディレクトリで起動
dev

# レイアウト指定
dev --layout claude    # Claude Code併用（デフォルト）
dev --layout split     # エディタ + ターミナル分割
dev --layout full      # フルスクリーン

# ヘルプ
dev --help
```

### Neovim

```vim
" ファイル検索
<leader>ff

" テキスト検索
<leader>fg

" ファイルツリー
<leader>e

" Git status
<leader>gs

" LSP: 定義へジャンプ
gd

" LSP: ホバー情報
K

" LSP: コードアクション
<leader>ca

" 設定リロード
<leader>R
```

### Tmux

```bash
# ペイン分割
Prefix |    # 垂直分割
Prefix -    # 水平分割

# ペイン移動
Ctrl+h/j/k/l    # Neovimと統合

# 新規ウィンドウ
Prefix c

# セッション一覧
Prefix s

# デタッチ
Prefix d
```

## 🐛 トラブルシューティング

### Neovimが起動しない

```bash
# エラーメッセージを確認
nvim

# Health check
nvim
:checkhealth

# ログを確認
tail -f ~/.local/state/nvim/log
```

### プラグインがインストールされない

```vim
" Lazy UI を開く
:Lazy

" 同期
:Lazy sync

" ログを確認
:Lazy log
```

### LSPが動作しない

```vim
" LSP情報を確認
:LspInfo

" Mason UI を開く
:Mason

" LSPサーバーを手動インストール
:MasonInstall lua-language-server
:MasonInstall typescript-language-server
```

### Tmuxプラグインがインストールされない

```bash
# TPMが存在するか確認
ls ~/.tmux/plugins/tpm

# 手動でインストール
~/.tmux/plugins/tpm/bin/install_plugins

# Tmux内で
# Prefix (Ctrl+A) + I
```

### Ctrl+h/j/k/lが動作しない

**Neovim側:**
```vim
" vim-tmux-navigatorがインストールされているか確認
:Lazy

" プラグインをリロード
:Lazy reload vim-tmux-navigator
```

**Tmux側:**
```bash
# 設定を確認
cat ~/.tmux.conf | grep "is_vim"

# 設定をリロード
# Prefix (Ctrl+A) + r
```

### カラーが正しく表示されない

```bash
# True colorが有効か確認
echo $COLORTERM  # "truecolor" と表示されるべき

# 環境変数を設定
export COLORTERM=truecolor

# ~/.zshrc に追加
echo 'export COLORTERM=truecolor' >> ~/.zshrc
```

## 📚 次のステップ

### 1. キーバインドを覚える

[docs/keybindings.md](keybindings.md) のチートシートを参照

**Week 1の必須キー:**
- `Ctrl+h/j/k/l` - 移動
- `<leader>ff` - ファイル検索
- `Ctrl+S` - 保存
- `gd` - 定義ジャンプ
- `Prefix |/-` - ペイン分割

### 2. カスタマイズ

設定ファイルを編集：
- `~/.config/nvim/lua/config/options.lua` - オプション
- `~/.config/nvim/lua/config/keymaps.lua` - キーマップ
- `~/.config/nvim/lua/plugins/` - プラグイン設定
- `~/.tmux.conf` - Tmux設定

### 3. 言語サポートの追加

```vim
" LSPサーバーをインストール
:Mason

" 使用したい言語のLSPサーバーを選択してインストール
" 例: Python
:MasonInstall pyright black isort

" 例: Rust
:MasonInstall rust-analyzer rustfmt

" 例: Go
:MasonInstall gopls gofmt goimports
```

### 4. Claude Codeとの併用

```bash
# 1. Neovim + Tmuxを起動
dev --layout claude

# 2. 別タブでClaude Code起動
# Cmd/Ctrl+T で新規タブ
cursor .

# 3. 作業開始
# - Neovim: 設定ファイル、スクリプト編集
# - Claude Code: 新機能開発、リファクタリング
```

## 📖 関連ドキュメント

- [キーバインディングガイド](keybindings.md)
- [要件定義](requirements/neovim-tmux-claude-parallel-dev.md)
- [カラースキーム統合](colorscheme-integration.md)

---

**最終更新:** 2026-01-11
