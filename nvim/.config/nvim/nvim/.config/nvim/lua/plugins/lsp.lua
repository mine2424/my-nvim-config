-- ========================================
-- LSP Configuration
-- ========================================

return {
  -- Mason: LSP server manager
  {
    "mason-org/mason.nvim",
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

  -- Mason-LSPConfig: Auto-setup LSP servers
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        -- Core languages
        "lua_ls",
        "bashls",
        "jsonls",
        "yamlls",
        "marksman",
        
        -- Web development
        "tsserver",
        "html",
        "cssls",
        "tailwindcss",
        "eslint",
        
        -- Mobile development
        "dartls",
        "kotlin_language_server",
        
        -- System programming
        "rust_analyzer",
        "gopls",
        "clangd",
        
        -- Scripting languages
        "pyright",
        "ruff_lsp",
        "solargraph",
      },
      automatic_installation = true,
    },
  },

  -- LSPConfig: LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Common on_attach function
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        
        -- Format on save (if supported)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end

      -- LSP server configurations
      local servers = {
        -- ========================================
        -- Lua
        -- ========================================
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
              format = {
                enable = false,  -- Use stylua instead
              },
            },
          },
        },

        -- ========================================
        -- TypeScript/JavaScript
        -- ========================================
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- ========================================
        -- Python
        -- ========================================
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },

        ruff_lsp = {
          init_options = {
            settings = {
              args = {},
            },
          },
        },

        -- ========================================
        -- Rust
        -- ========================================
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
              },
              checkOnSave = {
                command = "clippy",
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },

        -- ========================================
        -- Go
        -- ========================================
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },

        -- ========================================
        -- Dart/Flutter
        -- ========================================
        dartls = {
          settings = {
            dart = {
              enableSnippets = true,
              lineLength = 100,
              completeFunctionCalls = true,
            },
          },
        },

        -- ========================================
        -- Ruby
        -- ========================================
        solargraph = {
          settings = {
            solargraph = {
              diagnostics = true,
              formatting = true,
            },
          },
        },

        -- ========================================
        -- Kotlin
        -- ========================================
        kotlin_language_server = {},

        -- ========================================
        -- C/C++
        -- ========================================
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
          },
        },

        -- ========================================
        -- Other languages (default settings)
        -- ========================================
        bashls = {},
        jsonls = {},
        yamlls = {},
        marksman = {},
        html = {},
        cssls = {},
        tailwindcss = {},
        eslint = {},
      }

      -- Setup all servers
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        lspconfig[server].setup(config)
      end
    end,
  },
}
