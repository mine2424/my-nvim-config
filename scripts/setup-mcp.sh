#!/bin/bash

# MCP (Model Context Protocol) setup script for Claude Code
# This script installs MCP configurations for GitHub, context7, and Playwright

# Don't exit on error for non-critical operations
set +e

echo "🤖 Setting up MCP configurations for Claude Code..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Claude settings directory
CLAUDE_DIR="$HOME/.claude"
CLAUDE_SETTINGS_FILE="$CLAUDE_DIR/settings.json"

# Function to check if jq is installed
check_jq() {
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}jq is not installed. Installing...${NC}"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install jq
        else
            sudo apt-get update && sudo apt-get install -y jq
        fi
    fi
}

# Function to backup existing file
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}Backing up existing $(basename "$file") to $(basename "$backup")${NC}"
        cp "$file" "$backup"
    fi
}

# Function to check if server is already configured
is_server_configured() {
    local server_name="$1"
    claude mcp list 2>/dev/null | grep -q "^$server_name\s"
}

# Function to detect custom MCP server paths
detect_custom_paths() {
    # Check for custom MCP server paths in environment
    if [ -n "$MCP_GITHUB_PATH" ]; then
        echo -e "${YELLOW}Using custom GitHub MCP path: $MCP_GITHUB_PATH${NC}"
    fi
    if [ -n "$MCP_CONTEXT7_PATH" ]; then
        echo -e "${YELLOW}Using custom Context7 MCP path: $MCP_CONTEXT7_PATH${NC}"
    fi
    if [ -n "$MCP_PLAYWRIGHT_PATH" ]; then
        echo -e "${YELLOW}Using custom Playwright MCP path: $MCP_PLAYWRIGHT_PATH${NC}"
    fi
    if [ -n "$MCP_DEBUG_THINKING_PATH" ]; then
        echo -e "${YELLOW}Using custom Debug Thinking MCP path: $MCP_DEBUG_THINKING_PATH${NC}"
    fi
}

