# My Neovim Configuration - AstroNvim Edition 🚀

最新のAstroNvim v4ベースの高度なNeovim開発環境。Flutter、JavaScript/TypeScript、React/Next.js、Python開発に最適化され、AI統合と包括的な開発ツールを提供します。

## ✨ 主な機能

### 🌟 AstroNvim v4 ベース
- **モダンIDE体験**: 完全なLSPサポート、デバッグ、インテリジェント補完
- **遅延読み込み**: lazy.nvimによる高速起動
- **美しいUI**: アイコン、カラー、モダンなインターフェース

### 💻 言語サポート
- **Flutter/Dart**: ホットリロード対応の完全なFlutter開発環境
- **JavaScript/TypeScript**: React、Next.js、Node.js完全サポート
- **Python**: 仮想環境対応の包括的Python開発
- **Web技術**: HTML、CSS、Tailwind CSS、GraphQL

### 🤖 AI統合
- **GitHub Copilot**: インライン提案によるAIペアプログラミング
- **ChatGPT**: 統合チャットとコード支援
- **Avante**: Claude/GPT-4によるCursor風AI体験
- **Codeium**: Copilotの無料代替

### 🛠️ 追加ツール
- **Claude Code統合**: Serena MCPによるセマンティックコード操作
- **MCPサーバー**: GitHub、Filesystem、Playwright、Debug Thinking、Serena
- **Git統合**: Gitsigns、Neogit、Diffview
- **データベースクライアント**: UIを備えたvim-dadbod
- **RESTクライアント**: HTTPリクエストテスト
- **Markdownプレビュー**: render-markdown.nvimによるライブプレビュー
- **Telescope.nvim**: 高速ファジーファインダーと検索

## 🚀 クイックスタート

### 📦 AstroNvimへの移行（推奨）

```bash
# リポジトリクローン
git clone https://github.com/your-repo/my-nvim-config.git
cd my-nvim-config

# AstroNvimフルセットアップ（ワンコマンド！）
./scripts/setup.sh astronvim-full
```

この1つのコマンドで：
1. 既存のNeovim設定をバックアップ
2. AstroNvimをカスタム設定でインストール
3. すべての言語サーバーと開発ツールをセットアップ
4. AIアシスタント（Copilot、ChatGPT、Avante）を設定
5. すべてのプラグインをインストール・設定

### その他のインストールオプション

```bash
# 基本的なAstroNvim移行（設定のみ）
./scripts/setup.sh astronvim

# Claude Code完全統合（NEW!）
./scripts/setup.sh claude-integration

# 従来のNeovimセットアップ（レガシー）
./scripts/setup.sh --full

# 個別コンポーネント
./scripts/setup.sh mcp-only      # MCPサーバーのみ
./scripts/setup.sh kiro-only     # Kiroコマンドのみ
./scripts/setup.sh serena-only   # Serena MCPのみ
```

## 🎯 インストール後のセットアップ

### 1. Neovimを起動
```bash
nvim
```
プラグインが自動的にインストールされます（初回起動時のみ）。

### 2. 言語サーバーをインストール
Neovim内で実行：
```vim
:MasonInstall dartls tsserver pyright tailwindcss
```

### 3. AIツールをセットアップ
```vim
" GitHub Copilot
:Copilot setup
:Copilot enable

" ChatGPT/Avanteの場合、環境変数を設定：
" export OPENAI_API_KEY='your-key'
" export ANTHROPIC_API_KEY='your-key'
```

## ⌨️ 主要なキーマッピング

### 基本操作
| キー | 説明 |
|-----|------|
| `<Space>` | リーダーキー |
| `<Space>ff` | ファイル検索 |
| `<Space>fg` | テキスト検索（grep） |
| `<Space>fb` | バッファ検索 |
| `<Space>e` | ファイルエクスプローラー |

### AI機能
| キー | 説明 |
|-----|------|
| `<Tab>` | AI提案を受け入れ |
| `<Space>aa` | AI質問（Avante） |
| `<Space>acc` | Copilotチャット |
| `<Space>agg` | ChatGPT |
| `<M-]>` / `<M-[>` | 次/前の提案 |

### LSP機能
| キー | 説明 |
|-----|------|
| `gd` | 定義へジャンプ |
| `gr` | 参照を表示 |
| `K` | ホバー情報表示 |
| `<Space>la` | コードアクション |
| `<Space>lf` | コードフォーマット |
| `<Space>lr` | シンボルリネーム |

### Flutter開発
| キー | 説明 |
|-----|------|
| `<Space>Fa` | Flutterアプリ実行 |
| `<Space>Fr` | Flutterリロード |
| `<Space>Fq` | Flutter終了 |
| `<Space>Fd` | Flutterデバイス |

## 🔌 Claude Code統合

