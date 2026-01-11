# Dotfiles プロジェクト要件定義書

## 📋 プロジェクト概要

### 目的
開発環境の設定ファイル（dotfiles）を一元管理し、新しいマシンやクリーンインストール後に簡単に開発環境を再構築できるようにする。

### スコープ
以下の設定ファイルと環境を管理対象とする：
- エディタ: 
  - **Neovim (AstroNvim)** - ターミナルベースの開発環境
  - **Claude Code (Cursor)** - AI支援統合開発環境
  - 両者を併用し、用途に応じて使い分ける
- シェル: Zsh + 関連設定（Windows: PowerShell対応も検討）
- ターミナル: WezTerm
- プロンプト: Starship
- CLI ツール設定
- アプリケーション設定

### 対応OS
- macOS (Apple Silicon & Intel)
- Linux (Ubuntu/Debian, Arch, Fedora等)
- Windows 10/11 (WSL2 + ネイティブ対応)

---

## 🎯 機能要件

### 1. エディタ設定（AstroNvim + Claude Code併用）

#### 1.1 開発環境の使い分け

**AstroNvim（ターミナルベース）の用途:**
- 🚀 軽量・高速な編集作業
- 🖥️ サーバー上でのリモート編集
- 📝 設定ファイルやスクリプトの編集
- ⚡ クイックな修正・確認作業
- 🔧 システム管理タスク

**Claude Code（Cursor）の用途:**
- 🤖 AI支援による開発（コード生成、リファクタリング）
- 🏗️ 大規模プロジェクトの開発
- 🔍 コードベース全体の理解と探索
- 🐛 デバッグとテスト
- 📚 ドキュメント作成

#### 1.2 AstroNvim設定

