# Dotfiles プロジェクト実装計画

## 📋 概要

このドキュメントは、dotfilesプロジェクトの具体的な実装計画とタスクリストです。
要件定義書（`docs/requirements/first-requirement.md`）に基づいて、実装可能な順序でタスクを整理しています。

---

## 🎯 実装の優先順位

### Phase 1: 基礎インフラ構築（Week 1-2）
クリーニング、バックアップ、基本スクリプトの整備

### Phase 2: コアツール設定（Week 3-4）
AstroNvim、Zsh、WezTerm、Starshipの設定

### Phase 3: 統合と最適化（Week 5-6）
Claude Code統合、CLIツール、アプリケーション設定

### Phase 4: ドキュメントとテスト（Week 7-8）
ドキュメント整備、テスト、CI/CD構築

---

## 📅 Phase 1: 基礎インフラ構築（Week 1-2）

### Week 1: クリーニング・バックアップ機能

#### Day 1-2: プロジェクト構造の整備
- [ ] ディレクトリ構造の作成
  ```bash
  mkdir -p docs/{requirements,guides}
  mkdir -p scripts/utils
  mkdir -p {nvim,zsh,wezterm,starship,cursor,cli-tools,apps}/{.config,}
  mkdir -p backups
  echo "*" > backups/.gitignore
  echo "!.gitignore" >> backups/.gitignore
  ```
- [ ] `.gitignore`の設定
  - `backups/`を除外
  - OS固有ファイルを除外（`.DS_Store`, `Thumbs.db`等）
  - エディタ一時ファイルを除外
- [ ] `README.md`の更新
  - プロジェクト概要
  - クイックスタートガイド
  - ディレクトリ構造の説明

#### Day 3-4: ユーティリティ関数の実装
- [ ] `scripts/utils/common.sh`
  ```bash
  # 共通関数
  - log_info()    # 情報ログ
  - log_success() # 成功ログ
  - log_error()   # エラーログ
  - log_warn()    # 警告ログ
  - confirm()     # 確認プロンプト
  - check_command() # コマンド存在確認
  ```
- [ ] `scripts/utils/common.ps1`（Windows版）
- [ ] `scripts/utils/os-detect.sh`
  ```bash
  - detect_os()        # OS検出
  - detect_package_manager() # パッケージマネージャ検出
  - get_config_dir()   # 設定ディレクトリ取得
  ```
- [ ] `scripts/utils/logger.sh`
  ```bash
  - setup_logging()    # ログ初期化
  - log_to_file()      # ファイル出力
  - rotate_logs()      # ログローテーション
  ```
- [ ] `scripts/utils/backup.sh`
  ```bash
  - create_backup()    # バックアップ作成
  - list_backups()     # バックアップ一覧
  - get_backup_path()  # バックアップパス取得
  - create_manifest()  # マニフェスト作成
  ```

#### Day 5-7: クリーニングスクリプトの実装
- [ ] `scripts/clean.sh`（Linux/macOS）
  ```bash
  # 機能実装
  - parse_arguments()     # 引数解析
  - dry_run_mode()        # ドライラン
  - backup_before_clean() # クリーニング前バックアップ
  - clean_nvim()          # Neovim設定削除
  - clean_shell()         # シェル設定削除
  - clean_terminal()      # ターミナル設定削除
  - clean_cli_tools()     # CLIツール設定削除
  - clean_all()           # 全削除
  - show_summary()        # サマリー表示
  ```
- [ ] `scripts/clean.ps1`（Windows）
- [ ] テストケース作成
  - ドライランモードのテスト
  - バックアップ作成のテスト
  - 個別クリーニングのテスト

### Week 2: バックアップ・復元機能

#### Day 1-3: 復元スクリプトの実装
- [ ] `scripts/restore.sh`（Linux/macOS）
  ```bash
  # 機能実装
  - list_backups()        # バックアップ一覧表示
  - select_backup()       # バックアップ選択
  - validate_backup()     # バックアップ検証
  - restore_nvim()        # Neovim復元
  - restore_shell()       # シェル復元
  - restore_terminal()    # ターミナル復元
  - restore_all()         # 全復元
  - verify_restore()      # 復元検証
  ```
