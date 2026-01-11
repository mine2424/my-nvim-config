# カラースキーム統合ガイド

## 📋 概要

WezTerm、Tmux、Neovimの3つのレイヤーで統一されたカラースキームを実現するためのガイドです。

## 🎨 カラースキーム統合の課題

### 問題点

1. **WezTermの独自カラーパレット**
   - `config.colors`でターミナルカラー（ansi/brights）を設定
   - 全てのターミナルアプリケーションに影響

2. **Neovimのターミナルカラー**
   - `terminal_colors = true`でターミナルカラーを上書き
   - WezTermの設定と衝突する可能性

3. **Tmuxのカラー設定**
   - ステータスバー、ペインボーダーの色
   - True colorサポートが必要

### 衝突の例

```
WezTerm: background = "#282c34"
  ↓
Neovim: terminal_colors = true, background = "#1a1b26"
  ↓
結果: 背景色が不整合、テキストが読みにくい
```

## ✅ 推奨設定: Neovim優先モード

### 設計方針

- **Neovim**: カラースキームの主導権を持つ
- **WezTerm**: タブバーとウィンドウフレームのみカスタマイズ
- **Tmux**: Neovimのカラーに合わせる

### 1. Neovim設定

```lua
-- lua/plugins/colorscheme.lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,  -- 背景を表示
      terminal_colors = true,  -- ターミナルカラーを制御（重要！）
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats = "dark",
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
```

**ポイント:**
- `terminal_colors = true`: Neovimがターミナルカラーを制御
- `transparent = false`: 背景色を表示（WezTermの透明度は別途設定）

### 2. WezTerm設定

```lua
-- ~/.config/wezterm/wezterm.lua

-- ターミナルカラーはNeovimに任せる
config.colors = {
  -- ansi/brightsはコメントアウト（Neovimが制御）
  
  -- タブバーのみカスタマイズ（Tokyo Night Night風）
  tab_bar = {
    background = "#1a1b26",
    active_tab = {
      bg_color = "#7aa2f7",
      fg_color = "#1a1b26",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#292e42",
      fg_color = "#545c7e",
      intensity = "Half",
    },
  },
  split = "#3b4261",
}

-- 透明度設定
config.window_background_opacity = 0.85
config.macos_window_background_blur = 8
```

**ポイント:**
- `ansi`/`brights`を設定しない → Neovimに任せる
- タブバーとペイン分割線のみカスタマイズ

### 3. Tmux設定

```bash
# ~/.tmux.conf

# Tokyo Night Night カラー定義
bg_dark="#1a1b26"
bg="#24283b"
fg="#c0caf5"
blue="#7aa2f7"
cyan="#7dcfff"
green="#9ece6a"
magenta="#bb9af7"
red="#f7768e"
yellow="#e0af68"

# True color対応（必須）
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# ステータスバー
set -g status-style "bg=$bg,fg=$fg"

# ウィンドウステータス
setw -g window-status-style "fg=$fg,bg=$bg"
setw -g window-status-current-style "fg=$bg,bg=$blue,bold"

# ペインボーダー
set -g pane-border-style "fg=$bg"
set -g pane-active-border-style "fg=$blue"

# メッセージ
set -g message-style "fg=$bg,bg=$blue"
```

**ポイント:**
- Tokyo Night Nightのカラーコードを使用
- True color対応が必須（`tmux-256color` + `Tc`）

## 🔄 代替設定: 完全透過モード

### 設計方針

- **WezTerm**: カラーパレットを完全に定義
- **Neovim**: 透過モードで背景を表示しない
- **Tmux**: WezTermのカラーに合わせる

### 1. Neovim設定

```lua
{
  "folke/tokyonight.nvim",
  opts = {
    style = "night",
    transparent = true,  -- 完全透過
    terminal_colors = false,  -- WezTermのカラーを使用
  },
}
```

### 2. WezTerm設定

```lua
-- Tokyo Night Night カラーパレット（完全版）
config.colors = {
  foreground = "#c0caf5",
  background = "#1a1b26",
  cursor_bg = "#c0caf5",
  cursor_fg = "#1a1b26",
  cursor_border = "#c0caf5",
  selection_bg = "#283457",
  selection_fg = "#c0caf5",
  
  ansi = {
    "#15161e", -- black
    "#f7768e", -- red
    "#9ece6a", -- green
    "#e0af68", -- yellow
    "#7aa2f7", -- blue
    "#bb9af7", -- magenta
    "#7dcfff", -- cyan
    "#a9b1d6", -- white
  },
  brights = {
    "#414868", -- bright black
    "#f7768e", -- bright red
    "#9ece6a", -- bright green
    "#e0af68", -- bright yellow
    "#7aa2f7", -- bright blue
    "#bb9af7", -- bright magenta
    "#7dcfff", -- bright cyan
    "#c0caf5", -- bright white
  },
  
  tab_bar = {
    background = "#1a1b26",
    active_tab = {
      bg_color = "#7aa2f7",
      fg_color = "#1a1b26",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#292e42",
      fg_color = "#545c7e",
      intensity = "Half",
    },
  },
}
```

