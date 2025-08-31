#!/bin/bash

# ===============================================
# Flutter Development Environment Setup Script
# ===============================================
# Unified setup script for Flutter + Neovim + Ghostty + Starship
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
readonly MODE_PNPM_ONLY="pnpm-only"
readonly MODE_MCP_ONLY="mcp-only"
readonly MODE_MCP_FIX="mcp-fix"
readonly MODE_KIRO_ONLY="kiro-only"
readonly MODE_SERENA_ONLY="serena-only"
readonly MODE_ASTRONVIM="astronvim"
readonly MODE_ASTRONVIM_FULL="astronvim-full"
readonly MODE_CLAUDE_INTEGRATION="claude-integration"

# Default settings
INSTALL_STARSHIP=true
INSTALL_FLUTTER=false
INSTALL_PNPM=true
INSTALL_KIRO=true
INSTALL_ASTRONVIM=false
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
    🚀 Flutter Development Environment Setup
    =========================================
    
    Complete setup for modern Flutter development:
    ✨ Neovim with LSP + Copilot + Flutter-tools
    🖥️  Ghostty terminal with modern configuration
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
  pnpm-only           Install and configure pnpm only
  mcp-only            Install and configure MCP servers only
  mcp-fix             Fix MCP server connections (remove and reconfigure)
  kiro-only           Install and configure Kiro command only
  serena-only         Install and configure Serena MCP server only
  astronvim           Migrate to AstroNvim (backup existing config)
  astronvim-full      AstroNvim with full dev setup (LSP, AI tools, etc.)
  claude-integration  Setup Claude Code integration with Serena MCP

OPTIONS:
  --no-starship       Skip Starship installation
  --no-flutter        Skip Flutter installation
  --no-pnpm           Skip pnpm installation
  --no-kiro           Skip Kiro command installation
  --dry-run           Show what would be done without executing
  --help, -h          Show this help message

EXAMPLES:
  $0                          # Copy configs only (safe default)
  $0 --full                   # Full setup with all components
  $0 full                     # Full setup (legacy syntax)
  $0 quick                    # Quick setup (configs only)
  $0 config-only              # Copy configs only (explicit)
  $0 starship-only            # Install Starship only
  $0 pnpm-only                # Install pnpm only
  $0 serena-only              # Install Serena MCP only
  $0 mcp-fix                  # Fix MCP server connections
  $0 --full --no-flutter      # Full setup without Flutter
  $0 mcp-only                 # Install MCP servers only
  $0 kiro-only                # Install Kiro command only
  $0 astronvim                # Migrate to AstroNvim
  $0 astronvim-full           # AstroNvim with complete dev setup

ENVIRONMENT VARIABLES FOR MCP:
  Before running setup, you can set these environment variables to customize MCP:
  
  GitHub MCP Server:
    GITHUB_PERSONAL_ACCESS_TOKEN  - Personal access token for GitHub API
    GITHUB_API_URL               - Custom GitHub API endpoint (for GitHub Enterprise)
    MCP_GITHUB_PATH              - Custom path to local GitHub MCP server
  
  Context7 MCP Server:
    CONTEXT7_DATA_DIR            - Custom context storage location
    MCP_CONTEXT7_PATH            - Custom path to local Context7 MCP server
  
  Playwright MCP Server:
    PLAYWRIGHT_BROWSERS_PATH     - Custom browser download location
    PLAYWRIGHT_HEADLESS          - Headless mode (true/false)
    MCP_PLAYWRIGHT_PATH          - Custom path to local Playwright MCP server
  
  Debug Thinking MCP Server:
    DEBUG_THINKING_LOG_LEVEL     - Log level (debug, info, warn, error)
    DEBUG_THINKING_DATA_DIR      - Custom debug data directory
    MCP_DEBUG_THINKING_PATH      - Custom path to local Debug Thinking MCP server

  These can be set in ~/.zshrc.local or ~/.bashrc.local for persistence.

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
        "neovim"
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
        "rust"        # Rust toolchain for building avante.nvim
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
            cargo \       # For building avante.nvim
            nodejs \
            npm \
            direnv        # Directory-based environment management
            
        # Install Neovim (latest version)
        if ! command_exists nvim; then
            log_step "Installing Neovim (latest)..."
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
            sudo rm -rf /opt/nvim
            sudo tar -C /opt -xzf nvim-linux64.tar.gz
            sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
            rm nvim-linux64.tar.gz
        fi
        
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
        "$HOME/.config/nvim"
        "$HOME/.config/nvim/lua"
        "$HOME/.config/ghostty"
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