- [ ] `scripts/restore.ps1`（Windows）
- [ ] バックアップマニフェストのJSON形式定義
  ```json
  {
    "timestamp": "2026-01-11T14:30:22Z",
    "os": "darwin",
    "components": {
      "nvim": { "path": "~/.config/nvim", "size": "1.2MB" },
      "zsh": { "path": "~/.zshrc", "size": "15KB" }
    }
  }
  ```

#### Day 4-5: 基本セットアップスクリプトの骨組み
- [ ] `scripts/setup.sh`（Linux/macOS）
  ```bash
  # 基本構造
  - check_requirements()  # 必須要件確認
  - install_dependencies() # 依存関係インストール
  - setup_nvim()          # Neovim設定
  - setup_shell()         # シェル設定
  - setup_terminal()      # ターミナル設定
  - setup_all()           # 全設定
  - post_install()        # インストール後処理
  ```
- [ ] `scripts/setup.ps1`（Windows）
- [ ] ヘルプメッセージの実装

#### Day 6-7: 検証スクリプトの実装
- [ ] `scripts/verify-setup.sh`
  ```bash
  # 検証項目
  - verify_files_exist()      # ファイル存在確認
  - verify_symlinks()         # シンボリックリンク確認
  - verify_commands()         # コマンド確認
  - verify_config_syntax()    # 設定ファイル構文確認
  - generate_report()         # レポート生成
  ```
- [ ] `scripts/verify-setup.ps1`（Windows）
- [ ] レポート出力フォーマットの設計

---

## 📅 Phase 2: コアツール設定（Week 3-4）

### Week 3: Zsh + Starship設定

#### Day 1-2: Zsh基本設定
- [ ] `zsh/zshrc`の作成
  ```bash
  # 基本設定
  - 環境変数設定
  - PATH設定
  - エイリアス定義
  - コマンド履歴設定（検索機能）
  - プラグインマネージャ（Sheldon）初期化
  ```
- [ ] `zsh/zshenv`の作成
  - グローバル環境変数
  - XDG Base Directory設定
- [ ] `zsh/zprofile`の作成
  - ログイン時の設定

#### Day 3-4: Sheldonプラグイン設定
- [ ] `zsh/sheldon/plugins.toml`の作成
  ```toml
  # 推奨プラグイン
  [plugins.zsh-syntax-highlighting]
  [plugins.zsh-autosuggestions]
  [plugins.zsh-history-substring-search]
  ```
- [ ] Sheldon自動インストールスクリプト
- [ ] プラグイン設定のドキュメント作成

#### Day 5-7: Starship設定
- [ ] `starship/.config/starship.toml`の作成
  ```toml
  # 基本設定
  - format設定
  - 各種モジュール設定
  - Git統合
  - 言語バージョン表示
  - カスタムシンボル
  ```
- [ ] OS別設定の分岐実装
  - Linux/macOS: `~/.config/starship.toml`
  - Windows: `%APPDATA%\starship.toml`
- [ ] Starship自動インストールスクリプト
- [ ] 設定例のドキュメント作成

### Week 4: WezTerm + AstroNvim設定

#### Day 1-3: WezTerm設定
- [ ] `wezterm/.config/wezterm/wezterm.lua`の作成
  ```lua
  -- 基本設定
  - フォント設定（Nerd Fonts）
  - カラースキーム
  - ウィンドウ設定
  - タブバー設定
  - キーバインディング
  - OS別設定分岐
  ```
- [ ] `wezterm/.config/wezterm/colors.lua`の作成
  - カスタムカラースキーム定義
  - ランダムカラー機能
- [ ] WezTermインストールスクリプト
  - macOS: Homebrew
  - Linux: パッケージマネージャ
  - Windows: Scoop/Chocolatey/winget

#### Day 4-7: AstroNvim設定
- [ ] AstroNvim Template構造の作成
  ```
  nvim/
  ├── init.lua
  └── lua/
      ├── community.lua
      ├── lazy_setup.lua
      └── plugins/
          ├── astrocore.lua
          ├── astrolsp.lua
          ├── astroui.lua
          ├── mason.lua
          ├── none-ls.lua
          ├── treesitter.lua
          └── user.lua
  ```
