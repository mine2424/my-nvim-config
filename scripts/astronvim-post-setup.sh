#!/bin/bash

# ============================================================================
# AstroNvim Post-Installation Setup Script
# ============================================================================
# This script helps configure language servers and additional tools
# after AstroNvim installation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_step() { echo -e "${MAGENTA}[STEP]${NC} $1"; }

# ============================================================================
# Install Development Tools
# ============================================================================
install_dev_tools() {
    print_step "Installing development tools..."
    
    # Node.js and npm (required for many LSPs)
    if ! command -v node &> /dev/null; then
        print_info "Installing Node.js..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install node
        else
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt-get install -y nodejs
        fi
    else
        print_success "Node.js already installed: $(node --version)"
    fi
    
    # Python and pip
    if ! command -v python3 &> /dev/null; then
        print_info "Installing Python..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install python@3.11
        else
            sudo apt-get install -y python3 python3-pip python3-venv
        fi
    else
        print_success "Python already installed: $(python3 --version)"
    fi
    
    # Flutter
    if ! command -v flutter &> /dev/null; then
        print_warning "Flutter is not installed."
        print_info "To install Flutter:"
        print_info "  1. Visit https://flutter.dev/docs/get-started/install"
        print_info "  2. Or use FVM: npm install -g fvm && fvm install stable"
    else
        print_success "Flutter already installed: $(flutter --version | head -n1)"
    fi
    
    # Rust (for some tools)
    if ! command -v cargo &> /dev/null; then
        print_info "Installing Rust (optional but recommended)..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    else
        print_success "Rust already installed: $(rustc --version)"
    fi
}

# ============================================================================
# Install Global NPM Packages
# ============================================================================
install_npm_packages() {
    print_step "Installing global npm packages..."
    
    local packages=(
        "typescript"
        "ts-node"
        "@types/node"
        "eslint"
        "prettier"
        "typescript-language-server"
        "vscode-langservers-extracted"
        "tailwindcss-language-server"
        "@tailwindcss/language-server"
        "emmet-ls"
        "graphql-language-service-cli"
        "yaml-language-server"
        "vls"  # Vue language server
        "@angular/language-server"
        "svelte-language-server"
    )
    
    for package in "${packages[@]}"; do
        if npm list -g "$package" &>/dev/null; then
            print_info "$package is already installed"
        else
            print_info "Installing $package..."
            npm install -g "$package" || print_warning "Failed to install $package"
        fi
    done
    
    print_success "NPM packages installed"
}

# ============================================================================
# Install Python Packages
# ============================================================================
install_python_packages() {
    print_step "Installing Python packages..."
    
    local packages=(
        "pynvim"
        "black"
        "isort"
        "pylint"
        "flake8"
        "mypy"
        "debugpy"
        "ipython"
        "jupyter"
        "notebook"
    )
    
    for package in "${packages[@]}"; do
        print_info "Installing $package..."
        pip3 install --user "$package" || print_warning "Failed to install $package"
    done
    
    print_success "Python packages installed"
}

# ============================================================================
# Configure Git for better Neovim integration
# ============================================================================
configure_git() {
    print_step "Configuring Git for Neovim..."
    
    # Set Neovim as default editor
    git config --global core.editor "nvim"
    
    # Configure merge tool
    git config --global merge.tool "nvim"
    git config --global mergetool.nvim.cmd 'nvim -d $LOCAL $REMOTE $MERGED -c "wincmd w" -c "wincmd J"'
    
    # Configure diff tool
    git config --global diff.tool "nvim"
    git config --global difftool.nvim.cmd 'nvim -d $LOCAL $REMOTE'
    
    print_success "Git configured for Neovim"
}

