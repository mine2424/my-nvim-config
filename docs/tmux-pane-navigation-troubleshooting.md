# Tmuxペイン移動のトラブルシューティング

## 問題: Ctrl+h/j/k/lでペイン移動ができない

### 原因と解決策

#### 1. vim-tmux-navigatorプラグインがインストールされていない

**確認方法:**
```bash
ls ~/.tmux/plugins/vim-tmux-navigator
```

**解決策:**
```bash
# Tmux内で
# Prefix (Ctrl+A) + I を押してプラグインをインストール
```

または、tmuxの外から:
```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

#### 2. プラグインのスクリプトが実行されていない

**確認方法:**
```bash
# Tmux内で
tmux list-keys | grep "C-h\|C-j\|C-k\|C-l"
```

キーバインドが表示されない場合、プラグインのスクリプトが実行されていません。

**解決策:**
```bash
# Tmux内で設定をリロード
# Prefix (Ctrl+A) + r

# または、tmuxの外から
tmux source-file ~/.tmux.conf
```

#### 3. Neovim側の設定が正しくない

**確認方法:**
Neovim内で以下を実行:
```vim
:Lazy
```

`christoomey/vim-tmux-navigator`がインストールされているか確認。

**解決策:**
```vim
:Lazy sync
```

#### 4. WezTermがCtrl+h/j/k/lを先にキャッチしている

**確認方法:**
WezTermの設定ファイル (`~/.config/wezterm/wezterm.lua`) で、`Ctrl+h/j/k/l`が設定されていないか確認。

**解決策:**
WezTermの設定で、`Ctrl+h/j/k/l`を削除するか、tmuxに転送するように設定。

#### 5. プラグインのキーバインドが競合している

**確認方法:**
```bash
# Tmux内で
tmux list-keys | grep "C-h"
```

複数のキーバインドが表示される場合、競合している可能性があります。

**解決策:**
手動で設定したキーバインドを削除し、プラグインのキーバインドを使用する。

### デバッグ手順

1. **プラグインのインストール確認**
   ```bash
   ls ~/.tmux/plugins/vim-tmux-navigator
   ```

2. **プラグインのスクリプト確認**
   ```bash
   cat ~/.tmux/plugins/vim-tmux-navigator/vim-tmux-navigator.tmux
   ```

3. **キーバインド確認**
   ```bash
   # Tmux内で
   tmux list-keys | grep "C-h\|C-j\|C-k\|C-l"
   ```

4. **Neovim側の設定確認**
   ```vim
   :Lazy
   :checkhealth
   ```

5. **ログ確認**
   ```bash
   # Tmuxのログ
   tail -f ~/.tmux/tmux.log
   ```

### 手動でキーバインドを設定する場合

プラグインが動作しない場合、手動でキーバインドを設定できます:

```bash
# ~/.tmux.conf に追加
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

bind -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
```

### よくある問題

#### 問題: Neovim内でCtrl+h/j/k/lが動作しない

**原因:** Neovim側のキーバインドが設定されていない

**解決策:**
```vim
" Neovim内で確認
:Lazy
" vim-tmux-navigatorがインストールされているか確認
```

#### 問題: Tmux内でCtrl+h/j/k/lが動作しない

**原因:** プラグインのキーバインドが追加されていない

**解決策:**
```bash
# プラグインを再インストール
rm -rf ~/.tmux/plugins/vim-tmux-navigator
# Tmux内で
# Prefix (Ctrl+A) + I
```

#### 問題: WezTerm内でCtrl+h/j/k/lが動作しない

**原因:** WezTermがキーをキャッチしている

**解決策:**
WezTermの設定で、`Ctrl+h/j/k/l`を削除するか、tmuxに転送するように設定。

---

**最終更新**: 2026-01-XX
