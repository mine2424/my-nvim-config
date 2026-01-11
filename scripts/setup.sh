#!/bin/bash

# ===============================================
# Development Environment Setup Script
# ===============================================
# Unified setup script for development tools and configurations
# Supports: macOS, Linux (Ubuntu/Debian)

set -e  # Exit on error

# ===============================================
# Configuration and Constants
# ===============================================
SCRIPT_VERSION="2.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Setup modes
readonly MODE_FULL="full"
readonly MODE_QUICK="quick"
readonly MODE_CONFIG_ONLY="config-only"
readonly MODE_STARSHIP_ONLY="starship-only"

# Default settings
INSTALL_STARSHIP=true
INSTALL_FLUTTER=false
DRY_RUN=false

# Error handling
set -euo pipefail
trap 'log_error "Script failed on line $LINENO"' ERR

# ===============================================
# Utility Functions
# ===============================================

# Logging functions
log_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_step() {
    echo -e "${BLUE}🔄 $1${NC}"
}

# OS Detection
detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macOS" ;;
        Linux*)     
            if [[ -f /etc/debian_version ]]; then
                echo "debian"
            elif [[ -f /etc/redhat-release ]]; then
                echo "redhat"
            else
                echo "linux"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*) echo "windows" ;;
        *)          echo "unknown" ;;
    esac
}

# Package manager detection
detect_package_manager() {
    local os="$1"
    case "$os" in
        macOS)
            if command -v brew &> /dev/null; then
                echo "brew"
            else
                echo "none"
            fi
            ;;
        debian)
            echo "apt"
            ;;
        redhat)
            echo "yum"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# ===============================================
# Display Functions
# ===============================================

show_banner() {
    echo -e "${BLUE}${BOLD}"
    cat << 'EOF'
    🚀 Development Environment Setup
    =========================================
    
    Complete setup for modern development:
    ⭐ Starship prompt with Flutter/Dart integration
    🔧 All configs and key bindings optimized
    
EOF
    echo -e "${NC}"
    echo -e "${CYAN}Version: $SCRIPT_VERSION${NC}"
    echo -e "${CYAN}Project: $(basename "$PROJECT_ROOT")${NC}"
    echo ""
}

show_help() {
    cat << EOF
Usage: $0 [MODE] [OPTIONS]

MODES:
  (no argument)       Only copy configuration files (default)
  --full              Complete setup with all installations
  full                Complete setup with all installations (legacy)
  quick               Config files only (assumes dependencies installed)
  config-only         Only copy configuration files (same as default)
  starship-only       Install and configure Starship only

OPTIONS:
  --no-starship       Skip Starship installation
  --no-flutter        Skip Flutter installation
  --dry-run           Show what would be done without executing
  --help, -h          Show this help message

EXAMPLES:
  $0                          # Copy configs only (safe default)
  $0 --full                   # Full setup with all components
  $0 full                     # Full setup (legacy syntax)
  $0 quick                    # Quick setup (configs only)
  $0 config-only              # Copy configs only (explicit)
  $0 starship-only            # Install Starship only
  $0 --full --no-flutter      # Full setup without Flutter

EOF
}

# ===============================================
# Installation Functions
# ===============================================

