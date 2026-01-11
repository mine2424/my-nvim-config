# Neovim + Tmux + Claude Code 並列開発環境 要件定義書

## 📋 プロジェクト概要

### 目的
AstroNvimからシンプルなNeovim構成へ移行し、Tmuxによるターミナル多重化とClaude Code (Cursor)との並列開発を快適に行える開発環境を構築する。

### 背景
- **現状**: AstroNvimを使用しているが、重厚なフレームワークによる学習コストと設定の複雑さがある
- **課題**: 
  - AstroNvimの抽象化レイヤーにより、Neovimの基本動作の理解が難しい
  - Tmuxとの統合が不十分で、ターミナル多重化の恩恵を受けにくい
  - Claude Codeとの並列作業時に、それぞれの役割分担が曖昧
- **目標**: 
  - シンプルで理解しやすいNeovim設定
  - Tmuxによる効率的なワークスペース管理
  - Claude Codeとの明確な使い分けと連携

### スコープ
以下の構成要素を含む開発環境の構築：
1. **Neovim**: シンプルで拡張可能な設定（lazy.nvim使用）
2. **Tmux**: セッション管理とウィンドウ多重化
3. **Claude Code (Cursor)**: AI支援開発環境
4. **統合**: 3つのツール間のシームレスな連携

---

## 🎯 開発環境の使い分け戦略

### 1. Neovim（ターミナルベース・軽量エディタ）

#### 用途
- ⚡ **クイック編集**: 設定ファイル、スクリプト、ログファイルの編集
- 🖥️ **リモート作業**: SSHでのサーバー編集
- 📝 **テキスト処理**: マークダウン、ドキュメント作成
- 🔍 **コード確認**: ソースコードの閲覧、軽微な修正
- 🛠️ **システム管理**: dotfiles、シェルスクリプトの編集

#### 強み
- 起動が高速（<100ms）
- リソース消費が少ない
- Tmuxとの完璧な統合
- キーボード操作のみで完結
- SSHでの作業に最適

### 2. Tmux（ターミナルマルチプレクサ）

#### 用途
- 🪟 **ワークスペース管理**: プロジェクトごとのセッション作成
- 📊 **画面分割**: エディタ、ターミナル、ログ監視の同時表示
- 🔄 **セッション永続化**: 作業状態の保存と復元
- 🚀 **並列作業**: 複数のタスクを同時実行
- 📡 **リモート作業**: SSH接続が切れても作業継続

#### 強み
- セッションのデタッチ/アタッチ
- 複数ウィンドウ・ペインの管理
- スクリプトによる自動化
- リモート環境での作業継続性

### 3. Claude Code (Cursor)

#### 用途
- 🤖 **AI支援開発**: コード生成、リファクタリング、バグ修正
- 🏗️ **プロジェクト開発**: 大規模な機能追加、アーキテクチャ設計
- 🔍 **コードベース理解**: 既存コードの解析と説明
- 🐛 **デバッグ**: 複雑な問題の診断と解決
- 📚 **ドキュメント作成**: README、API仕様書の作成
- 🧪 **テスト作成**: ユニットテスト、統合テストの生成

#### 強み
- AIによるコード補完と生成
- コンテキスト理解に基づく提案
- 大規模コードベースの把握
- 自然言語でのコード操作
- GUI による視覚的な操作

### 4. 使い分けのワークフロー例

#### シナリオ1: 新機能開発
1. **Claude Code**: 機能設計、主要コードの生成
2. **Neovim + Tmux**: 細かい調整、設定ファイル編集、Git操作
3. **Tmux**: テスト実行、ログ監視、開発サーバー起動

#### シナリオ2: バグ修正
1. **Neovim + Tmux**: ログ確認、問題箇所の特定
2. **Claude Code**: 複雑なデバッグ、修正案の生成
3. **Neovim + Tmux**: 修正の適用、テスト実行

#### シナリオ3: リモート作業
1. **Tmux**: SSH接続、セッション作成
2. **Neovim**: サーバー上でのファイル編集
3. **Claude Code**: ローカルでのコード確認、ドキュメント作成

#### シナリオ4: 設定ファイル管理
1. **Neovim + Tmux**: dotfilesの編集、即座の反映確認
2. **Claude Code**: 複雑な設定の生成、ドキュメント作成

---

## 🔧 Neovim 設定要件

### 1. 設計哲学

#### 1.1 シンプルさ優先
- ✅ 最小限のプラグイン（20個以下を目標）
- ✅ 理解しやすい設定構造
- ✅ 標準機能の最大活用
- ❌ 過度な抽象化を避ける
- ❌ 使わない機能は入れない

#### 1.2 パフォーマンス重視
- ⚡ 起動時間 < 100ms
- ⚡ lazy loading の活用
- ⚡ 必要最小限のLSP設定
- ⚡ 軽量なプラグイン選択

#### 1.3 Tmuxとの統合
- 🔗 シームレスなペイン移動
- 🔗 クリップボード共有
- 🔗 一貫したキーバインディング
- 🔗 ビジュアルテーマの統一

### 2. ディレクトリ構造

```
~/.config/nvim/
├── init.lua                    # エントリーポイント
├── lua/
│   ├── config/
│   │   ├── options.lua         # Neovimオプション設定
│   │   ├── keymaps.lua         # キーマッピング
│   │   ├── autocmds.lua        # 自動コマンド
│   │   └── lazy.lua            # lazy.nvimブートストラップ
│   ├── plugins/
│   │   ├── colorscheme.lua     # カラースキーム
│   │   ├── treesitter.lua      # シンタックスハイライト
│   │   ├── lsp.lua             # LSP設定
│   │   ├── completion.lua      # 補完設定
│   │   ├── telescope.lua       # ファジーファインダー
│   │   ├── git.lua             # Git統合
│   │   ├── statusline.lua      # ステータスライン
│   │   ├── tmux.lua            # Tmux統合
│   │   └── ui.lua              # UI拡張
│   └── utils/
│       └── helpers.lua         # ヘルパー関数
└── after/
    └── ftplugin/               # ファイルタイプ別設定
        ├── lua.lua
        ├── python.lua
        ├── javascript.lua
        └── markdown.lua
```

### 3. プラグイン構成

#### 3.0 プラグイン一覧概要

**合計: 約30個のプラグイン**

| カテゴリ | プラグイン数 | 主要プラグイン |
|---------|------------|--------------|
| **コア** | 11個 | treesitter, mason, lspconfig, nvim-cmp, telescope |
| **言語別** | 9個 | typescript-tools, flutter-tools, rust-tools, go.nvim |
| **UI/UX** | 10個 | nvim-tree, which-key, lualine, indent-blankline |
| **カラースキーム** | 1-2個 | tokyonight (または catppuccin) |

**対応言語: 15言語**
- Web: JavaScript, TypeScript, HTML, CSS, React, Next.js
- モバイル: Dart, Flutter, Kotlin, Java, Swift
- システム: Rust, Go, C/C++
- スクリプト: Python, Ruby
- その他: Lua, Bash, JSON, YAML, Markdown

**主な機能:**
- ✅ LSP統合（全言語）
- ✅ 自動補完（全言語）
- ✅ シンタックスハイライト（Treesitter）
- ✅ フォーマット・Lint（言語別）
- ✅ Git統合
- ✅ ファジーファインダー
- ✅ Tmux統合

### 3. プラグインマネージャー: lazy.nvim

#### 3.1 lazy.nvimの特徴
- ⚡ **高速起動**: 遅延読み込み（lazy loading）による高速化
- 📦 **自動インストール**: 初回起動時に自動でプラグインをインストール
- 🔄 **自動更新**: プラグインの更新管理が簡単
- 🎨 **美しいUI**: プラグイン管理画面が見やすい
- 📊 **プロファイリング**: 起動時間の分析が可能
- 🔧 **設定の分離**: プラグインごとにファイルを分けて管理可能

#### 3.2 lazy.nvimのインストール

##### 3.2.1 ブートストラップコード
`~/.config/nvim/lua/config/lazy.lua`に以下を記述：

```lua
-- lazy.nvimのブートストラップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  -- lazy.nvimが存在しない場合は自動インストール
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- 安定版を使用
    lazypath,
  })
end

-- lazy.nvimをruntimepathに追加
vim.opt.rtp:prepend(lazypath)

-- プラグインのセットアップ
require("lazy").setup({
  -- プラグイン定義をインポート
  { import = "plugins" },
}, {
  -- lazy.nvimの設定
  defaults = {
    lazy = true, -- デフォルトで遅延読み込み
    version = false, -- 最新のgit commitを使用（version = "*"でリリース版）
  },
  install = {
    colorscheme = { "tokyonight", "habamax" }, -- インストール時のカラースキーム
  },
  checker = {
    enabled = true, -- 起動時に更新をチェック
    notify = false, -- 通知は無効
    frequency = 3600, -- チェック頻度（秒）
  },
  change_detection = {
    enabled = true, -- 設定ファイルの変更を自動検知
    notify = false, -- 通知は無効
  },
  performance = {
    rtp = {
      -- 無効化する標準プラグイン
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded", -- UIのボーダースタイル
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
```

##### 3.2.2 init.luaでの読み込み
`~/.config/nvim/init.lua`で読み込み：

```lua
-- Leader keyの設定（lazy.nvim読み込み前に設定）
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- 基本設定の読み込み
require("config.options")   -- Neovimオプション
require("config.lazy")      -- lazy.nvimのセットアップ
require("config.keymaps")   -- キーマッピング
require("config.autocmds")  -- 自動コマンド
```

#### 3.3 lazy.nvimの使い方

##### 3.3.1 基本コマンド
```vim
:Lazy              " lazy.nvimのUI を開く
:Lazy install      " プラグインをインストール
:Lazy update       " プラグインを更新
:Lazy sync         " install + update + clean
:Lazy clean        " 未使用のプラグインを削除
:Lazy check        " 更新をチェック
:Lazy log          " 更新ログを表示
:Lazy restore      " lockfileから復元
:Lazy profile      " プロファイル情報を表示
:Lazy debug        " デバッグ情報を表示
:Lazy help         " ヘルプを表示
```

##### 3.3.2 プラグイン定義の基本形式
```lua
-- 最小構成
{ "plugin/name" }

-- 設定付き
{
  "plugin/name",
  lazy = false,        -- 起動時に読み込む
  priority = 1000,     -- 読み込み優先度（高いほど先）
  dependencies = {     -- 依存プラグイン
    "other/plugin",
  },
  config = function()  -- 設定関数
    require("plugin").setup({})
  end,
}

-- イベントトリガー
{
  "plugin/name",
  event = "VeryLazy",  -- イベント発生時に読み込み
}

-- コマンドトリガー
{
  "plugin/name",
  cmd = "CommandName", -- コマンド実行時に読み込み
}

-- キーマップトリガー
{
  "plugin/name",
  keys = {
    { "<leader>f", "<cmd>Command<cr>", desc = "Description" },
  },
}

-- ファイルタイプトリガー
{
  "plugin/name",
  ft = { "lua", "python" }, -- 特定のファイルタイプで読み込み
}
```

