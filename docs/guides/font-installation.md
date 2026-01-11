# フォントインストールガイド

このdotfilesでは、[Moralerspace](https://github.com/yuru7/moralerspace)フォントを推奨しています。

## Moralerspaceについて

Moralerspaceは、欧文フォント**Monaspace**と日本語フォント**IBM Plex Sans JP**を合成したプログラミング向けフォントです。

### 特徴

- ✨ **Texture healing システム**搭載（GitHub製Monaspace由来）
- 📖 文字の懐が広く読みやすい日本語文字
- 📏 半角3:全角5の幅比率（ゆとりのある半角英数字）
- 🔍 全角スペースが可視化される
- 🎨 5つのバリエーション（Neon, Argon, Xenon, Radon, Krypton）

## インストール方法

### macOS

#### Homebrew経由（推奨）

```bash
# Homebrew Caskでインストール
brew tap homebrew/cask-fonts
brew install font-moralerspace
brew install font-moralerspace-nerd-font  # Nerd Fonts版
```

#### 手動インストール

1. [リリースページ](https://github.com/yuru7/moralerspace/releases)から最新版をダウンロード
2. zipファイルを解凍
3. `.ttf`ファイルをダブルクリックしてFont Bookで開く
4. 「フォントをインストール」をクリック

### Linux

#### Ubuntu/Debian

```bash
# フォントディレクトリを作成
mkdir -p ~/.local/share/fonts

# ダウンロードと解凍
cd ~/.local/share/fonts
wget https://github.com/yuru7/moralerspace/releases/latest/download/Moralerspace_v2.0.0.zip
unzip Moralerspace_v2.0.0.zip
rm Moralerspace_v2.0.0.zip

# フォントキャッシュを更新
fc-cache -fv
```

#### Arch Linux

```bash
# AURからインストール
yay -S ttf-moralerspace
# または
paru -S ttf-moralerspace
```

### Windows

1. [リリースページ](https://github.com/yuru7/moralerspace/releases)から最新版をダウンロード
2. zipファイルを解凍
3. `.ttf`ファイルを右クリック
4. 「すべてのユーザーに対してインストール」を選択

## バリエーション

このdotfilesでは、以下の優先順位でフォントを使用します：

1. **Moralerspace Neon** - デフォルト、バランスの良いスタイル
2. **Moralerspace Argon** - シャープなスタイル
3. **Moralerspace Xenon** - 丸みのあるスタイル
4. **Moralerspace Radon** - 手書き風スタイル（Kiwi-Maru由来）
5. **Moralerspace Krypton** - スティック風スタイル（Stick由来）

### Nerd Fonts版

ターミナルでアイコンを表示したい場合は、Nerd Fonts版をインストールしてください：

- `MoralerspaceNF-*.ttf` - Nerd Fontsパッチ適用版
- `MoralerspaceHWNF-*.ttf` - 半角1:全角2幅 + Nerd Fonts

## 設定の反映

### WezTerm

フォント設定は`wezterm/.config/wezterm/wezterm.lua`に記述されています。

```lua
config.font = wezterm.font_with_fallback({
	{ family = "Moralerspace Neon", weight = "Regular" },
	-- ...
})
```

### Neovim

Neovimはターミナルのフォント設定を使用します。GUIバージョン（Neovide等）を使用する場合は、`nvim/.config/nvim/lua/plugins/ui.lua`で設定できます。

## インストール確認

### macOS

```bash
# インストール済みフォントを確認
fc-list | grep -i moralerspace
# または
system_profiler SPFontsDataType | grep -i moralerspace
```

### Linux

```bash
# インストール済みフォントを確認
fc-list | grep -i moralerspace
```

### Windows

```powershell
# PowerShellで確認
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' | Select-String -Pattern 'Moralerspace'
```

## トラブルシューティング

### フォントが表示されない

1. **フォントキャッシュの更新**
   ```bash
   # macOS/Linux
   fc-cache -fv
   ```

2. **ターミナルの再起動**
   - WezTermを完全に終了して再起動

3. **フォント名の確認**
   ```bash
   # 正確なフォント名を確認
   fc-list | grep -i moralerspace
   ```

### 日本語が表示されない

Moralerspaceには日本語グリフが含まれているため、通常は問題ありません。それでも表示されない場合：

1. フォールバックフォントの確認
2. ターミナルのロケール設定を確認（UTF-8であること）

### リガチャ（合字）が効かない

WezTermの設定で有効化されています：

```lua
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
```

## 参考リンク

- [Moralerspace GitHub](https://github.com/yuru7/moralerspace)
- [Monaspace（元フォント）](https://monaspace.githubnext.com/)
- [IBM Plex（日本語部分）](https://github.com/IBM/plex)
- [Nerd Fonts](https://www.nerdfonts.com/)

## その他の推奨フォント

Moralerspaceが利用できない場合のフォールバック：

- **JetBrains Mono** - 無料、リガチャ対応
- **Hack** - オープンソース、可読性重視
- **Fira Code** - リガチャが豊富
- **Source Code Pro** - Adobe製、クリーンなデザイン
