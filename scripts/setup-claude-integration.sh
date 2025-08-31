#!/bin/bash

# ============================================================================
# Claude Code Integration Setup Script
# ============================================================================
# This script ensures Serena MCP and Claude Code settings are properly
# configured and applied to local environments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_step() { echo -e "${MAGENTA}[STEP]${NC} $1"; }

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Detect OS
OS="Unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
fi

# ============================================================================
# Step 1: Check Prerequisites
# ============================================================================
check_prerequisites() {
    print_step "Checking prerequisites..."
    
    local all_ok=true
    
    # Check Claude Code CLI
    if command -v claude &> /dev/null; then
        print_success "Claude Code CLI found ($(claude --version 2>/dev/null || echo 'version unknown'))"
    else
        print_warning "Claude Code CLI not found"
        print_info "Install from: https://claude.ai/code"
        all_ok=false
    fi
    
    # Check uv/uvx for Serena
    if command -v uvx &> /dev/null; then
        print_success "uvx found for Serena execution"
    elif command -v uv &> /dev/null; then
        print_success "uv found (uvx will be available)"
    else
        print_warning "uv/uvx not found - needed for Serena"
        print_info "Will be installed if you proceed"
    fi
    
    # Check npm for MCP servers
    if command -v npm &> /dev/null; then
        print_success "npm found ($(npm --version))"
    else
        print_warning "npm not found - MCP servers will use npx on-demand"
    fi
    
    # Check Neovim
    if command -v nvim &> /dev/null; then
        NVIM_VERSION=$(nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
        print_success "Neovim found (v$NVIM_VERSION)"
    else
        print_warning "Neovim not found"
    fi
    
    if [ "$all_ok" = false ]; then
        print_warning "Some prerequisites are missing but setup can continue"
        read -p "Continue anyway? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
}

# ============================================================================
# Step 2: Setup Serena MCP
# ============================================================================
setup_serena() {
    print_step "Setting up Serena MCP..."
    
    # Run Serena setup script
    if [[ -f "$SCRIPT_DIR/setup-serena.sh" ]]; then
        bash "$SCRIPT_DIR/setup-serena.sh"
    else
        print_error "Serena setup script not found"
        return 1
    fi
    
    # Verify Serena configuration
    if [[ -f "$HOME/.serena/serena_config.yml" ]]; then
        print_success "Serena configuration created"
    else
        print_warning "Serena configuration not found"
    fi
    
    # Create project-specific Serena config in nvim-config
    if [[ ! -f "$PROJECT_ROOT/.serena/project.yml" ]]; then
        mkdir -p "$PROJECT_ROOT/.serena"
        cat > "$PROJECT_ROOT/.serena/project.yml" << 'EOF'
# Serena Project Configuration for my-nvim-config
project:
  name: "my-nvim-config"
  type: "mixed"  # Lua, Shell, YAML
  root: "."
  
language_servers:
  lua:
    enabled: true
    server: lua-language-server
  
exclude:
  - ".git/"
  - "*.log"
  - "*.bak"
  - "node_modules/"
  
tools:
  search_symbol:
    include_tests: true
    include_private: false
  
  apply_edits:
    auto_format: true
    verify_syntax: true
EOF
        print_success "Created project-specific Serena configuration"
    fi
}

# ============================================================================
# Step 3: Setup Claude Code Safety Settings
# ============================================================================
setup_claude_safety() {
    print_step "Setting up Claude Code safety settings..."
    
    # Create Claude directory
    CLAUDE_DIR="$HOME/.claude"
    mkdir -p "$CLAUDE_DIR"
    mkdir -p "$CLAUDE_DIR/scripts"
    
    # Copy safety settings
    if [[ -f "$PROJECT_ROOT/claude/settings.json" ]]; then
        cp "$PROJECT_ROOT/claude/settings.json" "$CLAUDE_DIR/settings.json"
        print_success "Copied Claude Code safety settings"
    fi
    
    # Copy deny check script
    if [[ -f "$PROJECT_ROOT/claude/scripts/deny-check.sh" ]]; then
        cp "$PROJECT_ROOT/claude/scripts/deny-check.sh" "$CLAUDE_DIR/scripts/deny-check.sh"
        chmod +x "$CLAUDE_DIR/scripts/deny-check.sh"
        print_success "Installed command deny check script"
    fi
    
    # Update Claude Desktop configuration if it exists
    if [[ "$OS" == "macOS" ]]; then
        CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
    else
        CLAUDE_CONFIG_DIR="$HOME/.config/claude"
    fi
    
    if [[ -f "$PROJECT_ROOT/claude/claude_desktop_config.json" ]]; then
        mkdir -p "$CLAUDE_CONFIG_DIR"
        # Backup existing config
        if [[ -f "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" ]]; then
            cp "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" \
               "$CLAUDE_CONFIG_DIR/claude_desktop_config.json.bak.$(date +%Y%m%d_%H%M%S)"
        fi
        cp "$PROJECT_ROOT/claude/claude_desktop_config.json" "$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
        print_success "Updated Claude Desktop configuration"
    fi
}

# ============================================================================
# Step 4: Setup MCP Servers with User Scope
# ============================================================================
setup_mcp_servers() {
    print_step "Setting up MCP servers with user scope..."
    
    # Run MCP setup with user scope for global configuration
    if [[ -f "$SCRIPT_DIR/mcp.sh" ]]; then
        bash "$SCRIPT_DIR/mcp.sh" --user --no-test
        print_success "MCP servers configured with user scope"
    else
        print_warning "MCP setup script not found"
    fi
}

# ============================================================================
# Step 5: Setup Claude Code Neovim Integration
# ============================================================================
setup_nvim_integration() {
    print_step "Setting up Claude Code Neovim integration..."
    
    # Check if AstroNvim is installed
    if [[ -d "$HOME/.config/nvim" ]]; then
        # Ensure claude-code.nvim plugin is configured
        if grep -q "claude-code.nvim" "$HOME/.config/nvim/lua/plugins/"*.lua 2>/dev/null; then
            print_success "Claude Code Neovim plugin already configured"
        else
            print_info "Adding Claude Code plugin to Neovim configuration..."
            
            # Create claude integration plugin file
            cat > "$HOME/.config/nvim/lua/plugins/claude-integration.lua" << 'EOF'
-- Claude Code Integration for Neovim
return {
  -- Claude Code integration
  {
    "sivchari/claude-code.nvim",
    lazy = false,
    config = function()
      require("claude-code").setup({
        -- Enable per-worktree session management
        use_git_worktree = true,
        -- Auto-switch to relevant session when changing worktrees
        auto_switch_session = true,
        -- Monitor Claude sessions
        enable_monitor = true,
      })
    end,
  },
}
EOF
            print_success "Claude Code Neovim plugin configured"
        fi
    else
        print_warning "Neovim configuration not found"
        print_info "Run astronvim setup first: ./scripts/setup.sh astronvim-full"
    fi
}

# ============================================================================
# Step 6: Setup Environment Variables
# ============================================================================
setup_environment() {
    print_step "Setting up environment variables..."
    
    # Determine shell config file
    SHELL_RC=""
    if [[ -f "$HOME/.zshrc" ]]; then
        SHELL_RC="$HOME/.zshrc"
    elif [[ -f "$HOME/.bashrc" ]]; then
        SHELL_RC="$HOME/.bashrc"
    fi
    
    # Create local environment file
    LOCAL_ENV="$HOME/.zshrc.local"
    if [[ "$SHELL_RC" == *"bashrc" ]]; then
        LOCAL_ENV="$HOME/.bashrc.local"
    fi
    
    # Add environment variables if not already present
    if [[ -f "$LOCAL_ENV" ]]; then
        print_info "Local environment file exists: $LOCAL_ENV"
    else
        print_info "Creating local environment file: $LOCAL_ENV"
        cat > "$LOCAL_ENV" << 'EOF'
# Claude Code and MCP Environment Configuration
# =============================================

# GitHub MCP Server
# export GITHUB_PERSONAL_ACCESS_TOKEN='your-github-token-here'

# Serena MCP Configuration
export SERENA_CONFIG_PATH="$HOME/.serena/serena_config.yml"
export SERENA_PROJECT_PATH=".serena/project.yml"

# Filesystem MCP Base Path
export FILESYSTEM_BASE_PATH="$HOME/development"

# Add local bin to PATH for Serena wrapper
export PATH="$HOME/.local/bin:$PATH"

# Claude Code settings
export CLAUDE_SETTINGS_PATH="$HOME/.claude/settings.json"
EOF
        print_success "Created local environment file"
    fi
    
    # Source in shell RC if not already
    if [[ -n "$SHELL_RC" ]]; then
        if ! grep -q "source.*$LOCAL_ENV" "$SHELL_RC" 2>/dev/null; then
            echo "" >> "$SHELL_RC"
            echo "# Load local environment configuration" >> "$SHELL_RC"
            echo "[[ -f \"$LOCAL_ENV\" ]] && source \"$LOCAL_ENV\"" >> "$SHELL_RC"
            print_success "Added local environment sourcing to $SHELL_RC"
        else
            print_info "Local environment already sourced in $SHELL_RC"
        fi
    fi
}

# ============================================================================
# Step 7: Create Helper Commands
# ============================================================================
create_helpers() {
    print_step "Creating helper commands..."
    
    mkdir -p "$HOME/.local/bin"
    
    # Create claude-mcp command for easy MCP management
    cat > "$HOME/.local/bin/claude-mcp" << 'EOF'
#!/bin/bash
# Helper script for Claude MCP management

case "$1" in
    list)
        echo "Listing MCP servers..."
        claude mcp list
        ;;
    test)
        echo "Testing MCP connections..."
        claude mcp list
        ;;
    fix)
        echo "Fixing MCP configuration..."
        cd ~/development/my-nvim-config
        ./scripts/mcp.sh --fix --user
        ;;
    reload)
        echo "Reloading MCP servers..."
        claude mcp reload
        ;;
    serena)
        shift
        if [[ -f "$HOME/.local/bin/serena-mcp" ]]; then
            "$HOME/.local/bin/serena-mcp" "$@"
        else
            echo "Serena not installed. Run setup-claude-integration.sh first."
        fi
        ;;
    *)
        echo "Usage: claude-mcp {list|test|fix|reload|serena}"
        echo "  list   - List configured MCP servers"
        echo "  test   - Test MCP connections"
        echo "  fix    - Fix and reconfigure MCP servers"
        echo "  reload - Reload MCP configuration"
        echo "  serena - Run Serena MCP commands"
        ;;