## 🧪 検証方法

### 1. カラーテスト

```bash
# ターミナルを起動
wezterm

# Tmuxを起動
tmux

# Neovimを起動
nvim

# カラーテストを実行
:so $VIMRUNTIME/syntax/hitest.vim
```

### 2. 256色テスト

```bash
# 全256色を表示
for i in {0..255}; do
  printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
done
```

### 3. True Colorテスト

```bash
# True colorが有効か確認
echo $COLORTERM  # truecolorと表示されるべき

# グラデーションテスト
awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
}'
```

### 4. チェックリスト

- [ ] Neovimの背景色が正しく表示される
- [ ] シンタックスハイライトが見やすい
- [ ] Tmuxのステータスバーが読める
- [ ] ペインボーダーが明確に見える
- [ ] タブバーの色が統一されている
- [ ] 透明度が適切（背景が見える）
- [ ] カーソルが見やすい
- [ ] 選択範囲が明確

## 🎨 カラースキーム一覧

### Tokyo Night

| バリエーション | 背景色 | 前景色 | 特徴 |
|--------------|--------|--------|------|
| **night** | `#1a1b26` | `#c0caf5` | 最も暗い（推奨） |
| **storm** | `#24283b` | `#c0caf5` | 中間の明るさ |
| **day** | `#e1e2e7` | `#3760bf` | ライトテーマ |
| **moon** | `#222436` | `#c8d3f5` | 青みがかった暗色 |

### Catppuccin

| バリエーション | 背景色 | 前景色 | 特徴 |
|--------------|--------|--------|------|
| **mocha** | `#1e1e2e` | `#cdd6f4` | 最も暗い |
| **macchiato** | `#24273a` | `#cad3f5` | 中間 |
| **frappe** | `#303446` | `#c6d0f5` | やや明るい |
| **latte** | `#eff1f5` | `#4c4f69` | ライトテーマ |

## 🔧 トラブルシューティング

### 問題1: 背景色が二重に表示される

**症状:** Neovimの背景とWezTermの背景が両方見える

**原因:** 両方で背景色を設定している

**解決策:**
```lua
-- Neovim
transparent = true  -- または

-- WezTerm
-- config.colors.background をコメントアウト
```

### 問題2: 色が正しく表示されない

**症状:** 色が16色しか表示されない

**原因:** True colorが有効になっていない

**解決策:**
```bash
# ~/.zshrc または ~/.bashrc
export COLORTERM=truecolor

# Tmux
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
```

### 問題3: Tmuxで色が変わる

**症状:** Tmux内とTmux外で色が違う

**原因:** Tmuxのterminal設定が不適切

**解決策:**
```bash
# ~/.tmux.conf
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
```

### 問題4: カーソルが見えない

**症状:** カーソルの色が背景と同化

**解決策:**
```lua
-- WezTerm
config.colors = {
  cursor_bg = "#ffcc00",  -- 目立つ色に変更
  cursor_fg = "#1a1b26",
  cursor_border = "#ffcc00",
}
```

## 📚 参考リソース

### カラースキーム

- [Tokyo Night](https://github.com/folke/tokyonight.nvim)
- [Catppuccin](https://github.com/catppuccin/nvim)
- [Nord](https://github.com/shaunsingh/nord.nvim)
- [Gruvbox](https://github.com/ellisonleao/gruvbox.nvim)

### ツール

- [WezTerm Color Schemes](https://wezfurlong.org/wezterm/colorschemes/index.html)
- [Tmux Themes](https://github.com/jimeh/tmux-themepack)
- [Neovim Colorscheme Gallery](https://vimcolorschemes.com/)

### カラーツール

- [Coolors](https://coolors.co/) - カラーパレット生成
- [Color Hex](https://www.color-hex.com/) - 色コード変換
- [Terminal.sexy](https://terminal.sexy/) - ターミナルカラースキーム作成

---

**最終更新:** 2026-01-11