install_homebrew() {
    if ! command_exists brew; then
        log_step "Installing Homebrew..."
        if [[ ! "$DRY_RUN" == "true" ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        log_success "Homebrew installed"
    else
        log_success "Homebrew already installed"
    fi
}

install_packages_macos() {
    log_step "Installing packages via Homebrew..."
    # Essential packages only - removed btop (resource heavy)
    local packages=(
        "git"
        "ripgrep"
        "fd"
        "fzf"
        "node"
        "tmux"
        "sheldon"     # Plugin manager for zsh
        "eza"         # Modern replacement for ls
        "bat"         # Modern replacement for cat
        "lazygit"     # Terminal UI for git
        "mise"        # Runtime version manager (formerly rtx)
    )
    
    
    if [[ "$INSTALL_FLUTTER" == "true" ]]; then
        packages+=("--cask flutter")
    fi
    
    if [[ ! "$DRY_RUN" == "true" ]]; then
        brew update
        for package in "${packages[@]}"; do
            if [[ "$package" == "--cask"* ]]; then
                brew install $package || log_warning "Failed to install $package"
            else
                brew install "$package" || log_warning "Failed to install $package"
            fi
        done
    fi
    
    log_success "Package installation completed"
}

install_packages_debian() {
    log_step "Installing packages via apt..."
    
    if [[ ! "$DRY_RUN" == "true" ]]; then
        sudo apt update
        sudo apt install -y \
            curl \
            git \
            build-essential \
            ripgrep \
            fd-find \
            fzf \
            tmux \
            nodejs \
            npm \
            direnv        # Directory-based environment management
        
        # Install modern CLI tools via cargo
        log_step "Installing modern CLI tools..."
        # Install tools one by one to handle failures gracefully
        local rust_tools=("eza" "bat" "dust" "duf" "procs")
        for tool in "${rust_tools[@]}"; do
            if ! command_exists "$tool"; then
                cargo install "$tool" || log_warning "Failed to install $tool"
            fi
        done
        
        # Install sheldon
        if ! command_exists sheldon; then
            log_step "Installing sheldon..."
            curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
        fi
        
        # Install lazygit
        if ! command_exists lazygit; then
            log_step "Installing lazygit..."
            LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            tar xf lazygit.tar.gz lazygit
            sudo install lazygit /usr/local/bin
            rm lazygit.tar.gz lazygit
        fi
        
        # Install mise
        if ! command_exists mise; then
            log_step "Installing mise..."
            curl https://mise.run | sh
        fi
    fi
    
    log_success "Package installation completed"
}

install_starship() {
    if command_exists starship; then
        log_success "Starship already installed ($(starship --version))"
        return 0
    fi
    
    log_step "Installing Starship..."
    if [[ ! "$DRY_RUN" == "true" ]]; then
        curl -sS https://starship.rs/install.sh | sh -s -- --yes
    fi
    log_success "Starship installed"
}

# ===============================================
# Configuration Functions
# ===============================================

setup_directories() {
    log_step "Setting up configuration directories..."
    
    local dirs=(
        "$HOME/.config/sheldon"
        "$HOME/.local/bin"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ ! "$DRY_RUN" == "true" ]]; then
            mkdir -p "$dir"
        fi
    done
    
    log_success "Directories created"
}

install_starship_config() {
    if [[ "$INSTALL_STARSHIP" != "true" ]]; then
        log_info "Skipping Starship configuration"
        return 0
    fi
    
    log_step "Installing Starship configuration..."
    
    # Install Starship if not installed
    install_starship
    
    # Copy Starship config
    if [[ ! "$DRY_RUN" == "true" ]]; then
        mkdir -p "$HOME/.config"
        cp "$PROJECT_ROOT/starship.toml" "$HOME/.config/starship.toml"
    fi
    
    # Configure shell integration
    configure_starship_shell
    
    log_success "Starship configuration installed"
}


install_zsh_config() {
    log_step "Installing Zsh configuration..."
    
    # Check if zsh is installed
    if ! command_exists zsh; then
        log_warning "Zsh is not installed. Please install zsh first."
        return 1
    fi
    
    # Copy zsh configuration
    if [[ ! "$DRY_RUN" == "true" ]]; then
        # Install main zshrc
        cp "$PROJECT_ROOT/zsh/zshrc" "$HOME/.zshrc"
        
        # Install sheldon plugins configuration
        mkdir -p "$HOME/.config/sheldon"
        cp "$PROJECT_ROOT/zsh/sheldon/plugins.toml" "$HOME/.config/sheldon/plugins.toml"
        
        # Create local zshrc for user customizations
        if [[ ! -f "$HOME/.zshrc.local" ]]; then
            cat > "$HOME/.zshrc.local" << 'EOF'
# Local zsh customizations
# Add your personal configurations here

# ===== Your Personal Customizations =====

EOF
            log_success "Created ~/.zshrc.local"
        fi
    fi
    
    log_success "Zsh configuration installed"
    
    # Install sheldon if not already installed
    if ! command_exists sheldon; then
        log_step "Installing sheldon plugin manager..."
        if [[ ! "$DRY_RUN" == "true" ]]; then
            local os=$(detect_os)
            case "$os" in
                macOS)
                    brew install sheldon
                    ;;
                debian|linux)
                    curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
                    ;;
            esac
        fi
    fi
    
    log_success "Zsh setup completed"
}