##### 3.3.3 遅延読み込みのベストプラクティス
```lua
-- ❌ 悪い例：すべて即時読み込み
{
  "nvim-telescope/telescope.nvim",
  lazy = false,
}

-- ✅ 良い例：キーマップで遅延読み込み
{
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
  },
}

-- ❌ 悪い例：カラースキームを遅延読み込み
{
  "folke/tokyonight.nvim",
  lazy = true,
}

-- ✅ 良い例：カラースキームは即時読み込み
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme tokyonight]])
  end,
}
```

#### 3.4 プラグイン設定ファイルの構造

各プラグインを`~/.config/nvim/lua/plugins/`に分けて管理：

```
lua/plugins/
├── colorscheme.lua    # カラースキーム
├── treesitter.lua     # シンタックスハイライト
├── lsp.lua            # LSP設定
├── completion.lua     # 補完
├── telescope.lua      # ファジーファインダー
├── git.lua            # Git統合
├── statusline.lua     # ステータスライン
├── tmux.lua           # Tmux統合
└── ui.lua             # UI拡張
```

**例: `lua/plugins/colorscheme.lua`**
```lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
```

**例: `lua/plugins/telescope.lua`**
```lua
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = {
      { "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
  },
}
```

#### 3.5 lockfileによるバージョン管理

lazy.nvimは`lazy-lock.json`でプラグインのバージョンを管理：

```json
{
  "lazy.nvim": { "branch": "main", "commit": "abc123..." },
  "telescope.nvim": { "branch": "master", "commit": "def456..." },
  "nvim-treesitter": { "branch": "master", "commit": "ghi789..." }
}
```

**lockfileの活用：**
```bash
# lockfileをgit管理に含める（推奨）
git add lazy-lock.json
git commit -m "chore: update plugin versions"

# 別のマシンで同じバージョンを復元
nvim --headless "+Lazy restore" +qa
```

### 4. 必須プラグイン（最小構成）

#### 4.1 コアプラグイン（必須）
1. **nvim-treesitter** - シンタックスハイライト、コード理解
   ```lua
   {
     "nvim-treesitter/nvim-treesitter",
     build = ":TSUpdate",
     event = { "BufReadPost", "BufNewFile" },
   }
   ```

2. **nvim-lspconfig** - LSP設定の簡素化
   ```lua
   {
     "neovim/nvim-lspconfig",
     event = { "BufReadPre", "BufNewFile" },
     dependencies = {
       "williamboman/mason.nvim",
       "williamboman/mason-lspconfig.nvim",
     },
   }
   ```

3. **nvim-cmp** - 補完エンジン
   ```lua
   {
     "hrsh7th/nvim-cmp",
     event = "InsertEnter",
     dependencies = {
       "hrsh7th/cmp-nvim-lsp",     -- LSP補完
       "hrsh7th/cmp-buffer",        -- バッファ補完
       "hrsh7th/cmp-path",          -- パス補完
       "L3MON4D3/LuaSnip",          -- スニペットエンジン
       "saadparwaiz1/cmp_luasnip",  -- LuaSnip補完
     },
   }
   ```

4. **telescope.nvim** - ファジーファインダー
   ```lua
   {
     "nvim-telescope/telescope.nvim",
     cmd = "Telescope",
     dependencies = {
       "nvim-lua/plenary.nvim",
       {
         "nvim-telescope/telescope-fzf-native.nvim",
         build = "make",
       },
     },
   }
   ```

5. **gitsigns.nvim** - Git統合（変更表示、hunk操作）
   ```lua
   {
     "lewis6991/gitsigns.nvim",
     event = { "BufReadPre", "BufNewFile" },
   }
   ```

6. **lualine.nvim** - ステータスライン
   ```lua
   {
     "nvim-lualine/lualine.nvim",
     event = "VeryLazy",
     dependencies = { "nvim-tree/nvim-web-devicons" },
   }
   ```

7. **vim-tmux-navigator** - Tmuxペイン統合ナビゲーション
   ```lua
   {
     "christoomey/vim-tmux-navigator",
     lazy = false, -- Tmux統合のため即時読み込み
   }
   ```

#### 3.3 言語別プラグイン

8. **typescript-tools.nvim** - TypeScript/JavaScript拡張
   ```lua
   {
     "pmizio/typescript-tools.nvim",
     dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
     ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
   }
   ```

9. **flutter-tools.nvim** - Flutter開発支援
   ```lua
   {
     "akinsho/flutter-tools.nvim",
     ft = "dart",
     dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
   }
   ```

10. **rust-tools.nvim** - Rust開発支援
    ```lua
    {
      "simrat39/rust-tools.nvim",
      ft = "rust",
      dependencies = { "neovim/nvim-lspconfig" },
    }
    ```

11. **crates.nvim** - Cargo.toml サポート
    ```lua
    {
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
    }
    ```

12. **go.nvim** - Go開発支援
    ```lua
    {
      "ray-x/go.nvim",
      dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
      ft = { "go", "gomod" },
      build = ':lua require("go.install").update_all_sync()',
    }
    ```

13. **venv-selector.nvim** - Python仮想環境選択
    ```lua
    {
      "linux-cultist/venv-selector.nvim",
      ft = "python",
      dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    }
    ```

14. **nvim-jdtls** - Java開発支援
    ```lua
    {
      "mfussenegger/nvim-jdtls",
      ft = "java",
    }
    ```

15. **vim-rails** - Ruby on Rails支援
    ```lua
    {
      "tpope/vim-rails",
      ft = { "ruby", "eruby" },
    }
    ```

16. **nvim-ts-autotag** - HTML/JSX自動タグ閉じ
    ```lua
    {
      "windwp/nvim-ts-autotag",
      ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    }
    ```

#### 3.4 推奨プラグイン（オプション）

17. **nvim-tree.lua** - ファイルエクスプローラー（軽量）
    ```lua
    {
      "nvim-tree/nvim-tree.lua",
      cmd = { "NvimTreeToggle", "NvimTreeFocus" },
      keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
      },
      dependencies = { "nvim-tree/nvim-web-devicons" },
    }
    ```

18. **which-key.nvim** - キーバインディングヘルプ
    ```lua
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
    }
    ```

19. **Comment.nvim** - コメントアウト
    ```lua
    {
      "numToStr/Comment.nvim",
      keys = {
        { "gc", mode = { "n", "v" }, desc = "Comment toggle" },
        { "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
      },
    }
    ```

20. **nvim-autopairs** - 括弧自動補完
    ```lua
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
    }
    ```

21. **indent-blankline.nvim** - インデントガイド
    ```lua
    {
      "lukas-reineke/indent-blankline.nvim",
      event = { "BufReadPost", "BufNewFile" },
      main = "ibl",
    }
    ```

22. **toggleterm.nvim** - ターミナル統合（Tmux補完用）
    ```lua
    {
      "akinsho/toggleterm.nvim",
      cmd = { "ToggleTerm", "TermExec" },
      keys = {
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      },
    }
    ```

23. **trouble.nvim** - 診断表示の改善
    ```lua
    {
      "folke/trouble.nvim",
      cmd = { "Trouble", "TroubleToggle" },
      keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      },
    }
    ```

24. **mini.nvim** - 軽量ユーティリティ集
    ```lua
    {
      "echasnovski/mini.nvim",
      event = "VeryLazy",
      config = function()
        require("mini.surround").setup()  -- 囲み文字操作
        require("mini.ai").setup()        -- テキストオブジェクト拡張
      end,
    }
    ```

#### 3.5 カラースキーム（WezTerm統合）

> **⚠️ 重要**: WezTermとNeovimのカラースキームは統合設計が必要です。
> 
> **問題点:**
> - WezTermは独自のカラーパレット（`config.colors`）を持つ
> - Neovimは`terminal_colors = true`でターミナルカラーを上書きする
> - 両方が異なる色を設定すると、表示が不整合になる
>
> **解決策:**
> 1. Neovimで`transparent = true`を使用（背景透過）
> 2. Neovimの`terminal_colors = false`に設定（WezTermの色を尊重）
> 3. または、WezTermの`config.colors`を削除してNeovimに任せる（推奨）

##### 3.5.1 推奨設定: Neovimのカラースキームを優先

**Neovim側（tokyonight.nvim）**
```lua
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    transparent = false,  -- 背景を表示（WezTermの透明度は維持）
    terminal_colors = true,  -- ターミナルカラーを設定（Neovimが制御）
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      sidebars = "dark",
      floats = "dark",
    },
    sidebars = { "qf", "help", "terminal", "packer" },
    dim_inactive = false,
    lualine_bold = false,
    
    -- 言語別のハイライト設定
    on_highlights = function(hl, c)
      -- TypeScript/JavaScript
      hl.TSConstructor = { fg = c.blue }
      hl.TSKeywordFunction = { fg = c.magenta, style = { italic = true } }
      
      -- Rust
      hl.RustLifetime = { fg = c.orange }
      hl.RustMacro = { fg = c.cyan }
      
      -- Go
      hl.GoImport = { fg = c.blue }
      hl.GoPackage = { fg = c.magenta }
      
      -- Python
      hl.PythonDecorator = { fg = c.yellow }
      
      -- Dart/Flutter
      hl.DartKeyword = { fg = c.magenta, style = { italic = true } }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd([[colorscheme tokyonight]])
  end,
}
```

**WezTerm側（wezterm.lua）**
```lua
-- ========================================
-- カラースキーム設定（Neovim統合）
-- ========================================

-- オプション1: Neovimのカラースキームを優先（推奨）
-- config.colorsを設定しない、またはコメントアウト
-- Neovimが terminal_colors = true で制御

-- タブバーとウィンドウフレームのみカスタマイズ
config.colors = {
  -- ターミナルカラーはNeovimに任せる（コメントアウト）
  -- foreground = "#b9c0cb",
  -- background = "#282c34",
  -- ansi = { ... },
  -- brights = { ... },
  
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
    inactive_tab_hover = {
      bg_color = "#3b4261",
      fg_color = "#7aa2f7",
    },
    new_tab = {
      bg_color = "#1a1b26",
      fg_color = "#7aa2f7",
    },
  },
}

-- 透明度設定
config.window_background_opacity = 0.85
config.macos_window_background_blur = 8  -- 背景ブラー（macOS）
```

##### 3.5.2 代替設定: 完全透過モード

**Neovim側**
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

**WezTerm側**
```lua
-- Tokyo Night Night カラーパレット
config.colors = {
  foreground = "#c0caf5",
  background = "#1a1b26",
  cursor_bg = "#c0caf5",
  cursor_fg = "#1a1b26",
  cursor_border = "#c0caf5",
  selection_bg = "#283457",
  selection_fg = "#c0caf5",
  
  -- Tokyo Night Night カラー
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
}
```

##### 3.5.3 Tmux統合

