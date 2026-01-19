# OpenCode + Z.AI セットアップガイド

## 📋 概要

このドキュメントでは、OpenCodeとZ.AIを開発環境に統合する方法を説明します。

OpenCodeは、Z.AIのGLMモデルを使用できる強力なAIコーディングエージェントです。このdotfilesプロジェクトでは、OpenCodeを効率的に使用するための設定とエイリアスを提供しています。

## 🚀 クイックスタート

### 1. OpenCodeのインストール

#### 自動インストール（推奨）

```bash
# dotfilesのセットアップスクリプトを実行
./scripts/install-neovim-tmux.sh
```

このスクリプトは、OpenCodeのインストールも自動的に行います。

#### 手動インストール

```bash
# インストールスクリプトを使用（推奨）
curl -fsSL https://opencode.ai/install | bash

# または npm を使用
npm install -g opencode-ai
```

### 2. Z.AI APIキーの取得

1. [Z.AI API Console](https://console.z.ai/) にアクセス
2. アカウントを作成またはログイン
3. APIキーを取得

**GLM Coding Plan** に加入している場合は、Coding Plan用のAPIキーを使用してください。

### 3. OpenCodeの認証

```bash
# 認証を開始
opencode auth login

# またはエイリアスを使用
ocl
```

認証プロセス：

1. **プロバイダーを選択**
   - `Z.AI` を選択（通常のAPIキー）
   - `Z.AI Coding Plan` を選択（GLM Coding Plan加入者）

2. **APIキーを入力**
   - 取得したZ.AI APIキーを入力

3. **完了**
   - 認証が完了すると、OpenCodeを使用できるようになります

### 4. モデルの選択

```bash
# OpenCodeを起動
opencode

# モデルを選択（OpenCode内で）
/models

# または起動時にモデルを指定
opencode --model GLM-4.7
```

利用可能なモデル：
- **GLM-4.7**（デフォルト、推奨）
- GLM-4
- GLM-4-Plus
- その他のGLMモデル

## 🎯 使い方

### 基本的な使い方

```bash
# OpenCodeを起動
opencode

# またはエイリアスを使用
oc
```

### エイリアス一覧

このdotfilesでは、以下のエイリアスを提供しています：

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `oc` | `opencode` | OpenCodeを起動 |
| `oca` | `opencode auth` | 認証コマンド |
| `ocl` | `opencode auth login` | 認証を開始 |
| `ocm` | `opencode models` | モデル一覧を表示 |
| `ocs` | `opencode share` | 会話を共有 |
| `ocus` | `opencode unshare` | 共有を解除 |

### 便利な関数

#### `ocq` - クイック起動（モデル指定）

```bash
# GLM-4.7で起動（デフォルト）
ocq

# 特定のモデルで起動
ocq GLM-4

# モデルと追加引数を指定
ocq GLM-4.7 "explain this code"
```

#### `ocf` - ファイルコンテキスト付き起動

```bash
# ファイルを指定してOpenCodeを起動
ocf src/main.rs

# ファイルと質問を指定
ocf src/main.rs "explain this code"
ocf package.json "what dependencies are used?"
```

#### `ocgh` - GitHub統合

```bash
# GitHubワークフローをインストール
ocgh install

# インストール後、GitHubのIssueやPRで使用可能
# Issueで: /opencode explain this issue
# Issueで: /opencode fix this
# PRで: /oc implement this feature
```

## 🛠️ 開発環境との統合

### ocdevスクリプト

`ocdev`スクリプトを使用すると、OpenCodeと開発環境を統合したワークフローを構築できます。

```bash
# 基本的な使い方
ocdev

# セッション名を指定
ocdev myproject

# ディレクトリを指定
ocdev myproject ~/code/myapp

# モデルを指定
ocdev --model GLM-4.7

# レイアウトを指定
ocdev --layout split    # 上下分割
ocdev --layout full     # フルスクリーン
ocdev --layout default  # 左右分割（デフォルト）
```

#### レイアウト

**default（デフォルト）**: 左右分割
```
┌──────────┬──────────┐
│ OpenCode │ Terminal │
│ (50%)    │ (50%)    │
└──────────┴──────────┘
```

**split**: 上下分割
```
┌──────────────┐
│ OpenCode     │
│ (50%)        │
├──────────────┤
│ Terminal     │
│ (50%)        │
└──────────────┘
```

**full**: フルスクリーン
```
┌──────────────┐
│              │
│ OpenCode     │
│ (100%)       │
│              │
└──────────────┘
```

### agentスクリプトとの併用

`agent`スクリプトで5分割レイアウトを作成し、その中の1つのペインでOpenCodeを起動することもできます。

```bash
# agentレイアウトを起動
agent myproject

# 任意のペインでOpenCodeを起動
opencode --model GLM-4.7
```

## 📚 高度な使い方

### 会話の共有

OpenCodeの会話を共有して、チームメンバーと協力できます。

```bash
# 会話を共有
/share

# またはエイリアス
ocs

# 共有を解除
/unshare

# またはエイリアス
ocus
```

共有された会話には、`opencode.ai/s/<share-id>` というURLが生成されます。

### IDE統合

OpenCodeは、VS Code、Cursor、WindsurfなどのIDEと統合できます。

#### インストール

1. VS CodeまたはCursorを開く
2. 統合ターミナルを開く
3. `opencode` を実行すると、自動的に拡張機能がインストールされます

#### 使い方

- **クイック起動**: `Cmd+Esc` (Mac) または `Ctrl+Esc` (Windows/Linux)
- **新規セッション**: `Cmd+Shift+Esc` (Mac) または `Ctrl+Shift+Esc` (Windows/Linux)
- **ファイル参照**: `Cmd+Option+K` (Mac) または `Alt+Ctrl+K` (Linux/Windows)
  - 例: `@File#L37-42` でファイルの特定行を参照

### GitHub統合

OpenCodeをGitHubワークフローに統合すると、IssueやPRでOpenCodeを使用できます。

#### セットアップ

```bash
# GitHubリポジトリで実行
ocgh install
```

このコマンドは以下を実行します：
1. GitHub Appのインストール
2. ワークフローファイルの作成
3. シークレットの設定

#### 使い方

**Issueで使用**:
```
/opencode explain this issue
/opencode fix this
```

**PRで使用**:
```
/oc implement this feature
/oc review this PR
```

OpenCodeは、新しいブランチを作成し、変更を実装して、PRを開きます。

## 🔧 設定とカスタマイズ

### 環境変数

OpenCodeの動作を環境変数でカスタマイズできます。

```bash
# デフォルトモデルを設定
export OPENCODE_DEFAULT_MODEL="GLM-4.7"

# 設定ファイルの場所を指定
export OPENCODE_CONFIG_DIR="$HOME/.config/opencode"
```

### 設定ファイル

OpenCodeの設定は `~/.opencode/config.json` に保存されます。

```json
{
  "provider": "zai",
  "model": "GLM-4.7",
  "apiKey": "..."
}
```

## 🐛 トラブルシューティング

### OpenCodeがインストールされない

```bash
# インストールスクリプトを直接実行
curl -fsSL https://opencode.ai/install | bash

# PATHを確認
echo $PATH | grep opencode

# 手動でPATHに追加（zshrcに追加済み）
export PATH="$HOME/.opencode/bin:$PATH"
```

### 認証エラー

```bash
# 認証を再実行
opencode auth login

# 認証情報を確認
opencode auth status

# 認証情報を削除して再認証
rm ~/.opencode/config.json
opencode auth login
```

### モデルが選択できない

```bash
# 利用可能なモデルを確認
opencode models

# モデルを明示的に指定
opencode --model GLM-4.7
```

### IDE統合が動作しない

```bash
# OpenCodeがインストールされているか確認
which opencode

# IDEを再起動
# VS Code/Cursorを完全に終了して再起動
```

## 📖 参考資料

- [OpenCode公式ドキュメント](https://opencode.ai/docs)
- [Z.AI DEVELOPER DOCUMENT](https://docs.z.ai/scenario-example/develop-tools/opencode)
- [OpenCode GitHub](https://github.com/sst/opencode)
- [Z.AI API Console](https://console.z.ai/)

## 🎉 次のステップ

1. **基本的な使い方をマスター**
   - `opencode` で起動
   - `/models` でモデルを選択
   - コード生成や質問を試す

2. **開発環境と統合**
   - `ocdev` スクリプトを試す
   - IDE統合をセットアップ
   - ファイル参照機能を使う

3. **チームと協力**
   - 会話を共有
   - GitHub統合をセットアップ
   - ワークフローを最適化

4. **高度な機能を探索**
   - MCPサーバーとの統合
   - カスタムプロンプト
   - ワークフローの自動化

---

**最終更新**: 2026-01-11