esac
EOF
    chmod +x "$HOME/.local/bin/claude-mcp"
    print_success "Created claude-mcp helper command"
    
    # Create project activation script
    cat > "$HOME/.local/bin/activate-project" << 'EOF'
#!/bin/bash
# Activate a project for Serena MCP

PROJECT_PATH="${1:-.}"
PROJECT_NAME="$(basename "$(realpath "$PROJECT_PATH")")"

echo "Activating project: $PROJECT_NAME at $PROJECT_PATH"

# Create .serena directory if it doesn't exist
mkdir -p "$PROJECT_PATH/.serena"

# Create basic project configuration if it doesn't exist
if [[ ! -f "$PROJECT_PATH/.serena/project.yml" ]]; then
    cat > "$PROJECT_PATH/.serena/project.yml" << EOL
# Serena Project Configuration
project:
  name: "$PROJECT_NAME"
  type: "mixed"
  root: "."
  
exclude:
  - ".git/"
  - "node_modules/"
  - "build/"
  - "dist/"
  - "*.log"
EOL
    echo "Created .serena/project.yml"
fi

echo "Project activated. Serena will use this configuration when working in this directory."
EOF
    chmod +x "$HOME/.local/bin/activate-project"
    print_success "Created project activation helper"
}

# ============================================================================
# Step 8: Verify Installation
# ============================================================================
verify_installation() {
    print_step "Verifying installation..."
    
    local all_ok=true
    
    # Check Serena
    if [[ -f "$HOME/.local/bin/serena-mcp" ]]; then
        print_success "Serena MCP wrapper installed"
    else
        print_warning "Serena MCP wrapper not found"
        all_ok=false
    fi
    
    # Check Claude settings
    if [[ -f "$HOME/.claude/settings.json" ]]; then
        print_success "Claude Code settings installed"
    else
        print_warning "Claude Code settings not found"
        all_ok=false
    fi
    
    # Check MCP configuration
    if command -v claude &> /dev/null; then
        # Check if servers are configured (without testing connections)
        if claude mcp list --json 2>/dev/null | grep -q "serena"; then
            print_success "Serena MCP configured"
        else
            print_warning "Serena MCP not configured"
            all_ok=false
        fi
    fi
    
    # Check helper commands
    if [[ -f "$HOME/.local/bin/claude-mcp" ]]; then
        print_success "Helper commands installed"
    else
        print_warning "Helper commands not found"
        all_ok=false
    fi
    
    if [ "$all_ok" = true ]; then
        print_success "All components verified successfully!"
    else
        print_warning "Some components may need attention"
    fi
}

