#!/bin/bash

# ============================================================================
# AI Tools Setup Script for AstroNvim
# ============================================================================
# This script helps configure AI assistants for AstroNvim

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
# Check Prerequisites
# ============================================================================
check_prerequisites() {
    print_step "Checking prerequisites..."
    
    # Check if AstroNvim is installed
    if [[ ! -d "$HOME/.config/nvim/lua/plugins" ]]; then
        print_error "AstroNvim is not installed. Please run migrate-to-astronvim.sh first."
        exit 1
    fi
    
    # Check Node.js (required for Copilot)
    if ! command -v node &> /dev/null; then
        print_warning "Node.js is not installed. Required for GitHub Copilot."
        print_info "Install with: brew install node (macOS) or apt install nodejs (Linux)"
    else
        print_success "Node.js found: $(node --version)"
    fi
    
    # Check for Rust (required for Avante)
    if ! command -v cargo &> /dev/null; then
        print_warning "Rust is not installed. Required for building Avante."
        print_info "Install with: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    else
        print_success "Rust found: $(rustc --version)"
    fi
}

# ============================================================================
# Setup GitHub Copilot
# ============================================================================
setup_copilot() {
    print_step "Setting up GitHub Copilot..."
    
    # Check for GitHub CLI
    if ! command -v gh &> /dev/null; then
        print_warning "GitHub CLI not found. Installing..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install gh
        else
            print_info "Please install GitHub CLI manually: https://cli.github.com/"
        fi
    fi
    
    # Check GitHub authentication
    if gh auth status &>/dev/null; then
        print_success "GitHub CLI is authenticated"
    else
        print_info "Authenticating with GitHub..."
        gh auth login
    fi
    
    # Setup Copilot
    print_info "Setting up Copilot in Neovim..."
    print_info "Run :Copilot setup in Neovim to authenticate"
    print_info "Run :Copilot enable to enable Copilot"
    
    print_success "Copilot setup complete"
}

# ============================================================================
# Setup Codeium
# ============================================================================
setup_codeium() {
    print_step "Setting up Codeium (free alternative to Copilot)..."
    
    print_info "Codeium is a free AI code completion tool"
    print_info "To use Codeium:"
    print_info "1. Create a free account at https://codeium.com"
    print_info "2. In Neovim, run :Codeium Auth"
    print_info "3. Follow the browser authentication flow"
    print_info "4. Enable Codeium with :Codeium Enable"
    
    # Ask if user wants to enable Codeium instead of Copilot
    read -p "Do you want to use Codeium instead of Copilot? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Update AI configuration to enable Codeium
        if [[ -f "$HOME/.config/nvim/lua/plugins/ai.lua" ]]; then
            sed -i.bak 's/enabled = false, -- Enable this and disable Copilot/enabled = true, -- Enable this and disable Copilot/' "$HOME/.config/nvim/lua/plugins/ai.lua"
            print_success "Codeium enabled in configuration"
            print_info "Remember to disable Copilot in the configuration if you want to use only Codeium"
        fi
    fi
}

# ============================================================================
# Setup ChatGPT
# ============================================================================
setup_chatgpt() {
    print_step "Setting up ChatGPT integration..."
    
    # Check for OpenAI API key
    if [[ -z "$OPENAI_API_KEY" ]]; then
        print_warning "OPENAI_API_KEY environment variable not set"
        print_info "To use ChatGPT integration:"
        print_info "1. Get an API key from https://platform.openai.com/api-keys"
        print_info "2. Add to your shell config:"
        print_info "   export OPENAI_API_KEY='your-api-key-here'"
        
        read -p "Do you have an OpenAI API key? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "Enter your OpenAI API key: " api_key
            
            # Add to shell config
            if [[ -f "$HOME/.zshrc.local" ]]; then
                echo "export OPENAI_API_KEY='$api_key'" >> "$HOME/.zshrc.local"
                print_success "API key added to ~/.zshrc.local"
            elif [[ -f "$HOME/.bashrc.local" ]]; then
                echo "export OPENAI_API_KEY='$api_key'" >> "$HOME/.bashrc.local"
                print_success "API key added to ~/.bashrc.local"
            else
                echo "export OPENAI_API_KEY='$api_key'" >> "$HOME/.profile"
                print_success "API key added to ~/.profile"
            fi
            
            export OPENAI_API_KEY="$api_key"
        fi
    else
        print_success "OpenAI API key is configured"
    fi
}