**Tmux側（~/.tmux.conf）**
```bash
# Tokyo Night Night カラースキーム
# Neovim/WezTermと統一

# カラー定義
bg_dark="#1a1b26"
bg="#24283b"
fg="#c0caf5"
blue="#7aa2f7"
cyan="#7dcfff"
green="#9ece6a"
magenta="#bb9af7"
red="#f7768e"
yellow="#e0af68"
orange="#ff9e64"

# True color対応
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# ステータスバー背景
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

##### 3.5.4 カラースキーム検証方法

**統合テスト:**
```bash
# 1. WezTermを起動
wezterm

# 2. Tmuxを起動
tmux

# 3. Neovimを起動
nvim

# 4. カラーテスト
:so $VIMRUNTIME/syntax/hitest.vim

# 5. ターミナルカラーテスト
# 以下のスクリプトを実行
for i in {0..255}; do
  printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
done
```

**確認ポイント:**
- [ ] Neovimの背景色がWezTermと調和している
- [ ] シンタックスハイライトが正しく表示される
- [ ] Tmuxのステータスバーが見やすい
- [ ] ペインボーダーが明確に見える
- [ ] 透明度が適切（背景が見える）

##### 3.5.5 代替カラースキーム: Catppuccin

**Neovim側**
```lua
{
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "mocha",  -- latte, frappe, macchiato, mocha
    transparent_background = false,
    term_colors = true,  -- ターミナルカラーを設定
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
    },
    integrations = {
      treesitter = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
      },
      telescope = true,
      gitsigns = true,
      nvimtree = true,
      mason = true,
      cmp = true,
      which_key = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd([[colorscheme catppuccin]])
  end,
}
```

**WezTerm側（Catppuccin Mocha）**
```lua
-- Catppuccin Mocha カラーパレット
config.colors = {
  foreground = "#cdd6f4",
  background = "#1e1e2e",
  cursor_bg = "#f5e0dc",
  cursor_fg = "#1e1e2e",
  cursor_border = "#f5e0dc",
  selection_bg = "#585b70",
  selection_fg = "#cdd6f4",
  
  ansi = {
    "#45475a", -- black
    "#f38ba8", -- red
    "#a6e3a1", -- green
    "#f9e2af", -- yellow
    "#89b4fa", -- blue
    "#f5c2e7", -- magenta
    "#94e2d5", -- cyan
    "#bac2de", -- white
  },
  brights = {
    "#585b70", -- bright black
    "#f38ba8", -- bright red
    "#a6e3a1", -- bright green
    "#f9e2af", -- bright yellow
    "#89b4fa", -- bright blue
    "#f5c2e7", -- bright magenta
    "#94e2d5", -- bright cyan
    "#a6adc8", -- bright white
  },
}
```

### 4. LSP設定（多言語サポート）

#### 4.1 対応言語とLSPサーバー

##### 4.1.1 コア言語（必須）

| 言語 | LSPサーバー | 説明 | インストール |
|------|-----------|------|------------|
| **Lua** | `lua_ls` | Neovim設定用 | `:MasonInstall lua-language-server` |
| **Bash** | `bashls` | シェルスクリプト | `:MasonInstall bash-language-server` |
| **JSON** | `jsonls` | JSON設定ファイル | `:MasonInstall json-lsp` |
| **YAML** | `yamlls` | YAML設定ファイル | `:MasonInstall yaml-language-server` |
| **Markdown** | `marksman` | ドキュメント | `:MasonInstall marksman` |

##### 4.1.2 Web開発

| 言語/フレームワーク | LSPサーバー | 説明 | インストール |
|-------------------|-----------|------|------------|
| **JavaScript** | `tsserver` | JavaScript/TypeScript統合 | `:MasonInstall typescript-language-server` |
| **TypeScript** | `tsserver` | TypeScript | 同上 |
| **Node.js** | `tsserver` | Node.js開発 | 同上 |
| **React** | `tsserver` | React (JSX/TSX) | 同上 |
| **Next.js** | `tsserver` | Next.js | 同上 |
| **HTML** | `html` | HTML | `:MasonInstall html-lsp` |
| **CSS** | `cssls` | CSS/SCSS/Less | `:MasonInstall css-lsp` |
| **Tailwind CSS** | `tailwindcss` | Tailwind CSS | `:MasonInstall tailwindcss-language-server` |
| **ESLint** | `eslint` | Linter統合 | `:MasonInstall eslint-lsp` |

**追加プラグイン:**
```lua
-- TypeScript/JavaScript拡張
{
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  opts = {},
}

-- React/JSX サポート
{
  "windwp/nvim-ts-autotag",
  ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
  opts = {},
}
```

##### 4.1.3 モバイル開発

| 言語/フレームワーク | LSPサーバー | 説明 | インストール |
|-------------------|-----------|------|------------|
| **Dart** | `dartls` | Dart言語 | `:MasonInstall dart-language-server` |
| **Flutter** | `dartls` | Flutter開発 | 同上 |
| **Swift** | `sourcekit` | iOS/macOS開発 | 手動インストール（Xcode必須） |
| **Kotlin** | `kotlin_language_server` | Android/Kotlin | `:MasonInstall kotlin-language-server` |
| **Java** | `jdtls` | Java開発 | `:MasonInstall jdtls` |

**追加プラグイン:**
```lua
-- Flutter開発支援
{
  "akinsho/flutter-tools.nvim",
  ft = "dart",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  opts = {
    lsp = {
      color = {
        enabled = true,
      },
    },
    debugger = {
      enabled = true,
    },
  },
}

-- Dart スニペット
{
  "Nash0x7E2/awesome-flutter-snippets",
  ft = "dart",
}
```

##### 4.1.4 システムプログラミング

| 言語 | LSPサーバー | 説明 | インストール |
|------|-----------|------|------------|
| **Rust** | `rust_analyzer` | Rust開発 | `:MasonInstall rust-analyzer` |
| **Go** | `gopls` | Go開発 | `:MasonInstall gopls` |
| **C/C++** | `clangd` | C/C++開発 | `:MasonInstall clangd` |

**追加プラグイン:**
```lua
-- Rust開発支援
{
  "simrat39/rust-tools.nvim",
  ft = "rust",
  dependencies = { "neovim/nvim-lspconfig" },
  opts = {
    server = {
      on_attach = function(_, bufnr)
        -- Hover actions
        vim.keymap.set("n", "<C-space>", require("rust-tools").hover_actions.hover_actions, { buffer = bufnr })
      end,
    },
  },
}

-- Cargo.toml サポート
{
  "saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  opts = {
    src = {
      cmp = { enabled = true },
    },
  },
}

-- Go開発支援
{
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "go", "gomod" },
  build = ':lua require("go.install").update_all_sync()',
  opts = {},
}
```

##### 4.1.5 スクリプト言語

| 言語 | LSPサーバー | 説明 | インストール |
|------|-----------|------|------------|
| **Python** | `pyright` | Python型チェック | `:MasonInstall pyright` |
| **Python** | `ruff_lsp` | Python linter/formatter | `:MasonInstall ruff-lsp` |
| **Ruby** | `solargraph` | Ruby開発 | `:MasonInstall solargraph` |

**追加プラグイン:**
```lua
-- Python開発支援
{
  "linux-cultist/venv-selector.nvim",
  ft = "python",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    name = { "venv", ".venv", "env", ".env" },
  },
  keys = {
    { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
  },
}

-- Ruby開発支援
{
  "tpope/vim-rails",
  ft = { "ruby", "eruby" },
}
```

#### 4.2 LSP設定の実装

##### 4.2.1 Mason設定（lua/plugins/lsp.lua）

```lua
return {
  -- Mason: LSPサーバー管理
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason-LSPConfig: 自動セットアップ
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- コア言語
        "lua_ls",
        "bashls",
        "jsonls",
        "yamlls",
        "marksman",
        
        -- Web開発
        "tsserver",
        "html",
        "cssls",
        "tailwindcss",
        "eslint",
        
        -- モバイル開発
        "dartls",
        "kotlin_language_server",
        
        -- システムプログラミング
        "rust_analyzer",
        "gopls",
        "clangd",
        
        -- スクリプト言語
        "pyright",
        "ruff_lsp",
        "solargraph",
      },
      automatic_installation = true,
    },
  },

  -- LSPConfig: LSP設定
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 共通のon_attach関数
      local on_attach = function(client, bufnr)
        -- キーマップは lua/config/keymaps.lua で設定
        
        -- フォーマット設定
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end

      -- 各言語のLSP設定
      local servers = {
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },

        -- TypeScript/JavaScript
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
              },
            },
          },
        },

        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },

        -- Rust
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },

        -- Go
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
            },
          },
        },

        -- Dart/Flutter
        dartls = {
          settings = {
            dart = {
              enableSnippets = true,
              lineLength = 100,
            },
          },
        },

        -- その他のサーバーはデフォルト設定
        bashls = {},
        jsonls = {},
        yamlls = {},
        marksman = {},
        html = {},
        cssls = {},
        tailwindcss = {},
        eslint = {},
        kotlin_language_server = {},
        solargraph = {},
        clangd = {},
      }

      -- サーバーのセットアップ
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        lspconfig[server].setup(config)
      end
    end,
  },
}
```

##### 4.2.2 Java LSP設定（特別な設定が必要）

```lua
-- lua/plugins/java.lua
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local jdtls = require("jdtls")
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

      local config = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-javaagent:" .. vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar"),
          "-Xms1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-jar", vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
          "-configuration", vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/config_mac"),
          "-data", workspace_dir,
        },
        root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
          },
        },
        init_options = {
          bundles = {},
        },
      }

      jdtls.start_or_attach(config)
    end,
  },
}
```

#### 4.3 Treesitter設定（シンタックスハイライト）

```lua
-- lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        -- コア
        "lua", "vim", "vimdoc", "query",
        "bash", "json", "yaml", "toml",
        "markdown", "markdown_inline",
        
        -- Web開発
        "javascript", "typescript", "tsx", "jsx",
        "html", "css", "scss",
        
        -- モバイル開発
        "dart", "kotlin", "java", "swift",
        
        -- システムプログラミング
        "rust", "go", "c", "cpp",
        
        -- スクリプト言語
        "python", "ruby",
        
        -- その他
        "regex", "dockerfile", "gitignore",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