# ============================================================================
# Create Project Templates
# ============================================================================
create_project_templates() {
    print_step "Creating project templates..."
    
    local template_dir="$HOME/.config/nvim-templates"
    mkdir -p "$template_dir"
    
    # Flutter project template
    cat > "$template_dir/flutter-project.sh" << 'EOF'
#!/bin/bash
PROJECT_NAME=$1
flutter create "$PROJECT_NAME"
cd "$PROJECT_NAME"
cat > .nvim.lua << 'NVIM_CONFIG'
-- Project-specific Neovim configuration
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
NVIM_CONFIG
nvim .
EOF
    chmod +x "$template_dir/flutter-project.sh"
    
    # React/Next.js project template
    cat > "$template_dir/nextjs-project.sh" << 'EOF'
#!/bin/bash
PROJECT_NAME=$1
npx create-next-app@latest "$PROJECT_NAME" --typescript --tailwind --eslint --app
cd "$PROJECT_NAME"
cat > .nvim.lua << 'NVIM_CONFIG'
-- Project-specific Neovim configuration
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
NVIM_CONFIG
nvim .
EOF
    chmod +x "$template_dir/nextjs-project.sh"
    
    # Python project template
    cat > "$template_dir/python-project.sh" << 'EOF'
#!/bin/bash
PROJECT_NAME=$1
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"
python3 -m venv venv
source venv/bin/activate
pip install black isort pylint pytest
cat > .nvim.lua << 'NVIM_CONFIG'
-- Project-specific Neovim configuration
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
NVIM_CONFIG
cat > pyproject.toml << 'PYPROJECT'
[tool.black]
line-length = 88
target-version = ['py311']

[tool.isort]
profile = "black"
line_length = 88

[tool.pylint.messages_control]
disable = "C0111"
PYPROJECT
nvim .
EOF
    chmod +x "$template_dir/python-project.sh"
    
    print_success "Project templates created in $template_dir"
}

# ============================================================================
# Install Additional Neovim Plugins via CLI
# ============================================================================
install_lsp_servers() {
    print_step "Installing LSP servers in Neovim..."
    
    echo "Please run the following commands in Neovim:"
    echo
    echo -e "${CYAN}Language Servers:${NC}"
    echo "  :MasonInstall dartls                    # Flutter/Dart"
    echo "  :MasonInstall tsserver                  # TypeScript/JavaScript"
    echo "  :MasonInstall eslint                    # ESLint"
    echo "  :MasonInstall pyright                   # Python"
    echo "  :MasonInstall tailwindcss               # Tailwind CSS"
    echo "  :MasonInstall html                      # HTML"
    echo "  :MasonInstall cssls                     # CSS"
    echo "  :MasonInstall emmet_language_server     # Emmet"
    echo "  :MasonInstall jsonls                    # JSON"
    echo "  :MasonInstall yamlls                    # YAML"
    echo "  :MasonInstall lua_ls                    # Lua"
    echo "  :MasonInstall marksman                  # Markdown"
    echo
    echo -e "${CYAN}Formatters:${NC}"
    echo "  :MasonInstall prettier                  # JS/TS/HTML/CSS"
    echo "  :MasonInstall black                     # Python"
    echo "  :MasonInstall isort                     # Python imports"
    echo "  :MasonInstall stylua                    # Lua"
    echo
    echo -e "${CYAN}Linters:${NC}"
    echo "  :MasonInstall eslint_d                  # JavaScript/TypeScript"
    echo "  :MasonInstall pylint                    # Python"
    echo "  :MasonInstall flake8                    # Python"
    echo
    echo -e "${CYAN}Debug Adapters:${NC}"
    echo "  :MasonInstall js-debug-adapter          # JavaScript/TypeScript"
    echo "  :MasonInstall debugpy                   # Python"
    echo
    read -p "Press Enter to continue..."
}

# ============================================================================
# Create Neovim Desktop Entry (Linux)
# ============================================================================
create_desktop_entry() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_step "Creating desktop entry for Neovim..."
        
        cat > "$HOME/.local/share/applications/nvim.desktop" << 'EOF'
[Desktop Entry]
Name=Neovim
GenericName=Text Editor
Comment=Edit text files
Exec=nvim %F
Terminal=true
Type=Application
Keywords=Text;editor;
Icon=nvim
Categories=Utility;TextEditor;
StartupNotify=false
MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
EOF
        
        print_success "Desktop entry created"
    fi
}

