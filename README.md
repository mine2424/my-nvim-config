# Dotfiles

<div align="center">

**🚀 クロスプラットフォーム対応の統一開発環境**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey)]()

開発環境の設定ファイル集（dotfiles）。モダンで快適な開発環境を数分でセットアップ。

[クイックスタート](#-クイックスタート) • [機能](#-主な機能) • [ドキュメント](#-ドキュメント)

</div>

---

## 🎯 概要

このdotfilesプロジェクトは、以下の環境を統一的にセットアップします：

| カテゴリ | ツール | 説明 |
|---------|--------|------|
| **エディタ** | [AstroNvim](https://astronvim.com/) | モダンなNeovim設定（LSP、フォーマッター、プラグイン） |
| **シェル** | [Zsh](https://www.zsh.org/) + [Starship](https://starship.rs/) | 高速で美しいシェル環境 |
| **ターミナル** | [WezTerm](https://wezfurlong.org/wezterm/) | GPU加速ターミナルエミュレータ |
| **フォント** | [Moralerspace](https://github.com/yuru7/moralerspace) | プログラミング向け日英混植フォント |
| **AI統合** | [Cursor](https://cursor.sh/) | AI統合エディタ設定 |
| **CLIツール** | Git, tmux, fzf, etc. | 開発効率を上げる各種ツール |

## ✨ 主な機能

### 🎨 美しいUI/UX
- **Moralerspaceフォント**: Monaspace（欧文）+ IBM Plex Sans JP（和文）の合成フォント
- **Tokyo Nightテーマ**: 統一感のあるカラースキーム
- **Starshipプロンプト**: Git統合、言語バージョン表示、カスタムシンボル

### ⚡ 高速な開発環境
- **GPU加速ターミナル**: WezTermで120 FPS
- **遅延読み込み**: Sheldonによる高速シェル起動
- **LSP統合**: TypeScript、Rust、Go、Python等の言語サポート

### 🔄 簡単な管理
- **双方向同期**: `sync.sh`でdotfiles ⇔ ローカルPC間を同期
- **自動バックアップ**: クリーニング前に自動バックアップ
- **ドライランモード**: 安全に変更内容を確認

### 🌍 クロスプラットフォーム
- **macOS**: Apple Silicon / Intel対応
- **Linux**: Ubuntu、Debian、Arch等
- **Windows**: WSL2推奨

## 📁 プロジェクト構造

```
dotfiles/
├── docs/                           # 📚 ドキュメント
│   ├── requirements/               # 要件定義
│   ├── guides/                     # ガイド（フォント、セットアップ等）
│   └── implementation-plan.md      # 実装計画
├── scripts/                        # 🔧 セットアップスクリプト
│   ├── setup.sh                    # メインセットアップ
│   ├── sync.sh                     # 双方向同期
│   ├── clean.sh                    # クリーニング
│   ├── restore.sh                  # 復元
│   ├── verify-setup.sh             # 検証
│   └── utils/                      # ユーティリティ関数
│       ├── common.sh               # 共通関数
│       ├── os-detect.sh            # OS検出
│       ├── logger.sh               # ログ機能
│       └── backup.sh               # バックアップ機能
├── nvim/                           # 📝 AstroNvim設定
│   ├── init.lua                    # エントリーポイント
│   └── lua/
│       ├── community.lua           # コミュニティプラグイン
│       └── plugins/                # プラグイン設定
│           ├── astrocore.lua       # コア設定
│           ├── astrolsp.lua        # LSP設定
│           ├── astroui.lua         # UI設定
│           └── user.lua            # カスタムプラグイン
├── zsh/                            # 🐚 Zsh設定
│   ├── zshrc                       # メイン設定
│   ├── zshenv                      # 環境変数
│   ├── zprofile                    # PATH設定
│   └── sheldon/                    # プラグイン管理
│       └── plugins.toml            # プラグイン定義
├── wezterm/                        # 🖥️ WezTerm設定
│   └── .config/wezterm/
│       └── wezterm.lua             # ターミナル設定
├── starship/                       # ⭐ Starship設定
│   └── .config/
│       └── starship.toml           # プロンプト設定
├── cursor/                         # 🤖 Cursor設定（予定）
├── cli-tools/                      # 🛠️ CLIツール設定（予定）
├── apps/                           # 📱 アプリケーション設定（予定）
├── backups/                        # 💾 バックアップ（Git管理外）
└── README.md                       # このファイル
```

## 🚀 クイックスタート

### 前提条件

| 必須 | ツール | 説明 |
|------|--------|------|
| ✅ | Git | バージョン管理 |
| ✅ | Bash/Zsh | シェル |
| ✅ | インターネット接続 | パッケージダウンロード |
| 推奨 | [Moralerspace](https://github.com/yuru7/moralerspace) | プログラミングフォント |

#### フォントのインストール（推奨）

```bash
# macOS
brew install --cask font-monaspice-nerd-font
brew install font-moralerspace

# Linux (Ubuntu/Debian)
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/yuru7/moralerspace/releases/latest/download/Moralerspace_v2.0.0.zip
unzip Moralerspace_v2.0.0.zip && rm Moralerspace_v2.0.0.zip
fc-cache -fv

# 詳細は docs/guides/font-installation.md を参照
```

### インストール

```bash
# 1. リポジトリをクローン
git clone https://github.com/your-repo/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. フルセットアップ（推奨）
./scripts/setup.sh --all --install

# または、設定ファイルのみ適用（依存関係は手動インストール）
./scripts/setup.sh --all

# 3. セットアップの検証
./scripts/verify-setup.sh

# 4. シェルを再起動
exec $SHELL
```

### 個別コンポーネントのセットアップ

```bash
# AstroNvimのみ
./scripts/setup.sh --nvim --install

# Zsh + Starshipのみ
./scripts/setup.sh --shell --install

# WezTermのみ
./scripts/setup.sh --terminal --install

# ドライランモード（実際にはインストールしない）
./scripts/setup.sh --all --dry-run
```

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
./scripts/sync.sh pull --terminal  # WezTerm設定のみ
./scripts/sync.sh pull --shell     # シェル設定のみ

# 取り込み後はコミット
git add .
git commit -m "Update configurations from local"
```

### 推奨ワークフロー

1. **開発**: dotfilesで設定を編集
2. **反映**: `./scripts/sync.sh push` でローカルに反映
3. **確認**: ターミナルやエディタで動作確認
4. **コミット**: `git add . && git commit` で変更を保存

## 🧹 クリーニングと復元

### 既存設定のクリーニング

```bash
# ドライラン（何が削除されるか確認）
./scripts/clean.sh --dry-run

# 自動バックアップ付きクリーニング
./scripts/clean.sh --all

# 個別クリーニング
./scripts/clean.sh --nvim          # Neovim設定のみ
./scripts/clean.sh --shell         # シェル設定のみ
./scripts/clean.sh --terminal      # ターミナル設定のみ

# バックアップなしでクリーニング（非推奨）
./scripts/clean.sh --all --no-backup --force
```

### バックアップからの復元

```bash
# バックアップ一覧表示
./scripts/restore.sh --list

# 最新バックアップから復元
./scripts/restore.sh --latest

# 特定バックアップから復元
./scripts/restore.sh --backup 20260111_143022

# 個別復元
./scripts/restore.sh --latest --nvim      # Neovimのみ
./scripts/restore.sh --latest --shell     # シェル設定のみ
```

## 📦 含まれる設定

### エディタ・IDE

#### AstroNvim
- **LSP統合**: TypeScript、Rust、Go、Python、Lua等
- **自動フォーマット**: 保存時に自動フォーマット
- **Git統合**: Gitsigns、Neogit、Diffview
- **ファジーファインダー**: Telescope
- **GitHub Copilot**: AI補完統合
- **カスタムプラグイン**: Trouble、todo-comments、mini.nvim等

#### Cursor（予定）
- AI統合設定
- カスタムスニペット
- キーバインド

### シェル環境

#### Zsh
- **XDG Base Directory準拠**: 整理された設定ファイル配置
- **高度な履歴管理**: 検索、共有、重複排除
- **モダンコマンド**: eza、bat、fd、rg等への置き換え
- **豊富なエイリアス**: Git、Docker、Kubernetes等
- **便利な関数**: mkcd、extract、fcd、fv、fgb等

#### Sheldonプラグイン
- **高速起動**: 遅延読み込み対応
- **自動補完**: zsh-completions、fzf統合
- **シンタックスハイライト**: fast-syntax-highlighting
- **オートサジェスト**: zsh-autosuggestions
- **履歴検索**: zsh-history-substring-search
- **ツール統合**: Git、Docker、Kubectl、npm等

#### Starship
- **美しいプロンプト**: 2行表示、カスタムシンボル
- **Git統合**: ブランチ、ステータス、メトリクス表示
- **言語バージョン表示**: Node、Python、Rust、Go、Dart等
- **コマンド実行時間**: 500ms以上のコマンドを表示
- **バッテリー表示**: 残量に応じた色分け

### ターミナル

#### WezTerm
- **GPU加速**: WebGPU、120 FPS
- **カラースキーム**: カスタムカラー設定
- **半透明背景**: 0.8透過度、macOSではブラー効果
- **タブ/ペイン管理**: Vim風キーバインド
- **Claude監視機能**: タブごとの実行状態表示
- **Git統合**: リポジトリ名を自動表示
- **自動分割レイアウト**: 3ペイン構成を一発作成
- **OS別設定**: macOS、Linux、Windows対応

**キーバインド**:
- Leader key: `Ctrl+Space`
- ペイン分割: `Leader+s`（垂直）、`Leader+v`（水平）
- 自動レイアウト: `Leader+w`
- ペイン移動: `Leader+h/j/k/l`

### CLIツール（予定）

- **Git**: エイリアス、差分ツール、マージツール
- **tmux**: セッション管理、キーバインド
- **fzf**: ファジーファインダー
- **ripgrep**: 高速検索
- **fd**: 高速ファイル検索
- **bat**: catの代替
- **eza**: lsの代替

### OS別設定（予定）

- **Linux**: i3、AutoKey
- **Windows**: PowerShell、AutoHotkey、PowerToys
- **macOS**: Homebrew、defaults

## 📚 ドキュメント

詳細なドキュメントは`docs/`ディレクトリを参照してください：

| ドキュメント | 説明 |
|-------------|------|
| [要件定義](docs/requirements/first-requirement.md) | プロジェクトの要件と仕様 |
| [実装計画](docs/implementation-plan.md) | Phase別の実装計画 |
| [フォントインストールガイド](docs/guides/font-installation.md) | Moralerspaceのインストール方法 |
| セットアップガイド（予定） | 詳細なセットアップ手順 |
| カスタマイズガイド（予定） | 設定のカスタマイズ方法 |
| トラブルシューティング（予定） | よくある問題と解決方法 |

## 🔧 カスタマイズ

各設定ファイルは自由にカスタマイズできます。

### 主要な設定ファイル

| ファイル | 説明 |
|---------|------|
| `nvim/lua/plugins/user.lua` | 独自プラグイン追加 |
| `nvim/lua/plugins/astrocore.lua` | キーマップ、オプション設定 |
| `nvim/lua/plugins/astrolsp.lua` | LSP設定 |
| `zsh/zshrc` | シェル設定（エイリアス、関数） |
| `zsh/zshenv` | 環境変数設定 |
| `zsh/sheldon/plugins.toml` | プラグイン設定 |
| `wezterm/.config/wezterm/wezterm.lua` | ターミナル設定 |
| `starship/.config/starship.toml` | プロンプト設定 |

### カスタマイズ例

```bash
# 1. 設定ファイルを編集
vim ~/dotfiles/zsh/zshrc

# 2. ローカルに反映
cd ~/dotfiles
./scripts/sync.sh push --shell

# 3. シェルを再起動
exec $SHELL

# 4. 変更をコミット
git add .
git commit -m "Add custom aliases"
```

## 🛠️ 利用可能なスクリプト

| スクリプト | 説明 |
|-----------|------|
| `setup.sh` | セットアップ（依存関係インストール + 設定適用） |
| `sync.sh` | 双方向同期（push/pull） |
| `clean.sh` | クリーニング（バックアップ付き） |
| `restore.sh` | 復元（バックアップから） |
| `verify-setup.sh` | 検証（インストール状態確認） |

すべてのスクリプトは`--help`オプションで使い方を確認できます：

```bash
./scripts/setup.sh --help
./scripts/sync.sh --help
./scripts/clean.sh --help
```

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

- [AstroNvim](https://astronvim.com/) - Neovim設定フレームワーク
- [Moralerspace](https://github.com/yuru7/moralerspace) - プログラミングフォント
- [Starship](https://starship.rs/) - クロスシェルプロンプト
- [WezTerm](https://wezfurlong.org/wezterm/) - GPU加速ターミナル

---

<div align="center">

**最終更新**: 2026-01-11

Made with ❤️ for developers

</div>