- [ ] `nvim/lua/plugins/astrocore.lua`
  - キーバインディング設定
  - オプション設定
- [ ] `nvim/lua/plugins/astrolsp.lua`
  - LSP設定
  - フォーマッター設定
- [ ] `nvim/lua/plugins/astroui.lua`
  - UI/UX設定
  - テーマ設定
- [ ] `nvim/lua/plugins/mason.lua`
  - LSPサーバー自動インストール設定
- [ ] `nvim/lua/community.lua`
  - AstroCommunityプラグイン設定
  - 言語パック設定
- [ ] AstroNvimインストールスクリプト
  - 必須要件確認
  - Template自動クローン
  - 初回セットアップ

---

## 📅 Phase 3: 統合と最適化（Week 5-6）

### Week 5: Claude Code統合とCLIツール

#### Day 1-3: Claude Code (Cursor) 設定
- [ ] `cursor/settings.json`の作成
  ```json
  {
    "editor.fontFamily": "...",
    "editor.fontSize": 14,
    "workbench.colorTheme": "...",
    // AI設定
    // LSP設定
  }
  ```
- [ ] `cursor/keybindings.json`の作成
  - AstroNvimと共通のキーバインド哲学
- [ ] `cursor/snippets/`の作成
  - 言語別スニペット
- [ ] `cursor/.cursorrules.example`の作成
  - プロジェクト用AIルールテンプレート
- [ ] 推奨拡張機能リストの作成
- [ ] `.editorconfig`の作成
  - AstroNvimとCursorで共通の設定

#### Day 4-7: CLIツール設定
- [ ] `cli-tools/tmux.conf`
  - 基本設定
  - キーバインディング
  - プラグイン設定
- [ ] `cli-tools/gitconfig`
  ```ini
  [user]
  [core]
  [alias]
  [diff]
  [merge]
  ```
- [ ] `cli-tools/gitignore_global`
  - OS別除外設定
  - エディタ一時ファイル
- [ ] その他CLIツール設定
  - `gdbinit`
  - `vimrc`（フォールバック用）
  - `ripgreprc`
  - `curlrc`
  - `wgetrc`

### Week 6: アプリケーション設定とOS別対応

#### Day 1-3: Linux専用設定
- [ ] `apps/i3/config`
  - i3ウィンドウマネージャ設定
- [ ] `apps/autokey/`
  - AutoKey設定
- [ ] Linux固有のセットアップスクリプト

#### Day 4-5: Windows専用設定
- [ ] `apps/windows-terminal/settings.json`
  - Windows Terminal設定
- [ ] `apps/autohotkey/`
  - AutoHotkeyスクリプト
- [ ] `apps/powertoys/`
  - PowerToys設定
- [ ] `powershell/Microsoft.PowerShell_profile.ps1`
  - PowerShellプロファイル
- [ ] Clink設定（Starship統合）
- [ ] Windows固有のセットアップスクリプト

#### Day 6-7: macOS専用設定
- [ ] macOS固有の設定
- [ ] Homebrew Bundle設定
- [ ] macOS defaults設定

---

## 📅 Phase 4: ドキュメントとテスト（Week 7-8）

### Week 7: ドキュメント整備

#### Day 1-2: セットアップガイド
- [ ] `docs/setup-guide.md`
  ```markdown
  # 詳細セットアップガイド
  - 前提条件
  - インストール手順
  - 設定のカスタマイズ
  - トラブルシューティング
  ```
- [ ] `docs/setup-guide-windows.md`
  - Windows専用ガイド
  - WSL2セットアップ
  - PowerShell設定

#### Day 3-4: カスタマイズガイド
- [ ] `docs/customization.md`
  ```markdown
  # カスタマイズガイド
  - キーバインディングのカスタマイズ
  - テーマのカスタマイズ
  - プラグインの追加
  - 言語サポートの追加
  ```
- [ ] `docs/keybindings.md`
  - 全キーバインド一覧
  - カテゴリ別整理

#### Day 5-7: トラブルシューティングとFAQ
- [ ] `docs/troubleshooting.md`
  ```markdown
  # トラブルシューティング
  - よくある問題と解決方法
  - ログの確認方法
  - デバッグ方法
  ```
