# フォントインストールガイド

このdotfilesでは、[HackGen](https://github.com/yuru7/HackGen)フォントを推奨しています。

## HackGenについて

HackGenは、プログラミング向け英文フォント**Hack**と、源ノ角ゴシックの派生フォント**源柔ゴシック**を合成したプログラミングフォントです。

### 特徴

- 📏 **文字幅比率**: 半角1:全角2（通常版）または 半角3:全角5（HackGen35版）
- 🔤 **読みやすい英字**: Hack由来のしっとりとした印象の英字
- 📖 **引き締まった日本語**: 源柔ゴシック由来の丸ゴシック風合いのカナ文字・漢字（第一～第四水準漢字まで対応）
- 🔍 **可視化機能**: 全角スペースの可視化、パイプ記号 `|` の破断線化
- ⚡ **Powerline対応**: Powerline記号の表示
- 🎨 **判読性向上**: 濁点・半濁点を大きく、長音記号と漢数字の1を区別しやすく

### フォントファミリー

| フォント名 | 説明 |
|---------|------|
| **HackGen** | 文字幅比率「半角1:全角2」の通常版 |
| **HackGen Console** | Hackベースの字体を全て適用。記号類が半角で表示される |
| **HackGen35** | 文字幅比率「半角3:全角5」。英数字が通常版より大きく表示される |
| **HackGen35 Console** | HackGen Console の文字幅比率を半角3:全角5にした版 |
| **HackGen NF** | HackGen に Nerd Fonts を追加合成した版 |
| **HackGen35 NF** | HackGen35 に Nerd Fonts を追加合成した版 |

## インストール方法

### macOS

#### Homebrew経由（推奨）

```bash
# Homebrew Caskでインストール
brew install font-hackgen
brew install font-hackgen-nerd  # Nerd Fonts版
```

#### 手動インストール

1. [リリースページ](https://github.com/yuru7/HackGen/releases)から最新版をダウンロード
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
wget https://github.com/yuru7/HackGen/releases/latest/download/HackGen_*.zip
unzip HackGen_*.zip
rm HackGen_*.zip

# フォントキャッシュを更新
fc-cache -fv
```

#### Arch Linux

```bash
# AURからインストール
yay -S ttf-hackgen
# または
paru -S ttf-hackgen
```

### Windows

#### Chocolatey経由（推奨）

```powershell
# Chocolateyでインストール
choco install font-hackgen
choco install font-hackgen-nerd  # Nerd Fonts版
```

#### 手動インストール

1. [リリースページ](https://github.com/yuru7/HackGen/releases)から最新版をダウンロード
2. zipファイルを解凍
3. `.ttf`ファイルを右クリック
4. 「すべてのユーザーに対してインストール」を選択

## バリエーション

このdotfilesでは、以下の優先順位でフォントを使用します：

1. **HackGen** - 通常版（半角1:全角2）、バランスの良いスタイル
2. **HackGen35** - 半角3:全角5版、英数字が大きめで読みやすい
3. **HackGen Console** - 記号類を半角で表示したい場合
4. **HackGen35 Console** - HackGen35 + Console版

### Nerd Fonts版

ターミナルでアイコンを表示したい場合は、Nerd Fonts版をインストールしてください：

- `HackGen NF` - Nerd Fontsパッチ適用版
- `HackGen35 NF` - 半角3:全角5幅 + Nerd Fonts

## 設定の反映

### WezTerm

フォント設定は`wezterm/.config/wezterm/wezterm.lua`に記述されています。

```lua
config.font = wezterm.font_with_fallback({
	"HackGen",
	"HackGen35",
	"HackGen NF",
	"HackGen35 NF",
	-- フォールバック
	"JetBrains Mono",
	-- ...
})
```

### Neovim

Neovimはターミナルのフォント設定を使用します。GUIバージョン（Neovide等）を使用する場合は、`nvim/.config/nvim/lua/plugins/ui.lua`で設定できます。

## インストール確認

### macOS

```bash
# インストール済みフォントを確認
fc-list | grep -i hackgen
# または
system_profiler SPFontsDataType | grep -i hackgen
```

### Linux

```bash
# インストール済みフォントを確認
fc-list | grep -i hackgen
```

### Windows

```powershell
# PowerShellで確認
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' | Select-String -Pattern 'HackGen'
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
   fc-list | grep -i hackgen
   ```

### 日本語が表示されない

HackGenには日本語グリフが含まれているため、通常は問題ありません。それでも表示されない場合：

1. フォールバックフォントの確認
2. ターミナルのロケール設定を確認（UTF-8であること）

### リガチャ（合字）が効かない

WezTermの設定で有効化されています：

```lua
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
```

## 参考リンク

- [HackGen GitHub](https://github.com/yuru7/HackGen)
- [Hack（元フォント）](https://github.com/source-foundry/Hack)
- [源柔ゴシック（日本語部分）](https://github.com/adobe-fonts/source-han-sans)
- [Nerd Fonts](https://www.nerdfonts.com/)

## その他の推奨フォント

HackGenが利用できない場合のフォールバック：

- **JetBrains Mono** - 無料、リガチャ対応
- **Hack** - オープンソース、可読性重視
- **Fira Code** - リガチャが豊富
- **Source Code Pro** - Adobe製、クリーンなデザイン

---

## Moralerspaceについて（参考）

以前は[Moralerspace](https://github.com/yuru7/moralerspace)フォントを推奨していましたが、現在はHackGenを推奨しています。

Moralerspaceは、欧文フォント**Monaspace**と日本語フォント**IBM Plex Sans JP**を合成したプログラミング向けフォントです。

### Moralerspaceの特徴

- ✨ **Texture healing システム**搭載（GitHub製Monaspace由来）
- 📖 文字の懐が広く読みやすい日本語文字
- 📏 半角3:全角5の幅比率（ゆとりのある半角英数字）
- 🔍 全角スペースが可視化される
- 🎨 5つのバリエーション（Neon, Argon, Xenon, Radon, Krypton）

### Moralerspaceのインストール

#### macOS (Homebrew)

```bash
brew tap homebrew/cask-fonts
brew install font-moralerspace
brew install font-moralerspace-nerd-font  # Nerd Fonts版
```

#### Linux (Ubuntu/Debian)

```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/yuru7/moralerspace/releases/latest/download/Moralerspace_v2.0.0.zip
unzip Moralerspace_v2.0.0.zip
rm Moralerspace_v2.0.0.zip
fc-cache -fv
```

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