install_neovim_config() {
    log_step "Installing Neovim configuration..."
    
    # Backup existing configuration
    if [[ -d "$HOME/.config/nvim" ]] && [[ ! "$DRY_RUN" == "true" ]]; then
        local backup_dir="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backing up existing Neovim config to $backup_dir"
        mv "$HOME/.config/nvim" "$backup_dir"
    fi
    
    # Copy configuration files
    if [[ ! "$DRY_RUN" == "true" ]]; then
        mkdir -p "$HOME/.config/nvim/lua"
        cp "$PROJECT_ROOT/init.lua" "$HOME/.config/nvim/"
        cp -r "$PROJECT_ROOT/lua/"* "$HOME/.config/nvim/lua/"
        chmod +x "$PROJECT_ROOT/scripts/"*.sh
    fi
    
    log_success "Neovim configuration installed"
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

install_ghostty_config() {
    log_step "Installing Ghostty configuration..."
    
    # Copy Ghostty config
    if [[ ! "$DRY_RUN" == "true" ]]; then
        mkdir -p "$HOME/.config/ghostty"
        cp "$PROJECT_ROOT/ghostty/config" "$HOME/.config/ghostty/config"
    fi
    
    log_success "Ghostty configuration installed"
}

install_claude_config() {
    log_step "Installing Claude Desktop configuration..."
    
    # Detect Claude config directory based on OS
    local claude_config_dir=""
    local os=$(detect_os)
    
    case "$os" in
        macOS)
            claude_config_dir="$HOME/Library/Application Support/Claude"
            ;;
        debian|linux)
            claude_config_dir="$HOME/.config/claude"
            ;;
        *)
            log_warning "Claude Desktop configuration not supported on $os"
            return 0
            ;;
    esac
    
    # Copy Claude config
    if [[ ! "$DRY_RUN" == "true" ]]; then
        mkdir -p "$claude_config_dir"
        cp "$PROJECT_ROOT/claude/claude_desktop_config.json" "$claude_config_dir/claude_desktop_config.json"
    fi
    
    log_success "Claude Desktop configuration installed"
    
    # Install Claude safety configuration
    log_step "Installing Claude safety configuration..."
    
    # Copy Claude safety configuration
    if [[ ! "$DRY_RUN" == "true" ]]; then
        mkdir -p "$HOME/.claude/scripts"
        cp "$PROJECT_ROOT/claude/settings.json" "$HOME/.claude/settings.json"
        cp "$PROJECT_ROOT/claude/scripts/deny-check.sh" "$HOME/.claude/scripts/deny-check.sh"
        chmod +x "$HOME/.claude/scripts/deny-check.sh"
    fi
    
    log_success "Claude safety configuration installed"
    
    # Install MCP configuration
    install_mcp_config
    
    # Install Kiro command if enabled
    if [[ "$INSTALL_KIRO" == "true" ]]; then
        install_kiro_command
    fi
}

# Separate function for MCP installation
install_mcp_config() {
    # Load local environment configuration if exists
    load_local_env
    
    # Install MCP configuration with fix flag, no-test, and user scope for global settings
    if [[ -f "$PROJECT_ROOT/scripts/mcp.sh" ]]; then
        log_step "Installing and configuring MCP servers in user settings..."
        if [[ ! "$DRY_RUN" == "true" ]]; then
            # Use --fix flag to ensure clean installation, --no-test to avoid starting servers, and --user for global scope
            "$PROJECT_ROOT/scripts/mcp.sh" --fix --no-test --user
        fi
        log_success "MCP servers configured in user settings (not started)"
    else
        log_warning "MCP script not found"
    fi
}

# Helper function to load local environment
load_local_env() {
    if [[ -f "$HOME/.zshrc.local" ]]; then
        log_info "Loading local environment from ~/.zshrc.local"
        set +u  # Temporarily allow unset variables
        source "$HOME/.zshrc.local" || true
        set -u
    elif [[ -f "$HOME/.bashrc.local" ]]; then
        log_info "Loading local environment from ~/.bashrc.local"
        set +u  # Temporarily allow unset variables
        source "$HOME/.bashrc.local" || true
        set -u
    fi
}