##### 1.2.1 管理対象ファイル
- [ ] `~/.config/nvim/` - AstroNvim設定ディレクトリ全体
  - Linux/macOS: `~/.config/nvim/`
  - Windows: `%LOCALAPPDATA%\nvim\` または `~/AppData/Local/nvim/`
- [ ] カスタムプラグイン設定
- [ ] キーバインディング設定
- [ ] LSP設定（Claude Codeと共通のLSP設定を参照）
- [ ] テーマ/カラースキーム設定

##### 1.2.2 インストール要件
- [ ] **必須要件**
  - Neovim v0.10+ (nightlyは除く)
  - Nerd Fonts（アイコン表示用）
  - True color対応ターミナル
  - クリップボードツール（システムクリップボード統合用）
- [ ] **推奨ツール**
  - ripgrep - ファイル内検索
  - lazygit - Git UI
  - Tree-sitter CLI - 自動インストール機能用
  - Node.js - LSP用
  - Python - LSP・REPL用

##### 1.2.3 インストール手順
公式リポジトリ（[https://github.com/AstroNvim/AstroNvim](https://github.com/AstroNvim/AstroNvim)）および公式ドキュメント（[https://docs.astronvim.com/](https://docs.astronvim.com/)）に従ってインストール：

1. **既存設定のバックアップ**
   ```bash
   # Linux/macOS
   mv ~/.config/nvim ~/.config/nvim.bak
   mv ~/.local/share/nvim ~/.local/share/nvim.bak
   mv ~/.local/state/nvim ~/.local/state.nvim.bak
   mv ~/.cache/nvim ~/.cache/nvim.bak
   ```

   ```powershell
   # Windows (PowerShell)
   Rename-Item -Path $env:LOCALAPPDATA\nvim -NewName $env:LOCALAPPDATA\nvim.bak
   Rename-Item -Path $env:LOCALAPPDATA\nvim-data -NewName $env:LOCALAPPDATA\nvim-data.bak
   ```

2. **AstroNvim Templateのクローン**
   ```bash
   # Linux/macOS
   git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
   rm -rf ~/.config/nvim/.git
   nvim
   ```

   ```powershell
   # Windows (PowerShell)
   git clone --depth 1 https://github.com/AstroNvim/template $env:LOCALAPPDATA\nvim
   Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force
   nvim
   ```

3. **初回起動時の自動セットアップ**
   - lazy.nvimによるプラグイン自動インストール
   - 必要に応じてLSP、TreeSitter、Debuggerをインストール

> **Note**: 最新のインストール手順やバージョン情報は[GitHubリポジトリのREADME](https://github.com/AstroNvim/AstroNvim)を参照してください。

##### 1.2.4 セットアップ後の設定
- [ ] LSPインストール: `:LspInstall <server_name>`
- [ ] 言語パーサーインストール: `:TSInstall <language>`
- [ ] デバッガーインストール: `:DapInstall <debugger>`
- [ ] プラグイン管理:
  - `:Lazy check` - 更新確認
  - `:Lazy update` - プラグイン更新
  - `:AstroUpdate` - AstroNvim + Mason一括更新

##### 1.2.5 AstroNvim v5.0の主要機能
- [ ] **モダンなUI/UX**
  - 美しいデフォルトテーマ
  - ステータスライン、Winbar、タブライン（Heirline）
  - ファイルエクスプローラー（Neo-tree）
- [ ] **LSP統合（Native LSP）**
  - 自動補完（Blink.cmp）
  - コード診断
  - フォーマッター統合
  - リファクタリング支援
- [ ] **Git統合**
  - Gitsigns（変更表示）
  - Lazygit統合
  - Git blame表示
- [ ] **ファジーファインダー（snacks.picker）**
  - ファイル検索
  - テキスト検索
  - コマンドパレット
- [ ] **その他の主要機能**
  - ターミナル統合（Toggleterm）
  - シンタックスハイライト（Treesitter）
  - フォーマット・リント（none-ls）
  - パッケージ管理（mason.nvim）
  - プラグイン管理（lazy.nvim）

##### 1.2.6 AstroCommunity統合
- [ ] コミュニティプラグイン仕様の活用
- [ ] 言語パック（Rust, Python, TypeScript等）
- [ ] カラースキーム（Catppuccin等）
- [ ] 追加プラグインの簡単導入

##### 1.2.7 キーバインディング設計
- [ ] 基本操作
  - `<C-s>` - 保存（VSCode互換）
  - `;` - コマンドモード（`:`の代替）
  - `jk` / `jj` - インサートモード脱出
  - `<leader>y/Y` - システムクリップボード連携
- [ ] ナビゲーション
  - `<C-d>/<C-u>` - 半ページスクロール（画面中央維持）
  - `n/N` - 検索結果移動（画面中央維持）
- [ ] ファイル検索・操作
  - `<leader><leader>` - スマートピッカー
  - `<leader>sf` - ファイル検索
  - `<leader>sg` - テキスト検索（grep）
  - `<leader>sb` - バッファ検索
  - `<leader>sr` - 最近のファイル
- [ ] LSP機能
  - `gd` - 定義へジャンプ
  - `gr` - 参照検索
  - `K` - ホバー情報
  - `<leader>ca` - コードアクション
  - `<leader>rn` - リネーム
- [ ] Git操作
  - `<leader>gs` - Git status
  - `<leader>gc` - Git commit
  - `<leader>gp` - Git push
  - `]h/[h` - Hunk移動
- [ ] ウィンドウ・バッファ管理
  - `<C-h/j/k/l>` - ウィンドウ間移動
  - `<leader>bd` - バッファ削除
  - `<Tab>/<S-Tab>` - バッファ切り替え

##### 1.2.8 参考リソース
- **公式リソース**
  - [AstroNvim GitHub Repository](https://github.com/AstroNvim/AstroNvim) - 公式リポジトリ（最新バージョン、リリース情報、Issue・PR）
  - [AstroNvim Documentation](https://docs.astronvim.com/) - 公式ドキュメント（インストール、設定、レシピ集）
  - [AstroNvim Template](https://github.com/AstroNvim/template) - 公式テンプレートリポジトリ
  - [AstroCommunity](https://github.com/AstroNvim/astrocommunity) - コミュニティプラグイン仕様
- **参考記事**
  - [ターミナルがダサいとモテない - Neovim + AstroNvim v4.0 紹介編](https://medium.com/@yusuke_h/%E3%82%BF%E3%83%BC%E3%83%9F%E3%83%8A%E3%83%AB%E3%81%8C%E3%83%80%E3%82%B5%E3%81%84%E3%81%A8%E3%83%A2%E3%83%86%E3%81%AA%E3%81%84-neovim-astronvim-v4-0%E7%B4%B9%E4%BB%8B%E7%B7%A8-a8beeca5f2c8) - AstroNvim v4.0の詳細な紹介と設定例
  - [私の為のNvChadのキーマッピングガイド 2026年版](https://syu-m-5151.hatenablog.com/entry/2026/01/03/002621) - 実用的なキーバインド設計の参考例（Snacks.nvim, Telescope, LSP, Git等の統合）

> **Note**: AstroNvimの最新バージョンやリリース情報は[GitHubリポジトリ](https://github.com/AstroNvim/AstroNvim)で確認してください。現在はv5.x系が最新です。

---

### 2. Claude Code (Cursor) 設定

#### 2.1 管理対象ファイル
- [ ] `~/.config/cursor/` - Cursor設定ディレクトリ
  - Linux: `~/.config/Cursor/User/`
  - macOS: `~/Library/Application Support/Cursor/User/`
  - Windows: `%APPDATA%\Cursor\User\`
- [ ] `settings.json` - エディタ設定
- [ ] `keybindings.json` - キーバインディング設定
- [ ] `snippets/` - カスタムスニペット
- [ ] `.cursorrules` - プロジェクト固有のAIルール（プロジェクトルート）

#### 2.2 機能
- [ ] 設定ファイルの自動配置
- [ ] 推奨拡張機能リストの管理
- [ ] ワークスペース設定のテンプレート
- [ ] AI設定の最適化
  - Claude 3.5 Sonnetの設定
  - コンテキスト設定
  - プロンプトテンプレート

#### 2.3 AstroNvimとの連携
- [ ] 共通のLSP設定
- [ ] 統一されたフォーマッター設定
- [ ] 同じテーマ/カラースキームの使用（可能な範囲で）
- [ ] 共通のキーバインディング哲学
- [ ] プロジェクトごとの`.editorconfig`で統一

#### 2.4 推奨拡張機能
- [ ] 言語サポート（TypeScript, Python, Rust, Go等）
- [ ] Git統合（GitLens等）
- [ ] フォーマッター（Prettier, Black等）
- [ ] Linter統合
- [ ] Remote Development（SSH, WSL）

---

### 3. シェル設定 (Zsh)

#### 3.1 管理対象ファイル
- [x] `~/.zshrc` - メインZsh設定ファイル
- [x] `~/.config/sheldon/plugins.toml` - Sheldonプラグイン管理
- [ ] `~/.zshenv` - 環境変数設定
- [ ] `~/.zprofile` - ログイン時の設定
- [ ] カスタム関数・エイリアス集
- [ ] **Windows専用**: PowerShell設定
  - `$PROFILE` (PowerShell プロファイル)
  - `%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

#### 3.2 機能
- [ ] Zshの自動インストール（未インストール時）
- [ ] Sheldonの自動インストール
- [ ] プラグインの自動インストール
- [ ] 既存.zshrcのバックアップ
- [ ] **Windows**: WSL2内でのZsh設定
- [ ] **Windows**: PowerShell用の設定（オプション）

#### 3.3 推奨機能
- [ ] コマンド履歴の高度な検索機能
  - 入力途中のコマンドから履歴を検索（`Ctrl+P/N`）
  - 履歴の重複排除
  - 複数シェル間での履歴共有
- [ ] 推奨プラグイン
  - zsh-syntax-highlighting（シンタックスハイライト）
  - zsh-autosuggestions（自動補完提案）
  - zsh-history-substring-search（履歴検索）

#### 3.4 参考実装
- [zsh + Starship + WezTermで最強のターミナル環境を構築する](https://zenn.dev/botamotch/articles/e7960f0dc84d8b) - コマンド履歴検索、基本設定の実装例

---

### 4. ターミナル設定 (WezTerm)

#### 4.1 管理対象ファイル
- [ ] `~/.config/wezterm/wezterm.lua` - WezTerm設定ファイル
  - Linux/macOS: `~/.config/wezterm/`
  - Windows: `%USERPROFILE%\.config\wezterm\` または `%USERPROFILE%\.wezterm.lua`
- [ ] `colors.lua` - カスタムカラースキーム定義
- [ ] フォント設定
- [ ] キーバインディング設定
- [ ] OS別の設定分岐（パス区切り文字、デフォルトシェル等）

#### 4.2 機能
- [ ] WeztermのインストールガイドまたはHomebrew経由の自動インストール
- [ ] **Windows**: Scoop/Chocolatey/winget経由のインストール
- [ ] 設定ファイルの自動配置
- [ ] フォントの自動インストール（Nerd Fonts等）
- [ ] **Windows**: WSL2統合設定

#### 4.3 デザイン要件
- [ ] ランダムカラースキーム機能（起動時に色をランダム選択）
- [ ] カスタムタブバーデザイン
  - 丸みを帯びたタブエッジ（Nerd Fonts使用）
  - ホバー効果
  - アクティブ/非アクティブタブの視覚的区別
- [ ] ステータスバー表示
  - バッテリー残量インジケーター（ビジュアル表示）
  - 時刻表示
  - カスタムフォーマット
- [ ] ウィンドウ透明度設定
- [ ] ワークスペース表示機能
- [ ] タブタイトルのカスタマイズ（絵文字対応）

#### 4.4 基本機能要件
- [ ] タブ・ペイン機能
  - タブの作成・削除・切り替え
  - ペインの水平/垂直分割
  - ペイン間の移動とリサイズ
  - ペインのズーム機能
- [ ] キーバインディング
  - Leaderキー方式（例: `Ctrl+Q`）
  - tmux風のキーバインド
- [ ] コピーモード
  - クリップボード統合

#### 4.5 参考実装
- [gsuuon's WezTerm Config](https://gist.github.com/gsuuon/5511f0aa10c10c6cbd762e0b3e596b71) - スタイリッシュなタブバー、カラースキーム、ステータスバーの実装例
- [zsh + Starship + WezTermで最強のターミナル環境を構築する](https://zenn.dev/botamotch/articles/e7960f0dc84d8b) - タブ・ペイン機能、キーバインディングの設定例

---

### 5. プロンプト設定 (Starship)

#### 5.1 管理対象ファイル
- [ ] `~/.config/starship.toml` - Starship設定ファイル

#### 5.2 機能
- [x] Starshipの自動インストール（オプション）
- [ ] カスタムプロンプト設定の適用
- [ ] Git統合設定
  - リポジトリ情報の表示
  - ブランチ名の表示
  - 変更状態の表示
- [ ] 言語バージョン表示設定
  - プロジェクト検知による自動表示
  - 対応言語: Python, Node.js, Rust, Go等
- [ ] プロンプトカスタマイズ
  - 成功/エラー時のシンボル変更
  - 改行の制御
  - Nerd Fonts対応

#### 5.3 高度なカスタマイズ
- [ ] フォーマット設定
  - `format` - 表示項目の順序と配置
  - `right_format` - 右プロンプトの設定
  - `add_newline` - プロンプト前の改行制御
- [ ] 各種モジュールのカスタマイズ
  - スタイル設定（カラーコード）
  - シンボルのカスタマイズ（Nerd Fonts使用）
  - 表示条件の設定
- [ ] OS別設定
  - Windows (Clink統合)
  - Linux/macOS
- [ ] 詳細表示項目
  - バッテリー状態
  - メモリ使用量
  - ローカルIP表示
  - 各種言語バージョン（Node.js, Rust, Python等）

#### 5.4 参考実装
- [zsh + Starship + WezTermで最強のターミナル環境を構築する](https://zenn.dev/botamotch/articles/e7960f0dc84d8b) - シンプルで実用的なStarship設定例
- [【starship】ターミナルをかっこよく](https://qiita.com/darallium/items/0e3669c54e71d0826418) - 詳細なカスタマイズ例（format設定、右プロンプト、各種モジュール設定）

---

### 6. CLIツール設定

#### 6.1 管理対象ファイル
- [ ] `~/.tmux.conf` - tmux設定
- [ ] `~/.gdbinit` - GDBデバッガ設定
- [ ] `~/.gitconfig` - Git全体設定
- [ ] `~/.gitignore_global` - グローバルgitignore
- [ ] `~/.vimrc` - Vim設定（フォールバック用）
- [ ] `~/.curlrc` - curl設定
- [ ] `~/.wgetrc` - wget設定
- [ ] `~/.ripgreprc` - ripgrep設定

#### 6.2 機能
- [ ] 各ツールの設定ファイル配置
- [ ] 必要なツールのインストール確認
- [ ] ツール別のセットアップスクリプト

---

### 7. アプリケーション設定

#### 7.1 管理対象ファイル
- [ ] `~/.i3/` - i3ウィンドウマネージャ設定（Linux）
- [ ] `~/.autokey/` - AutoKey設定（Linux）
- [ ] **Windows専用**:
  - Windows Terminal設定 (`%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json`)
  - AutoHotkey設定（キーバインディング自動化）
  - PowerToys設定
- [ ] その他デスクトップアプリケーション設定

#### 7.2 機能
- [ ] OS別の設定ファイル管理
- [ ] 条件付き設定適用（Linux/macOS/Windows）
- [ ] **Windows**: レジストリ設定のエクスポート/インポート（オプション）

---

### 8. Windows固有の要件

#### 8.1 WSL2統合
- [ ] WSL2のインストール確認と推奨
- [ ] WSL2ディストリビューションの選択（Ubuntu推奨）
- [ ] WSL2内でのLinux環境セットアップ
- [ ] Windows ⇔ WSL2間のファイル共有設定
- [ ] WSL2からWindows側のツールへのアクセス

#### 8.2 パス処理
- [ ] Windowsパス形式 (`C:\Users\...`) とUnixパス形式の変換
- [ ] 環境変数の適切な設定（`%USERPROFILE%`, `$HOME`等）
- [ ] シンボリックリンクの代替（ジャンクション、ハードリンク）

#### 8.3 改行コード対応
- [ ] Git設定での自動変換 (`core.autocrlf`)
- [ ] エディタでの改行コード統一（LF推奨）

#### 8.4 実行権限
- [ ] PowerShell実行ポリシーの設定
- [ ] スクリプト実行権限の確認

#### 8.5 Windows専用ツール
- [ ] Scoop/Chocolatey/wingetのインストール
- [ ] Windows Terminal推奨設定
- [ ] AutoHotkey設定（オプション）
- [ ] PowerToys設定（オプション）
- [ ] Clink（Starship統合用）
  - `%LocalAppData%\clink\starship.lua`の設定

---

## 🧹 クリーニング要件

### 9. 既存設定のクリーニング

#### 9.1 クリーニングの目的
- 既存の設定ファイルとの競合を防ぐ
- クリーンな状態から新しい設定を適用
- 古い設定の残骸を削除
- バックアップを取った上で安全にリセット

#### 9.2 クリーニング対象

##### 9.2.1 エディタ設定
```bash
# Neovim/AstroNvim
~/.config/nvim/
~/.local/share/nvim/
~/.local/state/nvim/
~/.cache/nvim/

# Windows
%LOCALAPPDATA%\nvim\
%LOCALAPPDATA%\nvim-data\

# Cursor/Claude Code
~/.config/Cursor/
~/Library/Application Support/Cursor/  # macOS
%APPDATA%\Cursor\  # Windows
```

##### 9.2.2 シェル設定
```bash
# Zsh
~/.zshrc
~/.zshenv
~/.zprofile
~/.zsh_history
~/.config/sheldon/

# PowerShell (Windows)
$PROFILE
%USERPROFILE%\Documents\PowerShell\
```

##### 9.2.3 ターミナル・プロンプト設定
```bash
# WezTerm
~/.config/wezterm/
~/.wezterm.lua
%USERPROFILE%\.config\wezterm\  # Windows

# Starship
~/.config/starship.toml
%APPDATA%\starship.toml  # Windows
```

##### 9.2.4 CLIツール設定
```bash
~/.tmux.conf
~/.gdbinit
~/.gitconfig
~/.gitignore_global
~/.vimrc
~/.curlrc
~/.wgetrc
~/.ripgreprc
```

##### 9.2.5 アプリケーション設定
```bash
# Linux
~/.i3/
~/.autokey/

# Windows
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_*\
# AutoHotkey, PowerToys設定
```

#### 9.3 クリーニングスクリプト要件

##### 9.3.1 基本機能
- [ ] **バックアップ機能**
  - タイムスタンプ付きバックアップディレクトリ作成
  - 既存設定の完全バックアップ
  - バックアップ一覧の表示
- [ ] **ドライランモード**
  - 削除対象のプレビュー表示
  - 実際には削除せずに確認のみ
- [ ] **選択的クリーニング**
  - 全体クリーニング
  - カテゴリ別クリーニング（エディタのみ、シェルのみ等）
  - 個別ファイル指定
- [ ] **安全機能**
  - 確認プロンプト（デフォルト有効）
  - 強制モード（`--force`フラグ）
  - ログ出力

##### 9.3.2 クリーニングスクリプト例

**Linux/macOS (`scripts/clean.sh`):**
```bash
#!/bin/bash
# 使用例:
# ./scripts/clean.sh --dry-run          # プレビュー
# ./scripts/clean.sh --backup           # バックアップのみ
# ./scripts/clean.sh --all              # 全てクリーニング
# ./scripts/clean.sh --nvim             # Neovimのみ
# ./scripts/clean.sh --shell            # シェル設定のみ
```

**Windows (`scripts/clean.ps1`):**
```powershell
# 使用例:
# .\scripts\clean.ps1 -DryRun           # プレビュー
# .\scripts\clean.ps1 -Backup           # バックアップのみ
# .\scripts\clean.ps1 -All              # 全てクリーニング
# .\scripts\clean.ps1 -Component nvim   # Neovimのみ
```

##### 9.3.3 バックアップ構造
```
backups/
├── 2026-01-11_143022/              # タイムスタンプ
│   ├── nvim/
│   │   ├── config/
│   │   ├── share/
│   │   └── state/
│   ├── zsh/
│   │   ├── zshrc
│   │   ├── zshenv
│   │   └── sheldon/
│   ├── wezterm/
│   ├── starship/
│   ├── cursor/
│   └── cli-tools/
└── backup_manifest.json            # バックアップ情報
```

##### 9.3.4 復元機能
- [ ] バックアップからの復元スクリプト
- [ ] バックアップ一覧表示
- [ ] 特定バックアップの復元
- [ ] 部分復元（特定カテゴリのみ）

#### 9.4 クリーニングワークフロー

1. **事前確認**
   ```bash
   ./scripts/clean.sh --dry-run
   ```

2. **バックアップ作成**
   ```bash
   ./scripts/clean.sh --backup
   ```

3. **クリーニング実行**
   ```bash
   ./scripts/clean.sh --all
   ```

4. **新規セットアップ**
   ```bash
   ./scripts/setup.sh --full
   ```

5. **問題発生時の復元**
   ```bash
   ./scripts/restore.sh --list
   ./scripts/restore.sh --from 2026-01-11_143022
   ```

---

## 🛠️ セットアップスクリプト要件

### 10. メインセットアップスクリプト (`setup.sh` / `setup.ps1`)

#### 10.1 基本機能
- [x] 基本的な設定ファイルのコピー
- [ ] フルセットアップモード
- [ ] 個別コンポーネントのインストール
- [ ] OS検出機能（macOS/Linux/Windows）
- [ ] 既存ファイルのバックアップ機能
- [ ] ドライランモード（実際には変更せずに確認）
- [ ] ログ出力機能
- [ ] **Windows**: 管理者権限の確認と要求

#### 10.2 インストールモード
```bash
# Linux/macOS
# 基本モード（最小限の設定）
./scripts/setup.sh

# フルセットアップ（全ての設定とツール）
./scripts/setup.sh --full

# 個別コンポーネント
./scripts/setup.sh --nvim        # Neovimのみ
./scripts/setup.sh --zsh         # Zshのみ
./scripts/setup.sh --wezterm     # WeztermとStarshipのみ
./scripts/setup.sh --cli-tools   # CLIツール設定のみ
./scripts/setup.sh --apps        # アプリケーション設定のみ

# ドライラン
./scripts/setup.sh --dry-run

# バックアップのみ
./scripts/setup.sh --backup-only
```

```powershell
# Windows (PowerShell)
# 基本モード
.\scripts\setup.ps1

# フルセットアップ
.\scripts\setup.ps1 -Full

# WSL2環境のセットアップ
.\scripts\setup.ps1 -WSL

# 個別コンポーネント
.\scripts\setup.ps1 -Component nvim
.\scripts\setup.ps1 -Component wezterm
```

#### 10.3 依存関係管理
- [ ] 必要なパッケージマネージャの検出
  - macOS: Homebrew
  - Linux: apt, yum, pacman等
  - Windows: Scoop, Chocolatey, winget
- [ ] 依存ツールの自動インストール
- [ ] バージョン確認機能
- [ ] **Windows**: WSL2の存在確認と推奨

---

### 11. 検証スクリプト (`verify-setup.sh` / `verify-setup.ps1`)

#### 11.1 機能
- [x] 基本的な検証機能の骨組み
- [ ] 各設定ファイルの存在確認
- [ ] シンボリックリンクの正常性確認
- [ ] 必要なツールのインストール確認
- [ ] 設定ファイルの構文チェック
- [ ] レポート生成機能

---

### 12. 復元スクリプト (`restore.sh` / `restore.ps1`)

#### 12.1 機能
- [ ] バックアップ一覧の表示
- [ ] 特定バックアップからの復元
- [ ] 部分復元（カテゴリ別）
- [ ] 復元前の確認プロンプト
- [ ] 復元ログの生成

---

## 📂 ディレクトリ構造要件

### 13. プロジェクト構造

```
dotfiles/
├── README.md                          # プロジェクト概要
├── LICENSE                            # ライセンス
├── docs/                              # ドキュメント
│   ├── requirements/                  # 要件定義
│   │   └── first-requirement.md       # この要件定義書
│   ├── setup-guide.md                 # セットアップガイド
│   ├── setup-guide-windows.md         # Windows専用ガイド
│   └── troubleshooting.md             # トラブルシューティング
├── scripts/                           # セットアップスクリプト
│   ├── clean.sh                       # クリーニング (Linux/macOS)
│   ├── clean.ps1                      # クリーニング (Windows)
│   ├── setup.sh                       # メインセットアップ (Linux/macOS)
│   ├── setup.ps1                      # メインセットアップ (Windows)
│   ├── verify-setup.sh                # 検証スクリプト (Linux/macOS)
│   ├── verify-setup.ps1               # 検証スクリプト (Windows)
│   ├── restore.sh                     # 復元スクリプト (Linux/macOS)
│   ├── restore.ps1                    # 復元スクリプト (Windows)
│   └── utils/                         # ユーティリティ関数
│       ├── common.sh                  # 共通関数 (bash/zsh)
│       ├── common.ps1                 # 共通関数 (PowerShell)
│       ├── backup.sh                  # バックアップ関数
│       ├── os-detect.sh               # OS検出
│       └── logger.sh                  # ログ機能
├── nvim/                              # Neovim設定
│   └── .config/nvim/                  # AstroNvim設定
├── zsh/                               # Zsh設定
│   ├── zshrc                          # メイン設定
│   ├── zshenv                         # 環境変数
│   ├── zprofile                       # プロファイル
│   └── sheldon/                       # Sheldon設定
│       └── plugins.toml
├── powershell/                        # PowerShell設定 (Windows)
│   └── Microsoft.PowerShell_profile.ps1
├── wezterm/                           # WezTerm設定
│   └── .config/wezterm/
│       ├── wezterm.lua                # メイン設定
│       └── colors.lua                 # カラースキーム定義
├── starship/                          # Starship設定
│   ├── .config/starship.toml          # Linux/macOS設定
│   └── starship.toml                  # Windows設定 (%appdata%)
├── cursor/                            # Claude Code (Cursor) 設定
│   ├── settings.json                  # エディタ設定
│   ├── keybindings.json               # キーバインディング
│   ├── snippets/                      # カスタムスニペット
│   └── .cursorrules.example           # プロジェクト用AIルールのテンプレート
├── cli-tools/                         # CLIツール設定
│   ├── tmux.conf
│   ├── gdbinit
│   ├── gitconfig
│   ├── gitignore_global
│   ├── vimrc
│   └── ripgreprc
├── apps/                              # アプリケーション設定
│   ├── i3/                            # i3 WM (Linux)
│   ├── autokey/                       # AutoKey (Linux)
│   ├── windows-terminal/              # Windows Terminal (Windows)
│   ├── autohotkey/                    # AutoHotkey (Windows)
│   └── powertoys/                     # PowerToys (Windows)
└── backups/                           # バックアップディレクトリ（git管理外）
    └── .gitkeep
```

---

## 🔧 技術要件

### 14. 互換性

#### 12.1 OS対応
- [ ] macOS (Apple Silicon & Intel)
- [ ] Linux (Ubuntu/Debian)
- [ ] Linux (Arch/Manjaro)
- [ ] Linux (Fedora/RHEL)
- [ ] **Windows 10/11**
  - [ ] WSL2 (Ubuntu/Debian推奨)
  - [ ] ネイティブWindows環境
  - [ ] Git Bash環境（限定サポート）

#### 12.2 シェル
- [ ] Zsh 5.8+
- [ ] Bash（フォールバック）
- [ ] PowerShell 7+ (Windows)

#### 12.3 パッケージマネージャ
- [ ] macOS: Homebrew
- [ ] Linux: apt, yum, pacman, zypper
- [ ] Windows: Scoop (推奨), Chocolatey, winget

---

### 15. セキュリティ要件

- [ ] 機密情報（APIキー、トークン等）はdotfilesに含めない
- [ ] `.gitignore`で機密ファイルを除外
- [ ] 環境変数用のテンプレートファイル提供
- [ ] バックアップディレクトリをgit管理外に

---

## 📊 非機能要件

### 16. ユーザビリティ

- [ ] 分かりやすいログ出力（色付き、進捗表示）
- [ ] エラーメッセージの明確化
- [ ] インタラクティブモード（確認プロンプト）
- [ ] ヘルプメッセージの充実

### 17. 保守性

- [ ] モジュール化されたスクリプト構造
- [ ] コメントの充実
- [ ] 設定ファイルのバージョン管理
- [ ] 変更履歴の記録（CHANGELOG.md）

### 18. テスト

- [ ] セットアップスクリプトの自動テスト
- [ ] CI/CDパイプライン（GitHub Actions）
- [ ] 複数OS環境でのテスト
  - [ ] macOS (latest, Apple Silicon & Intel)
  - [ ] Ubuntu (20.04, 22.04, 24.04)
  - [ ] Windows 10/11 (ネイティブ & WSL2)
- [ ] PowerShellスクリプトのPester テスト
- [ ] シェルスクリプトのbatsテスト

---

## 🎨 UX要件

### 19. セットアップ体験

#### 19.1 初回セットアップ
```bash
# ワンライナーでのクイックスタート
curl -fsSL https://raw.githubusercontent.com/user/dotfiles/main/scripts/install.sh | bash
```

#### 19.2 進捗表示
- [ ] プログレスバー表示
- [ ] 各ステップの成功/失敗表示
- [ ] 推定残り時間表示

#### 19.3 カスタマイズ
- [ ] 対話式セットアップモード
- [ ] 設定ファイルのプリセット選択
- [ ] カラースキーム選択

---

## 📝 ドキュメント要件

### 20. 必要なドキュメント

- [x] README.md - プロジェクト概要とクイックスタート
- [ ] docs/setup-guide.md - 詳細セットアップガイド
- [ ] docs/setup-guide-windows.md - Windows専用セットアップガイド
- [ ] docs/troubleshooting.md - トラブルシューティング
- [ ] docs/troubleshooting-windows.md - Windows専用トラブルシューティング
- [ ] docs/customization.md - カスタマイズガイド
- [ ] docs/requirements/first-requirement.md - この要件定義書
- [ ] CHANGELOG.md - 変更履歴
- [ ] CONTRIBUTING.md - 貢献ガイド

---

## 🚀 実装優先順位

### Phase 1: 基礎構築（現在）
- [x] プロジェクト構造の確立
- [x] Zsh基本設定
- [x] 基本的なセットアップスクリプト
- [x] 要件定義書の完成
- [ ] **クリーニング環境の構築**
  - [ ] クリーニングスクリプト作成（`clean.sh` / `clean.ps1`）
  - [ ] バックアップ機能の実装
  - [ ] ドライランモードの実装
  - [ ] 復元スクリプト作成（`restore.sh` / `restore.ps1`）

### Phase 2: コア機能
- [ ] **エディタ環境の構築**
  - [ ] Neovim/AstroNvim v5.0設定の追加
    - [ ] 公式ドキュメント（https://docs.astronvim.com/）に従ったインストール
    - [ ] 必須要件の確認とインストール
      - Neovim v0.10+
      - Nerd Fonts
      - ripgrep, lazygit等の推奨ツール
    - [ ] AstroNvim Template のセットアップ
    - [ ] 基本設定（lua/plugins/ディレクトリ構造）
    - [ ] UI/UXカスタマイズ（テーマ、Heirline設定）
    - [ ] プラグイン設定（neo-tree, snacks.picker, ToggleTerm等）
    - [ ] LSP設定（`:LspInstall`による言語サーバー導入）
    - [ ] TreeSitter設定（`:TSInstall`による言語パーサー導入）
    - [ ] Git統合（Gitsigns, Lazygit）
    - [ ] AstroCommunity統合（言語パック、カラースキーム等）
    - [ ] キーバインディング設計
      - 基本操作（保存、モード切替、クリップボード）
      - ナビゲーション（スクロール、検索）
      - ファイル検索・操作
      - LSP機能（定義ジャンプ、参照、リネーム等）
      - Git操作
      - ウィンドウ・バッファ管理
  - [ ] Claude Code (Cursor) 設定の追加
    - [ ] settings.json
    - [ ] keybindings.json
    - [ ] 推奨拡張機能リスト
    - [ ] .cursorrulesテンプレート
  - [ ] 両エディタの連携設定
    - [ ] 共通LSP設定
    - [ ] 統一フォーマッター
    - [ ] .editorconfigの作成
- [ ] **ターミナル環境の構築**
  - [ ] Zsh設定の拡充
    - [ ] コマンド履歴検索機能
    - [ ] 推奨プラグインの統合
  - [ ] Starship設定の追加
    - [ ] 基本設定ファイル（Linux/macOS/Windows）
    - [ ] Git統合
    - [ ] 言語バージョン表示
    - [ ] フォーマットカスタマイズ
    - [ ] 右プロンプト設定
    - [ ] 各種モジュール設定
  - [ ] WezTerm設定の追加
    - [ ] 基本設定ファイル (wezterm.lua)
    - [ ] カラースキーム定義 (colors.lua)
    - [ ] カスタムタブバー実装
    - [ ] ステータスバー実装
    - [ ] タブ・ペイン機能
- [ ] 完全なセットアップスクリプト
- [ ] バックアップ/復元機能

### Phase 3: 拡張機能
- [ ] CLIツール設定の追加
- [ ] アプリケーション設定の追加
- [ ] OS別の条件分岐実装
- [ ] 検証スクリプトの完成

### Phase 4: 品質向上
- [ ] ドキュメントの充実
- [ ] テストの実装
- [ ] CI/CDの構築
- [ ] エラーハンドリングの強化

### Phase 5: 最適化
- [ ] パフォーマンス最適化
- [ ] UX改善
- [ ] カスタマイズ機能の追加
- [ ] コミュニティフィードバック対応

---

## 📌 注意事項・制約事項

### 21. 既知の制約

1. **OS依存性**: 一部の設定はOS固有
   - i3, AutoKey: Linuxのみ
   - AutoHotkey, PowerToys: Windowsのみ
   - 一部のシェル機能: Unix系のみ
2. **権限**: 一部のインストールに管理者権限が必要
   - Linux/macOS: sudo権限
   - Windows: 管理者権限（PowerShell実行ポリシー変更等）
3. **ネットワーク**: 初回セットアップ時にインターネット接続が必要
4. **ディスク容量**: プラグイン等のインストールに十分な容量が必要
5. **Windows制約**:
   - シンボリックリンク作成に開発者モードまたは管理者権限が必要
   - パス長制限（260文字）の問題がある場合がある
   - 改行コード（CRLF vs LF）の違いに注意が必要

### 22. 将来的な拡張案

- [ ] GUI設定ツールの開発
- [ ] Webベースのカスタマイズツール
- [ ] dotfiles同期機能（複数マシン間）
- [ ] プロファイル機能（仕事用/個人用等）
- [ ] プラグインシステムの実装
- [ ] クロスプラットフォーム設定の自動変換
- [ ] Windows Subsystem for Android (WSA) 対応

---

## 🔄 更新履歴

| 日付 | バージョン | 変更内容 | 担当者 |
|------|-----------|---------|--------|
| 2026-01-11 | 0.6.0 | クリーニング・バックアップ・復元機能の要件追加 | - |
| 2026-01-11 | 0.5.1 | AstroNvim GitHubリポジトリ参照の追加、Windows手順の明記 | - |
| 2026-01-11 | 0.5.0 | AstroNvim v5.0公式ドキュメント準拠、インストール手順の詳細化 | - |
| 2026-01-11 | 0.4.2 | Neovimキーバインディング設計の詳細化と参考記事の追加 | - |
| 2026-01-11 | 0.4.1 | AstroNvim v4.0の詳細機能と参考記事の追加 | - |
| 2026-01-11 | 0.4.0 | AstroNvimとClaude Code併用の要件追加、エディタ環境の明確化 | - |
| 2026-01-11 | 0.3.1 | Starshipの詳細カスタマイズ例とWindows対応の追加 | - |
| 2026-01-11 | 0.3.0 | Zsh/Starship/WezTermの統合設定例と推奨プラグインの追加 | - |
| 2026-01-11 | 0.2.1 | WezTerm設定の詳細化と参考実装の追加 | - |
| 2026-01-11 | 0.2.0 | Windows対応の追加 | - |
| 2026-01-11 | 0.1.0 | 初版作成 | - |

---

## ✅ レビュー・承認

- [ ] 要件レビュー完了
- [ ] 技術的実現可能性確認
- [ ] 優先順位の合意
- [ ] 実装開始承認

---

## 📎 参考リンク

### 公式ドキュメント

#### AstroNvim
- [AstroNvim GitHub](https://github.com/AstroNvim/AstroNvim) - 公式リポジトリ（⭐14k+、最新バージョン・リリース情報）
- [AstroNvim Documentation](https://docs.astronvim.com/) - 公式ドキュメント（v5.x対応）
- [AstroNvim Template](https://github.com/AstroNvim/template) - 公式テンプレート
- [AstroCommunity](https://github.com/AstroNvim/astrocommunity) - コミュニティプラグイン仕様

#### その他ツール
- [WezTerm Documentation](https://wezfurlong.org/wezterm/)
- [Starship Documentation](https://starship.rs/)
- [Sheldon Plugin Manager](https://sheldon.cli.rs/)
- [Zsh Documentation](https://www.zsh.org/)

### 参考実装・設定例

#### Neovim / AstroNvim
- [ターミナルがダサいとモテない - Neovim + AstroNvim v4.0 紹介編](https://medium.com/@yusuke_h/%E3%82%BF%E3%83%BC%E3%83%9F%E3%83%8A%E3%83%AB%E3%81%8C%E3%83%80%E3%82%B5%E3%81%84%E3%81%A8%E3%83%A2%E3%83%86%E3%81%AA%E3%81%84-neovim-astronvim-v4-0%E7%B4%B9%E4%BB%8B%E7%B7%A8-a8beeca5f2c8) - AstroNvim v4.0の詳細な紹介（UI/UX、LSP統合、Git統合、プラグイン設定）
- [私の為のNvChadのキーマッピングガイド 2026年版](https://syu-m-5151.hatenablog.com/entry/2026/01/03/002621) - 実用的なキーバインド設計の参考（Snacks.nvim, Telescope, LSP, Git操作、ウィンドウ管理等）

#### 統合設定
- [zsh + Starship + WezTermで最強のターミナル環境を構築する](https://zenn.dev/botamotch/articles/e7960f0dc84d8b) - Zsh、Starship、WezTermの統合設定例（コマンド履歴検索、タブ・ペイン機能、キーバインディング）

#### Starship
- [【starship】ターミナルをかっこよく](https://qiita.com/darallium/items/0e3669c54e71d0826418) - Starshipの詳細なカスタマイズ例（format設定、右プロンプト、各種モジュール、Windows対応）

#### WezTerm
- [gsuuon's WezTerm Config](https://gist.github.com/gsuuon/5511f0aa10c10c6cbd762e0b3e596b71) - スタイリッシュなWezTerm設定（カラースキーム、タブバー、ステータスバー）

### 推奨プラグイン
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - コマンドのシンタックスハイライト
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) - 履歴ベースの自動補完提案
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) - 部分文字列による履歴検索

---

**このドキュメントは随時更新されます。新しい要件や変更があれば、このファイルに追記してください。**