# ============================================================================
# Setup Avante (Cursor-like AI)
# ============================================================================
setup_avante() {
    print_step "Setting up Avante (Cursor-like AI experience)..."
    
    # Check for API keys
    print_info "Avante supports multiple providers:"
    print_info "1. Claude (Anthropic) - Recommended"
    print_info "2. OpenAI (GPT-4)"
    print_info "3. Azure OpenAI"
    print_info "4. GitHub Copilot"
    
    # Check for Anthropic API key
    if [[ -z "$ANTHROPIC_API_KEY" ]]; then
        print_warning "ANTHROPIC_API_KEY not set"
        print_info "To use Claude with Avante:"
        print_info "1. Get an API key from https://console.anthropic.com/"
        print_info "2. Add to your shell config:"
        print_info "   export ANTHROPIC_API_KEY='your-api-key-here'"
        
        read -p "Do you have an Anthropic API key? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "Enter your Anthropic API key: " api_key
            
            # Add to shell config
            if [[ -f "$HOME/.zshrc.local" ]]; then
                echo "export ANTHROPIC_API_KEY='$api_key'" >> "$HOME/.zshrc.local"
                print_success "API key added to ~/.zshrc.local"
            elif [[ -f "$HOME/.bashrc.local" ]]; then
                echo "export ANTHROPIC_API_KEY='$api_key'" >> "$HOME/.bashrc.local"
                print_success "API key added to ~/.bashrc.local"
            else
                echo "export ANTHROPIC_API_KEY='$api_key'" >> "$HOME/.profile"
                print_success "API key added to ~/.profile"
            fi
            
            export ANTHROPIC_API_KEY="$api_key"
        fi
    else
        print_success "Anthropic API key is configured"
    fi
    
    # Build Avante
    print_info "Building Avante dependencies..."
    if command -v cargo &> /dev/null; then
        cd "$HOME/.local/share/nvim/lazy/avante.nvim" 2>/dev/null && make || print_warning "Avante build will happen on first launch"
    else
        print_warning "Rust not installed. Avante will use fallback (slower)"
    fi
}

# ============================================================================
# Configure AI Settings
# ============================================================================
configure_ai_settings() {
    print_step "Configuring AI settings..."
    
    # Create AI configuration directory
    mkdir -p "$HOME/.config/nvim/lua/plugins"
    
    # Copy AI configuration
    if [[ -f "$(dirname "$0")/../astronvim-configs/lua/plugins/ai.lua" ]]; then
        cp "$(dirname "$0")/../astronvim-configs/lua/plugins/ai.lua" "$HOME/.config/nvim/lua/plugins/ai.lua"
        print_success "AI configuration installed"
    else
        print_warning "AI configuration file not found in astronvim-configs"
    fi
    
    # Create environment template
    cat > "$HOME/.ai-env-template" << 'EOF'
# AI Tools Environment Variables
# Add these to your ~/.zshrc.local or ~/.bashrc.local

# GitHub Copilot (automatically uses GitHub authentication)
# No API key needed - uses GitHub account

# Codeium (free alternative to Copilot)
# Sign up at https://codeium.com
# Authentication happens in Neovim with :Codeium Auth

# OpenAI (for ChatGPT integration)
export OPENAI_API_KEY='your-openai-api-key-here'

# Anthropic (for Claude/Avante)
export ANTHROPIC_API_KEY='your-anthropic-api-key-here'

# Optional: Azure OpenAI
# export AZURE_OPENAI_API_KEY='your-azure-key-here'
# export AZURE_OPENAI_ENDPOINT='your-azure-endpoint'

# Optional: Custom API endpoints (for proxies or local models)
# export OPENAI_API_BASE='https://your-proxy.com/v1'
# export ANTHROPIC_API_BASE='https://your-proxy.com'
EOF
    
    print_success "Environment template created at ~/.ai-env-template"
}

