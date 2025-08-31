# Setup Guide - My Neovim Configuration

## 📋 Prerequisites

Before starting, ensure you have:
- Git installed
- Terminal access (Zsh or Bash)
- macOS or Linux (Ubuntu/Debian supported)

## 🚀 Quick Start Options

### Option 1: AstroNvim with Full Development Setup (Recommended)
```bash
git clone https://github.com/your-repo/my-nvim-config.git
cd my-nvim-config
./scripts/setup.sh astronvim-full
```

### Option 2: Claude Code Complete Integration
```bash
./scripts/setup.sh claude-integration
```

### Option 3: Minimal Configuration Only
```bash
./scripts/setup.sh config-only
```

## 📦 Available Setup Modes

| Mode | Command | Description |
|------|---------|-------------|
| **astronvim-full** | `./scripts/setup.sh astronvim-full` | Complete AstroNvim with LSP, AI tools, development setup |
| **claude-integration** | `./scripts/setup.sh claude-integration` | Claude Code with Serena MCP and all integrations |
| **astronvim** | `./scripts/setup.sh astronvim` | Basic AstroNvim migration (config only) |
| **full** | `./scripts/setup.sh --full` | Legacy complete setup with all tools |
| **config-only** | `./scripts/setup.sh` | Configuration files only (default) |
| **mcp-only** | `./scripts/setup.sh mcp-only` | MCP servers setup only |
| **serena-only** | `./scripts/setup.sh serena-only` | Serena MCP server only |
| **kiro-only** | `./scripts/setup.sh kiro-only` | Kiro command only |

## 🔧 Step-by-Step Installation

### 1. Clone the Repository
```bash
git clone https://github.com/your-repo/my-nvim-config.git
cd my-nvim-config
```

### 2. Choose Your Setup Path

#### For New Users - AstroNvim Full Setup
```bash
./scripts/setup.sh astronvim-full
```
This installs:
- ✅ AstroNvim v4 configuration
- ✅ All language servers (Dart, TypeScript, Python, etc.)
- ✅ AI tools (Copilot, ChatGPT, Avante)
- ✅ Development tools (Git, formatters, linters)
- ✅ Telescope.nvim for file search
- ✅ Flutter tools

#### For Claude Code Users - Complete Integration
```bash
./scripts/setup.sh claude-integration
```
This installs:
- ✅ Serena MCP for semantic code operations
- ✅ All MCP servers (GitHub, Filesystem, Playwright, Debug Thinking)
- ✅ Claude Code safety settings
- ✅ Neovim plugin integration
- ✅ Helper commands (`claude-mcp`, `activate-project`)
- ✅ Environment configuration

#### For Existing Neovim Users - Migration
```bash
# Backup your config first!
cp -r ~/.config/nvim ~/.config/nvim.backup

# Then run migration
./scripts/setup.sh astronvim
```

### 3. Post-Installation Setup

#### Set Environment Variables
Add to `~/.zshrc.local` or `~/.bashrc.local`:
```bash
# GitHub token for MCP
export GITHUB_PERSONAL_ACCESS_TOKEN='your-github-token'

# AI API keys (optional)
export OPENAI_API_KEY='your-openai-key'
export ANTHROPIC_API_KEY='your-anthropic-key'
```

#### Reload Shell Configuration
```bash
source ~/.zshrc  # or ~/.bashrc
```

#### Install LSP Servers (in Neovim)
```vim
:MasonInstall tsserver pyright tailwindcss
```

#### Setup GitHub Copilot (in Neovim)
```vim
:Copilot setup
:Copilot enable
```

### 4. Test Your Installation

#### Test MCP Servers
```bash
claude-mcp test
```

#### Test Neovim
```bash
nvim
:checkhealth
```

#### Activate Serena for a Project
```bash
cd your-project
activate-project
```

## 🛠️ Helper Commands

After installation, these commands are available:

### MCP Management
- `claude-mcp list` - List MCP servers and status
- `claude-mcp test` - Test MCP connections
- `claude-mcp fix` - Fix MCP configuration
- `claude-mcp serena` - Run Serena commands

### Project Management
- `activate-project` - Activate Serena for current directory

### Usage Monitor (if installed)
- `cm` - Open Claude usage monitor
- `cmp` - Monitor for Pro plan
- `cmx` - Monitor for Max20 plan

## 🔍 Verification

### Check Installation Status
```bash
# Check Neovim version
nvim --version

# Check Claude Code CLI
claude --version

# Check MCP servers
claude-mcp list

# Check installed tools
which uvx  # For Serena
which npm  # For MCP servers
which rg   # For searching
```

### Common Issues and Solutions

#### Issue: MCP servers not connecting
```bash
# Fix MCP connections
claude-mcp fix

# Restart Claude Desktop
# Then test again
claude-mcp test
```

#### Issue: Neovim plugins not loading
```vim
" In Neovim
:Lazy sync
:checkhealth
```

#### Issue: LSP not working
```vim
" In Neovim
:LspInfo
:Mason
" Install missing servers
:MasonInstall <server-name>
```

## 📖 Key Features After Setup

### Neovim Features
- **Leader key**: `<Space>`
- **File search**: `<Space>ff` (Telescope)
- **Text search**: `<Space>fw` (Live grep)
- **AI assistance**: `<Space>aa` (Avante)
- **File explorer**: `<Space>e`
- **Git integration**: `<Space>g*` commands

### Claude Code Features
- **Serena MCP**: Semantic code operations
- **Project configs**: `.serena/project.yml` per project
- **Safety settings**: Command deny list active
- **MCP servers**: GitHub, Filesystem, Playwright, Debug Thinking

### Development Features
- **Flutter**: Full Flutter/Dart support with hot reload
- **TypeScript/JavaScript**: React, Next.js, Node.js support
- **Python**: Virtual environment aware
- **AI**: Copilot, ChatGPT, Avante integration

## 📚 Additional Resources

- [README.md](README.md) - Main documentation
- [CLAUDE.md](CLAUDE.md) - Claude Code specific documentation
- [ASTRONVIM_MIGRATION.md](ASTRONVIM_MIGRATION.md) - Migration guide
- [MCP_SETUP.md](MCP_SETUP.md) - MCP server details
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues

## 🆘 Getting Help

If you encounter issues:
1. Check the troubleshooting guide
2. Run `:checkhealth` in Neovim
3. Check the logs in `~/.claude/` and `~/.serena/`
4. Open an issue on GitHub with error details

## 🎉 Ready to Code!

Your development environment is now ready. Start coding with:
```bash
cd your-project
nvim .
```

Happy coding! 🚀