- [ ] `docs/troubleshooting-windows.md`
  - Windows固有の問題
- [ ] `docs/faq.md`
  - よくある質問
  - Tips & Tricks

### Week 8: テストとCI/CD

#### Day 1-3: テストの実装
- [ ] シェルスクリプトのテスト（bats）
  ```bash
  # tests/clean.bats
  # tests/setup.bats
  # tests/restore.bats
  ```
- [ ] PowerShellスクリプトのテスト（Pester）
  ```powershell
  # tests/Clean.Tests.ps1
  # tests/Setup.Tests.ps1
  ```
- [ ] 設定ファイルの構文チェック
  - Lua: luacheck
  - TOML: taplo
  - JSON: jq

#### Day 4-5: CI/CD構築
- [ ] `.github/workflows/test.yml`
  ```yaml
  # テストワークフロー
  - Linux (Ubuntu)
  - macOS
  - Windows
  ```
- [ ] `.github/workflows/lint.yml`
  - ShellCheck
  - stylua
  - その他リンター
- [ ] `.github/workflows/docs.yml`
  - ドキュメント自動生成

#### Day 6-7: 最終調整とリリース準備
- [ ] `CHANGELOG.md`の作成
- [ ] `CONTRIBUTING.md`の作成
- [ ] `LICENSE`の確認
- [ ] README.mdの最終更新
- [ ] バージョンタグの設定
- [ ] リリースノートの作成

---

## 🔄 継続的な改善タスク

### 優先度: 高
- [ ] エラーハンドリングの強化
- [ ] ログ出力の改善
- [ ] パフォーマンス最適化
- [ ] ユーザーフィードバックの収集

### 優先度: 中
- [ ] 追加言語サポート
- [ ] プラグインの追加
- [ ] テーマバリエーションの追加
- [ ] ドキュメントの多言語化

### 優先度: 低
- [ ] GUI設定ツールの開発
- [ ] Webベースのカスタマイズツール
- [ ] dotfiles同期機能
- [ ] プロファイル機能

---

## 📊 進捗管理

### マイルストーン

| マイルストーン | 期限 | ステータス |
|--------------|------|-----------|
| Phase 1完了 | Week 2終了 | 🔄 進行中 |
| Phase 2完了 | Week 4終了 | ⏳ 未着手 |
| Phase 3完了 | Week 6終了 | ⏳ 未着手 |
| Phase 4完了 | Week 8終了 | ⏳ 未着手 |
| v1.0.0リリース | Week 8終了 | ⏳ 未着手 |

### 完了基準

各Phaseの完了基準：

**Phase 1:**
- [ ] クリーニングスクリプトが動作
- [ ] バックアップ・復元が動作
- [ ] 基本的なユーティリティ関数が実装済み

**Phase 2:**
- [ ] Zsh + Starshipが動作
- [ ] WezTermが設定済み
- [ ] AstroNvimがインストール・設定済み

**Phase 3:**
- [ ] Claude Code設定が完了
- [ ] CLIツール設定が完了
- [ ] OS別設定が完了

**Phase 4:**
- [ ] 全ドキュメントが完成
- [ ] テストが通過
- [ ] CI/CDが動作

---

## 🎯 次のアクション

### 今すぐ始めるべきタスク

1. **プロジェクト構造の作成**
   ```bash
   cd /Users/mine/development/dotfiles
   mkdir -p docs/{requirements,guides}
   mkdir -p scripts/utils
   mkdir -p {nvim,zsh,wezterm,starship,cursor,cli-tools,apps}
   mkdir -p backups
   ```

2. **ユーティリティ関数の実装開始**
   - `scripts/utils/common.sh`から着手
   - ログ機能の実装

3. **クリーニングスクリプトのプロトタイプ作成**
   - ドライランモードのみ実装
   - 削除対象の表示機能

---

## 📝 メモ

- 各スクリプトは必ずドライランモードでテストしてからコミット
- バックアップは必須機能として優先実装
- ドキュメントは実装と並行して作成
- テストは早期から導入

---

**最終更新日**: 2026-01-11
**バージョン**: 1.0.0