```

#### 4.4 フォーマッター設定（conform.nvim）

```lua
-- lua/plugins/formatter.lua
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        -- Web開発
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        
        -- モバイル開発
        dart = { "dart_format" },
        kotlin = { "ktlint" },
        java = { "google-java-format" },
        swift = { "swift_format" },
        
        -- システムプログラミング
        rust = { "rustfmt" },
        go = { "gofmt", "goimports" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        
        -- スクリプト言語
        python = { "black", "isort" },
        ruby = { "rubocop" },
        
        -- その他
        lua = { "stylua" },
        bash = { "shfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
}
```

#### 4.5 Linter設定（nvim-lint）

```lua
-- lua/plugins/linter.lua
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        -- Web開発
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        
        -- Python
        python = { "pylint", "mypy" },
        
        -- Ruby
        ruby = { "rubocop" },
        
        -- Bash
        bash = { "shellcheck" },
        
        -- Markdown
        markdown = { "markdownlint" },
      }

      -- 自動Lint
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
```

#### 4.6 LSP機能

すべての言語で以下の機能が利用可能：

- ✅ **定義ジャンプ** (`gd`) - 関数・変数の定義へ移動
- ✅ **参照検索** (`gr`) - 使用箇所を検索
- ✅ **ホバー情報** (`K`) - ドキュメント表示
- ✅ **リネーム** (`<leader>rn`) - シンボル名の一括変更
- ✅ **コードアクション** (`<leader>ca`) - 自動修正・リファクタリング
- ✅ **フォーマット** (`<leader>f`) - コード整形
- ✅ **診断表示** (`<leader>d`) - エラー・警告の表示
- ✅ **シグネチャヘルプ** (`Ctrl+K`) - 関数シグネチャ表示
- ✅ **自動補完** - 入力時の候補表示
- ✅ **インレイヒント** - 型情報の表示（対応言語のみ）

#### 4.7 言語別の追加機能

##### Dart/Flutter
- Flutter デバイス選択
- ホットリロード
- Widget インスペクター
- Pub パッケージ管理

##### Rust
- Cargo コマンド統合
- Crates.io 連携
- Clippy 統合

##### Go
- Go モジュール管理
- テスト実行
- ベンチマーク

##### Python
- 仮想環境選択
- Jupyter Notebook サポート（別プラグイン）

##### TypeScript/JavaScript
- 自動インポート
- パスエイリアス解決
- JSDoc サポート

### 5. キーバインディング設計

> **📚 詳細なキーバインド一覧**: [docs/keybindings.md](../keybindings.md) を参照してください。
> 
> このドキュメントには、Neovim、Tmux、WezTermの統合されたキーバインディング設計、
> 設定例、クイックリファレンス、学習ガイドが含まれています。

#### 5.1 基本原則
- **Leader キー**: `<Space>`（Neovim）
- **Local Leader**: `,`（ファイルタイプ固有）
- **Prefix キー**: `Ctrl+A`（Tmux）
- **統合ナビゲーション**: `Ctrl+h/j/k/l` で全レイヤー横断的にペイン移動
- **一貫性**: 似た操作は似たキーに配置（`f` = find, `g` = git）
- **階層設計**: WezTerm → Tmux → Neovim の順で処理

#### 5.2 キーバインド概要

##### 5.2.1 統合ナビゲーション（最重要）

**Ctrl+h/j/k/l**: WezTerm、Tmux、Neovim間をシームレスに移動
```
Ctrl+h  左のペイン/ウィンドウへ
Ctrl+j  下のペイン/ウィンドウへ
Ctrl+k  上のペイン/ウィンドウへ
Ctrl+l  右のペイン/ウィンドウへ
```

この統合ナビゲーションにより、どのレイヤーにいても同じキーで移動可能。

##### 5.2.2 レイヤー別プレフィックス

| レイヤー | プレフィックス | 用途 |
|---------|--------------|------|
| WezTerm | `Ctrl+Shift` | タブ管理、設定 |
| Tmux | `Ctrl+A` | セッション、ウィンドウ、ペイン管理 |
| Neovim | `Space` (Leader) | ファイル、Git、LSP操作 |

##### 5.2.3 よく使うキーバインド Top 10

1. `Ctrl+h/j/k/l` - ペイン/ウィンドウ移動（全レイヤー）
2. `<leader>ff` - ファイル検索（Neovim）
3. `<leader>fg` - テキスト検索（Neovim）
4. `Ctrl+S` - 保存（Neovim）
5. `gd` - 定義へジャンプ（Neovim）
6. `Prefix |/-` - ペイン分割（Tmux）
7. `<leader>e` - ファイルツリー（Neovim）
8. `<leader>gs` - Git status（Neovim）
9. `K` - ホバー情報（Neovim）
10. `Prefix c` - 新規ウィンドウ（Tmux）

##### 5.2.4 カテゴリ別キーマップ

**基本操作（Neovim）**
```
Ctrl+S          保存
<leader>w       保存
<leader>q       終了
jk / jj         インサートモード脱出
<leader>y/p     システムクリップボード
```

**ファイル・検索（Neovim）**
```
<leader>ff      ファイル検索
<leader>fg      テキスト検索
<leader>fb      バッファ検索
<leader>fr      最近のファイル
```

**LSP（Neovim）**
```
gd              定義へジャンプ
gr              参照検索
K               ホバー情報
<leader>ca      コードアクション
<leader>rn      リネーム
<leader>f       フォーマット
```

**Git（Neovim）**
```
<leader>gs      Git status
<leader>gc      Git commits
<leader>gb      Git branches
]h / [h         Hunk移動
<leader>gp      Hunkプレビュー
```

**Tmux操作**
```
Prefix |        垂直分割
Prefix -        水平分割
Prefix c        新規ウィンドウ
Prefix s        セッション一覧
Prefix d        デタッチ
Prefix z        ペインズーム
```

**WezTerm操作（macOS: Cmd、Windows/Linux: Ctrl）**
```
Cmd/Ctrl+T      新規タブ
Cmd/Ctrl+W      タブを閉じる
Cmd/Ctrl+[1-9]  タブ切り替え
Ctrl+Shift+|    垂直分割
Ctrl+Shift+_    水平分割
```

> **💡 ヒント**: 詳細な設定例、全キーバインド一覧、学習ガイドは [docs/keybindings.md](../keybindings.md) を参照してください。

### 6. Tmux統合の詳細

#### 6.1 vim-tmux-navigator設定
```lua
-- Neovim側の設定
vim.g.tmux_navigator_no_mappings = 1
vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<CR>', { silent = true })
vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<CR>', { silent = true })
vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<CR>', { silent = true })
vim.keymap.set('n', '<C-l>', ':TmuxNavigateRight<CR>', { silent = true })
```

#### 6.2 クリップボード統合
```lua
-- Tmuxとのクリップボード共有
vim.opt.clipboard = 'unnamedplus'

-- OSCヤンク対応（SSH経由でも動作）
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
    -- OSC 52でクリップボードに送信
    if vim.env.TMUX then
      local copy = vim.fn.getreg('"')
      vim.fn.system('tmux load-buffer -', copy)
    end
  end,
})
```

#### 6.3 カラースキーム統一
- Neovim: `tokyonight-night`
- Tmux: 同じカラーパレット使用
- WezTerm: 同じテーマ適用

### 7. 設定変更のリアルタイム反映

#### 7.0 設定リロード戦略

> **📝 重要**: Neovimの設定変更は、ファイル保存後に自動的には反映されません。
> 明示的なリロードが必要です。

##### 7.0.1 リロード方法

**方法1: Neovim再起動（最も確実）**
```vim
:qa          " 全て終了
nvim         " 再起動
```

**方法2: 設定ファイルを再読み込み**
```vim
:source ~/.config/nvim/init.lua
" または
:luafile ~/.config/nvim/init.lua
```

**方法3: lazy.nvimのリロード**
```vim
:Lazy reload <plugin-name>  " 特定プラグインのリロード
:Lazy sync                  " 全プラグインの同期
```

**方法4: 自動リロード設定（推奨）**
```lua
-- lua/config/autocmds.lua

-- 設定ファイル保存時に自動リロード
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*/nvim/**/*.lua" },
  callback = function()
    -- 設定ファイルのパスを取得
    local filepath = vim.fn.expand("%:p")
    
    -- キャッシュをクリア
    for module_name, _ in pairs(package.loaded) do
      if module_name:match("^config%.") or module_name:match("^plugins%.") then
        package.loaded[module_name] = nil
      end
    end
    
    -- 設定を再読み込み
    dofile(vim.env.MYVIMRC)
    
    vim.notify("Config reloaded: " .. vim.fn.fnamemodify(filepath, ":t"), vim.log.levels.INFO)
  end,
})
```

##### 7.0.2 リロードが必要な変更

| 変更内容 | リロード方法 | 即座に反映？ |
|---------|------------|-------------|
| **カラースキーム** | `:colorscheme <name>` | ✅ 即座 |
| **キーマップ** | `:source %` | ✅ 即座 |
| **オプション設定** | `:source %` | ✅ 即座 |
| **プラグイン追加** | `:Lazy sync` + 再起動 | ❌ 再起動必要 |
| **プラグイン設定変更** | `:Lazy reload <name>` | ⚠️ プラグイン依存 |
| **LSP設定** | `:LspRestart` | ✅ 即座 |
| **autocmd** | `:source %` | ✅ 即座（重複注意） |
| **関数定義** | `:source %` | ✅ 即座 |

##### 7.0.3 リロード用キーマップ

```lua
-- lua/config/keymaps.lua

-- 設定リロード
vim.keymap.set("n", "<leader>R", function()
  -- キャッシュクリア
  for module_name, _ in pairs(package.loaded) do
    if module_name:match("^config%.") or module_name:match("^plugins%.") then
      package.loaded[module_name] = nil
    end
  end
  
  -- 設定リロード
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded!", vim.log.levels.INFO)
end, { desc = "Reload config" })

-- カラースキーム変更
vim.keymap.set("n", "<leader>cs", "<cmd>Telescope colorscheme<cr>", { desc = "Change colorscheme" })

-- LSP再起動
vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- Lazy UI
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
```

##### 7.0.4 開発ワークフロー

**推奨ワークフロー:**

```bash
# 1. Neovimで設定ファイルを編集
nvim ~/.config/nvim/lua/plugins/lsp.lua

# 2. 変更を保存（自動リロードが有効な場合）
:w  # 自動的にリロードされる

# 3. または手動リロード
<leader>R  # 設定リロード

# 4. プラグイン追加の場合
:Lazy sync  # プラグインを同期
:qa         # Neovim再起動
nvim
```

**Tmux + Neovimでの開発:**

```
┌─────────────────────────────────┐
│ Pane 1: Neovim                  │
│ - 設定ファイルを編集            │
│ - :w で保存                     │
│ - <leader>R でリロード          │
├─────────────────────────────────┤
│ Pane 2: テスト用Neovim          │
│ - 変更をテスト                  │
│ - 問題があれば Pane 1 で修正    │
└─────────────────────────────────┘
```

##### 7.0.5 リロード時の注意点

**⚠️ 注意:**

1. **autocmdの重複**
   ```lua
   -- 悪い例: リロードのたびに追加される
   vim.api.nvim_create_autocmd("BufWritePost", {
     callback = function() print("saved") end,
   })
   
   -- 良い例: グループを使用
   local group = vim.api.nvim_create_augroup("MyConfig", { clear = true })
   vim.api.nvim_create_autocmd("BufWritePost", {
     group = group,
     callback = function() print("saved") end,
   })
   ```

2. **プラグインの状態**
   - 一部のプラグインはリロードで正しく動作しない
   - LSP、Treesitterなどは再起動が必要な場合がある

3. **キャッシュ**
   - Luaモジュールキャッシュをクリアする必要がある
   - `package.loaded`を適切にクリア

##### 7.0.6 デバッグ方法

**設定エラーの確認:**
```vim
:messages         " エラーメッセージを表示
:checkhealth      " 健全性チェック
:Lazy log         " lazy.nvimのログ
:LspLog           " LSPログ
```

**Luaコードのデバッグ:**
```lua
-- デバッグプリント
print(vim.inspect(some_variable))