configure_starship_shell() {
    local shell_name=$(basename "$SHELL")
    local shell_rc=""
    local init_command=""
    
    case "$shell_name" in
        zsh)
            shell_rc="$HOME/.zshrc"
            init_command='eval "$(starship init zsh)"'
            ;;
        bash)
            shell_rc="$HOME/.bashrc"
            init_command='eval "$(starship init bash)"'
            ;;
        fish)
            shell_rc="$HOME/.config/fish/config.fish"
            init_command='starship init fish | source'
            ;;
        *)
            log_warning "Unsupported shell: $shell_name"
            return 1
            ;;
    esac
    
    # Check if already configured
    if [[ -f "$shell_rc" ]] && grep -q "starship init" "$shell_rc"; then
        log_success "Shell already configured for Starship"
        return 0
    fi
    
    # Add initialization to shell config
    if [[ ! "$DRY_RUN" == "true" ]]; then
        # Create backup of shell config
        cp "$shell_rc" "${shell_rc}.backup.$(date +%Y%m%d_%H%M%S)" || true
        
        echo "" >> "$shell_rc"
        echo "# Starship prompt initialization" >> "$shell_rc"
        echo "$init_command" >> "$shell_rc"
    fi
    
    log_success "Added Starship initialization to $shell_rc"
}

# ===============================================
# Verification Functions
# ===============================================

verify_installation() {
    log_step "Verifying installation..."
    
    local errors=0
    
    # Check Starship (if enabled)
    if [[ "$INSTALL_STARSHIP" == "true" ]]; then
        if command_exists starship; then
            log_success "Starship: $(starship --version)"
        else
            log_error "Starship not found"
            ((errors++))
        fi
        
        if [[ -f "$HOME/.config/starship.toml" ]]; then
            log_success "Starship config: ✓"
        else
            log_error "Starship config not found"
            ((errors++))
        fi
    fi
    
    
    if [[ $errors -eq 0 ]]; then
        log_success "All components verified successfully!"
        return 0
    else
        log_error "Verification failed with $errors errors"
        return 1
    fi
}

show_completion_message() {
    echo ""
    echo -e "${GREEN}${BOLD}🎉 Setup completed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Restart your terminal or run: source ~/.$(basename $SHELL)rc"
    if [[ "$INSTALL_STARSHIP" == "true" ]]; then
        echo "2. Test Starship prompt in a Git repository"
    fi
    echo ""
    echo -e "${CYAN}Key features installed:${NC}"
    echo "• Modern Zsh configuration with fast plugin management"
    if [[ "$INSTALL_STARSHIP" == "true" ]]; then
        echo "• Starship prompt with Flutter/Dart integration"
    fi
    echo "• Essential CLI tools (eza, bat, lazygit)"
}

# ===============================================
# Main Setup Logic
# ===============================================

main() {
    show_banner
    
    # Parse arguments
    local mode="$MODE_CONFIG_ONLY"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --full)
                mode="$MODE_FULL"
                shift
                ;;
            full|quick|config-only|starship-only)
                mode="$1"
                shift
                ;;
            --no-starship)
                INSTALL_STARSHIP=false
                shift
                ;;
            --no-flutter)
                INSTALL_FLUTTER=false
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Show dry run warning
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN MODE - No changes will be made"
        echo ""
    fi
    
    # Detect OS and package manager
    local os=$(detect_os)
    local pkg_mgr=$(detect_package_manager "$os")
    
    log_info "Detected OS: $os"
    log_info "Package Manager: $pkg_mgr"
    log_info "Setup Mode: $mode"
    echo ""
    
    # Confirm before proceeding (skip for config-only mode)
    if [[ "$DRY_RUN" != "true" ]] && [[ "$mode" != "$MODE_CONFIG_ONLY" ]]; then
        echo -e "${YELLOW}This will modify your system and configuration files.${NC}"
        read -p "Continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Setup cancelled by user"
            exit 0
        fi
        echo ""
    fi
    
    # Execute setup based on mode
    case "$mode" in
        "$MODE_FULL")
            # Full installation
            case "$os" in
                macOS)
                    install_homebrew
                    install_packages_macos
                    ;;
                debian)
                    install_packages_debian
                    ;;
                *)
                    log_error "Unsupported OS for full installation: $os"
                    exit 1
                    ;;
            esac
            
            setup_directories
            install_zsh_config
            install_starship_config
            ;;
            
        "$MODE_QUICK")
            # Quick setup (dependencies assumed)
            setup_directories
            install_zsh_config
            install_starship_config
            ;;
            
        "$MODE_CONFIG_ONLY")
            # Configuration files only
            setup_directories
            ;;
            
        "$MODE_STARSHIP_ONLY")
            # Starship only
            install_starship_config
            ;;
    esac
    
    # Verify installation
    if [[ "$mode" != "$MODE_STARSHIP_ONLY" ]]; then
        verify_installation
    fi
    
    # Show completion message
    show_completion_message
}

# Run main function with all arguments
main "$@"