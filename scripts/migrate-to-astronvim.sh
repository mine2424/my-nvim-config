#!/bin/bash

# ============================================================================
# AstroNvim Migration Script
# ============================================================================
# This script backs up current Neovim configuration and installs AstroNvim
# with support for Flutter, JavaScript/TypeScript, React, Next.js, and Python

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_step() { echo -e "${MAGENTA}[STEP]${NC} $1"; }

# Get timestamp for backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/.config/nvim-backup-$TIMESTAMP"

# ============================================================================
# Step 1: Check Prerequisites
# ============================================================================
check_prerequisites() {
    print_step "Checking prerequisites..."
    
    # Check Neovim version
    if command -v nvim &> /dev/null; then
        NVIM_VERSION=$(nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
        print_success "Neovim found: v$NVIM_VERSION"
        
        # Check if version is 0.10 or higher
        if [[ $(echo "$NVIM_VERSION >= 0.10" | bc -l) -eq 0 ]]; then
            print_warning "Neovim 0.10+ is recommended for AstroNvim v4"
        fi
    else
        print_error "Neovim is not installed. Please install Neovim first."
        exit 1
    fi
    
    # Check Git
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    print_success "Git found"
    
    # Check for Nerd Font
    print_info "Please ensure you have a Nerd Font installed for icons to display correctly"
    print_info "Recommended: JetBrainsMono Nerd Font"
}

# ============================================================================
# Step 2: Backup Current Configuration
# ============================================================================
backup_current_config() {
    print_step "Backing up current Neovim configuration..."
    
    # Create backup directory
    mkdir -p "$(dirname "$BACKUP_DIR")"
    
    # Backup directories if they exist
    if [[ -d "$HOME/.config/nvim" ]]; then
        cp -r "$HOME/.config/nvim" "$BACKUP_DIR"
        print_success "Backed up ~/.config/nvim to $BACKUP_DIR"
    fi
    
    if [[ -d "$HOME/.local/share/nvim" ]]; then
        cp -r "$HOME/.local/share/nvim" "$HOME/.local/share/nvim-backup-$TIMESTAMP"
        print_success "Backed up ~/.local/share/nvim"
    fi
    
    if [[ -d "$HOME/.local/state/nvim" ]]; then
        cp -r "$HOME/.local/state/nvim" "$HOME/.local/state/nvim-backup-$TIMESTAMP"
        print_success "Backed up ~/.local/state/nvim"
    fi
    
    if [[ -d "$HOME/.cache/nvim" ]]; then
        cp -r "$HOME/.cache/nvim" "$HOME/.cache/nvim-backup-$TIMESTAMP"
        print_success "Backed up ~/.cache/nvim"
    fi
    
    print_info "Backup completed. Your old config is saved in:"
    print_info "  - $BACKUP_DIR"
    print_info "  - ~/.local/share/nvim-backup-$TIMESTAMP"
    print_info "  - ~/.local/state/nvim-backup-$TIMESTAMP"
    print_info "  - ~/.cache/nvim-backup-$TIMESTAMP"
}

# ============================================================================
# Step 3: Clean Existing Configuration
# ============================================================================
clean_existing_config() {
    print_step "Cleaning existing Neovim configuration..."
    
    # Ask for confirmation
    echo -e "${YELLOW}This will remove your current Neovim configuration.${NC}"
    echo -e "${YELLOW}Make sure backup was successful before proceeding.${NC}"
    read -p "Continue? (y/n): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Migration cancelled."
        exit 0
    fi
    
    # Remove existing configurations
    rm -rf "$HOME/.config/nvim"
    rm -rf "$HOME/.local/share/nvim"
    rm -rf "$HOME/.local/state/nvim"
    rm -rf "$HOME/.cache/nvim"
    
    print_success "Cleaned existing configuration"
}

# ============================================================================
# Step 4: Install AstroNvim
# ============================================================================
install_astronvim() {
    print_step "Installing AstroNvim..."
    
    # Clone AstroNvim template
    git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
    
    # Remove .git directory to make it our own repository
    rm -rf ~/.config/nvim/.git
    
    print_success "AstroNvim installed successfully"
}

# ============================================================================
# Step 5: Create Custom Configuration
# ============================================================================
create_custom_config() {
    print_step "Creating custom configuration for development..."
    
    # Create plugins directory
    mkdir -p ~/.config/nvim/lua/plugins
    
    # Create AstroCore configuration with keymaps and options
    cat > ~/.config/nvim/lua/plugins/astrocore.lua << 'EOF'
return {
  "AstroNvim/astrocore",
  opts = {
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics_mode = 3,
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    options = {
      opt = {
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,
        tabstop = 2,
        shiftwidth = 2,
        expandtab = true,
        smartindent = true,
      },
      g = {
        mapleader = " ",
        maplocalleader = ",",
        autoformat_enabled = true,
        cmp_enabled = true,
        autopairs_enabled = true,
        diagnostics_mode = 3,
        icons_enabled = true,
        ui_notifications_enabled = true,
      },
    },
    mappings = {
      n = {
        -- Buffer navigation
        ["<S-l>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<S-h>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        
        -- Window navigation
        ["<C-h>"] = { "<C-w>h", desc = "Move to left split" },
        ["<C-j>"] = { "<C-w>j", desc = "Move to below split" },
        ["<C-k>"] = { "<C-w>k", desc = "Move to above split" },
        ["<C-l>"] = { "<C-w>l", desc = "Move to right split" },
        
        -- Resize windows
        ["<C-Up>"] = { "<cmd>resize -2<CR>", desc = "Resize split up" },
        ["<C-Down>"] = { "<cmd>resize +2<CR>", desc = "Resize split down" },
        ["<C-Left>"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" },
        ["<C-Right>"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" },
      },
    },
  },
}
EOF
    
    # Create AstroLSP configuration
    cat > ~/.config/nvim/lua/plugins/astrolsp.lua << 'EOF'
return {
  "AstroNvim/astrolsp",
  opts = {
    features = {
      autoformat = true,
      codelens = true,
      inlay_hints = true,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = {
          "lua",
          "python",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "dart",
          "json",
          "html",
          "css",
          "scss",
          "markdown",
        },
      },
      timeout_ms = 1000,
    },
    servers = {
      -- will be automatically installed by mason
    },
    config = {
      -- Dart/Flutter handled by flutter-tools.nvim
      -- dartls configuration removed - handled by flutter-tools.nvim
      -- TypeScript/JavaScript
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
      -- Python
      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
            },
          },
        },
      },
      -- Tailwind CSS
      tailwindcss = {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
              },
            },
          },
        },
      },
    },
  },
}
EOF
    
    # Create Mason configuration for LSP servers
    cat > ~/.config/nvim/lua/plugins/mason.lua << 'EOF'