### Serena MCPによるセマンティックコード操作
- **セマンティック検索**: シンボル、定義、参照の高度な検索
- **コードナビゲーション**: 言語サーバーベースの正確な移動
- **リファクタリング**: シンボルのリネーム、自動編集
- **プロジェクト管理**: プロジェクト固有の設定対応

### ヘルパーコマンド
```bash
# MCPサーバー管理
claude-mcp list    # サーバー一覧と接続状態
claude-mcp test    # 接続テスト
claude-mcp fix     # 設定修正

# プロジェクト設定
activate-project   # 現在のディレクトリでSerena有効化
```

### セットアップ
```bash
# Claude Code完全統合のインストール
./scripts/setup.sh claude-integration

# 環境変数設定（~/.zshrc.localに追加）
export GITHUB_PERSONAL_ACCESS_TOKEN='your-token'
```

## 📁 プロジェクト構造

```
my-nvim-config/
├── scripts/
│   ├── setup.sh                    # メインセットアップスクリプト
│   ├── setup-claude-integration.sh # Claude Code完全統合
│   ├── setup-serena.sh            # Serena MCPセットアップ
│   ├── setup-kiro.sh              # Kiro コマンドセットアップ
│   └── mcp.sh                     # MCPサーバーセットアップ
├── astronvim-configs/
│   └── lua/plugins/
│       ├── ai.lua                 # AIプラグイン設定
│       ├── telescope.lua          # Telescope設定
│       └── claude-integration.lua # Claude Code Neovim統合
├── claude/                        # Claude Desktop設定
│   ├── commands/kiro/            # Kiroコマンド
│   ├── settings.json             # Claude Code安全設定
│   └── serena_config.yml         # Serena設定
├── ghostty/                       # Ghosttyターミナル設定
├── zsh/                          # Zsh設定
├── starship.toml                 # Starshipプロンプト設定
└── legacy-configs/               # 旧Neovim設定（バックアップ）
```

## 📚 詳細ドキュメント

- **[CLAUDE.md](CLAUDE.md)** - Claude Code統合ガイド  
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - セットアップガイド
- **[MCP_SETUP.md](MCP_SETUP.md)** - MCPサーバー設定
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - トラブルシューティング
- **[FLUTTER_KEYBINDINGS.md](FLUTTER_KEYBINDINGS.md)** - Flutterキーバインド

## 🔧 システム要件

- **Neovim** 0.11.0+ (推奨: 最新版)
- **Flutter** 3.0.0+
- **Git** 2.30.0+
- **Node.js** 16.0.0+ (Copilot用)
- **ripgrep** (高速検索用)
- **fd** (ファイル検索用)
- **pnpm** 8.0.0+ (オプション、JavaScript開発用)

## 📦 含まれる設定

- **Neovim**: 完全なFlutter開発環境
- **Zsh**: モダンなシェル設定（sheldon、プラグイン、エイリアス）
- **Ghostty**: モダンターミナル設定
- **Starship**: Flutter特化プロンプト
- **Claude Desktop**: 安全なコマンド実行設定
- **Claude Code MCP**: GitHub、Context7、Playwright統合
- **pnpm**: ワークスペース対応パッケージマネージャー設定
- **Scripts**: 整理された開発ツール（setup.sh、flutter.sh、pnpm.sh、mcp.sh）

## 🛠️ 環境変数の設定

`~/.zshrc.local`または`~/.bashrc.local`を作成：

```bash
# AI APIキー
export OPENAI_API_KEY='your-openai-key'
export ANTHROPIC_API_KEY='your-anthropic-key'

# GitHubトークン（MCP用）
export GITHUB_PERSONAL_ACCESS_TOKEN='your-github-token'

# Flutter（オプション）
export PATH="$PATH:$HOME/flutter/bin"
```

## 🔄 更新方法

```bash
# AstroNvimとプラグインを更新
nvim
:Lazy sync

# 言語サーバーを更新
:MasonUpdate
```

## 🔙 以前の設定に戻す

設定を復元する場合：

```bash
# バックアップを探す
ls -la ~/.config/ | grep nvim-backup

# 復元
rm -rf ~/.config/nvim
mv ~/.config/nvim-backup-TIMESTAMP ~/.config/nvim
```

## 🛟 トラブルシューティング

### よくある問題

1. **プラグインが読み込まれない**
   ```vim
   :Lazy sync
   :checkhealth
   ```

2. **LSPが動作しない**
   ```vim
   :LspInfo
   :Mason
   ```

3. **AI機能が動作しない**
   - APIキーが正しく設定されているか確認
   - GitHub Copilotの場合は `:Copilot setup` を実行
   - ネットワーク接続を確認

## 🤝 貢献

改善のための Issue や Pull Request を歓迎します。

## 📄 ライセンス

MIT License - 詳細は [LICENSE](LICENSE) ファイルを参照してください。