install_pnpm_config() {
    log_step "Installing pnpm configuration..."
    
    # Check if pnpm script exists
    if [[ -f "$PROJECT_ROOT/scripts/pnpm.sh" ]]; then
        if [[ ! "$DRY_RUN" == "true" ]]; then
            "$PROJECT_ROOT/scripts/pnpm.sh" install
            "$PROJECT_ROOT/scripts/pnpm.sh" setup
        fi
        log_success "pnpm installed and configured"
    else
        log_warning "pnpm script not found"
    fi
    
    # Copy pnpm configuration files
    if [[ ! "$DRY_RUN" == "true" ]]; then
        if [[ -f "$PROJECT_ROOT/.npmrc" ]]; then
            cp "$PROJECT_ROOT/.npmrc" "$HOME/.npmrc"
            log_success "pnpm configuration (.npmrc) installed"
        fi
    fi
}

install_mcp_only() {
    log_step "Installing MCP servers..."
    
    # Check for Claude CLI
    if ! command_exists claude; then
        log_warning "Claude Code CLI not found. Installing..."
        if [[ ! "$DRY_RUN" == "true" ]]; then
            npm install -g @anthropic-ai/claude-code || {
                log_error "Failed to install Claude Code CLI"
                return 1
            }
        fi
    fi
    
    # Install MCP configuration
    install_mcp_config
}

# Fix MCP server connections
fix_mcp_servers() {
    log_step "Fixing MCP server connections..."
    
    # Run the MCP script with fix flag, no-test, and user scope
    if [[ -f "$SCRIPT_DIR/mcp.sh" ]]; then
        if [[ ! "$DRY_RUN" == "true" ]]; then
            bash "$SCRIPT_DIR/mcp.sh" --fix --no-test --user || {
                log_error "Failed to fix MCP servers"
                return 1
            }
        else
            log_info "Would run: bash $SCRIPT_DIR/mcp.sh --fix --no-test --user"
        fi
        log_success "MCP servers configured in user settings (not started)"
        log_info "Test connections manually with: claude mcp list"
    else
        log_error "MCP script not found: $SCRIPT_DIR/mcp.sh"
        return 1
    fi
}

install_kiro_command() {
    log_step "Installing Kiro spec-driven development command..."
    
    # Run the Kiro setup script
    if [[ -f "$SCRIPT_DIR/setup-kiro.sh" ]]; then
        if [[ ! "$DRY_RUN" == "true" ]]; then
            bash "$SCRIPT_DIR/setup-kiro.sh" || {
                log_error "Failed to install Kiro command"
                return 1
            }
        else
            log_info "Would run: bash $SCRIPT_DIR/setup-kiro.sh"
        fi
        log_success "Kiro command installed successfully"
    else
        log_error "Kiro setup script not found: $SCRIPT_DIR/setup-kiro.sh"
        return 1
    fi
}

# Install Serena MCP server
install_serena_mcp() {
    log_step "Installing Serena MCP server..."
    
    # Run the Serena setup script
    if [[ -f "$SCRIPT_DIR/setup-serena.sh" ]]; then
        if [[ ! "$DRY_RUN" == "true" ]]; then
            bash "$SCRIPT_DIR/setup-serena.sh" || {
                log_error "Failed to install Serena MCP server"
                return 1
            }
        else
            log_info "Would run: bash $SCRIPT_DIR/setup-serena.sh"
        fi
        log_success "Serena MCP server installed successfully"
        
        # Only configure Serena specifically, not all MCP servers
        log_step "Adding Serena to Claude MCP user configuration..."
        if [[ ! "$DRY_RUN" == "true" ]]; then
            # Check if Serena is already configured
            if ! claude mcp list 2>/dev/null | grep -q "^serena\s"; then
                # Add Serena with uvx to user scope
                claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server || {
                    log_warning "Failed to add Serena to MCP config"
                }
            else
                log_info "Serena already configured in MCP"
            fi
        else
            log_info "Would add Serena to MCP user config"
        fi
    else
        log_error "Serena setup script not found: $SCRIPT_DIR/setup-serena.sh"
        return 1
    fi
}

# ===============================================
# AstroNvim Installation Functions
# ===============================================