# Function to add MCP servers using Claude CLI
add_mcp_servers() {
    echo -e "${GREEN}Adding MCP servers to Claude Code...${NC}"
    
    # Check if claude command exists
    if ! command -v claude &> /dev/null; then
        echo -e "${RED}Error: Claude Code CLI is not installed${NC}"
        echo -e "${YELLOW}Please install Claude Code first: https://claude.ai/code${NC}"
        return 1
    fi
    
    # Detect custom paths
    detect_custom_paths
    
    # Add GitHub MCP server
    if is_server_configured "github"; then
        echo -e "${GREEN}✓ GitHub MCP server already configured${NC}"
    else
        echo -e "${YELLOW}Adding GitHub MCP server...${NC}"
        local github_cmd="${MCP_GITHUB_PATH:-npx -y @modelcontextprotocol/server-github}"
        
        # Build environment variables
        local env_args=""
        if [ -n "$GITHUB_PERSONAL_ACCESS_TOKEN" ]; then
            env_args="$env_args -e GITHUB_PERSONAL_ACCESS_TOKEN=\"$GITHUB_PERSONAL_ACCESS_TOKEN\""
        fi
        if [ -n "$GITHUB_API_URL" ]; then
            env_args="$env_args -e GITHUB_API_URL=\"$GITHUB_API_URL\""
        fi
        
        if [ -n "$env_args" ]; then
            eval "claude mcp add github $env_args -- $github_cmd"
        else
            claude mcp add github -- $github_cmd
            echo -e "${YELLOW}Note: GitHub MCP server added without token. Set GITHUB_PERSONAL_ACCESS_TOKEN to enable full functionality.${NC}"
        fi
    fi
    
    # Add Context7 MCP server
    if is_server_configured "context7"; then
        echo -e "${GREEN}✓ Context7 MCP server already configured${NC}"
    else
        echo -e "${YELLOW}Adding Context7 MCP server...${NC}"
        local context7_cmd="${MCP_CONTEXT7_PATH:-npx -y @context7/mcp-server}"
        
        # Build environment variables
        local env_args=""
        if [ -n "$CONTEXT7_DATA_DIR" ]; then
            env_args="$env_args -e CONTEXT7_DATA_DIR=\"$CONTEXT7_DATA_DIR\""
        fi
        
        if [ -n "$env_args" ]; then
            eval "claude mcp add context7 $env_args -- $context7_cmd"
        else
            claude mcp add context7 -- $context7_cmd
        fi
    fi
    
    # Add Playwright MCP server
    if is_server_configured "playwright"; then
        echo -e "${GREEN}✓ Playwright MCP server already configured${NC}"
    else
        echo -e "${YELLOW}Adding Playwright MCP server...${NC}"
        local playwright_cmd="${MCP_PLAYWRIGHT_PATH:-npx -y @automatalabs/mcp-server-playwright}"
        
        # Build environment variables
        local env_args=""
        if [ -n "$PLAYWRIGHT_BROWSERS_PATH" ]; then
            env_args="$env_args -e PLAYWRIGHT_BROWSERS_PATH=\"$PLAYWRIGHT_BROWSERS_PATH\""
        fi
        if [ -n "$PLAYWRIGHT_HEADLESS" ]; then
            env_args="$env_args -e PLAYWRIGHT_HEADLESS=\"$PLAYWRIGHT_HEADLESS\""
        fi
        
        if [ -n "$env_args" ]; then
            eval "claude mcp add playwright $env_args -- $playwright_cmd"
        else
            claude mcp add playwright -- $playwright_cmd
        fi
    fi
    
    # Add Debug Thinking MCP server
    if is_server_configured "debug-thinking"; then
        echo -e "${GREEN}✓ Debug Thinking MCP server already configured${NC}"
    else
        echo -e "${YELLOW}Adding Debug Thinking MCP server...${NC}"
        local debug_thinking_cmd="${MCP_DEBUG_THINKING_PATH:-npx -y mcp-server-debug-thinking}"
        
        # Build environment variables
        local env_args=""
        if [ -n "$DEBUG_THINKING_LOG_LEVEL" ]; then
            env_args="$env_args -e DEBUG_THINKING_LOG_LEVEL=\"$DEBUG_THINKING_LOG_LEVEL\""
        fi
        if [ -n "$DEBUG_THINKING_DATA_DIR" ]; then
            env_args="$env_args -e DEBUG_THINKING_DATA_DIR=\"$DEBUG_THINKING_DATA_DIR\""
        fi
        
        if [ -n "$env_args" ]; then
            eval "claude mcp add debug-thinking $env_args -- $debug_thinking_cmd"
        else
            claude mcp add debug-thinking -- $debug_thinking_cmd
        fi
    fi
    
    echo -e "${GREEN}✓ All MCP servers have been configured${NC}"
    
    # List configured servers
    echo -e "${GREEN}Configured MCP servers:${NC}"
    claude mcp list
}

# Function to validate GitHub token
validate_github_token() {
    if [ -z "$GITHUB_PERSONAL_ACCESS_TOKEN" ]; then
        echo -e "${YELLOW}⚠️  Warning: GITHUB_PERSONAL_ACCESS_TOKEN is not set${NC}"
        echo -e "${YELLOW}   The GitHub MCP server requires a personal access token to function${NC}"
        echo -e "${YELLOW}   Please set it in your shell configuration:${NC}"
        echo -e "${YELLOW}   export GITHUB_PERSONAL_ACCESS_TOKEN='your-token-here'${NC}"
        echo ""
        echo -e "${YELLOW}   You can create a token at: https://github.com/settings/tokens${NC}"
        echo -e "${YELLOW}   Required scopes: repo, read:org, read:user${NC}"
    else
        echo -e "${GREEN}✓ GitHub personal access token is configured${NC}"
    fi
}

