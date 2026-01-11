# Dotfiles

<div align="center">

**🚀 Neovim + Tmux + Claude Code 並列開発環境**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey)]()

モダンで快適な開発環境を数分でセットアップ。  
15言語対応、統合ナビゲーション、AI開発との完璧な併用。

[クイックスタート](#-クイックスタート) • [機能](#-主な機能) • [ドキュメント](#-ドキュメント)

</div>

---

## 🎯 概要

このdotfilesプロジェクトは、Neovim + Tmux + Claude Codeを統合した並列開発環境を提供します。

| カテゴリ | ツール | 説明 |
|---------|--------|------|
| **エディタ** | [Neovim](https://neovim.io/) + [lazy.nvim](https://github.com/folke/lazy.nvim) | モダンなNeovim設定（LSP、15言語対応） |
| **マルチプレクサ** | [Tmux](https://github.com/tmux/tmux) | セッション管理、ペイン分割 |
| **ターミナル** | [WezTerm](https://wezfurlong.org/wezterm/) | GPU加速、統合ナビゲーション |
| **AI開発** | [Cursor](https://cursor.sh/) | Claude Code併用ワークフロー |
| **シェル** | [Zsh](https://www.zsh.org/) + [Starship](https://starship.rs/) | 高速で美しいシェル環境 |
| **フォント** | [Moralerspace](https://github.com/yuru7/moralerspace) | プログラミング向け日英混植フォント |

## ✨ 主な機能

### 🔄 統合ナビゲーション
- **`Ctrl+h/j/k/l`**: WezTerm → Tmux → Neovim間をシームレスに移動
- **vim-tmux-navigator**: 完全統合
- **一貫したキーバインディング**: 全レイヤーで統一

### 🌐 15言語サポート
- **Web**: JavaScript, TypeScript, React, Next.js, HTML, CSS
- **モバイル**: Dart, Flutter, Kotlin, Java, Swift
- **システム**: Rust, Go, C/C++
- **スクリプト**: Python, Ruby
- **その他**: Lua, Bash, JSON, YAML, Markdown

### 🎨 美しいUI/UX
- **Tokyo Night Night**: 3レイヤー統一カラースキーム
- **Neovim優先モード**: ターミナル色をNeovimが制御
- **透過設定**: WezTermの透過度とブラー効果

### ⚡ 高速な開発環境
- **lazy.nvim**: 遅延読み込みで高速起動
- **LSP統合**: 15言語のコード補完・診断
- **自動フォーマット**: 保存時に自動フォーマット
- **Linter統合**: リアルタイムコード検証

### 🤖 Claude Code併用
- **明確な使い分け**: Neovim（設定・スクリプト）、Claude Code（新機能開発）
- **最適化レイアウト**: Git + Terminal統合
- **devコマンド**: 一発起動

### 🔧 簡単な管理
- **自動セットアップ**: ワンコマンドでインストール
- **設定同期**: dotfiles ⇔ ローカルPC間を双方向同期
- **自動リロード**: 設定変更を即座に反映

## 📁 プロジェクト構造

```
dotfiles/
├── docs/                                    # 📚 ドキュメント
│   ├── requirements/
│   │   └── neovim-tmux-claude-parallel-dev.md  # 要件定義（3,700行）
│   ├── keybindings.md                       # キーバインドガイド（1,000行）
│   ├── colorscheme-integration.md           # カラースキーム統合
│   ├── setup-guide-neovim-tmux.md           # セットアップガイド
│   └── implementation-summary.md            # 実装サマリー
├── scripts/                                 # 🔧 セットアップスクリプト
│   ├── install-neovim-tmux.sh               # Neovim + Tmux自動セットアップ
│   ├── dev                                  # クイック起動コマンド
│   ├── sync.sh                              # 双方向同期
│   ├── clean.sh                             # クリーニング
│   └── restore.sh                           # 復元
├── nvim/.config/nvim/                       # 📝 Neovim設定
│   ├── init.lua                             # エントリーポイント
│   └── lua/
│       ├── config/                          # 基本設定
│       │   ├── options.lua                  # Neovimオプション
│       │   ├── lazy.lua                     # lazy.nvimブートストラップ
│       │   ├── keymaps.lua                  # キーマッピング
│       │   └── autocmds.lua                 # 自動コマンド
│       └── plugins/                         # プラグイン設定（11ファイル）
│           ├── colorscheme.lua              # Tokyo Night Night
│           ├── treesitter.lua               # シンタックスハイライト
│           ├── lsp.lua                      # LSP設定（15言語）
│           ├── completion.lua               # 補完（nvim-cmp）
│           ├── telescope.lua                # ファジーファインダー
│           ├── git.lua                      # Git統合
│           ├── ui.lua                       # UI拡張
│           ├── editor.lua                   # エディター拡張
│           ├── languages.lua                # 言語別プラグイン
│           ├── formatter.lua                # フォーマッター
│           └── linter.lua                   # Linter
├── tmux/                                    # 🖥️ Tmux設定
│   └── .tmux.conf                           # Tokyo Night、vim-tmux-navigator統合
├── wezterm/.config/wezterm/                 # 🖥️ WezTerm設定
│   └── wezterm.lua                          # OS別キーバインド、カラー統合
├── zsh/                                     # 🐚 Zsh設定
│   ├── zshrc                                # メイン設定
│   ├── zshenv                               # 環境変数
│   ├── zprofile                             # PATH設定
│   └── sheldon/plugins.toml                 # プラグイン管理
├── starship/.config/                        # ⭐ Starship設定
│   └── starship.toml                        # プロンプト設定
└── npm/                                     # 📦 npm設定
    └── npmrc                                # npm設定
```

## 🚀 クイックスタート

### 前提条件

| 必須 | ツール | 説明 |
|------|--------|------|
| ✅ | Git | バージョン管理 |
| ✅ | Bash/Zsh | シェル |
| ✅ | インターネット接続 | パッケージダウンロード |
| 推奨 | [Nerd Font](https://www.nerdfonts.com/) | アイコン表示（JetBrains Mono推奨） |
| 推奨 | [WezTerm](https://wezfurlong.org/wezterm/) | ターミナルエミュレータ |

### インストール

```bash
# 1. リポジトリをクローン
git clone https://github.com/your-repo/dotfiles.git ~/development/dotfiles
cd ~/development/dotfiles

# 2. Neovim + Tmux自動セットアップ（推奨）
./scripts/install-neovim-tmux.sh

# 3. シェルを再起動
exec $SHELL

# 4. 開発環境を起動
dev

# 5. Neovimでhealth checkを実行
nvim
:checkhealth
```

### 初回起動時の流れ

1. **Neovim起動**: lazy.nvimが自動的にプラグインをインストール（数分）
2. **LSPサーバー**: `:Mason`で必要な言語のLSPサーバーをインストール
3. **Tmuxプラグイン**: `Prefix (Ctrl+A) + I`でプラグインをインストール

## 🎮 使い方

### devコマンド

`dev`コマンドでNeovim + Tmuxを一発で起動できます。

```bash
# 基本起動（claudeレイアウトがデフォルト）
dev

# セッション名を指定
dev myproject

# ディレクトリを指定
dev myproject ~/code/myapp

# レイアウトを指定
dev --layout claude    # Claude Code併用（デフォルト）
dev --layout split     # エディタ + ターミナル分割
dev --layout full      # フルスクリーン

# ヘルプ表示
dev --help
```

### レイアウト

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

### Claude Code併用ワークフロー

```bash
# 1. Neovim + Tmuxを起動
dev

# 2. 別タブでClaude Code起動
# Cmd/Ctrl+T で新規タブ
cursor .

# 3. 作業開始
# - Neovim: 設定ファイル、スクリプト編集、Git操作
# - Claude Code: 新機能開発、リファクタリング
# - Git pane: 変更確認
# - Terminal pane: テスト実行、ビルド
```

### 基本的なキーバインド

**統合ナビゲーション:**
```
Ctrl+h/j/k/l    ペイン/ウィンドウ移動（全レイヤー）
```

**Neovim（Leader: Space）:**
```
<leader>ff      ファイル検索
<leader>fg      テキスト検索
<leader>e       ファイルツリー
<leader>gs      Git status
gd              定義ジャンプ
K               ホバー情報
<leader>ca      コードアクション
Ctrl+S          保存
```

**Tmux（Prefix: Ctrl+A）:**
```
Prefix |        垂直分割
Prefix -        水平分割
Prefix c        新規ウィンドウ
Prefix s        セッション一覧
Prefix d        デタッチ
```

**WezTerm（macOS: Cmd、Windows/Linux: Ctrl）:**
```
Cmd/Ctrl+T      新規タブ
Cmd/Ctrl+W      タブを閉じる
Cmd/Ctrl+[1-9]  タブ切り替え
```

詳細は [docs/keybindings.md](docs/keybindings.md) を参照してください。

## 🔄 設定の同期

dotfilesとローカルPC間で設定を同期できます。

### dotfilesからローカルPCに反映（Push）

```bash
# すべての設定を反映
./scripts/sync.sh push

# 個別に反映
./scripts/sync.sh push --terminal  # WezTerm設定のみ
./scripts/sync.sh push --shell     # シェル設定のみ
./scripts/sync.sh push --nvim      # Neovim設定のみ

# ドライランで確認
./scripts/sync.sh push --dry-run
```

### ローカルPCからdotfilesに取り込み（Pull）

```bash
# すべての設定を取り込み
./scripts/sync.sh pull

# 個別に取り込み
./scripts/sync.sh pull --nvim      # Neovim設定のみ
./scripts/sync.sh pull --terminal  # WezTerm設定のみ

# 取り込み後はコミット
git add .
git commit -m "Update configurations from local"
```

## 📦 含まれる設定

### Neovim

**コアプラグイン:**
- **lazy.nvim**: 高速プラグインマネージャー
- **Tokyo Night Night**: カラースキーム
- **nvim-treesitter**: シンタックスハイライト（15言語）
- **nvim-lspconfig**: LSP統合
- **mason.nvim**: LSPサーバー管理
- **nvim-cmp**: 補完エンジン
- **LuaSnip**: スニペット
- **telescope.nvim**: ファジーファインダー
- **gitsigns.nvim**: Git統合

**UI拡張:**
- **nvim-tree**: ファイルツリー
- **lualine**: ステータスライン
- **which-key**: キーバインドヘルプ
- **indent-blankline**: インデントガイド
- **dressing.nvim**: UI改善
- **nvim-notify**: 通知

**エディター拡張:**
- **Comment.nvim**: コメント
- **nvim-autopairs**: 括弧自動補完
- **mini.nvim**: surround, ai, splitjoin, move
- **nvim-ts-autotag**: HTMLタグ自動補完
- **trouble.nvim**: 診断一覧
- **toggleterm.nvim**: ターミナル統合
- **vim-tmux-navigator**: Tmux統合

**言語別プラグイン:**
- **TypeScript**: typescript-tools.nvim
- **Flutter**: flutter-tools.nvim
- **Rust**: rust-tools.nvim, crates.nvim
- **Go**: go.nvim
- **Python**: venv-selector.nvim
- **Java**: nvim-jdtls
- **Ruby**: vim-rails
- **Markdown**: markdown-preview.nvim

**フォーマッター・Linter:**
- **conform.nvim**: 自動フォーマット（15言語）
- **nvim-lint**: リアルタイムLint

### Tmux

- **Prefix**: `Ctrl+A`
- **vim-tmux-navigator**: Neovim統合
- **Tokyo Night Night**: カラースキーム
- **TPM**: プラグインマネージャー
- **tmux-resurrect**: セッション保存
- **tmux-continuum**: 自動保存
- **tmux-yank**: クリップボード統合

### WezTerm

- **GPU加速**: WebGPU、120 FPS
- **OS別キーバインド**: macOS（Cmd）、Windows/Linux（Ctrl）
- **カラー統合**: Neovim優先モード
- **透過設定**: 0.8透過度、macOSブラー効果
- **統合ナビゲーション**: `Ctrl+h/j/k/l`

### Zsh + Starship

- **高速起動**: Sheldon遅延読み込み
- **豊富なエイリアス**: Git、Docker、Kubernetes等
- **便利な関数**: mkcd、extract、fcd、fv、fgb等
- **美しいプロンプト**: Git統合、言語バージョン表示

## 📚 ドキュメント

詳細なドキュメントは`docs/`ディレクトリを参照してください：

| ドキュメント | 説明 | 行数 |
|-------------|------|------|
| [要件定義](docs/requirements/neovim-tmux-claude-parallel-dev.md) | 完全な要件と設計 | 3,700行 |
| [キーバインディング](docs/keybindings.md) | 全キーバインド一覧 | 1,000行 |
| [カラースキーム統合](docs/colorscheme-integration.md) | 色の設定ガイド | - |
| [セットアップガイド](docs/setup-guide-neovim-tmux.md) | インストール手順 | - |
| [実装サマリー](docs/implementation-summary.md) | 実装内容の概要 | - |

## 🔧 カスタマイズ

各設定ファイルは自由にカスタマイズできます。

### 主要な設定ファイル

| ファイル | 説明 |
|---------|------|
| `nvim/lua/config/options.lua` | Neovimオプション |
| `nvim/lua/config/keymaps.lua` | キーマッピング |
| `nvim/lua/plugins/*.lua` | プラグイン設定 |
| `tmux/.tmux.conf` | Tmux設定 |
| `wezterm/.config/wezterm/wezterm.lua` | WezTerm設定 |
| `zsh/zshrc` | シェル設定 |
| `starship/.config/starship.toml` | プロンプト設定 |

### カスタマイズ例

```bash
# 1. 設定ファイルを編集
nvim ~/.config/nvim/lua/config/options.lua

# 2. 保存すると自動リロード（autocmd設定済み）
# または手動リロード: <leader>R

# 3. 変更をdotfilesに取り込み
cd ~/development/dotfiles
./scripts/sync.sh pull --nvim

# 4. 変更をコミット
git add .
git commit -m "Update Neovim options"
```

## 🛠️ 利用可能なスクリプト

| スクリプト | 説明 |
|-----------|------|
| `install-neovim-tmux.sh` | Neovim + Tmux自動セットアップ |
| `dev` | Neovim + Tmuxクイック起動 |
| `sync.sh` | 双方向同期（push/pull） |
| `clean.sh` | クリーニング（バックアップ付き） |
| `restore.sh` | 復元（バックアップから） |
| `verify-setup.sh` | 検証（インストール状態確認） |

すべてのスクリプトは`--help`オプションで使い方を確認できます。

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

### Ctrl+h/j/k/lが動作しない

```vim
" vim-tmux-navigatorがインストールされているか確認
:Lazy

" プラグインをリロード
:Lazy reload vim-tmux-navigator
```

```bash
# Tmux設定を確認
cat ~/.tmux.conf | grep "is_vim"

# 設定をリロード
# Prefix (Ctrl+A) + r
```

詳細は [docs/setup-guide-neovim-tmux.md](docs/setup-guide-neovim-tmux.md) のトラブルシューティングセクションを参照してください。

## 📊 統計

- **設定ファイル数**: 16個
- **プラグイン数**: 約30個
- **対応言語**: 15言語
- **ドキュメント**: 5個（合計6,000行以上）
- **キーバインド**: 100個以上

## 🤝 貢献

改善のための Issue や Pull Request を歓迎します。

### 貢献方法

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. Pull Requestを作成

## 📄 ライセンス

MIT License - 詳細は [LICENSE](LICENSE) ファイルを参照してください。

## 🙏 謝辞

このdotfilesは以下のプロジェクトを参考にしています：

- [Neovim](https://neovim.io/) - ハイパー拡張可能なVimベースのテキストエディタ
- [lazy.nvim](https://github.com/folke/lazy.nvim) - モダンなNeovimプラグインマネージャー
- [Tmux](https://github.com/tmux/tmux) - ターミナルマルチプレクサ
- [WezTerm](https://wezfurlong.org/wezterm/) - GPU加速ターミナル
- [Tokyo Night](https://github.com/folke/tokyonight.nvim) - カラースキーム
- [Starship](https://starship.rs/) - クロスシェルプロンプト
- [Moralerspace](https://github.com/yuru7/moralerspace) - プログラミングフォント

---

<div align="center">

**最終更新**: 2026-01-11

Made with ❤️ for developers

**今すぐ始めましょう！**

```bash
cd ~/development/dotfiles && ./scripts/install-neovim-tmux.sh
```

</div>
