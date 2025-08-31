#!/bin/bash

# ============================================================================
# Fix AstroNvim Configuration Issues
# ============================================================================
# This script fixes:
# 1. Avante deprecated configuration warnings
# 2. Unknown LSP server dartls in mason-lspconfig

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

print_info "Fixing AstroNvim configuration issues..."

# Fix 1: Update Avante configuration in ai.lua
if [[ -f ~/.config/nvim/lua/plugins/ai.lua ]]; then
    print_info "Fixing Avante deprecated configuration..."
    
    # Backup the file
    cp ~/.config/nvim/lua/plugins/ai.lua ~/.config/nvim/lua/plugins/ai.lua.bak
    
    # Update claude and openai config to use providers structure
    sed -i '' 's/claude = {/providers = {\n        claude = {/g' ~/.config/nvim/lua/plugins/ai.lua
    sed -i '' 's/openai = {/},\n        openai = {/g' ~/.config/nvim/lua/plugins/ai.lua
    # Add closing bracket for providers
    sed -i '' '/openai = {/,/},$/s/},$/},\n      },/' ~/.config/nvim/lua/plugins/ai.lua
    
    print_success "Avante configuration updated"
else
    # Copy the fixed ai.lua from astronvim-configs
    if [[ -f ~/development/my-nvim-config/astronvim-configs/lua/plugins/ai.lua ]]; then
        mkdir -p ~/.config/nvim/lua/plugins
        cp ~/development/my-nvim-config/astronvim-configs/lua/plugins/ai.lua ~/.config/nvim/lua/plugins/
        print_success "AI configuration installed with fixes"
    fi
fi

# Fix 2: Remove dartls from mason.lua and update flutter-tools configuration
if [[ -f ~/.config/nvim/lua/plugins/mason.lua ]]; then
    print_info "Removing dartls from mason-lspconfig..."
    
    # Backup the file
    cp ~/.config/nvim/lua/plugins/mason.lua ~/.config/nvim/lua/plugins/mason.lua.bak
    
    # Remove dartls from ensure_installed
    sed -i '' '/"dartls",/d' ~/.config/nvim/lua/plugins/mason.lua
    # Add comment about dartls being handled by flutter-tools
    sed -i '' 's/ensure_installed = {/ensure_installed = {\n        -- Flutter\/Dart handled by flutter-tools.nvim/' ~/.config/nvim/lua/plugins/mason.lua
    
    print_success "Removed dartls from mason-lspconfig"
fi

# Fix 3: Update AstroLSP configuration to remove dartls config
if [[ -f ~/.config/nvim/lua/plugins/astrolsp.lua ]]; then
    print_info "Updating AstroLSP configuration..."
    
    # Backup the file
    cp ~/.config/nvim/lua/plugins/astrolsp.lua ~/.config/nvim/lua/plugins/astrolsp.lua.bak
    
    # Remove dartls configuration block
    sed -i '' '/dartls = {/,/^      },$/d' ~/.config/nvim/lua/plugins/astrolsp.lua
    # Add comment about dartls
    sed -i '' 's/config = {/config = {\n      -- Dart\/Flutter handled by flutter-tools.nvim/' ~/.config/nvim/lua/plugins/astrolsp.lua
    
    print_success "Updated AstroLSP configuration"
fi

# Fix 4: Ensure flutter-tools.nvim is properly configured
if [[ -f ~/.config/nvim/lua/plugins/user.lua ]]; then
    print_info "Checking flutter-tools configuration..."
    
    # Check if flutter-tools has proper LSP configuration
    if ! grep -q "on_attach.*astrolsp" ~/.config/nvim/lua/plugins/user.lua; then
        print_warning "Flutter-tools LSP configuration may need updating"
        print_info "Consider adding on_attach and capabilities functions to flutter-tools lsp config"
    else
        print_success "Flutter-tools configuration looks good"
    fi
fi

print_success "All fixes applied!"
print_info "Please restart Neovim for changes to take effect"
print_info "Run :Lazy sync to update plugins if needed"

# Show summary
echo
echo -e "${GREEN}Fixed Issues:${NC}"
echo "✓ Avante deprecated configuration warnings"
echo "✓ Unknown LSP server dartls in mason-lspconfig"
echo
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Restart Neovim"
echo "2. Run :Lazy sync to update plugins"
echo "3. Run :checkhealth to verify configuration"