# Function to test MCP server availability (non-blocking)
test_mcp_servers() {
    echo -e "${GREEN}Testing MCP server availability (optional)...${NC}"
    
    # Check if npm is installed
    if ! command -v npm &> /dev/null; then
        echo -e "${YELLOW}⚠️  npm is not installed. Skipping MCP server tests.${NC}"
        echo -e "${YELLOW}   MCP servers will be downloaded when Claude Code first uses them.${NC}"
        return 0
    fi
    
    # Create a temporary directory for testing MCP servers
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    # Test each MCP server with timeout
    echo -e "${YELLOW}Note: This is just a connectivity test. MCP servers will be installed automatically by Claude Code.${NC}"
    
    # GitHub MCP server
    echo -n "  GitHub MCP server: "
    if timeout 10s npx -y @modelcontextprotocol/server-github --help &> /dev/null; then
        echo -e "${GREEN}✓ Available${NC}"
    else
        echo -e "${YELLOW}⚠️  Not tested (will be installed on first use)${NC}"
    fi
    
    # Context7 MCP server
    echo -n "  Context7 MCP server: "
    if timeout 10s npx -y @context7/mcp-server --help &> /dev/null; then
        echo -e "${GREEN}✓ Available${NC}"
    else
        echo -e "${YELLOW}⚠️  Not tested (will be installed on first use)${NC}"
    fi
    
    # Playwright MCP server
    echo -n "  Playwright MCP server: "
    if timeout 10s npx -y @automatalabs/mcp-server-playwright --help &> /dev/null; then
        echo -e "${GREEN}✓ Available${NC}"
    else
        echo -e "${YELLOW}⚠️  Not tested (will be installed on first use)${NC}"
    fi
    
    # Clean up
    cd - > /dev/null
    rm -rf "$temp_dir"
    
    echo -e "${GREEN}✓ MCP configuration has been installed successfully${NC}"
}


# Function to show environment variables
show_environment_help() {
    echo -e "${CYAN}Available Environment Variables:${NC}"
    echo ""
    echo -e "${YELLOW}GitHub MCP Server:${NC}"
    echo "  GITHUB_PERSONAL_ACCESS_TOKEN  - Personal access token for GitHub API"
    echo "  GITHUB_API_URL               - Custom GitHub API endpoint (for GitHub Enterprise)"
    echo "  MCP_GITHUB_PATH              - Custom path to local GitHub MCP server"
    echo ""
    echo -e "${YELLOW}Context7 MCP Server:${NC}"
    echo "  CONTEXT7_DATA_DIR            - Custom context storage location"
    echo "  MCP_CONTEXT7_PATH            - Custom path to local Context7 MCP server"
    echo ""
    echo -e "${YELLOW}Playwright MCP Server:${NC}"
    echo "  PLAYWRIGHT_BROWSERS_PATH     - Custom browser download location"
    echo "  PLAYWRIGHT_HEADLESS          - Headless mode (true/false)"
    echo "  MCP_PLAYWRIGHT_PATH          - Custom path to local Playwright MCP server"
    echo ""
    echo -e "${YELLOW}Debug Thinking MCP Server:${NC}"
    echo "  DEBUG_THINKING_LOG_LEVEL     - Log level (debug, info, warn, error)"
    echo "  DEBUG_THINKING_DATA_DIR      - Custom debug data directory"
    echo "  MCP_DEBUG_THINKING_PATH      - Custom path to local Debug Thinking MCP server"
    echo ""
    echo -e "${YELLOW}Proxy Configuration:${NC}"
    echo "  HTTP_PROXY                   - HTTP proxy URL"
    echo "  HTTPS_PROXY                  - HTTPS proxy URL"
    echo "  NO_PROXY                     - Comma-separated list of no-proxy hosts"
    echo ""
}

# Main setup process
main() {
    echo -e "${GREEN}=== MCP Setup for Claude Code ===${NC}"
    echo ""
    
    # Check dependencies
    check_jq
    
    # Add MCP servers using Claude CLI
    add_mcp_servers
    
    # Validate GitHub token
    validate_github_token
    
    echo ""
    echo -e "${GREEN}=== MCP Setup Complete ===${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Set your GitHub personal access token:"
    echo "   export GITHUB_PERSONAL_ACCESS_TOKEN='your-token-here'"
    echo ""
    echo "2. Restart Claude Code to load the new MCP servers"
    echo ""
    echo "3. The following MCP servers are now configured:"
    echo "   - GitHub: Repository operations, issues, PRs"
    echo "   - Context7: Enhanced context management"
    echo "   - Playwright: Web automation and testing"
    echo "   - Debug Thinking: Enhanced debugging and thought process visualization"
    echo ""
    
    # Show environment variables help
    echo -e "${CYAN}To customize MCP servers for your environment:${NC}"
    echo "Set any of these environment variables before running setup:"
    echo ""
    show_environment_help
    
    echo -e "${GREEN}Happy coding with MCP! 🚀${NC}"
}

# Run main function
main