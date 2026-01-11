# Scripts Directory

このディレクトリには開発環境のセットアップと管理用のユーティリティスクリプトが含まれています。

## メインスクリプト

### setup.sh
開発環境のメインインストールスクリプト。
```bash
./setup.sh                # 設定ファイルのみコピー（デフォルト）
./setup.sh --full         # 完全インストール
./setup.sh --help         # すべてのオプションを表示
```

### verify-setup.sh
開発環境のセットアップを検証するスクリプト。
```bash
./verify-setup.sh    # すべての検証テストを実行
```

## スクリプトの整理

スクリプトは機能別に整理されています：
- **環境セットアップ**: setup.sh
- **検証**: verify-setup.sh
