# Dotfiles

開発環境の設定ファイル集（dotfiles）。wezterm + nvim 環境を一から整えるためのリポジトリです。

## 📁 プロジェクト構造

```
dotfiles/
├── scripts/
│   ├── setup.sh                    # メインセットアップスクリプト
│   └── verify-setup.sh             # セットアップ検証スクリプト
├── zsh/                            # Zsh設定
│   ├── zshrc                       # メインZsh設定
│   └── sheldon/                    # Sheldonプラグイン設定
└── README.md                       # このファイル
```

## 🚀 セットアップ

```bash
# リポジトリクローン
git clone https://github.com/your-repo/dotfiles.git
cd dotfiles

# 基本的な設定ファイルのみコピー（デフォルト）
./scripts/setup.sh

# フルセットアップ
./scripts/setup.sh --full

# 個別コンポーネント
./scripts/setup.sh starship-only    # Starshipのみ
```

## 📦 含まれる設定

- **Zsh**: モダンなシェル設定（sheldon、プラグイン、エイリアス）
- **Starship**: プロンプト設定（オプション）

## 🤝 貢献

改善のための Issue や Pull Request を歓迎します。

## 📄 ライセンス

MIT License - 詳細は [LICENSE](LICENSE) ファイルを参照してください。
