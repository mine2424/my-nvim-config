# devコマンドのセットアップ

## 問題

`dev`コマンドを実行しても「command not found」となる。

## 原因

1. `dev`コマンドが`~/.local/bin`にインストールされていない
2. `~/.local/bin`がPATHに含まれていない
3. シェルを再起動していないため、PATH設定が反映されていない

## 解決方法

### 1. devコマンドをインストール

```bash
# devコマンドを~/.local/binにコピー
mkdir -p ~/.local/bin
cp ~/development/dotfiles/scripts/dev ~/.local/bin/dev
chmod +x ~/.local/bin/dev
```

### 2. PATHを確認

```bash
# ~/.local/binがPATHに含まれているか確認
echo $PATH | tr ':' '\n' | grep "\.local/bin"
```

含まれていない場合は、以下を実行：

```bash
# 一時的にPATHに追加（現在のセッションのみ）
export PATH="$HOME/.local/bin:$PATH"

# 永続的に追加（~/.zshrcまたは~/.zprofileに追加）
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

**注意**: dotfilesの`zsh/zprofile`には既に設定されているので、dotfilesを適用していれば不要です。

### 3. シェルを再起動

```bash
# シェルを再起動
exec $SHELL

# または新しいターミナルウィンドウを開く
```

### 4. 動作確認

```bash
# devコマンドが見つかるか確認
which dev
# 出力: /Users/yourusername/.local/bin/dev

# devコマンドを実行
dev --help
```

## クイックセットアップ（推奨）

以下のコマンドを一度に実行：

```bash
# 1. devコマンドをインストール
mkdir -p ~/.local/bin && \
cp ~/development/dotfiles/scripts/dev ~/.local/bin/dev && \
chmod +x ~/.local/bin/dev

# 2. dotfilesのzsh設定を適用（まだの場合）
cd ~/development/dotfiles
./scripts/sync.sh push --shell

# 3. シェルを再起動
exec $SHELL

# 4. 動作確認
dev --help
```

## トラブルシューティング

### devコマンドが見つからない

```bash
# devコマンドが存在するか確認
ls -la ~/.local/bin/dev

# 実行権限があるか確認
ls -l ~/.local/bin/dev
# -rwxr-xr-x と表示されるべき

# 実行権限を付与
chmod +x ~/.local/bin/dev
```

### PATHに~/.local/binが含まれていない

```bash
# 現在のPATHを確認
echo $PATH

# ~/.local/binを追加（一時的）
export PATH="$HOME/.local/bin:$PATH"

# 永続的に追加
# ~/.zshrcまたは~/.zprofileに以下を追加
export PATH="$HOME/.local/bin:$PATH"
```

### dotfilesのzsh設定を適用する

```bash
# zsh設定を適用
cd ~/development/dotfiles
./scripts/sync.sh push --shell

# シェルを再起動
exec $SHELL
```

### それでも動かない場合

```bash
# フルパスで実行してみる
~/.local/bin/dev --help

# または
/Users/$(whoami)/.local/bin/dev --help

# 動作する場合は、PATH設定の問題
```

## 自動セットアップスクリプトを使用

`install-neovim-tmux.sh`スクリプトは自動的に`dev`コマンドをインストールします：

```bash
cd ~/development/dotfiles
./scripts/install-neovim-tmux.sh
```

このスクリプトは以下を実行します：
1. Neovim、Tmuxのインストール
2. 必要なツール（ripgrep, fd, fzf等）のインストール
3. 設定ファイルのシンボリックリンク作成
4. **devコマンドのインストール**
5. プラグインの自動インストール

## 使用例

```bash
# 基本起動
dev

# レイアウト指定
dev --layout claude    # Claude Code併用（デフォルト）
dev --layout split     # 分割レイアウト
dev --layout full      # フルスクリーン

# セッション名指定
dev myproject

# ディレクトリ指定
dev myproject ~/code/myapp

# ヘルプ
dev --help
```

---

**最終更新**: 2026-01-11