return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        -- Flutter/Dart handled by flutter-tools.nvim
        -- "dartls", -- Removed: handled by flutter-tools.nvim
        
        -- JavaScript/TypeScript
        "tsserver",
        "eslint",
        
        -- React/Next.js (uses tsserver)
        "tailwindcss",
        "html",
        "cssls",
        "emmet_language_server",
        
        -- Python
        "pyright",
        "ruff_lsp",
        
        -- JSON/YAML
        "jsonls",
        "yamlls",
        
        -- Lua
        "lua_ls",
        
        -- Markdown
        "marksman",
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "python",
        "js",
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {
        -- Formatters
        "prettier",
        "black",
        "isort",
        "stylua",
        
        -- Linters
        "eslint_d",
        "pylint",
        "flake8",
      },
    },
  },
}
EOF
    
    # Create Treesitter configuration
    cat > ~/.config/nvim/lua/plugins/treesitter.lua << 'EOF'
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "markdown",
      "markdown_inline",
      "bash",
      "python",
      "javascript",
      "typescript",
      "tsx",
      "jsx",
      "html",
      "css",
      "scss",
      "json",
      "yaml",
      "toml",
      "dart",
      "regex",
      "graphql",
      "prisma",
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
  },
}
EOF
    
    # Create community plugins configuration
    cat > ~/.config/nvim/lua/plugins/community.lua << 'EOF'
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.motion.leap-nvim" },
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.diffview-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.lsp.lsp-inlayhints-nvim" },
  { import = "astrocommunity.completion.copilot-lua" },
}
EOF
    
    # Copy AI configuration if it exists
    if [[ -f "$HOME/development/my-nvim-config/astronvim-configs/lua/plugins/ai.lua" ]]; then
        cp "$HOME/development/my-nvim-config/astronvim-configs/lua/plugins/ai.lua" ~/.config/nvim/lua/plugins/ai.lua
        print_success "AI configuration installed"
    fi
    
    # Copy Telescope configuration if it exists
    if [[ -f "$HOME/development/my-nvim-config/astronvim-configs/lua/plugins/telescope.lua" ]]; then
        cp "$HOME/development/my-nvim-config/astronvim-configs/lua/plugins/telescope.lua" ~/.config/nvim/lua/plugins/telescope.lua
        print_success "Telescope configuration installed"
    fi
    
    # Create custom user plugins
    cat > ~/.config/nvim/lua/plugins/user.lua << 'EOF'
