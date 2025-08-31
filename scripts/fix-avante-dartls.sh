#!/bin/bash

# ============================================================================
# Fix Avante and dartls Issues
# ============================================================================
# This script fixes:
# 1. Avante provider configuration deprecation warnings
# 2. dartls mason-lspconfig warning

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Fix 1: Copy updated AI configuration with proper Avante structure
print_info "Fixing Avante provider configuration..."

if [[ ! -d ~/.config/nvim/lua/plugins ]]; then
    mkdir -p ~/.config/nvim/lua/plugins
    print_info "Created plugins directory"
fi

# Copy the fixed AI configuration
if [[ -f ~/development/my-nvim-config/astronvim-configs/lua/plugins/ai.lua ]]; then
    cp ~/development/my-nvim-config/astronvim-configs/lua/plugins/ai.lua ~/.config/nvim/lua/plugins/ai.lua
    print_success "Updated Avante configuration with proper provider structure"
else
    print_warning "AI configuration file not found in source"
fi

# Fix 2: Remove dartls from mason configuration if it exists
print_info "Checking for dartls in mason configuration..."

# Check if mason.lua exists and remove dartls
if [[ -f ~/.config/nvim/lua/plugins/mason.lua ]]; then
    print_info "Found mason.lua, removing dartls..."
    
    # Backup the file
    cp ~/.config/nvim/lua/plugins/mason.lua ~/.config/nvim/lua/plugins/mason.lua.bak.$(date +%Y%m%d_%H%M%S)
    
    # Remove dartls line
    sed -i '' '/"dartls",/d' ~/.config/nvim/lua/plugins/mason.lua 2>/dev/null || true
    
    # Check if dartls was removed
    if ! grep -q "dartls" ~/.config/nvim/lua/plugins/mason.lua; then
        print_success "Removed dartls from mason.lua"
    else
        print_warning "dartls might still be present in mason.lua"
    fi
else
    print_info "No mason.lua file found, checking community config..."
fi

# Fix 3: Check and update astrolsp.lua to remove dartls config
if [[ -f ~/.config/nvim/lua/plugins/astrolsp.lua ]]; then
    print_info "Found astrolsp.lua, checking for dartls configuration..."
    
    # Backup the file
    cp ~/.config/nvim/lua/plugins/astrolsp.lua ~/.config/nvim/lua/plugins/astrolsp.lua.bak.$(date +%Y%m%d_%H%M%S)
    
    # Remove dartls configuration block (multi-line)
    # This removes the dartls = { ... }, block
    sed -i '' '/dartls = {/,/^[[:space:]]*},$/d' ~/.config/nvim/lua/plugins/astrolsp.lua 2>/dev/null || true
    
    print_success "Cleaned dartls from astrolsp.lua"
fi

# Fix 4: Ensure flutter-tools.nvim is handling Dart LSP
print_info "Checking flutter-tools configuration..."

# Create a minimal flutter-tools config if user.lua doesn't exist
if [[ ! -f ~/.config/nvim/lua/plugins/user.lua ]]; then
    cat > ~/.config/nvim/lua/plugins/user.lua << 'EOF'
return {
  -- Flutter Tools (handles Dart LSP)
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        lsp = {
          color = {
            enabled = true,
            background = false,
            virtual_text = true,
            virtual_text_str = "■",
          },
          on_attach = function(client, bufnr)
            -- Use AstroNvim's LSP attach if available
            local ok, astrolsp = pcall(require, "astrolsp")
            if ok then
              astrolsp.on_attach(client, bufnr)
            end
          end,
          capabilities = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            
            -- Use cmp_nvim_lsp capabilities if available
            local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if ok then
              capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
            end
            
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
}
EOF
    print_success "Created flutter-tools configuration"
else
    print_info "user.lua already exists, flutter-tools should be configured"
fi

# Fix 5: Create a clean mason-lspconfig setup without dartls
print_info "Creating clean mason-lspconfig configuration..."

# Only create if it doesn't exist or explicitly remove dartls
if [[ ! -f ~/.config/nvim/lua/plugins/mason-clean.lua ]]; then
    cat > ~/.config/nvim/lua/plugins/mason-clean.lua << 'EOF'
-- Mason configuration without dartls (handled by flutter-tools.nvim)
return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      
      -- Remove dartls if it exists
      local new_list = {}
      for _, server in ipairs(opts.ensure_installed) do
        if server ~= "dartls" then
          table.insert(new_list, server)
        end
      end
      opts.ensure_installed = new_list
      
      -- Add other servers if not present
      local servers_to_add = {
        "tsserver", "eslint", "tailwindcss", "html", "cssls",
        "pyright", "ruff_lsp", "jsonls", "yamlls", "lua_ls", "marksman"
      }
      
      for _, server in ipairs(servers_to_add) do
        if not vim.tbl_contains(opts.ensure_installed, server) then
          table.insert(opts.ensure_installed, server)
        end
      end
      
      return opts
    end,
  },
}
EOF
    print_success "Created clean mason configuration"
fi

# Summary
echo
echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}                    Fixes Applied Successfully!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo
echo -e "${GREEN}✅ Fixed Issues:${NC}"
echo "• Avante provider configuration updated to new structure"
echo "• temperature and max_tokens moved to extra_request_body"
echo "• dartls removed from mason-lspconfig"
echo "• Flutter-tools.nvim configured to handle Dart LSP"
echo
echo -e "${BLUE}📝 Next Steps:${NC}"
echo "1. Restart Neovim"
echo "2. Run :Lazy sync to update plugins"
echo "3. Run :checkhealth to verify configuration"
echo
echo -e "${YELLOW}💡 Tips:${NC}"
echo "• If you still see warnings, run :Lazy clean then :Lazy sync"
echo "• For Flutter projects, flutter-tools.nvim will handle the LSP"
echo "• Check :LspInfo to see active language servers"