#!/bin/bash

# Setup script for Serena MCP (Model Context Protocol) Server
# A powerful coding agent toolkit for semantic code retrieval and editing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detect OS
OS="Unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
fi

print_info "Setting up Serena MCP for $OS..."

# Check if uv is installed
check_uv() {
    if command -v uv &> /dev/null; then
        print_success "uv is already installed"
        return 0
    else
        print_warning "uv is not installed"
        return 1
    fi
}

# Install uv if not present
install_uv() {
    print_info "Installing uv package manager..."
    
    if [[ "$OS" == "macOS" ]]; then
        # Try homebrew first
        if command -v brew &> /dev/null; then
            print_info "Installing uv via Homebrew..."
            brew install uv
        else
            # Fall back to curl installation
            print_info "Installing uv via curl..."
            curl -LsSf https://astral.sh/uv/install.sh | sh
        fi
    else
        # Linux or other Unix-like systems
        print_info "Installing uv via curl..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
    
    # Add to PATH if needed
    if [[ -f "$HOME/.cargo/bin/uv" ]]; then
        export PATH="$HOME/.cargo/bin:$PATH"
        print_info "Added uv to PATH from cargo"
    fi
}

# Install Serena
install_serena() {
    print_info "Installing Serena MCP server..."
    
    # Create directory for Serena configuration
    SERENA_DIR="$HOME/.serena"
    mkdir -p "$SERENA_DIR"
    
    # We don't need to clone or install locally since we use uvx
    # uvx will handle the installation automatically
    print_info "Serena will be installed on-demand via uvx"
    
    # Create a wrapper script for easy execution
    cat > "$HOME/.local/bin/serena-mcp" << 'EOF'
#!/bin/bash
# Wrapper script for Serena MCP server

# Ensure uv/uvx environment is available
if [[ -f "$HOME/.cargo/bin/uvx" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
elif [[ -f "$HOME/.local/bin/uvx" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Check if uvx is available
if command -v uvx &> /dev/null; then
    # Run Serena MCP server with uvx (using correct git URL format)
    # If no arguments provided, default to start-mcp-server for MCP usage
    if [ $# -eq 0 ]; then
        exec uvx --from git+https://github.com/oraios/serena serena start-mcp-server
    else
        exec uvx --from git+https://github.com/oraios/serena serena "$@"
    fi
else
    echo "Error: uvx not found. Please install uv first." >&2
    exit 1
fi
EOF
    
    chmod +x "$HOME/.local/bin/serena-mcp"
    
    # Ensure ~/.local/bin is in PATH
    mkdir -p "$HOME/.local/bin"
    
    print_success "Serena MCP installed successfully"
}

# Create Serena configuration
setup_serena_config() {
    print_info "Setting up Serena configuration..."
    
    SERENA_CONFIG_DIR="$HOME/.serena"
    mkdir -p "$SERENA_CONFIG_DIR"
    
    # Get the directory of this script
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
    
    # Copy pre-configured Serena configuration if it exists
    if [[ -f "$PROJECT_ROOT/claude/serena_config.yml" ]]; then
        print_info "Copying Serena configuration from project..."
        cp "$PROJECT_ROOT/claude/serena_config.yml" "$SERENA_CONFIG_DIR/serena_config.yml"
    else
        # Create global Serena configuration
        print_info "Creating default Serena configuration..."
        cat > "$SERENA_CONFIG_DIR/serena_config.yml" << 'EOF'
# Serena Global Configuration
# This file configures the Serena MCP server for semantic code operations

# Projects configuration (required)
# Projects will be activated dynamically via the activate_project tool
projects: {}

# Language servers configuration
language_servers:
  python:
    enabled: true
    server: pylsp
  typescript:
    enabled: true
    server: typescript-language-server
  javascript:
    enabled: true
    server: typescript-language-server
  rust:
    enabled: true
    server: rust-analyzer
  go:
    enabled: true
    server: gopls

# Tool configuration
tools:
  # Enable all tools by default
  enabled_tools:
    - get_file_tree
    - get_file_content
    - get_references
    - get_definitions
    - get_implementations
    - search_symbol
    - apply_edits
    - rename_symbol
    
  # Tool-specific settings
  settings:
    max_search_results: 50
    include_docstrings: true
    show_type_hints: true

# Context settings
context:
  # Default context for operations
  default: "terminal"
  
  # Context-specific settings
  contexts:
    terminal:
      max_file_size: 1000000  # 1MB
      exclude_patterns:
        - "*.pyc"
        - "__pycache__"
        - "node_modules"
        - ".git"
        - "*.log"
    ide:
      max_file_size: 5000000  # 5MB
      include_hidden_files: false

# Performance settings
performance:
  cache_enabled: true
  cache_ttl: 3600  # 1 hour
  parallel_operations: true
  max_workers: 4

# Logging
logging:
  level: INFO
  file: ~/.serena/serena.log
  rotate: true
  max_size: 10485760  # 10MB
EOF
    fi
    
    print_success "Serena configuration created at $SERENA_CONFIG_DIR/serena_config.yml"
}

# Create project-specific Serena configuration template
create_project_template() {
    print_info "Creating project configuration template..."
    
    TEMPLATE_DIR="$HOME/.serena/templates"
    mkdir -p "$TEMPLATE_DIR"
    
    # Get the directory of this script
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
    
    # Copy pre-configured project template if it exists
    if [[ -f "$PROJECT_ROOT/claude/serena_project_template.yml" ]]; then
        print_info "Copying project template from project..."
        cp "$PROJECT_ROOT/claude/serena_project_template.yml" "$TEMPLATE_DIR/project.yml"
    else
        # Create default project template
        print_info "Creating default project template..."
        cat > "$TEMPLATE_DIR/project.yml" << 'EOF'
# Serena Project Configuration Template
# Copy this to your project root as .serena/project.yml

# Project-specific settings
project:
  name: "My Project"
  type: "mixed"  # python, typescript, rust, go, or mixed
  root: "."
  
# Language server overrides for this project
language_servers:
  python:
    settings:
      pylsp:
        plugins:
          pycodestyle:
            enabled: true
            maxLineLength: 88
          pylint:
            enabled: false
  
  typescript:
    settings:
      diagnostics:
        enable: true
      format:
        enable: true

# Project-specific exclusions
exclude:
  - "build/"
  - "dist/"
  - "coverage/"
  - "*.min.js"
  - "*.map"
  - ".venv/"
  - "venv/"

# Custom tool settings for this project
tools:
  search_symbol:
    include_tests: true
    include_private: false
  
  apply_edits:
    auto_format: true
    verify_syntax: true

# Environment variables (optional)
environment:
  # INTELEPHENSE_LICENSE_KEY: "your-key-here"  # For PHP premium features
EOF
    fi
    
    print_success "Project template created at $TEMPLATE_DIR/project.yml"
}

# Update MCP configuration
update_mcp_config() {
    print_info "Updating MCP configuration to include Serena..."
    
    # Determine MCP config location based on OS
    if [[ "$OS" == "macOS" ]]; then
        MCP_CONFIG_DIR="$HOME/Library/Application Support/Claude"
    else
        MCP_CONFIG_DIR="$HOME/.config/claude"
    fi
    
    MCP_CONFIG_FILE="$MCP_CONFIG_DIR/claude_desktop_config.json"
    
    # Backup existing config
    if [[ -f "$MCP_CONFIG_FILE" ]]; then
        cp "$MCP_CONFIG_FILE" "$MCP_CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backed up existing MCP configuration"
    fi
    
    # Create the MCP configuration directory if it doesn't exist
    mkdir -p "$MCP_CONFIG_DIR"
    
    # Path to Serena executable
    SERENA_PATH="$HOME/.local/bin/serena-mcp"
    
    # Check if we can use uvx directly
    if command -v uvx &> /dev/null; then
        SERENA_COMMAND="uvx"
        SERENA_ARGS='["--from", "github:oraios/serena", "serena"]'
    else
        SERENA_COMMAND="$SERENA_PATH"
        SERENA_ARGS='[]'
    fi
    
    print_success "Serena MCP setup completed!"
    print_info ""
    print_info "Next steps:"
    print_info "1. Run 'scripts/setup-mcp-adaptive.sh' to add Serena to your Claude Desktop config"
    print_info "2. Restart Claude Desktop to load the new MCP server"
    print_info "3. Create a .serena/project.yml in your project root for project-specific settings"
    print_info ""
    print_info "Serena will be available with the following path detection:"
    print_info "  - Environment variable: MCP_SERENA_PATH"
    print_info "  - Direct execution: serena-mcp"
    print_info "  - uvx fallback: uvx --from github:oraios/serena serena"
}

# Main setup flow
main() {
    print_info "Starting Serena MCP setup..."
    
    # Check and install uv if needed
    if ! check_uv; then
        install_uv
    fi
    
    # Install Serena
    install_serena
    
    # Setup configuration
    setup_serena_config
    create_project_template
    
    # Update MCP config
    update_mcp_config
    
    print_success "✨ Serena MCP setup complete!"
    print_info ""
    print_info "You can now use Serena for semantic code operations in Claude Desktop."
    print_info "Configuration file: ~/.serena/serena_config.yml"
    print_info "Project template: ~/.serena/templates/project.yml"
}

# Run main function
main