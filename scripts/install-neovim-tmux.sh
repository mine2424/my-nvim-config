#!/bin/bash

# ========================================
# Neovim + Tmux Setup Script
# ========================================

set -e

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/development/dotfiles}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ========================================
# Helper Functions
# ========================================

log_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
  echo -e "${GREEN}✓${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
  echo -e "${RED}✗${NC} $1"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# ========================================
# OS Detection
# ========================================

detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "linux"
  else
    echo "unknown"
  fi
}

OS=$(detect_os)

# ========================================
# Install Neovim
# ========================================

install_neovim() {
  log_info "Installing Neovim..."
  
  if command_exists nvim; then
    local version=$(nvim --version | head -n1)
    log_warn "Neovim is already installed: $version"
    return 0
  fi
  
  case "$OS" in
    macos)
      if command_exists brew; then
        brew install neovim
      else
        log_error "Homebrew not found. Please install Homebrew first."
        return 1
      fi
      ;;
    linux)
      if command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y neovim
      elif command_exists dnf; then
        sudo dnf install -y neovim
      elif command_exists pacman; then
        sudo pacman -S --noconfirm neovim
      else
        log_error "Unsupported package manager"
        return 1
      fi
      ;;
    *)
      log_error "Unsupported OS"
      return 1
      ;;
  esac
  
  log_success "Neovim installed successfully"
}

# ========================================
# Install Tmux
# ========================================

install_tmux() {
  log_info "Installing Tmux..."
  
  if command_exists tmux; then
    local version=$(tmux -V)
    log_warn "Tmux is already installed: $version"
    return 0
  fi
  
  case "$OS" in
    macos)
      if command_exists brew; then
        brew install tmux
      else
        log_error "Homebrew not found"
        return 1
      fi
      ;;
    linux)
      if command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y tmux
      elif command_exists dnf; then
        sudo dnf install -y tmux
      elif command_exists pacman; then
        sudo pacman -S --noconfirm tmux
      else
        log_error "Unsupported package manager"
        return 1
      fi
      ;;
    *)
      log_error "Unsupported OS"
      return 1
      ;;
  esac
  
  log_success "Tmux installed successfully"
}

# ========================================
# Install Required Tools
# ========================================

install_tools() {
  log_info "Installing required tools..."
  
  local tools=("ripgrep" "fd" "fzf")
  
  case "$OS" in
    macos)
      if command_exists brew; then
        for tool in "${tools[@]}"; do
          if ! command_exists "$tool"; then
            brew install "$tool"
          fi
        done
        
        # Optional tools
        brew install lazygit git-delta bat eza 2>/dev/null || true
      fi
      ;;
    linux)
      if command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y ripgrep fd-find fzf
      elif command_exists dnf; then
        sudo dnf install -y ripgrep fd-find fzf
      elif command_exists pacman; then
        sudo pacman -S --noconfirm ripgrep fd fzf
      fi
      ;;
  esac
  
  log_success "Required tools installed"
}

# ========================================
# Setup Neovim Config
# ========================================

setup_neovim_config() {
  log_info "Setting up Neovim configuration..."
  
  # Backup existing config
  if [ -d ~/.config/nvim ]; then
    log_warn "Backing up existing Neovim config..."
    mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)
  fi
  
  # Create symlink
  mkdir -p ~/.config
  ln -sf "$DOTFILES_DIR/nvim/.config/nvim" ~/.config/nvim
  
  log_success "Neovim config linked"
}

# ========================================
# Setup Tmux Config
# ========================================

setup_tmux_config() {
  log_info "Setting up Tmux configuration..."
  
  # Backup existing config
  if [ -f ~/.tmux.conf ]; then
    log_warn "Backing up existing Tmux config..."
    mv ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)
  fi
  
  # Create symlink
  ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf
  
  # Install TPM
  if [ ! -d ~/.tmux/plugins/tpm ]; then
    log_info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    log_success "TPM installed"
  fi
  
  log_success "Tmux config linked"
}

# ========================================
# Install dev command
# ========================================

install_dev_command() {
  log_info "Installing dev command..."
  
  mkdir -p ~/.local/bin
  cp "$DOTFILES_DIR/scripts/dev" ~/.local/bin/dev
  chmod +x ~/.local/bin/dev
  
  # Check if ~/.local/bin is in PATH
  if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    log_warn "~/.local/bin is not in PATH"
    log_info "Add this to your ~/.zshrc or ~/.bashrc:"
    echo '  export PATH="$HOME/.local/bin:$PATH"'
  fi
  
  log_success "dev command installed"
}

# ========================================
# Install Neovim Plugins
# ========================================

install_neovim_plugins() {
  log_info "Installing Neovim plugins..."
  
  nvim --headless "+Lazy! sync" +qa
  
  log_success "Neovim plugins installed"
}

# ========================================
# Install Tmux Plugins
# ========================================

install_tmux_plugins() {
  log_info "Installing Tmux plugins..."
  
  if [ -d ~/.tmux/plugins/tpm ]; then
    ~/.tmux/plugins/tpm/bin/install_plugins
    log_success "Tmux plugins installed"
  else
    log_warn "TPM not found. Run tmux and press Prefix + I to install plugins."
  fi
}

# ========================================
# Main
# ========================================

main() {
  echo ""
  echo "=========================================="
  echo "  Neovim + Tmux Setup"
  echo "=========================================="
  echo ""
  
  # Check if dotfiles directory exists
  if [ ! -d "$DOTFILES_DIR" ]; then
    log_error "Dotfiles directory not found: $DOTFILES_DIR"
    exit 1
  fi
  
  # Install dependencies
  install_neovim
  install_tmux
  install_tools
  
  echo ""
  log_info "Setting up configurations..."
  
  # Setup configs
  setup_neovim_config
  setup_tmux_config
  install_dev_command
  
  echo ""
  log_info "Installing plugins..."
  
  # Install plugins
  install_neovim_plugins
  install_tmux_plugins
  
  echo ""
  echo "=========================================="
  log_success "Setup complete!"
  echo "=========================================="
  echo ""
  echo "Next steps:"
  echo "  1. Restart your terminal or run: exec \$SHELL"
  echo "  2. Open Neovim and run: :checkhealth"
  echo "  3. Start Tmux and press Prefix (Ctrl+A) + I to install plugins"
  echo "  4. Try the dev command: dev --help"
  echo ""
  echo "Key bindings:"
  echo "  - Neovim: Space (Leader)"
  echo "  - Tmux: Ctrl+A (Prefix)"
  echo "  - Navigation: Ctrl+h/j/k/l (works across all layers)"
  echo ""
  echo "Documentation:"
  echo "  - Keybindings: docs/keybindings.md"
  echo "  - Requirements: docs/requirements/neovim-tmux-claude-parallel-dev.md"
  echo "  - Colorscheme: docs/colorscheme-integration.md"
  echo ""
}

main "$@"
