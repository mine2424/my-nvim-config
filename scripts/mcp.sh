#!/bin/bash

# MCP (Model Context Protocol) Setup for Claude Code
# ===============================================
# Adaptive installation with intelligent path detection
# Replaces both setup-mcp.sh and setup-mcp-adaptive.sh

set +e  # Don't exit on error for non-critical operations

echo "🤖 Setting up adaptive MCP configurations for Claude Code..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Claude settings directory
CLAUDE_DIR="$HOME/.claude"

# ===============================================
# Path Detection Functions
# ===============================================

# Function to detect npm global installation path
detect_npm_global_path() {
    local server_name="$1"
    local package_name="$2"
    
    # Check npm global bin directory
    if command -v npm &> /dev/null; then
        local npm_bin=$(npm bin -g 2>/dev/null)
        if [ -n "$npm_bin" ] && [ -f "$npm_bin/$server_name" ]; then
            echo "$npm_bin/$server_name"
            return 0
        fi
    fi
    
    # Check common npm global locations
    local common_paths=(
        "$HOME/.npm-global/bin/$server_name"
        "$HOME/.npm/bin/$server_name"
        "/usr/local/lib/node_modules/.bin/$server_name"
        "/opt/homebrew/lib/node_modules/.bin/$server_name"
    )
    
    for path in "${common_paths[@]}"; do
        if [ -f "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

# Function to detect local npm installation
detect_npm_local_path() {
    local package_name="$1"
    
    # Check if package exists in local node_modules
    if [ -d "node_modules/$package_name" ]; then
        local bin_path="node_modules/.bin/$(basename $package_name)"
        if [ -f "$bin_path" ]; then
            echo "$(pwd)/$bin_path"
            return 0
        fi
    fi
    
    return 1
}

# Function to detect homebrew installation
detect_homebrew_path() {
    local formula_name="$1"
    
    if command -v brew &> /dev/null; then
        # Check if formula is installed
        if brew list "$formula_name" &>/dev/null; then
            local brew_prefix=$(brew --prefix)
            local bin_path="$brew_prefix/bin/$formula_name"
            if [ -f "$bin_path" ]; then
                echo "$bin_path"
                return 0
            fi
        fi
    fi
    
    return 1
}

# Function to find executable in PATH
find_in_path() {
    local executable="$1"
    command -v "$executable" 2>/dev/null
}

# Function to detect MCP server installation
detect_mcp_server() {
    local server_name="$1"
    local npm_package="$2"
    local homebrew_formula="$3"
    local env_var="$4"
    
    echo -e "${CYAN}Detecting $server_name installation...${NC}"
    
    # 1. Check environment variable override
    if [ -n "${!env_var}" ] && [ -f "${!env_var}" ]; then
        echo -e "${GREEN}  ✓ Found via environment variable: ${!env_var}${NC}"
        echo "${!env_var}"
        return 0
    fi
    
    # 2. Check if executable is in PATH
    local path_exec=$(find_in_path "$server_name")
    if [ -n "$path_exec" ]; then
        echo -e "${GREEN}  ✓ Found in PATH: $path_exec${NC}"
        echo "$path_exec"
        return 0
    fi
    
    # 3. Check npm global installation
    local npm_global=$(detect_npm_global_path "$server_name" "$npm_package")
    if [ -n "$npm_global" ]; then
        echo -e "${GREEN}  ✓ Found npm global installation: $npm_global${NC}"
        echo "$npm_global"
        return 0
    fi
    
    # 4. Check homebrew installation (if formula provided)
    if [ -n "$homebrew_formula" ]; then
        local brew_path=$(detect_homebrew_path "$homebrew_formula")
        if [ -n "$brew_path" ]; then
            echo -e "${GREEN}  ✓ Found homebrew installation: $brew_path${NC}"
            echo "$brew_path"
            return 0
        fi
    fi
    
    # 5. Check local npm installation
    local npm_local=$(detect_npm_local_path "$npm_package")
    if [ -n "$npm_local" ]; then
        echo -e "${GREEN}  ✓ Found local npm installation: $npm_local${NC}"
        echo "$npm_local"
        return 0
    fi
    
    # Not found - will use npx
    echo -e "${YELLOW}  ⚠️  Not found locally, will use npx for dynamic installation${NC}"
    echo "npx -y $npm_package"
    return 0
}

# ===============================================
# Server Configuration Functions
# ===============================================

# Function to check if server is already configured
# Note: This does NOT test connections, just checks if configured
is_server_configured() {
    local server_name="$1"
    # Check the configuration file directly instead of using claude mcp list
    # which tries to start and test servers
    if [[ -f "$HOME/.claude.json" ]]; then
        grep -q "\"$server_name\":" "$HOME/.claude.json" 2>/dev/null
    else
        return 1
    fi
}

# Function to fix MCP servers
fix_mcp_connections() {
    echo -e "${CYAN}Fixing MCP server connections...${NC}"
    
    # Test npx functionality
    if ! npx --version > /dev/null 2>&1; then
        echo -e "${RED}❌ npx is not working properly${NC}"
        return 1
    fi
    echo -e "${GREEN}  ✓ npx is working (version: $(npx --version))${NC}"
}

# Function to remove all MCP servers
remove_all_mcp_servers() {
    local scope="${1:-user}"
    echo -e "${CYAN}Removing existing MCP configurations (scope: $scope)...${NC}"
    local servers=("github" "filesystem" "playwright" "debug-thinking" "serena" "context7")
    for server in "${servers[@]}"; do
        if is_server_configured "$server"; then
            claude mcp remove --scope "$scope" "$server" 2>/dev/null && \
                echo -e "${GREEN}  ✓ Removed $server${NC}" || \
                echo -e "${YELLOW}  ⚠️  Failed to remove $server${NC}"
        fi
    done
}

# Function to configure GitHub MCP server
configure_github_mcp() {
    local scope="${1:-user}"
    
    if is_server_configured "github"; then
        echo -e "${GREEN}✓ GitHub MCP server already configured${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}Configuring GitHub MCP server...${NC}"
    
    # Use npx with -y flag for better reliability
    local github_cmd="npx -y @modelcontextprotocol/server-github"
    
    # Build environment variables
    local env_args=""
    if [ -n "$GITHUB_PERSONAL_ACCESS_TOKEN" ]; then
        env_args="$env_args -e GITHUB_PERSONAL_ACCESS_TOKEN=\"$GITHUB_PERSONAL_ACCESS_TOKEN\""
    fi
    if [ -n "$GITHUB_API_URL" ]; then
        env_args="$env_args -e GITHUB_API_URL=\"$GITHUB_API_URL\""
    fi
    
    # Remove existing configuration first to avoid conflicts
    claude mcp remove --scope "$scope" github 2>/dev/null || true
    
    # Add server with scope
    if [ -n "$env_args" ]; then
        eval "claude mcp add --scope $scope github $env_args -- $github_cmd"
    else
        claude mcp add --scope "$scope" github -- $github_cmd
        echo -e "${YELLOW}Note: Set GITHUB_PERSONAL_ACCESS_TOKEN for full functionality${NC}"
    fi
}

# Function to configure Filesystem MCP server (replacing non-existent Context7)
configure_filesystem_mcp() {
    local scope="${1:-user}"
    
    if is_server_configured "filesystem"; then
        echo -e "${GREEN}✓ Filesystem MCP server already configured${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}Configuring Filesystem MCP server...${NC}"
    
    # Use npx with -y flag for better reliability
    local filesystem_cmd="npx -y @modelcontextprotocol/server-filesystem"
    
    # Build environment variables and arguments
    local env_args=""
    local fs_path="${FILESYSTEM_BASE_PATH:-$HOME/development}"
    
    if [ -n "$FILESYSTEM_ALLOWED_PATHS" ]; then
        env_args="$env_args -e FILESYSTEM_ALLOWED_PATHS=\"$FILESYSTEM_ALLOWED_PATHS\""
    fi
    
    # Remove existing configuration first to avoid conflicts
    claude mcp remove --scope "$scope" filesystem 2>/dev/null || true
    
    # Add server with path argument and scope
    if [ -n "$env_args" ]; then
        eval "claude mcp add --scope $scope filesystem $env_args -- $filesystem_cmd \"$fs_path\""
    else
        claude mcp add --scope "$scope" filesystem -- $filesystem_cmd "$fs_path"
    fi
}

# Function to configure Playwright MCP server
configure_playwright_mcp() {
    local scope="${1:-user}"
    
    if is_server_configured "playwright"; then
        echo -e "${GREEN}✓ Playwright MCP server already configured${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}Configuring Playwright MCP server...${NC}"
    
    # Use npx with -y flag for better reliability
    local playwright_cmd="npx -y @automatalabs/mcp-server-playwright"
    
    # Build environment variables
    local env_args=""
    if [ -n "$PLAYWRIGHT_BROWSERS_PATH" ]; then
        env_args="$env_args -e PLAYWRIGHT_BROWSERS_PATH=\"$PLAYWRIGHT_BROWSERS_PATH\""
    fi
    if [ -n "$PLAYWRIGHT_HEADLESS" ]; then
        env_args="$env_args -e PLAYWRIGHT_HEADLESS=\"$PLAYWRIGHT_HEADLESS\""
    fi
    
    # Remove existing configuration first to avoid conflicts
    claude mcp remove --scope "$scope" playwright 2>/dev/null || true
    
    # Add server with scope
    if [ -n "$env_args" ]; then
        eval "claude mcp add --scope $scope playwright $env_args -- $playwright_cmd"
    else
        claude mcp add --scope "$scope" playwright -- $playwright_cmd
    fi
}

# Function to configure Debug Thinking MCP server
configure_debug_thinking_mcp() {
    local scope="${1:-user}"
    
    if is_server_configured "debug-thinking"; then
        echo -e "${GREEN}✓ Debug Thinking MCP server already configured${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}Configuring Debug Thinking MCP server...${NC}"
    
    # Check if installed via Homebrew first
    local debug_cmd=""
    if command -v mcp-server-debug-thinking &> /dev/null; then
        echo -e "${GREEN}  ✓ Found in PATH${NC}"
        debug_cmd="mcp-server-debug-thinking"
    else
        # Use npx with -y flag
        debug_cmd="npx -y mcp-server-debug-thinking"
    fi
    
    # Build environment variables
    local env_args=""
    if [ -n "$DEBUG_THINKING_LOG_LEVEL" ]; then
        env_args="$env_args -e DEBUG_THINKING_LOG_LEVEL=\"$DEBUG_THINKING_LOG_LEVEL\""
    fi
    if [ -n "$DEBUG_THINKING_DATA_DIR" ]; then
        env_args="$env_args -e DEBUG_THINKING_DATA_DIR=\"$DEBUG_THINKING_DATA_DIR\""
    fi
    
    # Remove existing configuration first to avoid conflicts
    claude mcp remove --scope "$scope" debug-thinking 2>/dev/null || true
    
    # Add server with scope
    if [ -n "$env_args" ]; then
        eval "claude mcp add --scope $scope debug-thinking $env_args -- $debug_cmd"
    else
        claude mcp add --scope "$scope" debug-thinking -- $debug_cmd
    fi
}

# Function to configure Serena MCP server
configure_serena_mcp() {
    local scope="${1:-user}"
    
    if is_server_configured "serena"; then
        echo -e "${GREEN}✓ Serena MCP server already configured${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}Configuring Serena MCP server...${NC}"
    
    # Check for uvx or serena-mcp command
    local serena_cmd=""
    
    # 1. Check environment variable override
    if [ -n "$MCP_SERENA_PATH" ] && [ -f "$MCP_SERENA_PATH" ]; then
        echo -e "${GREEN}  ✓ Found via environment variable: $MCP_SERENA_PATH${NC}"
        serena_cmd="$MCP_SERENA_PATH"
    # 2. Check if serena-mcp wrapper exists
    elif [ -f "$HOME/.local/bin/serena-mcp" ]; then
        echo -e "${GREEN}  ✓ Found serena-mcp wrapper: $HOME/.local/bin/serena-mcp${NC}"
        serena_cmd="$HOME/.local/bin/serena-mcp"
    # 3. Check if uvx is available
    elif command -v uvx &> /dev/null; then
        echo -e "${GREEN}  ✓ Using uvx for Serena${NC}"
        # uvx requires separate arguments for claude mcp add
        serena_cmd="uvx"
        serena_args="--from git+https://github.com/oraios/serena serena"
    # 4. Check if uv is available for installation
    elif command -v uv &> /dev/null; then
        echo -e "${YELLOW}  ⚠️  Installing Serena with uv...${NC}"
        # Run the Serena setup script
        if [ -f "$SCRIPT_DIR/setup-serena.sh" ]; then
            bash "$SCRIPT_DIR/setup-serena.sh"
            if [ -f "$HOME/.local/bin/serena-mcp" ]; then
                serena_cmd="$HOME/.local/bin/serena-mcp"
            fi
        fi
    else
        echo -e "${YELLOW}  ⚠️  Serena requires uv/uvx - run setup-serena.sh first${NC}"
        return 1
    fi
    
    if [ -n "$serena_cmd" ]; then
        # Build environment variables
        local env_args=""
        if [ -n "$SERENA_CONFIG_PATH" ]; then
            env_args="$env_args -e SERENA_CONFIG_PATH=\"$SERENA_CONFIG_PATH\""
        fi
        if [ -n "$SERENA_PROJECT_PATH" ]; then
            env_args="$env_args -e SERENA_PROJECT_PATH=\"$SERENA_PROJECT_PATH\""
        fi
        
        # Remove existing configuration first to avoid conflicts
        claude mcp remove --scope "$scope" serena 2>/dev/null || true
        
        # Add server - handle uvx case specially
        if [ "$serena_cmd" = "uvx" ]; then
            # For uvx, we need to pass arguments differently with start-mcp-server command
            if [ -n "$env_args" ]; then
                eval "claude mcp add --scope $scope serena $env_args -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server"
            else
                claude mcp add --scope "$scope" serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server
            fi
        else
            # For regular commands (wrapper script handles start-mcp-server)
            if [ -n "$env_args" ]; then
                eval "claude mcp add --scope $scope serena $env_args -- $serena_cmd"
            else
                claude mcp add --scope "$scope" serena -- $serena_cmd
            fi
        fi
        
        echo -e "${GREEN}  ✓ Serena MCP server configured successfully${NC}"
    fi
}

# ===============================================
# Validation Functions
# ===============================================

# Function to validate environment
validate_environment() {
    echo -e "${CYAN}Validating environment...${NC}"
    
    # Check Claude CLI
    if ! command -v claude &> /dev/null; then
        echo -e "${RED}❌ Error: Claude Code CLI is not installed${NC}"
        echo -e "${YELLOW}   Please install Claude Code first: https://claude.ai/code${NC}"
        return 1
    fi
    echo -e "${GREEN}  ✓ Claude Code CLI found${NC}"
    
    # Check npm (optional)
    if command -v npm &> /dev/null; then
        echo -e "${GREEN}  ✓ npm found ($(npm --version))${NC}"
    else
        echo -e "${YELLOW}  ⚠️  npm not found - MCP servers will be installed on demand${NC}"
    fi
    
    # Check GitHub token
    if [ -n "$GITHUB_PERSONAL_ACCESS_TOKEN" ]; then
        echo -e "${GREEN}  ✓ GitHub token configured${NC}"
    else
        echo -e "${YELLOW}  ⚠️  GitHub token not set - limited functionality${NC}"
    fi
    
    return 0
}

# Function to generate environment template
generate_env_template() {
    local template_file="$HOME/.mcp-env-template"
    
    echo -e "${CYAN}Generating environment template...${NC}"
    
    cat > "$template_file" << 'EOF'
# MCP Environment Configuration Template
# Copy this to ~/.zshrc.local or ~/.bashrc.local and customize

# ===== GitHub MCP Server =====
# export GITHUB_PERSONAL_ACCESS_TOKEN='your-github-token-here'
# export GITHUB_API_URL='https://api.github.com'  # For GitHub Enterprise
# export MCP_GITHUB_PATH='/custom/path/to/mcp-server-github'

# ===== Filesystem MCP Server =====
# export FILESYSTEM_BASE_PATH="$HOME/development"  # Base directory for file operations
# export FILESYSTEM_ALLOWED_PATHS="/path/to/allowed,/another/path"  # Comma-separated allowed paths
# export MCP_FILESYSTEM_PATH='/custom/path/to/mcp-server-filesystem'

# ===== Playwright MCP Server =====
# export PLAYWRIGHT_BROWSERS_PATH="$HOME/.cache/playwright"
# export PLAYWRIGHT_HEADLESS=true
# export MCP_PLAYWRIGHT_PATH='/custom/path/to/mcp-server-playwright'

# ===== Debug Thinking MCP Server =====
# export DEBUG_THINKING_LOG_LEVEL=info
# export DEBUG_THINKING_DATA_DIR="$HOME/.debug-thinking-mcp"
# export MCP_DEBUG_THINKING_PATH='/custom/path/to/mcp-server-debug-thinking'

# ===== Serena MCP Server =====
# export SERENA_CONFIG_PATH="$HOME/.serena/serena_config.yml"
# export SERENA_PROJECT_PATH=".serena/project.yml"
# export MCP_SERENA_PATH='/custom/path/to/serena-mcp'

# ===== Proxy Configuration =====
# export HTTP_PROXY="http://proxy.example.com:8080"
# export HTTPS_PROXY="http://proxy.example.com:8080"
# export NO_PROXY="localhost,127.0.0.1"
EOF
    
    echo -e "${GREEN}  ✓ Template saved to: $template_file${NC}"
}

# ===============================================
# Main Setup Process
# ===============================================

main() {
    echo -e "${GREEN}=== Adaptive MCP Setup for Claude Code ===${NC}"
    echo ""
    
    # Parse flags
    local FIX_MODE=false
    local NO_TEST=false
    local SCOPE="user"  # Default to user scope for global configuration
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --fix|fix)
                FIX_MODE=true
                echo -e "${CYAN}Running in FIX mode - will remove and reconfigure all servers${NC}"
                shift
                ;;
            --no-test)
                NO_TEST=true
                echo -e "${CYAN}Configuration only mode - will not test connections${NC}"
                shift
                ;;
            --local)
                SCOPE="local"
                echo -e "${CYAN}Using local scope (project-specific)${NC}"
                shift
                ;;
            --user)
                SCOPE="user"
                echo -e "${CYAN}Using user scope (global)${NC}"
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
    
    echo -e "${CYAN}Configuration scope: ${SCOPE}${NC}"
    
    # Load local environment if exists
    if [ -f "$HOME/.zshrc.local" ]; then
        echo -e "${CYAN}Loading environment from ~/.zshrc.local...${NC}"
        source "$HOME/.zshrc.local"
    elif [ -f "$HOME/.bashrc.local" ]; then
        echo -e "${CYAN}Loading environment from ~/.bashrc.local...${NC}"
        source "$HOME/.bashrc.local"
    fi
    
    # Validate environment
    if ! validate_environment; then
        exit 1
    fi
    
    # If fix mode, remove all servers first
    if [ "$FIX_MODE" = true ]; then
        remove_all_mcp_servers "$SCOPE"
        fix_mcp_connections
    fi
    
    echo ""
    echo -e "${CYAN}Configuring MCP servers...${NC}"
    
    # Configure each server with the specified scope
    configure_github_mcp "$SCOPE"
    configure_filesystem_mcp "$SCOPE"  # Replaced context7 with filesystem
    configure_playwright_mcp "$SCOPE"
    configure_debug_thinking_mcp "$SCOPE"
    configure_serena_mcp "$SCOPE"
    
    echo ""
    echo -e "${GREEN}=== MCP Setup Complete ===${NC}"
    
    # Only test connections if not in no-test mode
    if [ "$NO_TEST" = false ]; then
        # List configured servers and test connections
        echo ""
        echo -e "${CYAN}Testing MCP server connections...${NC}"
        claude mcp list
    else
        # Just show configured servers without testing
        echo ""
        echo -e "${CYAN}MCP servers configured (not testing connections):${NC}"
        echo -e "${GREEN}  ✓ GitHub MCP server${NC}"
        echo -e "${GREEN}  ✓ Filesystem MCP server${NC}"
        echo -e "${GREEN}  ✓ Playwright MCP server${NC}"
        echo -e "${GREEN}  ✓ Debug Thinking MCP server${NC}"
        echo -e "${GREEN}  ✓ Serena MCP server${NC}"
    fi
    
    # Generate environment template
    generate_env_template
    
    echo ""
    echo -e "${GREEN}Next steps:${NC}"
    echo "1. Review the environment template: ~/.mcp-env-template"
    echo "2. Copy needed variables to ~/.zshrc.local or ~/.bashrc.local"
    echo "3. Set your GitHub token for full functionality:"
    echo "   export GITHUB_PERSONAL_ACCESS_TOKEN='your-token-here'"
    if [ "$NO_TEST" = true ]; then
        echo "4. Test connections with: claude mcp list"
        echo "5. Restart Claude Code to load the new configuration"
    else
        echo "4. Restart Claude Code to load the new configuration"
    fi
    
    echo ""
    echo -e "${GREEN}Happy coding with adaptive MCP! 🚀${NC}"
}

# Run main function
main "$@"