# ============================================================================
# Configure Shell Aliases
# ============================================================================
configure_shell_aliases() {
    print_step "Configuring shell aliases..."
    
    local alias_config="
# AstroNvim aliases
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias nv='nvim'

# Project launchers
alias nvf='nvim-flutter'
alias nvr='nvim-react'
alias nvp='nvim-python'

# Quick edits
alias nvconfig='nvim ~/.config/nvim/'
alias nvplugins='nvim ~/.config/nvim/lua/plugins/'

# Git with Neovim
alias gd='git difftool'
alias gm='git mergetool'
"
    
    # Add to .zshrc.local or .bashrc.local
    if [[ -f "$HOME/.zshrc.local" ]]; then
        echo "$alias_config" >> "$HOME/.zshrc.local"
        print_success "Aliases added to ~/.zshrc.local"
    elif [[ -f "$HOME/.bashrc.local" ]]; then
        echo "$alias_config" >> "$HOME/.bashrc.local"
        print_success "Aliases added to ~/.bashrc.local"
    else
        echo "$alias_config" > "$HOME/.shell_aliases"
        print_info "Aliases saved to ~/.shell_aliases"
        print_info "Add 'source ~/.shell_aliases' to your shell config"
    fi
}

# ============================================================================
# Health Check
# ============================================================================
run_health_check() {
    print_step "Running health check..."
    
    echo -e "${CYAN}Checking installations:${NC}"
    
    # Check Neovim
    if command -v nvim &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} Neovim: $(nvim --version | head -n1)"
    else
        echo -e "  ${RED}✗${NC} Neovim not found"
    fi
    
    # Check Node.js
    if command -v node &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} Node.js: $(node --version)"
    else
        echo -e "  ${RED}✗${NC} Node.js not found"
    fi
    
    # Check Python
    if command -v python3 &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} Python: $(python3 --version)"
    else
        echo -e "  ${RED}✗${NC} Python not found"
    fi
    
    # Check Flutter
    if command -v flutter &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} Flutter: $(flutter --version | head -n1)"
    else
        echo -e "  ${YELLOW}⚠${NC} Flutter not found (optional)"
    fi
    
    # Check Git
    if command -v git &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} Git: $(git --version)"
    else
        echo -e "  ${RED}✗${NC} Git not found"
    fi
    
    # Check ripgrep
    if command -v rg &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} ripgrep: $(rg --version | head -n1)"
    else
        echo -e "  ${YELLOW}⚠${NC} ripgrep not found (recommended for telescope)"
    fi
    
    # Check fd
    if command -v fd &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} fd: $(fd --version)"
    else
        echo -e "  ${YELLOW}⚠${NC} fd not found (recommended for telescope)"
    fi
}

# ============================================================================
# Main Menu
# ============================================================================
show_menu() {
    echo
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}        AstroNvim Post-Installation Setup${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo
    echo "1) Install development tools (Node.js, Python, etc.)"
    echo "2) Install NPM packages for LSPs"
    echo "3) Install Python packages"
    echo "4) Configure Git for Neovim"
    echo "5) Create project templates"
    echo "6) Configure shell aliases"
    echo "7) Show LSP installation commands"
    echo "8) Run health check"
    echo "9) Run all setup steps"
    echo "0) Exit"
    echo
    read -p "Select option: " choice
    
    case $choice in
        1) install_dev_tools ;;
        2) install_npm_packages ;;
        3) install_python_packages ;;
        4) configure_git ;;
        5) create_project_templates ;;
        6) configure_shell_aliases ;;
        7) install_lsp_servers ;;
        8) run_health_check ;;
        9) 
            install_dev_tools
            install_npm_packages
            install_python_packages
            configure_git
            create_project_templates
            configure_shell_aliases
            create_desktop_entry
            run_health_check
            install_lsp_servers
            ;;
        0) exit 0 ;;
        *) print_error "Invalid option" ;;
    esac
    
    show_menu
}

# ============================================================================
# Main Execution
# ============================================================================
main() {
    # Check if running with --all flag
    if [[ "$1" == "--all" ]]; then
        install_dev_tools
        install_npm_packages
        install_python_packages
        configure_git
        create_project_templates
        configure_shell_aliases
        create_desktop_entry
        run_health_check
        install_lsp_servers
    else
        show_menu
    fi
}

# Run the script
main "$@"