-- 通知で表示
vim.notify("Debug: " .. vim.inspect(value), vim.log.levels.DEBUG)

-- ログファイルに出力
vim.fn.writefile({ vim.inspect(value) }, "/tmp/nvim-debug.log", "a")
```

##### 7.0.7 ホットリロードプラグイン（オプション）

より高度なリロード機能が必要な場合：

```lua
-- lua/plugins/dev.lua
return {
  {
    "folke/neodev.nvim",
    ft = "lua",
    opts = {
      library = {
        plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
      },
    },
  },
  
  -- 設定ファイルの変更を監視
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      stages = "fade_in_slide_out",
    },
  },
}
```

### 8. パフォーマンス最適化

#### 8.1 lazy.nvimによる最適化

##### 7.1.1 遅延読み込みパターン

**イベントベース読み込み**
```lua
-- ファイル読み込み時
{
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
}

-- インサートモード時
{
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
}

-- 遅延読み込み（アイドル時）
{
  "folke/which-key.nvim",
  event = "VeryLazy",
}
```

**コマンドベース読み込み**
```lua
{
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
}

{
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
}
```

**キーマップベース読み込み**
```lua
{
  "numToStr/Comment.nvim",
  keys = {
    { "gc", mode = { "n", "v" } },
    { "gb", mode = { "n", "v" } },
  },
}
```

**ファイルタイプベース読み込み**
```lua
{
  "mfussenegger/nvim-dap-python",
  ft = "python",
}
```

##### 7.1.2 優先度の設定
```lua
-- カラースキームは最優先
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,  -- 最高優先度
}

-- LSPは高優先度
{
  "neovim/nvim-lspconfig",
  priority = 900,
}

-- その他のプラグインはデフォルト（50）
```

##### 7.1.3 条件付き読み込み
```lua
-- 特定の条件でのみ読み込み
{
  "linux-only/plugin",
  cond = function()
    return vim.fn.has("unix") == 1
  end,
}

-- 実行ファイルが存在する場合のみ
{
  "tool-plugin",
  cond = function()
    return vim.fn.executable("tool") == 1
  end,
}
```

#### 7.2 起動時間の測定とプロファイリング

##### 7.2.1 起動時間計測
```bash
# 起動時間の詳細ログ
nvim --startuptime startup.log

# 簡易計測
time nvim --headless +quit

# lazy.nvimのプロファイル表示
nvim
:Lazy profile
```

##### 7.2.2 プラグイン読み込み時間の確認
```vim
" lazy.nvimのUI で確認
:Lazy

" プロファイル情報
:Lazy profile

" 起動時のイベントログ
:Lazy log
```

##### 7.2.3 詳細プロファイリング
```vim
" プロファイリング開始
:profile start profile.log
:profile func *
:profile file *

" Neovimを使用...

" プロファイリング終了
:profile dump
:qa

