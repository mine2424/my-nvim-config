-- ===============================================
-- Flutter開発環境設定（DAP機能なし版）
-- ===============================================

-- 既存のプラグインマネージャーとの競合を防ぐ
local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    return nil
  end
  return result
end

-- 既存のpacker設定をクリア
vim.g.loaded_packer = nil
package.loaded.packer = nil
package.loaded['packer.nvim'] = nil

-- プラグインマネージャー（lazy.nvim）の自動インストール
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Flutter開発用プラグイン設定（DAP機能なし）
require("lazy").setup({
  -- Flutter Tools - Flutter開発の核となるプラグイン
  {
    'akinsho/flutter-tools.nvim',
    ft = { "dart" },
    cmd = {
      "FlutterRun", "FlutterDevices", "FlutterEmulators", "FlutterReload",
      "FlutterRestart", "FlutterQuit", "FlutterDevTools"
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- UI改善
    },
    config = function()
      require("flutter-tools").setup {
        ui = {
          border = "rounded",
          notification_style = 'native'
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
            project_config = true,
          }
        },
        debugger = {
          enabled = false,  -- デバッグ機能を無効化
          run_via_dap = false,
          exception_breakpoints = {},
        },
        flutter_path = "/opt/homebrew/bin/flutter",
        flutter_lookup_cmd = nil,
        fvm = false,
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "ErrorMsg",
          prefix = ">",
          enabled = true,
        },
        dev_log = {
          enabled = true,
          notify_errors = false,
          open_cmd = "tabedit",
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = false,
        },
        outline = {
          open_cmd = "30vnew",
          auto_open = false,
        },
        lsp = {
          color = {
            enabled = false,
            background = false,
            foreground = false,
            virtual_text = true,
            virtual_text_str = "■",
          },
          on_attach = function(client, bufnr)
            -- LSP用キーマップ
            local opts = { buffer = bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
            
            -- Flutter専用キーマップ
            vim.keymap.set('n', '<Leader>fr', '<cmd>FlutterRun<cr>', opts)
            vim.keymap.set('n', '<Leader>fq', '<cmd>FlutterQuit<cr>', opts)
            vim.keymap.set('n', '<Leader>fR', '<cmd>FlutterRestart<cr>', opts)
            vim.keymap.set('n', '<Leader>fh', '<cmd>FlutterReload<cr>', opts)
            vim.keymap.set('n', '<Leader>fd', '<cmd>FlutterDevices<cr>', opts)
            vim.keymap.set('n', '<Leader>fe', '<cmd>FlutterEmulators<cr>', opts)
            vim.keymap.set('n', '<Leader>fo', '<cmd>FlutterOutlineToggle<cr>', opts)
            vim.keymap.set('n', '<Leader>ft', '<cmd>FlutterDevTools<cr>', opts)
            vim.keymap.set('n', '<Leader>fc', '<cmd>FlutterLogClear<cr>', opts)
          end,
          capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            require('cmp_nvim_lsp').default_capabilities()
          ),
          settings = {
            dart = {
              completeFunctionCalls = true,
              showTodos = true,
              lineLength = 120,
            }
          }
        }
      }
    end,
  },

  -- 補完エンジン
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      -- friendly-snippetsを読み込み
      require("luasnip.loaders.from_vscode").lazy_load()
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })
    end,
  },

  -- Treesitter - シンタックスハイライト
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "dart", "yaml", "json", "markdown", "lua", "vim" },
        auto_install = true,
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        -- Neovim 0.10での競合を回避
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = {"BufWrite", "CursorHold"},
        },
      }
    end,
  },

  -- Telescope - ファジーファインダー
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })
      
      -- Telescopeキーマップ
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<Leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<Leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<Leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<Leader>fh', builtin.help_tags, {})
      vim.keymap.set('n', '<Leader>fs', builtin.lsp_document_symbols, {})
      vim.keymap.set('n', '<Leader>fw', builtin.lsp_workspace_symbols, {})
    end,
  },

  -- Git統合
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
        },
      }
    end,
  },

  -- ファイルエクスプローラー
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {
        view = {
          width = 30,
          side = 'left',
        },
        filters = {
          dotfiles = false,
          custom = { '.git', 'node_modules', '.cache' },
        },
        git = {
          enable = true,
          ignore = false,
        },
      }
      vim.keymap.set('n', '<Leader>e', ':NvimTreeToggle<CR>', {})
    end,
  },

  -- Flutterプロジェクト管理
  {
    'RobertBrunhage/flutter-riverpod-snippets',
    ft = 'dart',
  },

  -- YAML設定ファイル支援
  {
    'stephpy/vim-yaml',
    ft = 'yaml',
  },
}, {
  ui = {
    border = "rounded",
  },
})