return {
  -- Flutter Tools
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        ui = {
          border = "rounded",
          notification_style = "native",
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
          },
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
        },
        flutter_path = nil,
        flutter_lookup_cmd = nil,
        fvm = true,
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "Comment",
          prefix = "// ",
          enabled = true,
        },
        dev_log = {
          enabled = true,
          open_cmd = "tabedit",
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = true,
        },
        outline = {
          open_cmd = "30vnew",
          auto_open = false,
        },
        lsp = {
          color = {
            enabled = true,
            background = false,
            virtual_text = true,
            virtual_text_str = "■",
          },
          on_attach = function(client, bufnr)
            -- This ensures flutter-tools LSP properly attaches
            -- and prevents conflicts with mason-lspconfig
            require("astrolsp").on_attach(client, bufnr)
          end,
          capabilities = function()
            -- Use AstroNvim's LSP capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            return capabilities
          end,
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            analysisExcludedFolders = {
              vim.fn.expand("$HOME/.pub-cache"),
              vim.fn.expand("$HOME/fvm"),
            },
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            updateImportsOnRename = true,
          },
        },
      })
    end,
  },
  
  -- TypeScript Tools (enhanced TypeScript support)
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  
  -- Package info for package.json
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    opts = {},
    event = "BufRead package.json",
  },
  
  -- Better Python indentation
  {
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
  },
  
  -- Auto-close tags for React/JSX
  {
    "windwp/nvim-ts-autotag",
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true,
    },
  },
  
  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  
  -- Database client
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  
  -- REST client
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = "http",
    config = function()
      require("rest-nvim").setup({
        result_split_horizontal = false,
        result_split_in_place = false,
        skip_ssl_verification = false,
        encode_url = true,
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          show_url = true,
          show_http_info = true,
          show_headers = true,
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
            end
          },
        },
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
      })
    end,
  },
}
EOF
    
    print_success "Custom configuration created"
}

# ============================================================================
# Step 6: Create Helper Scripts
# ============================================================================
create_helper_scripts() {
    print_step "Creating helper scripts..."
    
    # Create Flutter project launcher
    cat > ~/bin/nvim-flutter << 'EOF'
#!/bin/bash
# Launch Neovim with Flutter project
cd "$1" || exit
nvim .
EOF
    chmod +x ~/bin/nvim-flutter
    
    # Create React/Next.js project launcher
    cat > ~/bin/nvim-react << 'EOF'
#!/bin/bash
# Launch Neovim with React/Next.js project
cd "$1" || exit
nvim .
EOF
    chmod +x ~/bin/nvim-react
    
    # Create Python project launcher
    cat > ~/bin/nvim-python << 'EOF'
#!/bin/bash
# Launch Neovim with Python project
cd "$1" || exit
source .venv/bin/activate 2>/dev/null || source venv/bin/activate 2>/dev/null
nvim .
EOF
    chmod +x ~/bin/nvim-python
    
    print_success "Helper scripts created in ~/bin/"
}

# ============================================================================
# Step 7: Post-Installation Instructions
# ============================================================================
show_post_install_instructions() {
    echo
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}        AstroNvim Installation Complete! 🚀${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo
    echo -e "${BLUE}Next Steps:${NC}"
    echo "1. Launch Neovim: nvim"
    echo "2. Wait for plugins to install automatically"
    echo "3. Install language servers:"
    echo "   - :LspInstall dartls         (Flutter/Dart)"
    echo "   - :LspInstall tsserver        (TypeScript/JavaScript)"
    echo "   - :LspInstall pyright         (Python)"
    echo "   - :LspInstall tailwindcss     (Tailwind CSS)"
    echo
    echo -e "${BLUE}Key Mappings:${NC}"
    echo "   Leader key: <Space>"
    echo "   - <Space>ff  Find files"
    echo "   - <Space>fg  Find text (grep)"
    echo "   - <Space>fb  Find buffers"
    echo "   - <Space>e   File explorer"
    echo "   - <Space>ld  Show diagnostics"
    echo "   - <Space>lf  Format code"
    echo "   - gd         Go to definition"
    echo "   - K          Show hover info"
    echo
    echo -e "${BLUE}Flutter Commands:${NC}"
    echo "   - <Space>Fa  Flutter run app"
    echo "   - <Space>Fq  Flutter quit"
    echo "   - <Space>Fr  Flutter reload"
    echo "   - <Space>FR  Flutter restart"
    echo "   - <Space>Fd  Flutter devices"
    echo
    echo -e "${YELLOW}Your old configuration is backed up at:${NC}"
    echo "   $BACKUP_DIR"
    echo
    echo -e "${GREEN}Happy coding with AstroNvim! 🎉${NC}"
}

# ============================================================================
# Main Execution
# ============================================================================
main() {
    # Check for --config-only flag
    if [[ "$1" == "--config-only" ]]; then
        # Only create configuration files, skip backup and installation
        create_custom_config
        return 0
    fi
    
    echo -e "${MAGENTA}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}        AstroNvim Migration Script${NC}"
    echo -e "${MAGENTA}════════════════════════════════════════════════════════════════${NC}"
    echo
    
    check_prerequisites
    backup_current_config
    clean_existing_config
    install_astronvim
    create_custom_config
    create_helper_scripts
    show_post_install_instructions
}

# Run the script
main "$@"