" profile.logを確認
```

#### 7.3 最適化チェックリスト

##### 7.3.1 プラグイン最適化
- [ ] 不要なプラグインの削除
- [ ] 重複機能を持つプラグインの統合
- [ ] 重いプラグインの軽量代替を検討
- [ ] すべてのプラグインに適切な遅延読み込み設定
- [ ] 依存関係の最小化

##### 7.3.2 lazy.nvim設定最適化
```lua
-- 最適化された設定例
require("lazy").setup({
  { import = "plugins" },
}, {
  defaults = {
    lazy = true,  -- デフォルトで遅延読み込み
  },
  performance = {
    cache = {
      enabled = true,  -- キャッシュ有効化
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
```

##### 7.3.3 LSP最適化
```lua
-- LSPの起動を遅延
{
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- 必要な言語サーバーのみ起動
    local servers = { "lua_ls", "pyright" }
    for _, server in ipairs(servers) do
      require("lspconfig")[server].setup({})
    end
  end,
}
```

##### 7.3.4 Treesitter最適化
```lua
{
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- 使用する言語のみインストール
    ensure_installed = {
      "lua", "vim", "vimdoc",
      "python", "javascript", "typescript",
      "bash", "json", "yaml", "markdown",
    },
    -- 自動インストールは無効化（手動管理）
    auto_install = false,
  },
}
```

##### 7.3.5 目標値
- [ ] **起動時間**: < 100ms（プラグイン読み込み含む）
- [ ] **初回ファイル開く**: < 200ms
- [ ] **LSP起動**: < 500ms
- [ ] **補完表示**: < 50ms

#### 7.4 lazy.nvimのデバッグ

##### 7.4.1 問題の診断
```vim
" プラグインの状態確認
:Lazy

" デバッグ情報
:Lazy debug

" ログ確認
:Lazy log

" ヘルスチェック
:checkhealth lazy
```

##### 7.4.2 よくある問題と解決策

**問題: プラグインが読み込まれない**
```lua
-- 解決: lazy = false で即時読み込み
{
  "plugin/name",
  lazy = false,
}
```

**問題: キーマップが動作しない**
```lua
-- 解決: keys設定を確認
{
  "plugin/name",
  keys = {
    { "<leader>f", "<cmd>Command<cr>", desc = "Description" },
  },
}
```

**問題: 依存関係のエラー**
```lua
-- 解決: dependencies を明示的に指定
{
  "plugin/name",
  dependencies = {
    "required/plugin",
  },
}
```

---

## 🪟 Tmux 設定要件

### 1. 設計哲学

#### 1.1 目的
- **セッション管理**: プロジェクトごとの作業環境
- **画面分割**: 効率的なマルチタスク
- **永続化**: 作業状態の保存と復元
- **Neovim統合**: シームレスな連携

#### 1.2 原則
- ✅ 直感的なキーバインディング
- ✅ Neovimとの一貫性
- ✅ 視覚的に分かりやすいUI
- ✅ スクリプトによる自動化

### 2. 基本設定

#### 2.1 プレフィックスキー
```bash
# デフォルト: C-b
# 推奨: C-a（screenライク）または C-q（Neovimと競合しない）
set -g prefix C-a
unbind C-b
bind C-a send-prefix
```

#### 2.2 基本オプション
```bash
# マウス操作有効化
set -g mouse on

# ウィンドウ番号を1から開始
set -g base-index 1
setw -g pane-base-index 1

# ウィンドウ番号を詰める
set -g renumber-windows on

# エスケープ遅延なし（Neovim用）
set -sg escape-time 0

# 履歴行数
set -g history-limit 50000

# ステータス更新間隔
set -g status-interval 5

# フォーカスイベント有効化
set -g focus-events on

# True color対応
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# クリップボード統合
set -g set-clipboard on
```

### 3. キーバインディング

#### 3.1 基本操作
```bash
# 設定リロード
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# ペイン分割（直感的）
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# 新規ウィンドウ（カレントディレクトリで）
bind c new-window -c "#{pane_current_path}"

# ペイン移動（vim風）
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# ペインリサイズ
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# ペインズーム
bind z resize-pane -Z
```

#### 3.2 コピーモード（vi風）
```bash
# コピーモード
setw -g mode-keys vi
bind [ copy-mode
bind ] paste-buffer

# vi風選択
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-selection-and-cancel
bind -T copy-mode-vi C-v send -X rectangle-toggle

# マウス選択でコピー
bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-selection-and-cancel
```

#### 3.3 セッション管理
```bash
# セッション選択
bind s choose-session

# セッション作成
bind C-c new-session

# セッション名変更
bind C-r command-prompt -I "#S" "rename-session '%%'"

# ウィンドウ名変更
bind , command-prompt -I "#W" "rename-window '%%'"
```

### 4. Neovim統合（vim-tmux-navigator）

#### 4.1 Tmux側の設定
```bash
# Smart pane switching with awareness of Vim splits.
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

bind -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"

# Restore C-l for clear screen
bind C-l send-keys 'C-l'
```

### 5. ステータスライン設計

#### 5.1 基本設定
```bash
# ステータスバー位置
set -g status-position bottom

# ステータスバー更新間隔
set -g status-interval 1

# ステータスバーの長さ
set -g status-left-length 50
set -g status-right-length 100
```

#### 5.2 カラースキーム（Tokyonight風）
```bash
# カラー定義
bg_dark="#1a1b26"
bg="#24283b"
fg="#c0caf5"
blue="#7aa2f7"
cyan="#7dcfff"
green="#9ece6a"
magenta="#bb9af7"
red="#f7768e"
yellow="#e0af68"

# ステータスバー背景
set -g status-style "bg=$bg,fg=$fg"

# ウィンドウステータス
setw -g window-status-style "fg=$fg,bg=$bg"
setw -g window-status-current-style "fg=$bg,bg=$blue,bold"
setw -g window-status-format " #I:#W "
setw -g window-status-current-format " #I:#W "

# ペインボーダー
set -g pane-border-style "fg=$bg"
set -g pane-active-border-style "fg=$blue"

# メッセージ
set -g message-style "fg=$bg,bg=$blue"
```

#### 5.3 ステータス表示内容
```bash
# 左側: セッション名、ウィンドウ番号
set -g status-left "#[fg=$bg,bg=$blue,bold] #S #[fg=$blue,bg=$bg] "

# 右側: ホスト名、日時
set -g status-right "#[fg=$cyan] %Y-%m-%d %H:%M #[fg=$bg,bg=$blue,bold] #H "
```

### 6. プラグイン管理（TPM）

#### 6.1 TPMインストール
```bash
# TPM（Tmux Plugin Manager）
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

#### 6.2 推奨プラグイン
```bash
# ~/.tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'      # 基本設定
set -g @plugin 'tmux-plugins/tmux-resurrect'     # セッション保存
set -g @plugin 'tmux-plugins/tmux-continuum'     # 自動保存
set -g @plugin 'tmux-plugins/tmux-yank'          # クリップボード統合
set -g @plugin 'christoomey/vim-tmux-navigator'  # Neovim統合

# Resurrect設定
set -g @resurrect-strategy-nvim 'session'
set -g @resurrect-capture-pane-contents 'on'

# Continuum設定（自動保存）
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'

# TPM初期化（最後に記述）
run '~/.tmux/plugins/tpm/tpm'
```

### 7. セッション管理スクリプト

#### 7.1 クイック起動スクリプト（dev コマンド）

**目的**: Neovim + Tmuxを一発で起動し、Claude Codeとの併用を考慮した画面レイアウトを作成

```bash
#!/bin/bash
# ~/bin/dev または ~/.local/bin/dev

# ========================================
# Neovim + Tmux クイック起動スクリプト
# ========================================
# 使用例:
#   dev                    # カレントディレクトリで起動
#   dev ~/project          # 指定ディレクトリで起動
#   dev myproject ~/code   # セッション名とディレクトリ指定
#   dev --layout split     # 分割レイアウト
#   dev --layout full      # フルスクリーンレイアウト
#   dev --layout claude    # Claude Code併用レイアウト

set -e

# ========================================
# 設定
# ========================================

DEFAULT_LAYOUT="split"  # split, full, claude
SESSION_PREFIX="dev"

# ========================================
# ヘルプ表示
# ========================================

show_help() {
  cat << EOF
Usage: dev [OPTIONS] [SESSION_NAME] [PROJECT_DIR]

Neovim + Tmux開発環境を起動します。

Arguments:
  SESSION_NAME    セッション名（省略時: カレントディレクトリ名）
  PROJECT_DIR     プロジェクトディレクトリ（省略時: カレントディレクトリ）

Options:
  -l, --layout LAYOUT    レイアウト選択 (split|full|claude)
                         split:  エディタ + ターミナル分割（デフォルト）
                         full:   エディタフルスクリーン
                         claude: Claude Code併用レイアウト
  -h, --help            このヘルプを表示

Layouts:
  split:   ┌─────────────────┐
           │ Neovim (70%)    │
           ├─────────────────┤
           │ Terminal (30%)  │
           └─────────────────┘

  full:    ┌─────────────────┐
           │                 │
           │ Neovim (100%)   │
           │                 │
           └─────────────────┘

  claude:  ┌──────────┬──────┐
           │          │ Git  │
           │ Neovim   ├──────┤
           │ (60%)    │ Term │
           └──────────┴──────┘
           ※ Claude Codeは別ウィンドウで使用

Examples:
  dev                           # カレントディレクトリで起動
  dev myproject                 # myprojectセッションで起動
  dev myproject ~/code/myapp    # 指定ディレクトリで起動
  dev --layout claude           # Claude併用レイアウト
  dev -l full myproject         # フルスクリーンレイアウト

EOF
}

# ========================================
# 引数解析
# ========================================

LAYOUT="$DEFAULT_LAYOUT"
SESSION_NAME=""
PROJECT_DIR=""

while [[ $# -gt 0 ]]; do
  case $1 in
    -l|--layout)
      LAYOUT="$2"
      shift 2
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      if [ -z "$SESSION_NAME" ]; then
        SESSION_NAME="$1"
      elif [ -z "$PROJECT_DIR" ]; then
        PROJECT_DIR="$1"
      fi
      shift
      ;;
  esac
done

# ========================================
# デフォルト値設定
# ========================================

# プロジェクトディレクトリのデフォルト
if [ -z "$PROJECT_DIR" ]; then
  PROJECT_DIR="$(pwd)"
fi

# セッション名のデフォルト（ディレクトリ名から生成）
if [ -z "$SESSION_NAME" ]; then
  SESSION_NAME="${SESSION_PREFIX}-$(basename "$PROJECT_DIR")"
fi

# ディレクトリの存在確認
if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: Directory not found: $PROJECT_DIR"
  exit 1
fi

# レイアウトの検証
if [[ ! "$LAYOUT" =~ ^(split|full|claude)$ ]]; then
  echo "Error: Invalid layout: $LAYOUT"
  echo "Valid layouts: split, full, claude"
  exit 1
fi

# ========================================
# セッション作成関数
# ========================================

create_split_layout() {
  local session=$1
  local dir=$2
  
  # メインウィンドウ: editor
  tmux new-session -d -s "$session" -n "editor" -c "$dir"
  tmux send-keys -t "$session:editor" "nvim" C-m
  
  # エディタペインを分割（下30%にターミナル）
  tmux split-window -t "$session:editor" -v -p 30 -c "$dir"
  
  # エディタペインにフォーカス
  tmux select-pane -t "$session:editor.0"
}

create_full_layout() {
  local session=$1
  local dir=$2
  
  # メインウィンドウ: editor（フルスクリーン）
  tmux new-session -d -s "$session" -n "editor" -c "$dir"
  tmux send-keys -t "$session:editor" "nvim" C-m
  
  # 別ウィンドウ: terminal
  tmux new-window -t "$session" -n "terminal" -c "$dir"
  
  # エディタウィンドウに戻る
  tmux select-window -t "$session:editor"
}

create_claude_layout() {
  local session=$1
  local dir=$2
  
  # メインウィンドウ: editor
  tmux new-session -d -s "$session" -n "editor" -c "$dir"
  tmux send-keys -t "$session:editor" "nvim" C-m
  
  # 右側に縦分割（40%）
  tmux split-window -t "$session:editor" -h -p 40 -c "$dir"
  
  # 右ペインを横分割（上50%: git、下50%: terminal）
  tmux split-window -t "$session:editor.1" -v -p 50 -c "$dir"
  tmux send-keys -t "$session:editor.1" "git status" C-m
  
  # エディタペインにフォーカス
  tmux select-pane -t "$session:editor.0"
  
  echo ""
  echo "💡 Claude Code併用レイアウト作成完了"
  echo "   - 左: Neovim (60%)"
  echo "   - 右上: Git (20%)"
  echo "   - 右下: Terminal (20%)"
  echo ""
  echo "   Claude Codeは別ウィンドウで開いてください"
  echo "   推奨: WezTermの別タブまたはOSのウィンドウ分割機能を使用"
}

# ========================================
# メイン処理
# ========================================

# 既存セッションの確認
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  echo "📌 セッション '$SESSION_NAME' は既に存在します"
  echo "   アタッチしています..."
  
  # Tmux内から実行された場合
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$SESSION_NAME"
  else
    tmux attach-session -t "$SESSION_NAME"
  fi
  exit 0
fi

# 新規セッション作成
echo "🚀 セッション '$SESSION_NAME' を作成中..."
echo "   ディレクトリ: $PROJECT_DIR"
echo "   レイアウト: $LAYOUT"
echo ""

case "$LAYOUT" in
  split)
    create_split_layout "$SESSION_NAME" "$PROJECT_DIR"
    ;;
  full)
    create_full_layout "$SESSION_NAME" "$PROJECT_DIR"
    ;;
  claude)
    create_claude_layout "$SESSION_NAME" "$PROJECT_DIR"
    ;;
esac

# セッションにアタッチ
if [ -n "$TMUX" ]; then
  tmux switch-client -t "$SESSION_NAME"
else
  tmux attach-session -t "$SESSION_NAME"
fi
```

#### 7.2 インストール手順

```bash
# スクリプトを作成
mkdir -p ~/.local/bin
cat > ~/.local/bin/dev << 'EOF'
# 上記のスクリプト内容をペースト
EOF

# 実行権限を付与
chmod +x ~/.local/bin/dev

# PATHに追加（~/.zshrcまたは~/.bashrc）
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

# 反映
source ~/.zshrc

# 動作確認
dev --help
```

#### 7.3 使用例

```bash
# 基本的な使い方
dev                           # カレントディレクトリで起動

# セッション名を指定
dev myproject                 # myprojectセッションで起動

# ディレクトリを指定
dev myproject ~/code/myapp    # 指定ディレクトリで起動

# レイアウトを指定
dev --layout claude           # Claude Code併用レイアウト（デフォルト）
dev --layout split            # 分割レイアウト
dev --layout full             # フルスクリーンレイアウト

# 短縮形
dev -l claude myproject ~/code/myapp
```

#### 7.4 プロジェクトセッション作成（高度な例）

```bash
#!/bin/bash
# ~/bin/tmux-project

SESSION_NAME=$1
PROJECT_DIR=$2

if [ -z "$SESSION_NAME" ]; then
  echo "Usage: tmux-project <session-name> [project-dir]"
  exit 1
fi

# セッションが既に存在する場合はアタッチ
tmux has-session -t "$SESSION_NAME" 2>/dev/null
if [ $? -eq 0 ]; then
  tmux attach-session -t "$SESSION_NAME"
  exit 0
fi

# 新規セッション作成
cd "$PROJECT_DIR" || exit 1

tmux new-session -d -s "$SESSION_NAME" -n "editor"
tmux send-keys -t "$SESSION_NAME:editor" "nvim" C-m

tmux new-window -t "$SESSION_NAME" -n "terminal"
tmux send-keys -t "$SESSION_NAME:terminal" "clear" C-m

tmux new-window -t "$SESSION_NAME" -n "git"
tmux send-keys -t "$SESSION_NAME:git" "git status" C-m

tmux select-window -t "$SESSION_NAME:editor"
tmux attach-session -t "$SESSION_NAME"
```

#### 7.5 セッション一覧と切り替え

```bash
# セッション一覧
tmux ls

# セッション切り替え（fzf使用）
tmux-switch() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | fzf --prompt="Select session: ")
  if [ -n "$session" ]; then
    tmux switch-client -t "$session"
  fi
}

# ~/.zshrcに追加
alias tls='tmux ls'
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias ts='tmux-switch'
```

#### 7.6 Claude Code併用のワークフロー

**推奨セットアップ:**

1. **WezTermで2タブ構成**
   ```
   タブ1: dev --layout claude  # Neovim + Tmux
   タブ2: (通常のシェル)       # Claude Code起動用
   ```

2. **OS標準のウィンドウ分割**
   ```
   左半分: WezTerm (Neovim + Tmux)
   右半分: Claude Code
   ```

3. **外部モニター使用時**
   ```
   モニター1: WezTerm (Neovim + Tmux) - フルスクリーン
   モニター2: Claude Code - フルスクリーン
   ```

**ワークフロー例:**

```bash
# 1. プロジェクトで開発環境起動
cd ~/code/myproject
dev --layout claude

# 2. 別タブまたはウィンドウでClaude Code起動
# Cmd/Ctrl+T で新規タブ
cursor .

# 3. 作業開始
# - Neovim: 設定ファイル、スクリプト編集
# - Claude Code: 新機能開発、リファクタリング
# - Git pane: 変更確認
# - Terminal pane: テスト実行、ビルド
```

### 8. ワークフロー例

#### 8.1 標準的な開発セッション
```
Session: myproject
├── Window 1: editor
│   ├── Pane 1: Neovim（メインコード編集）
│   └── Pane 2: Neovim（テストファイル）
├── Window 2: terminal
│   ├── Pane 1: シェル（コマンド実行）
│   └── Pane 2: 開発サーバー
├── Window 3: git
│   └── Pane 1: lazygit または git コマンド
└── Window 4: monitor
    ├── Pane 1: ログ監視（tail -f）
    └── Pane 2: システムモニター（htop）
```

#### 8.2 リモート開発セッション
```bash
# ローカル
ssh user@remote

# リモート
tmux new -s remote-dev
# ... 作業 ...
# デタッチ: C-a d

# 再接続
ssh user@remote
tmux attach -t remote-dev
```

---

## 🤖 Claude Code (Cursor) 統合要件

### 1. 役割分担の明確化

#### 1.1 Claude Codeの主な用途
- **新機能開発**: AIによるコード生成、アーキテクチャ提案
- **リファクタリング**: 大規模なコード改善、パターン適用
- **ドキュメント作成**: README、API仕様、コメント生成
- **コードレビュー**: 品質チェック、改善提案
- **学習**: 新しいライブラリ、フレームワークの理解

#### 1.2 Neovim + Tmuxの主な用途
- **日常的な編集**: 設定ファイル、スクリプト、小規模修正
- **Git操作**: コミット、ブランチ管理、マージ
- **ターミナル作業**: ビルド、テスト実行、デプロイ
- **リモート作業**: SSH経由での編集
- **システム管理**: dotfiles、サーバー設定

### 2. 設定の共通化

#### 2.1 EditorConfig
```ini
# .editorconfig（プロジェクトルート）
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.{js,ts,jsx,tsx,json}]
indent_style = space
indent_size = 2

[*.{py,lua}]
indent_style = space
indent_size = 4

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
```

#### 2.2 共通LSP設定
- 同じLSPサーバーを使用（pyright, tsserver等）
- 同じフォーマッター設定（prettier, black等）
- 同じlinter設定（eslint, ruff等）

#### 2.3 Git統合
```gitconfig
# ~/.gitconfig
[core]
    editor = nvim
    pager = delta

[diff]
    tool = nvimdiff

[merge]
    tool = nvimdiff
    conflictstyle = diff3

[difftool "nvimdiff"]
    cmd = nvim -d $LOCAL $REMOTE

[mergetool "nvimdiff"]
    cmd = nvim -d $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'
```

### 3. Cursor設定

#### 3.1 settings.json
```json
{
  // エディタ基本設定
  "editor.fontSize": 14,
  "editor.fontFamily": "'JetBrains Mono', 'Fira Code', monospace",
  "editor.fontLigatures": true,
  "editor.lineNumbers": "relative",
  "editor.cursorBlinking": "solid",
  "editor.cursorSmoothCaretAnimation": "on",
  
  // Neovimライクな設定
  "editor.lineNumbers": "relative",
  "editor.cursorSurroundingLines": 8,
  "editor.scrollBeyondLastLine": false,
  
  // フォーマット設定（Neovimと統一）
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter"
  },
  "[lua]": {
    "editor.defaultFormatter": "JohnnyMorganz.stylua"
  },
  
  // ターミナル設定
  "terminal.integrated.fontFamily": "'JetBrains Mono', monospace",
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.defaultProfile.osx": "zsh",
  
  // カラーテーマ（Neovim/Tmuxと統一）
  "workbench.colorTheme": "Tokyo Night",
  
  // Claude AI設定
  "cursor.aiEnabled": true,
  "cursor.aiModel": "claude-3.5-sonnet",
  "cursor.aiContextLines": 100,
  
  // ファイル除外（パフォーマンス向上）
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/node_modules/**": true,
    "**/.venv/**": true
  }
}
```

#### 3.2 keybindings.json（Neovimライク）
```json
[
  // ファイル保存
  {
    "key": "ctrl+s",
    "command": "workbench.action.files.save"
  },
  
  // パネル移動（Tmux/Neovimと統一）
  {
    "key": "ctrl+h",
    "command": "workbench.action.navigateLeft"
  },
  {
    "key": "ctrl+j",
    "command": "workbench.action.navigateDown"
  },
  {
    "key": "ctrl+k",
    "command": "workbench.action.navigateUp"
  },
  {
    "key": "ctrl+l",
    "command": "workbench.action.navigateRight"
  },
  
  // ターミナルトグル
  {
    "key": "ctrl+`",
    "command": "workbench.action.terminal.toggleTerminal"
  },
  
  // AI機能
  {
    "key": "ctrl+shift+a",
    "command": "cursor.aiChat"
  },
  {
    "key": "ctrl+shift+e",
    "command": "cursor.aiEdit"
  }
]
```

#### 3.3 .cursorrules（プロジェクトルート）
```markdown
# プロジェクト固有のAIルール

## コーディング規約
- インデント: スペース2個（JS/TS）、4個（Python/Lua）
- 改行: LF
- 文字コード: UTF-8
- 最大行長: 100文字

## 優先事項
1. シンプルさと可読性
2. パフォーマンス
3. テスト可能性
4. ドキュメント

## 避けるべきこと
- 過度な抽象化
- 不要な依存関係
- 複雑なネスト
- マジックナンバー

## テスト
- ユニットテストを含める
- エッジケースを考慮
- テストカバレッジ80%以上

## ドキュメント
- 関数には docstring を記述
- 複雑なロジックにはコメント
- READMEを更新
```

### 4. ワークフロー統合

#### 4.1 並列開発のパターン

**パターン1: 画面分割開発**
```
┌─────────────────────────────────────────┐
│ Claude Code (Cursor)                    │
│ - AI支援コード生成                       │
│ - 大規模リファクタリング                 │
│ - ドキュメント作成                       │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ Terminal (WezTerm + Tmux + Neovim)      │
│ ┌─────────────┬─────────────────────────┤
│ │ Neovim      │ Terminal                │
│ │ - 設定編集  │ - Git操作               │
│ │ - 微調整    │ - テスト実行            │
│ └─────────────┴─────────────────────────┤
└─────────────────────────────────────────┘
```

**パターン2: タスク別使い分け**
1. **設計フェーズ**: Claude Codeでアーキテクチャ設計、コード生成
2. **実装フェーズ**: Neovim + Tmuxで細かい調整、設定ファイル編集
3. **テストフェーズ**: Tmuxでテスト実行、ログ監視、Neovimで修正
4. **レビューフェーズ**: Claude Codeでコードレビュー、改善提案

#### 4.2 ファイル同期
```bash
# Claude Codeで生成したコードをNeovimで確認
# Git経由で同期（推奨）
git add .
git commit -m "WIP: Claude generated code"

# Tmuxセッションで確認
tmux attach -t myproject
# Neovimで開く
nvim src/generated_file.py
```

#### 4.3 Git統合ワークフロー
```bash
# Claude Codeで開発
# → ファイル保存（自動Git追跡）

# Tmux + Neovimで確認・調整
tmux attach -t myproject
nvim .
# :Telescope git_status でGit状態確認
# 必要に応じて修正

# コミット（Neovim内 or lazygit）
:!git add .
:!git commit -m "feat: add new feature"

# または lazygit使用
:!lazygit
```

---

## 📦 インストール・セットアップ要件

### 1. 前提条件

#### 1.1 必須ツール
- **Neovim**: v0.10.0以上
- **Tmux**: v3.2以上
- **Git**: v2.30以上
- **Zsh**: v5.8以上（シェル）
- **WezTerm**: 最新版（ターミナル）

#### 1.2 推奨ツール
- **ripgrep**: 高速検索
- **fd**: 高速ファイル検索
- **lazygit**: Git TUI
- **fzf**: ファジーファインダー
- **delta**: Gitdiff表示改善
- **bat**: catの代替（シンタックスハイライト）
- **eza**: lsの代替（モダンな表示）

#### 1.3 フォント
- **Nerd Fonts**: アイコン表示用
  - 推奨: JetBrains Mono Nerd Font, Fira Code Nerd Font

### 2. ディレクトリ構造

```
~/development/dotfiles/
├── nvim/
│   └── .config/nvim/           # Neovim設定
│       ├── init.lua
│       ├── lua/
│       │   ├── config/
│       │   ├── plugins/
│       │   └── utils/
│       └── after/
├── tmux/
│   ├── .tmux.conf              # Tmux設定
│   └── scripts/                # Tmuxスクリプト
│       └── tmux-project.sh
├── cursor/
│   ├── settings.json           # Cursor設定
│   ├── keybindings.json
│   └── .cursorrules.example
├── zsh/
│   ├── .zshrc
│   └── sheldon/
│       └── plugins.toml
├── wezterm/
│   └── .config/wezterm/
│       └── wezterm.lua
├── starship/
│   └── .config/starship.toml
├── git/
│   ├── .gitconfig
│   └── .gitignore_global
├── scripts/
│   ├── setup.sh                # セットアップスクリプト
│   ├── install-neovim.sh
│   ├── install-tmux.sh
│   └── install-tools.sh
└── docs/
    └── requirements/
        └── neovim-tmux-claude-parallel-dev.md
```

### 3. セットアップスクリプト

#### 3.1 メインセットアップ
```bash
#!/bin/bash
# scripts/setup.sh

set -e

DOTFILES_DIR="$HOME/development/dotfiles"

echo "🚀 Setting up Neovim + Tmux + Claude development environment..."

# 1. 依存ツールのインストール確認
echo "📦 Checking dependencies..."
command -v nvim >/dev/null 2>&1 || { echo "Installing Neovim..."; ./scripts/install-neovim.sh; }
command -v tmux >/dev/null 2>&1 || { echo "Installing Tmux..."; ./scripts/install-tmux.sh; }
command -v rg >/dev/null 2>&1 || { echo "Installing ripgrep..."; ./scripts/install-tools.sh; }

# 2. Neovim設定のシンボリックリンク
echo "🔗 Linking Neovim config..."
mkdir -p ~/.config
ln -sf "$DOTFILES_DIR/nvim/.config/nvim" ~/.config/nvim

# 3. Tmux設定のシンボリックリンク
echo "🔗 Linking Tmux config..."
ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

# 4. TPMのインストール
if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "📦 Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# 5. Cursor設定のコピー（参考用）
echo "📋 Copying Cursor config examples..."
mkdir -p ~/Documents/cursor-config
cp "$DOTFILES_DIR/cursor/"* ~/Documents/cursor-config/

# 6. Neovimプラグインのインストール
echo "📦 Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa

# 7. Tmuxプラグインのインストール
echo "📦 Installing Tmux plugins..."
~/.tmux/plugins/tpm/bin/install_plugins

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Open Neovim and run :checkhealth"
echo "2. Start Tmux and press prefix + I to install plugins"
echo "3. Copy Cursor settings from ~/Documents/cursor-config/"
echo "4. Restart your terminal"
```

#### 3.2 Neovimインストール
```bash
#!/bin/bash
# scripts/install-neovim.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  brew install neovim
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux
  if command -v apt-get &> /dev/null; then
    # Ubuntu/Debian
    sudo apt-get update
    sudo apt-get install -y neovim
  elif command -v dnf &> /dev/null; then
    # Fedora
    sudo dnf install -y neovim
  elif command -v pacman &> /dev/null; then
    # Arch
    sudo pacman -S neovim
  fi
fi

# バージョン確認
nvim --version
```

#### 3.3 推奨ツールインストール
```bash
#!/bin/bash
# scripts/install-tools.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install ripgrep fd lazygit fzf git-delta bat eza
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if command -v apt-get &> /dev/null; then
    sudo apt-get install -y ripgrep fd-find fzf bat
    # lazygit, delta, ezaは別途インストール
  fi
fi
```

### 4. 検証スクリプト

```bash
#!/bin/bash
# scripts/verify-setup.sh

echo "🔍 Verifying setup..."

# 必須ツール確認
check_command() {
  if command -v "$1" &> /dev/null; then
    echo "✅ $1: $(command -v $1)"
  else
    echo "❌ $1: not found"
  fi
}

check_command nvim
check_command tmux
check_command git
check_command rg
check_command fd
check_command fzf

# Neovim設定確認
if [ -d ~/.config/nvim ]; then
  echo "✅ Neovim config: ~/.config/nvim"
else
  echo "❌ Neovim config: not found"
fi

# Tmux設定確認
if [ -f ~/.tmux.conf ]; then
  echo "✅ Tmux config: ~/.tmux.conf"
else
  echo "❌ Tmux config: not found"
fi

# Neovim health check
echo ""
echo "Running Neovim health check..."
nvim --headless "+checkhealth" +qa

echo ""
echo "✅ Verification complete!"
```

---

## 📚 ドキュメント要件

### 1. 必要なドキュメント

- [ ] **README.md**: プロジェクト概要、クイックスタート
- [ ] **docs/setup-guide.md**: 詳細セットアップ手順
- [ ] **docs/neovim-guide.md**: Neovim設定とカスタマイズ
- [ ] **docs/tmux-guide.md**: Tmux使い方とワークフロー
- [ ] **docs/cursor-integration.md**: Cursor連携ガイド
- [x] **docs/keybindings.md**: 全キーバインディング一覧（統合設計）
- [ ] **docs/troubleshooting.md**: トラブルシューティング
- [ ] **docs/migration-from-astronvim.md**: AstroNvimからの移行ガイド

### 2. チートシート

> **📚 完全版チートシート**: [docs/keybindings.md](../keybindings.md) に詳細な一覧があります。

#### 2.1 統合チートシート（印刷用）

```markdown
# 統合キーバインド クイックリファレンス

## 🔑 統合ナビゲーション（全レイヤー共通）
Ctrl+h/j/k/l    ペイン/ウィンドウ移動

## 📝 Neovim (Leader: Space)
### 基本
Ctrl+S          保存
<leader>w       保存
<leader>q       終了
jk/jj           インサートモード脱出

### ファイル・検索
<leader>ff      ファイル検索
<leader>fg      テキスト検索
<leader>fb      バッファ検索
<leader>e       ファイルツリー

### LSP
gd              定義へジャンプ
gr              参照検索
K               ホバー情報
<leader>ca      コードアクション
<leader>rn      リネーム
<leader>f       フォーマット

### Git
<leader>gs      Git status
<leader>gc      Git commits
]h / [h         Hunk移動
<leader>gp      Hunkプレビュー

## 🪟 Tmux (Prefix: Ctrl+A)
### ペイン
Prefix |        垂直分割
Prefix -        水平分割
Prefix z        ズーム
Prefix x        閉じる

### ウィンドウ
Prefix c        新規ウィンドウ
Prefix n/p      次/前のウィンドウ
Prefix [0-9]    番号で移動

### セッション
Prefix s        セッション一覧
Prefix d        デタッチ
Prefix $        セッション名変更

### その他
Prefix r        設定リロード
Prefix [        コピーモード

## 🖥️ WezTerm
### タブ（macOS: Cmd、Win/Linux: Ctrl）
Cmd/Ctrl+T      新規タブ
Cmd/Ctrl+W      閉じる
Cmd/Ctrl+[1-9]  番号で移動
Cmd/Ctrl+Tab    次のタブ

### ペイン
Ctrl+Shift+|    垂直分割
Ctrl+Shift+_    水平分割
Leader z        ズーム

### その他
Cmd/Ctrl+Shift+R    設定リロード
Cmd/Ctrl+Shift+P    コマンドパレット
Cmd/Ctrl+F          検索
```

#### 2.2 学習用チートシート（段階的）

**Week 1: 必須キー（これだけは覚える）**
```
Ctrl+h/j/k/l    移動（最重要！）
<leader>ff      ファイル検索
Ctrl+S          保存
gd              定義ジャンプ
Prefix |/-      ペイン分割（Tmux）
Cmd/Ctrl+T      新規タブ（WezTerm）
```

**Week 2: よく使うキー**
```
<leader>fg      テキスト検索
<leader>e       ファイルツリー
<leader>gs      Git status
K               ホバー情報
Prefix c        新規ウィンドウ
```

**Week 3: 効率化キー**
```
<leader>ca      コードアクション
<leader>rn      リネーム
]h / [h         Hunk移動
Prefix z        ズーム
Tab/Shift+Tab   バッファ切り替え
```

---

## 🎯 実装優先順位

### Phase 1: 基礎構築（Week 1-2）
- [x] 要件定義の完成
- [x] キーバインディング設計の完成
- [x] クイック起動スクリプト（dev コマンド）の作成
- [ ] Neovim基本設定
  - [ ] init.lua構造の作成
  - [ ] lazy.nvimブートストラップ
  - [ ] 基本オプション設定（options.lua）
  - [ ] キーマッピング設定（keymaps.lua）- **統合ナビゲーション実装**
  - [ ] 自動コマンド設定（autocmds.lua）
- [ ] lazy.nvim設定
  - [ ] lua/config/lazy.luaの作成
  - [ ] プラグイン管理構造の構築
  - [ ] 遅延読み込み戦略の実装
  - [ ] lockfileの管理方針決定
- [ ] Tmux基本設定
  - [ ] .tmux.conf作成
  - [ ] Prefixキー設定（Ctrl+A）
  - [ ] 基本キーバインディング
  - [ ] vim-tmux-navigator統合
  - [ ] カラースキーム
- [ ] WezTerm設定
  - [x] wezterm.lua基本設定（OS別タブ管理）
  - [x] キーバインディング設定
  - [ ] Tmux統合設定
- [ ] セットアップスクリプト
  - [ ] setup.sh
  - [ ] install-neovim.sh
  - [ ] install-tmux.sh
  - [ ] install-wezterm.sh
  - [x] dev コマンドのインストール手順

### Phase 2: コア機能（Week 3-4）
- [ ] Neovimコアプラグイン導入（lazy.nvim使用）
  - [ ] カラースキーム（tokyonight.nvim）
  - [ ] Treesitter設定（lua/plugins/treesitter.lua）
    - [ ] 多言語パーサーインストール
    - [ ] テキストオブジェクト設定
  - [ ] LSP設定（lua/plugins/lsp.lua）
    - [ ] mason.nvim導入
    - [ ] mason-lspconfig.nvim設定
    - [ ] 各言語サーバー設定
      - [ ] コア言語（Lua, Bash, JSON, YAML, Markdown）
      - [ ] Web開発（TypeScript, JavaScript, HTML, CSS, Tailwind）
      - [ ] モバイル開発（Dart, Flutter, Kotlin, Java, Swift）
      - [ ] システムプログラミング（Rust, Go, C/C++）
      - [ ] スクリプト言語（Python, Ruby）
  - [ ] 補完設定（lua/plugins/completion.lua）
    - [ ] nvim-cmp設定
    - [ ] LuaSnip設定
    - [ ] 言語別スニペット
  - [ ] Telescope設定（lua/plugins/telescope.lua）
  - [ ] Gitsigns設定（lua/plugins/git.lua）
  - [ ] ステータスライン（lua/plugins/statusline.lua）
  - [ ] フォーマッター（lua/plugins/formatter.lua）
    - [ ] conform.nvim設定
    - [ ] 言語別フォーマッター設定
  - [ ] Linter（lua/plugins/linter.lua）
    - [ ] nvim-lint設定
    - [ ] 言語別Linter設定
- [ ] 言語別プラグイン導入
  - [ ] TypeScript/JavaScript（typescript-tools.nvim）
  - [ ] Flutter（flutter-tools.nvim）
  - [ ] Rust（rust-tools.nvim, crates.nvim）
  - [ ] Go（go.nvim）
  - [ ] Python（venv-selector.nvim）
  - [ ] Java（nvim-jdtls）
  - [ ] Ruby（vim-rails）
  - [ ] HTML/JSX（nvim-ts-autotag）
- [ ] Tmux統合
  - [ ] vim-tmux-navigator導入
  - [ ] クリップボード共有設定
  - [ ] TPMプラグイン設定
- [ ] キーバインディング統一
- [ ] lazy.nvim最適化
  - [ ] 遅延読み込み設定の調整
  - [ ] 起動時間の計測と改善

### Phase 3: 統合・最適化（Week 5-6）
- [ ] 推奨プラグイン導入
  - [ ] nvim-tree.lua
  - [ ] which-key.nvim
  - [ ] Comment.nvim
  - [ ] その他UI拡張
- [ ] Cursor設定作成
  - [ ] settings.json
  - [ ] keybindings.json
  - [ ] .cursorrules
- [ ] EditorConfig設定
- [ ] Git統合設定
- [ ] パフォーマンス最適化
  - [ ] lazy.nvimプロファイリング
  - [ ] 起動時間100ms以下達成
  - [ ] プラグイン遅延読み込みの最適化
- [ ] ドキュメント作成
  - [ ] Neovimガイド
  - [ ] lazy.nvim使い方ガイド
  - [ ] プラグイン一覧

### Phase 4: 移行・テスト（Week 7-8）
- [ ] AstroNvimからの移行ガイド
- [ ] 実環境でのテスト
- [ ] トラブルシューティング
- [ ] 最終調整

---

## ✅ 成功基準

### 1. パフォーマンス
- [ ] Neovim起動時間 < 100ms
- [ ] Tmuxセッション作成 < 1秒
- [ ] LSP応答時間 < 500ms

### 2. 使いやすさ
- [ ] 直感的なキーバインディング
- [ ] 一貫したUI/UX
- [ ] 分かりやすいドキュメント

### 3. 機能性
- [ ] LSP完全動作（定義ジャンプ、補完、診断）
- [ ] Git統合（変更表示、hunk操作）
- [ ] Tmux統合（シームレスなペイン移動）
- [ ] Cursor連携（設定共有、ワークフロー統合）

### 4. 保守性
- [ ] シンプルな設定構造
- [ ] コメント充実
- [ ] モジュール化された設計

---

## 📝 参考リソース

### Neovim
- [Neovim公式ドキュメント](https://neovim.io/doc/)
- [lazy.nvim](https://github.com/folke/lazy.nvim) - プラグインマネージャー
- [lazy.nvim Documentation](https://lazy.folke.io/) - 公式ドキュメント
- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - シンプルな設定例（lazy.nvim使用）
- [LazyVim](https://www.lazyvim.org/) - lazy.nvimベースのNeovim設定（参考用）
- [Neovim from Scratch](https://github.com/LunarVim/Neovim-from-scratch)
- [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim) - プラグイン一覧

### Tmux
- [Tmux公式ドキュメント](https://github.com/tmux/tmux/wiki)
- [TPM](https://github.com/tmux-plugins/tpm)
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)

### 統合
- [My Development Environment](https://mitchellh.com/writing/my-development-environment) - Mitchell Hashimoto
- [How I Setup Neovim](https://www.youtube.com/watch?v=w7i4amO_zaE) - ThePrimeagen

---

**このドキュメントは実装を進めながら随時更新します。**