-- ===============================================
-- Flutter開発用自動コマンド
-- ===============================================

local flutter_group = vim.api.nvim_create_augroup("FlutterDev", { clear = true })

-- Dartファイル専用設定
vim.api.nvim_create_autocmd("FileType", {
  group = flutter_group,
  pattern = "dart",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.colorcolumn = "120"
    
    -- Dart特有のキーマップ
    vim.keymap.set('n', '<Leader>di', ':FlutterRun --verbose<CR>', { buffer = true })
    vim.keymap.set('n', '<Leader>dh', ':FlutterReload<CR>', { buffer = true })
    vim.keymap.set('n', '<Leader>dR', ':FlutterRestart<CR>', { buffer = true })
  end,
})

-- pubspec.yaml用設定
vim.api.nvim_create_autocmd("BufRead", {
  group = flutter_group,
  pattern = "pubspec.yaml",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- Flutter専用保存時処理
vim.api.nvim_create_autocmd("BufWritePre", {
  group = flutter_group,
  pattern = "*.dart",
  callback = function()
    -- 保存時に自動フォーマット
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
})

-- ===============================================
-- Flutter開発用ユーティリティ関数
-- ===============================================

-- Flutterプロジェクト検出
function _G.is_flutter_project()
  return vim.fn.filereadable(vim.fn.getcwd() .. '/pubspec.yaml') == 1
end

-- Flutter開発モード切り替え
function _G.toggle_flutter_mode()
  if _G.is_flutter_project() then
    print("Flutter development mode enabled")
    vim.cmd('FlutterRun')
  else
    print("Not a Flutter project")
  end
end

-- クイックFlutter新規プロジェクト作成
function _G.create_flutter_project()
  local project_name = vim.fn.input("Project name: ")
  if project_name ~= "" then
    vim.fn.system("flutter create " .. project_name)
    vim.cmd("cd " .. project_name)
    print("Flutter project '" .. project_name .. "' created")
  end
end

-- Flutter開発用ステータスライン更新
function _G.flutter_statusline()
  local status = ""
  if _G.is_flutter_project() then
    status = status .. "📱 Flutter"
    
    -- Flutterデバイス情報取得
    local device_info = vim.fn.system("flutter devices --machine 2>/dev/null")
    if vim.v.shell_error == 0 and device_info ~= "" then
      status = status .. " | 📲"
    end
  end
  return status
end

-- ===============================================
-- Flutter開発用キーマップ
-- ===============================================

-- グローバルFlutterキーマップ
vim.keymap.set('n', '<Leader>Fn', ':lua _G.create_flutter_project()<CR>', { desc = 'New Flutter project' })
vim.keymap.set('n', '<Leader>Ft', ':lua _G.toggle_flutter_mode()<CR>', { desc = 'Toggle Flutter mode' })
vim.keymap.set('n', '<Leader>Fl', ':FlutterLogToggle<CR>', { desc = 'Toggle Flutter logs' })
vim.keymap.set('n', '<Leader>Fs', ':FlutterSuper<CR>', { desc = 'Flutter super class' })
vim.keymap.set('n', '<Leader>Fw', ':FlutterWrap<CR>', { desc = 'Flutter wrap widget' })

print("Flutter development environment loaded! 🎯 (DAP debugging disabled)")