# ============================================================================
# Show AI Keybindings
# ============================================================================
show_keybindings() {
    print_step "AI Keybindings Reference"
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}                    AI Keybindings                              ${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo
    echo -e "${GREEN}General AI (Leader = Space):${NC}"
    echo "  <leader>a    - AI menu"
    echo
    echo -e "${GREEN}GitHub Copilot:${NC}"
    echo "  <Tab>        - Accept suggestion"
    echo "  <M-]>        - Next suggestion"
    echo "  <M-[>        - Previous suggestion"
    echo "  <M-w>        - Accept word"
    echo "  <M-l>        - Accept line"
    echo "  <C-]>        - Dismiss suggestion"
    echo "  <leader>acp  - Copilot panel"
    echo "  <leader>acc  - Copilot chat"
    echo "  <leader>acs  - Copilot status"
    echo
    echo -e "${GREEN}ChatGPT:${NC}"
    echo "  <leader>agg  - Open ChatGPT"
    echo "  <leader>age  - Edit with instruction"
    echo "  <leader>agx  - Explain code"
    echo "  <leader>agf  - Fix bugs"
    echo "  <leader>ago  - Optimize code"
    echo "  <leader>agd  - Add docstring"
    echo "  <leader>agt  - Add tests"
    echo
    echo -e "${GREEN}Avante (Cursor-like):${NC}"
    echo "  <leader>aa   - Ask AI"
    echo "  <leader>ae   - Edit with AI"
    echo "  <leader>ar   - Refresh"
    echo "  <leader>at   - Toggle sidebar"
    echo "  <leader>ab   - Build/Apply changes"
    echo "  <leader>as   - Switch provider"
    echo
    echo -e "${GREEN}Codeium (if enabled):${NC}"
    echo "  <Tab>        - Accept suggestion"
    echo "  <M-]>        - Next suggestion"
    echo "  <M-[>        - Previous suggestion"
    echo "  <leader>ake  - Enable Codeium"
    echo "  <leader>akd  - Disable Codeium"
    echo "  <leader>akc  - Codeium chat"
    echo
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
}

# ============================================================================
# Test AI Integration
# ============================================================================
test_ai_integration() {
    print_step "Testing AI integration..."
    
    cat > /tmp/test_ai.py << 'EOF'
# Test file for AI suggestions
def fibonacci(n):
    """
    Calculate fibonacci number
    TODO: AI should suggest the implementation
    """
    # Type here and wait for AI suggestions
    
def main():
    # Test the function
    print(fibonacci(10))

if __name__ == "__main__":
    main()
EOF
    
    print_info "Opening test file in Neovim..."
    print_info "Try the following:"
    print_info "1. Position cursor after 'def fibonacci(n):' and wait for suggestions"
    print_info "2. Select the function and press <leader>agx to explain code"
    print_info "3. Press <leader>aa to ask Avante about the code"
    print_info "4. Press <leader>agg to open ChatGPT"
    echo
    read -p "Press Enter to open the test file..."
    
    nvim /tmp/test_ai.py
}

# ============================================================================
# Main Menu
# ============================================================================
show_menu() {
    echo
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}              AI Tools Setup for AstroNvim                      ${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo
    echo "1) Setup GitHub Copilot"
    echo "2) Setup Codeium (free alternative)"
    echo "3) Setup ChatGPT"
    echo "4) Setup Avante (Cursor-like AI)"
    echo "5) Configure AI settings"
    echo "6) Show AI keybindings"
    echo "7) Test AI integration"
    echo "8) Run all setup steps"
    echo "0) Exit"
    echo
    read -p "Select option: " choice
    
    case $choice in
        1) setup_copilot ;;
        2) setup_codeium ;;
        3) setup_chatgpt ;;
        4) setup_avante ;;
        5) configure_ai_settings ;;
        6) show_keybindings ;;
        7) test_ai_integration ;;
        8) 
            check_prerequisites
            setup_copilot
            setup_codeium
            setup_chatgpt
            setup_avante
            configure_ai_settings
            show_keybindings
            ;;
        0) 
            print_success "AI setup complete!"
            exit 0 
            ;;
        *) print_error "Invalid option" ;;
    esac
    
    show_menu
}

# ============================================================================
# Main Execution
# ============================================================================
main() {
    echo -e "${MAGENTA}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}           AI Tools Setup for AstroNvim                         ${NC}"
    echo -e "${MAGENTA}════════════════════════════════════════════════════════════════${NC}"
    echo
    
    check_prerequisites
    
    # Check if running with --all flag
    if [[ "$1" == "--all" ]]; then
        setup_copilot
        setup_chatgpt
        setup_avante
        configure_ai_settings
        show_keybindings
        print_success "AI setup complete!"
    else
        show_menu
    fi
}

# Run the script
main "$@"