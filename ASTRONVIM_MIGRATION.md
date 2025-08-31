# AstroNvim Migration Guide

## 🚀 Overview

This guide helps you migrate from your current Neovim configuration to AstroNvim v4, a powerful and feature-rich Neovim distribution optimized for Flutter, JavaScript/TypeScript, React, Next.js, and Python development.

## 📋 Prerequisites

- **Neovim 0.10+** (required for AstroNvim v4)
- **Git**
- **Node.js & npm** (for language servers)
- **Python 3** (for Python development)
- **Nerd Font** (JetBrainsMono Nerd Font recommended)
- **True color terminal**

## 🔄 Migration Process

### Step 1: Run the Migration Script

```bash
./scripts/migrate-to-astronvim.sh
```

This script will:
1. ✅ Check prerequisites
2. 💾 Backup your current configuration
3. 🧹 Clean existing Neovim settings
4. 📦 Install AstroNvim
5. ⚙️ Create custom configurations for your tech stack
6. 🛠️ Create helper scripts

### Step 2: Launch Neovim and Wait for Plugin Installation

```bash
nvim
```

On first launch, AstroNvim will automatically:
- Download and install all plugins
- Set up the plugin manager (lazy.nvim)
- Configure the base environment

This may take 2-3 minutes on first run.

### Step 3: Run Post-Installation Setup

```bash
./scripts/astronvim-post-setup.sh
```

### Step 4: Setup AI Tools (Optional but Recommended)

```bash
./scripts/setup-ai-tools.sh
```

This will help you configure:
- 🤖 GitHub Copilot - AI pair programming
- 💻 Codeium - Free alternative to Copilot  
- 💬 ChatGPT - AI chat and code assistance
- 🚀 Avante - Cursor-like AI experience with Claude/GPT-4

Choose option 9 to run all setup steps, or select individual options:
1. Install development tools
2. Install NPM packages for LSPs
3. Install Python packages
4. Configure Git integration
5. Create project templates
6. Configure shell aliases
7. Show LSP installation commands
8. Run health check

### Step 5: Install Language Servers

In Neovim, run these commands:

#### For Flutter Development:
```vim
:MasonInstall dartls
```

#### For JavaScript/TypeScript/React/Next.js:
```vim
:MasonInstall tsserver eslint tailwindcss html cssls emmet_language_server
```

#### For Python:
```vim
:MasonInstall pyright ruff_lsp black isort
```

#### Additional Tools:
```vim
:MasonInstall prettier jsonls yamlls marksman lua_ls
```

## 🎨 Configuration Structure

```
~/.config/nvim/
├── init.lua                      # Entry point
└── lua/
    ├── plugins/
    │   ├── astrocore.lua        # Core settings and keymaps
    │   ├── astrolsp.lua         # LSP configuration
    │   ├── mason.lua            # Language server installer
    │   ├── treesitter.lua       # Syntax highlighting
    │   ├── community.lua        # Community plugins
    │   └── user.lua             # Custom plugins
    └── polish.lua               # Final configurations
```

## ⌨️ Key Mappings

### Leader Key: `<Space>`

### Essential Commands

| Key | Description |
|-----|-------------|
| `<Space>ff` | Find files |
| `<Space>fg` | Find text (grep) |
| `<Space>fw` | Find word under cursor |
| `<Space>fb` | Find buffers |
| `<Space>fh` | Find help |
| `<Space>fo` | Find old files (recent) |

### File Explorer

| Key | Description |
|-----|-------------|
| `<Space>e` | Toggle file explorer |
| `<Space>o` | Focus file explorer |

### LSP Features

| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Show hover documentation |
| `<Space>la` | Code actions |
| `<Space>lf` | Format code |
| `<Space>lr` | Rename symbol |
| `<Space>ld` | Show diagnostics |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Buffer Management

