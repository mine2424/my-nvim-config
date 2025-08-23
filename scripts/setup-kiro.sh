#!/bin/bash

# Kiro Command Setup Script
# Sets up the /kiro custom command for Claude Code

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Claude settings directory
CLAUDE_SETTINGS_DIR="$HOME/.claude"
CLAUDE_COMMANDS_DIR="$CLAUDE_SETTINGS_DIR/commands"
PROJECT_KIRO_DIR="$(pwd)/claude/commands/kiro"

echo -e "${BLUE}Setting up /kiro command for Claude Code...${NC}"

# Create Claude settings directory if it doesn't exist
if [ ! -d "$CLAUDE_SETTINGS_DIR" ]; then
    echo -e "${YELLOW}Creating Claude settings directory...${NC}"
    mkdir -p "$CLAUDE_SETTINGS_DIR"
fi

# Create commands directory
if [ ! -d "$CLAUDE_COMMANDS_DIR" ]; then
    echo -e "${YELLOW}Creating Claude commands directory...${NC}"
    mkdir -p "$CLAUDE_COMMANDS_DIR"
fi

# Copy kiro command files
echo -e "${GREEN}Installing /kiro command files...${NC}"
if [ -d "$PROJECT_KIRO_DIR" ]; then
    cp -r "$PROJECT_KIRO_DIR" "$CLAUDE_COMMANDS_DIR/"
    echo -e "${GREEN}✓ Kiro command files installed${NC}"
else
    echo -e "${RED}Error: Kiro command files not found in project${NC}"
    exit 1
fi

# Update or create Claude settings.json to include custom commands
SETTINGS_FILE="$CLAUDE_SETTINGS_DIR/settings.json"
if [ -f "$SETTINGS_FILE" ]; then
    echo -e "${YELLOW}Updating existing Claude settings...${NC}"
    # Backup existing settings
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Use Python to update JSON safely
    python3 -c "
import json
import sys

settings_file = '$SETTINGS_FILE'
with open(settings_file, 'r') as f:
    settings = json.load(f)

# Add custom commands section if it doesn't exist
if 'customCommands' not in settings:
    settings['customCommands'] = {}

# Add kiro command
settings['customCommands']['kiro'] = {
    'description': 'Kiro Spec-Driven Development - 構造化された仕様駆動開発',
    'implementation': '$CLAUDE_COMMANDS_DIR/kiro/implementation.md',
    'documentation': '$CLAUDE_COMMANDS_DIR/kiro/kiro.md',
    'templates': '$CLAUDE_COMMANDS_DIR/kiro/templates/'
}

with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)
print('Settings updated successfully')
"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Claude settings updated${NC}"
    else
        echo -e "${RED}Error updating Claude settings${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Creating new Claude settings file...${NC}"
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "customCommands": {
    "kiro": {
      "description": "Kiro Spec-Driven Development - 構造化された仕様駆動開発",
      "implementation": "~/.claude/commands/kiro/implementation.md",
      "documentation": "~/.claude/commands/kiro/kiro.md",
      "templates": "~/.claude/commands/kiro/templates/"
    }
  }
}
EOF
    echo -e "${GREEN}✓ Claude settings created${NC}"
fi

# Create a quick reference guide
echo -e "${BLUE}Creating quick reference guide...${NC}"
cat > "$CLAUDE_COMMANDS_DIR/kiro/quick-reference.md" << 'EOF'
# /kiro Quick Reference

## Basic Usage
```
/kiro [機能名]
```

## Example Commands
- `/kiro ユーザー管理システム`
- `/kiro 商品レビュー機能`
- `/kiro 決済システム API`

## Workflow Control
- **「次に進んで」** - Complete current phase and generate file
- **「修正して」** - Adjust current phase content
- **「やり直して」** - Restart current phase
- **「詳しく説明して」** - Get more details

## Output Files
1. `requirements.md` - Phase 1: Requirements Discovery
2. `design.md` - Phase 2: Design Exploration
3. `tasks.md` - Phase 3: Implementation Planning

## Key Features
- EARS notation for requirements
- Mermaid diagrams for design
- TypeScript interfaces generation
- Security best practices auto-applied
- Quality checkpoints at each phase
EOF

echo -e "${GREEN}✓ Quick reference guide created${NC}"

# Verify installation
echo -e "${BLUE}Verifying installation...${NC}"
if [ -d "$CLAUDE_COMMANDS_DIR/kiro" ] && [ -f "$CLAUDE_COMMANDS_DIR/kiro/implementation.md" ]; then
    echo -e "${GREEN}✓ /kiro command successfully installed!${NC}"
    echo
    echo -e "${BLUE}Installation Summary:${NC}"
    echo -e "  Command files: $CLAUDE_COMMANDS_DIR/kiro/"
    echo -e "  Settings file: $SETTINGS_FILE"
    echo
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  In Claude Code, type: ${GREEN}/kiro [feature name]${NC}"
    echo -e "  Example: ${GREEN}/kiro ユーザー管理システム${NC}"
    echo
    echo -e "${BLUE}The /kiro command is now available in Claude Code!${NC}"
else
    echo -e "${RED}Installation verification failed${NC}"
    exit 1
fi