# ============================================================================
# Main Installation Flow
# ============================================================================
main() {
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}        Claude Code Integration Setup${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo
    echo "This script will set up:"
    echo "• Serena MCP for semantic code operations"
    echo "• Claude Code safety settings"
    echo "• MCP servers (GitHub, Filesystem, Playwright, Debug Thinking)"
    echo "• Neovim integration"
    echo "• Helper commands and environment"
    echo
    
    # Parse arguments
    SKIP_PREREQ=false
    SKIP_VERIFY=false
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --skip-prereq)
                SKIP_PREREQ=true
                shift
                ;;
            --skip-verify)
                SKIP_VERIFY=true
                shift
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --skip-prereq  Skip prerequisite checks"
                echo "  --skip-verify  Skip verification step"
                echo "  --help         Show this help message"
                exit 0
                ;;
            *)
                shift
                ;;
        esac
    done
    
    # Run setup steps
    if [ "$SKIP_PREREQ" = false ]; then
        check_prerequisites
    fi
    
    setup_serena
    setup_claude_safety
    setup_mcp_servers
    setup_nvim_integration
    setup_environment
    create_helpers
    
    if [ "$SKIP_VERIFY" = false ]; then
        verify_installation
    fi
    
    # Final instructions
    echo
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}        Setup Complete! 🎉${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo
    echo -e "${BLUE}Next Steps:${NC}"
    echo "1. Set your GitHub token (if not already set):"
    echo "   export GITHUB_PERSONAL_ACCESS_TOKEN='your-token-here'"
    echo
    echo "2. Reload your shell configuration:"
    echo "   source ~/.zshrc  # or ~/.bashrc"
    echo
    echo "3. Test MCP servers:"
    echo "   claude-mcp test"
    echo
    echo "4. Activate Serena for a project:"
    echo "   cd your-project && activate-project"
    echo
    echo "5. Restart Claude Desktop to load new configuration"
    echo
    echo -e "${CYAN}Helper Commands:${NC}"
    echo "• claude-mcp list    - List MCP servers"
    echo "• claude-mcp test    - Test connections"
    echo "• claude-mcp fix     - Fix configuration"
    echo "• claude-mcp serena  - Run Serena commands"
    echo "• activate-project   - Activate Serena for current directory"
    echo
    echo -e "${GREEN}Happy coding with Claude! 🚀${NC}"
}

# Run main function
main "$@"