| Key | Description |
|-----|-------------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<Space>bd` | Delete buffer |
| `<Space>bc` | Close buffer |
| `<Space>bD` | Delete all buffers |

### Window Navigation

| Key | Description |
|-----|-------------|
| `<C-h>` | Move to left window |
| `<C-j>` | Move to below window |
| `<C-k>` | Move to above window |
| `<C-l>` | Move to right window |
| `<C-Up>` | Resize window up |
| `<C-Down>` | Resize window down |
| `<C-Left>` | Resize window left |
| `<C-Right>` | Resize window right |

### Git Integration

| Key | Description |
|-----|-------------|
| `<Space>gg` | Open Neogit |
| `<Space>gd` | Git diff |
| `<Space>gb` | Git blame |
| `<Space>gs` | Git status |
| `]g` | Next git hunk |
| `[g` | Previous git hunk |

## 💻 Language-Specific Features

### Flutter Development

The configuration includes `flutter-tools.nvim` with:
- Flutter commands palette
- Widget guides
- Closing tags
- Hot reload integration
- DevTools integration
- FVM support

Flutter Commands:
- `<Space>Fa` - Flutter run app
- `<Space>Fq` - Flutter quit
- `<Space>Fr` - Flutter reload
- `<Space>FR` - Flutter restart
- `<Space>Fd` - Flutter devices
- `<Space>FD` - Flutter doctor
- `<Space>Fo` - Flutter outline

### JavaScript/TypeScript

Enhanced support with:
- `typescript-tools.nvim` for better TS support
- ESLint integration
- Prettier formatting
- Auto-import
- Inlay hints
- Package.json integration

### React/Next.js

- JSX/TSX support
- Auto-close tags
- Tailwind CSS IntelliSense
- Component navigation
- Fast refresh support

### Python

- Type checking with Pyright
- Formatting with Black
- Import sorting with isort
- Linting with Ruff
- Virtual environment detection
- Jupyter notebook support

## 🛠️ Project Templates

Use the created project templates to quickly start new projects:

### Flutter Project
```bash
~/.config/nvim-templates/flutter-project.sh my-flutter-app
```

### Next.js Project
```bash
~/.config/nvim-templates/nextjs-project.sh my-nextjs-app
```

### Python Project
```bash
~/.config/nvim-templates/python-project.sh my-python-project
```

## 🔧 Customization

### Adding Custom Plugins

Edit `~/.config/nvim/lua/plugins/user.lua`:

```lua
return {
  {
    "plugin/name",
    opts = {
      -- plugin options
    },
  },
}
```

### Modifying Keymaps

Edit `~/.config/nvim/lua/plugins/astrocore.lua`:

```lua
mappings = {
  n = {
    ["<leader>xx"] = { "<cmd>YourCommand<cr>", desc = "Your description" },
  },
}
```

### Changing Color Scheme

The configuration includes Catppuccin by default. To change:

```lua
-- In ~/.config/nvim/lua/plugins/user.lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
```

## 🏃 Quick Start Commands

### Open a Flutter project:
```bash
cd ~/your-flutter-project
nvim .
```

### Open a React/Next.js project:
```bash
cd ~/your-react-project
nvim .
```

### Open a Python project with virtual environment:
```bash
cd ~/your-python-project
source venv/bin/activate
nvim .
```

## 🆘 Troubleshooting

### Plugins not loading
```vim
:Lazy sync
```

### LSP not working
```vim
:LspInfo
:Mason
```

### Treesitter errors
```vim
:TSUpdate
```

### Check health
```vim
:checkhealth
```

## 🔙 Restore Old Configuration

If you need to restore your old configuration:

```bash
# Find your backup timestamp
ls -la ~/.config/ | grep nvim-backup

# Restore the backup
rm -rf ~/.config/nvim
mv ~/.config/nvim-backup-TIMESTAMP ~/.config/nvim
mv ~/.local/share/nvim-backup-TIMESTAMP ~/.local/share/nvim
mv ~/.local/state/nvim-backup-TIMESTAMP ~/.local/state/nvim
mv ~/.cache/nvim-backup-TIMESTAMP ~/.cache/nvim
```

## 📚 Resources

- [AstroNvim Documentation](https://docs.astronvim.com/)
- [AstroNvim GitHub](https://github.com/AstroNvim/AstroNvim)
- [AstroCommunity](https://github.com/AstroNvim/astrocommunity)
- [Neovim Documentation](https://neovim.io/doc/)

## 🎉 Enjoy Your New IDE!

AstroNvim provides a powerful, modern IDE experience with:
- ⚡ Fast startup and performance
- 🎨 Beautiful UI with icons and colors
- 🔧 Extensive customization options
- 📦 Lazy-loaded plugins for efficiency
- 🚀 Modern development workflow

Happy coding with AstroNvim! 🚀