install_astronvim() {
    log_step "Migrating to AstroNvim..."
    
    # Get timestamp for backup
    local TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    local BACKUP_DIR="$HOME/.config/nvim-backup-$TIMESTAMP"
    
    # Check Neovim version
    if command_exists nvim; then
        local NVIM_VERSION=$(nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
        log_success "Neovim found: v$NVIM_VERSION"
        
        # Check if version is 0.10 or higher
        if [[ $(echo "$NVIM_VERSION >= 0.10" | bc -l 2>/dev/null || echo "0") -eq 0 ]]; then
            log_warning "Neovim 0.10+ is recommended for AstroNvim v4"
        fi
    else
        log_error "Neovim is not installed. Please install Neovim first."
        return 1
    fi
    
    # Backup current configuration
    if [[ -d "$HOME/.config/nvim" ]]; then
        log_info "Backing up current Neovim configuration..."
        if [[ ! "$DRY_RUN" == "true" ]]; then
            cp -r "$HOME/.config/nvim" "$BACKUP_DIR"
            log_success "Backed up to $BACKUP_DIR"
            
            # Backup data directories
            [[ -d "$HOME/.local/share/nvim" ]] && cp -r "$HOME/.local/share/nvim" "$HOME/.local/share/nvim-backup-$TIMESTAMP"
            [[ -d "$HOME/.local/state/nvim" ]] && cp -r "$HOME/.local/state/nvim" "$HOME/.local/state/nvim-backup-$TIMESTAMP"
            [[ -d "$HOME/.cache/nvim" ]] && cp -r "$HOME/.cache/nvim" "$HOME/.cache/nvim-backup-$TIMESTAMP"
        fi
    fi
    
    # Clean existing configuration
    if [[ ! "$DRY_RUN" == "true" ]]; then
        rm -rf "$HOME/.config/nvim"
        rm -rf "$HOME/.local/share/nvim"
        rm -rf "$HOME/.local/state/nvim"
        rm -rf "$HOME/.cache/nvim"
    fi
    
    # Install AstroNvim
    log_info "Installing AstroNvim..."
    if [[ ! "$DRY_RUN" == "true" ]]; then
        git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
        rm -rf ~/.config/nvim/.git
    fi
    
    # Copy custom configurations
    log_info "Setting up custom configurations..."
    if [[ ! "$DRY_RUN" == "true" ]]; then
        # Create plugins directory
        mkdir -p ~/.config/nvim/lua/plugins
        
        # Copy configuration files
        if [[ -f "$SCRIPT_DIR/migrate-to-astronvim.sh" ]]; then
            # Run the migration script to generate configurations
            bash "$SCRIPT_DIR/migrate-to-astronvim.sh" --config-only
        fi
        
        # Copy AI configuration if it exists
        if [[ -f "$PROJECT_ROOT/astronvim-configs/lua/plugins/ai.lua" ]]; then
            cp "$PROJECT_ROOT/astronvim-configs/lua/plugins/ai.lua" ~/.config/nvim/lua/plugins/ai.lua
        fi
    fi
    
    log_success "AstroNvim installed successfully!"
    log_info "Next: Run 'nvim' to install plugins automatically"
}

install_astronvim_full() {
    log_step "Installing AstroNvim with full development setup..."
    
    # Install AstroNvim
    install_astronvim
    
    # Install development tools
    if [[ ! "$DRY_RUN" == "true" ]]; then
        log_info "Installing development tools..."
        
        # Install LSP servers and tools
        if [[ -f "$SCRIPT_DIR/astronvim-post-setup.sh" ]]; then
            bash "$SCRIPT_DIR/astronvim-post-setup.sh" --all
        fi
        
        # Setup AI tools
        if [[ -f "$SCRIPT_DIR/setup-ai-tools.sh" ]]; then
            log_info "Setting up AI tools..."
            bash "$SCRIPT_DIR/setup-ai-tools.sh" --all || log_warning "AI setup incomplete - manual configuration may be needed"
        fi
    fi
    
    # Install plugins in headless mode
    log_info "Installing Neovim plugins..."
    if [[ ! "$DRY_RUN" == "true" ]]; then
        nvim --headless "+Lazy! sync" +qa || log_warning "Plugin installation will complete on first launch"
    fi
    
    log_success "AstroNvim full setup complete!"
    show_astronvim_instructions
}

show_astronvim_instructions() {
    echo
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}        AstroNvim Installation Complete! 🚀${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo
    echo -e "${BLUE}Quick Start:${NC}"
    echo "1. Launch Neovim: nvim"
    echo "2. Install LSP servers (in Neovim):"
    echo "   :MasonInstall dartls tsserver pyright tailwindcss"
    echo "3. Setup GitHub Copilot (in Neovim):"
    echo "   :Copilot setup"
    echo
    echo -e "${BLUE}Key Mappings:${NC}"
    echo "   Leader key: <Space>"
    echo "   <Space>ff - Find files"
    echo "   <Space>fg - Find text"
    echo "   <Space>e  - File explorer"
    echo "   <Space>aa - Ask AI (Avante)"
    echo "   <Tab>     - Accept AI suggestion"
    echo
    echo -e "${BLUE}Development:${NC}"
    echo "   Flutter:     cd ~/project && nvim ."
    echo "   React/Next:  cd ~/project && nvim ."
    echo "   Python:      cd ~/project && nvim ."
    echo
}

install_claude_integration() {
    log_step "Setting up Claude Code integration with Serena MCP..."
    
    # Run the Claude integration setup script
    if [[ -f "$SCRIPT_DIR/setup-claude-integration.sh" ]]; then
        if [[ ! "$DRY_RUN" == "true" ]]; then
            bash "$SCRIPT_DIR/setup-claude-integration.sh"
        else
            log_info "[DRY RUN] Would run setup-claude-integration.sh"
        fi
        log_success "Claude Code integration setup complete"
    else
        log_error "Claude integration setup script not found"
        return 1
    fi
    
    echo
    echo -e "${GREEN}Claude Code Integration Setup Complete!${NC}"
    echo
    echo -e "${BLUE}Next Steps:${NC}"
    echo "1. Set GitHub token (if not already set):"
    echo "   export GITHUB_PERSONAL_ACCESS_TOKEN='your-token'"
    echo "2. Reload shell configuration:"
    echo "   source ~/.zshrc  # or ~/.bashrc"
    echo "3. Test MCP servers:"
    echo "   claude-mcp test"
    echo "4. Activate Serena for a project:"
    echo "   cd your-project && activate-project"
    echo "5. Restart Claude Desktop"
    echo
    echo -e "${BLUE}Helper Commands:${NC}"
    echo "   claude-mcp list  - List MCP servers"
    echo "   claude-mcp test  - Test connections"
    echo "   claude-mcp fix   - Fix configuration"
    echo
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

# ===== MCP Environment Variables =====
# Uncomment and configure as needed for your environment

# GitHub MCP Server
# export GITHUB_PERSONAL_ACCESS_TOKEN='your-github-token-here'
# export GITHUB_API_URL='https://api.github.com'  # For GitHub Enterprise

# Context7 MCP Server
# export CONTEXT7_DATA_DIR="$HOME/.context7/data"

# Playwright MCP Server
# export PLAYWRIGHT_BROWSERS_PATH="$HOME/.cache/playwright"
# export PLAYWRIGHT_HEADLESS=true

# Debug Thinking MCP Server
# export DEBUG_THINKING_LOG_LEVEL=info
# export DEBUG_THINKING_DATA_DIR="$HOME/.debug-thinking-mcp"

# Custom MCP Server Paths (if using local installations)
# export MCP_GITHUB_PATH="/path/to/local/github-mcp-server"
# export MCP_CONTEXT7_PATH="/path/to/local/context7-mcp-server"
# export MCP_PLAYWRIGHT_PATH="/path/to/local/playwright-mcp-server"
# export MCP_DEBUG_THINKING_PATH="/path/to/local/debug-thinking-mcp-server"

# Proxy Configuration (if behind corporate proxy)
# export HTTP_PROXY="http://proxy.example.com:8080"
# export HTTPS_PROXY="http://proxy.example.com:8080"
# export NO_PROXY="localhost,127.0.0.1"

# ===== Your Personal Customizations =====

EOF
            log_success "Created ~/.zshrc.local with MCP environment template"
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
    
    # Check Neovim
    if command_exists nvim; then
        log_success "Neovim: $(nvim --version | head -n1)"
    else
        log_error "Neovim not found"
        ((errors++))
    fi
    
    # Check configuration files
    if [[ -f "$HOME/.config/nvim/init.lua" ]]; then
        log_success "Neovim config: ✓"
    else
        log_error "Neovim config not found"
        ((errors++))
    fi
    
    
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
    
    # Check Ghostty config
    if [[ -f "$HOME/.config/ghostty/config" ]]; then
        log_success "Ghostty config: ✓"
    else
        log_error "Ghostty config not found"
        ((errors++))
    fi
    
    # Check Claude Desktop config
    local os=$(detect_os)
    local claude_config_path=""
    case "$os" in
        macOS)
            claude_config_path="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
            ;;
        debian|linux)
            claude_config_path="$HOME/.config/claude/claude_desktop_config.json"
            ;;
    esac
    
    if [[ -n "$claude_config_path" ]] && [[ -f "$claude_config_path" ]]; then
        log_success "Claude Desktop config: ✓"
    elif [[ -n "$claude_config_path" ]]; then
        log_error "Claude Desktop config not found"
        ((errors++))
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
    echo "2. Open Neovim and let plugins install automatically"
    echo "3. For Flutter development, run: flutter doctor"
    if [[ "$INSTALL_STARSHIP" == "true" ]]; then
        echo "4. Test Starship prompt in a Git repository"
    fi
    echo ""
    echo -e "${CYAN}Key features installed:${NC}"
    echo "• Neovim with optimized LSP, Copilot, and Flutter tools"
    echo "• Performance-tuned configuration with lazy loading"
    echo "• Modern Zsh configuration with fast plugin management"
    if [[ "$INSTALL_STARSHIP" == "true" ]]; then
        echo "• Starship prompt with Flutter/Dart integration"
    fi
    echo "• Ghostty terminal configuration"
    echo "• Claude Desktop safety configuration"
    echo "• Claude Code adaptive MCP servers"
    if [[ "$INSTALL_PNPM" == "true" ]]; then
        echo "• pnpm package manager with workspace support"
    fi
    echo "• Essential CLI tools (eza, bat, lazygit)"
    echo ""
    echo -e "${PURPLE}Documentation: Check SETUP_GUIDE.md and FLUTTER_KEYBINDINGS.md${NC}"
    echo -e "${PURPLE}Future improvements: See FUTURE_IMPROVEMENTS.md${NC}"
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
            full|quick|config-only|starship-only|pnpm-only|mcp-only|mcp-fix|kiro-only|serena-only|astronvim|astronvim-full|claude-integration)
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
            --no-pnpm)
                INSTALL_PNPM=false
                shift
                ;;
            --no-kiro)
                INSTALL_KIRO=false
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
            install_neovim_config
            install_zsh_config
            install_starship_config
            install_ghostty_config
            install_claude_config
            install_pnpm_config
            ;;
            
        "$MODE_QUICK")
            # Quick setup (dependencies assumed)
            setup_directories
            install_neovim_config
            install_zsh_config
            install_starship_config
            install_ghostty_config
            install_claude_config
            install_pnpm_config
            ;;
            
        "$MODE_CONFIG_ONLY")
            # Configuration files only
            setup_directories
            install_neovim_config
            install_ghostty_config
            install_claude_config
            ;;
            
        "$MODE_STARSHIP_ONLY")
            # Starship only
            install_starship_config
            ;;
            
        "$MODE_PNPM_ONLY")
            # pnpm only
            install_pnpm_config
            ;;
            
        "$MODE_MCP_ONLY")
            # MCP only
            install_mcp_only
            ;;
            
        "$MODE_MCP_FIX")
            # Fix MCP connections
            fix_mcp_servers
            ;;
            
        "$MODE_KIRO_ONLY")
            # Kiro command only
            install_kiro_command
            ;;
            
        "$MODE_SERENA_ONLY")
            # Serena MCP server only
            install_serena_mcp
            ;;
            
        "$MODE_ASTRONVIM")
            # AstroNvim migration only
            install_astronvim
            ;;
            
        "$MODE_ASTRONVIM_FULL")
            # AstroNvim with full development setup
            install_astronvim_full
            ;;
            
        "$MODE_CLAUDE_INTEGRATION"|claude-integration)
            # Claude Code integration with Serena and MCP
            install_claude_integration
            ;;
    esac
    
    # Verify installation
    if [[ "$mode" != "$MODE_STARSHIP_ONLY" ]] && [[ "$mode" != "$MODE_PNPM_ONLY" ]] && [[ "$mode" != "$MODE_MCP_ONLY" ]] && [[ "$mode" != "$MODE_MCP_FIX" ]] && [[ "$mode" != "$MODE_KIRO_ONLY" ]] && [[ "$mode" != "$MODE_SERENA_ONLY" ]] && [[ "$mode" != "$MODE_ASTRONVIM" ]] && [[ "$mode" != "$MODE_ASTRONVIM_FULL" ]] && [[ "$mode" != "$MODE_CLAUDE_INTEGRATION" ]]; then
        verify_installation
    fi
    
    # Show completion message
    show_completion_message
}

# Run main function with all arguments
main "$@"