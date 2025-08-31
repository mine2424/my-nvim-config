#!/bin/bash

# ============================================================================
# Install Telescope Configuration for AstroNvim
# ============================================================================
# This script installs Telescope.nvim with enhanced configuration

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

print_info "Installing Telescope configuration for AstroNvim..."

# Check if config directory exists
if [[ ! -d ~/.config/nvim ]]; then
    print_warning "Neovim config directory not found. Please run setup first."
    exit 1
fi

# Create plugins directory if it doesn't exist
mkdir -p ~/.config/nvim/lua/plugins

# Copy Telescope configuration
if [[ -f ~/development/my-nvim-config/astronvim-configs/lua/plugins/telescope.lua ]]; then
    cp ~/development/my-nvim-config/astronvim-configs/lua/plugins/telescope.lua ~/.config/nvim/lua/plugins/
    print_success "Telescope configuration installed"
else
    print_warning "Telescope configuration file not found in astronvim-configs"
fi

print_success "Telescope installation complete!"
echo
echo -e "${GREEN}Key Features Added:${NC}"
echo "✓ Enhanced file finder with <Space>ff"
echo "✓ Live grep with <Space>fw"
echo "✓ Buffer search with <Space>fb"
echo "✓ File browser with <Space>fe"
echo "✓ Project search with <Space>fp"
echo "✓ Undo history with <Space>fu"
echo "✓ Git integration with <Space>g*"
echo "✓ LSP integration with <Space>l*"
echo "✓ Quick access with Ctrl+P"
echo
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Restart Neovim"
echo "2. Run :Lazy sync to install/update Telescope"
echo "3. Try <Space>ff to search files"
echo
echo -e "${YELLOW}Additional Keybindings:${NC}"
echo "• <C-p>     - Quick file search"
echo "• <C-S-p>   - Command palette"
echo "• <C-f>     - Search in current buffer"
echo "• <Space>fr - Resume last search"
echo "• <Space>fW - Live grep with arguments"
echo "• <Space>fu - Browse undo history"