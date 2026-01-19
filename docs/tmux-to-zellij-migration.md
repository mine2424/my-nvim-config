# Tmux to Zellij Migration Guide

This document outlines the migration from tmux to Zellij as your terminal multiplexer.

## Overview

Zellij has been installed and configured with the following features:

- **Standard Zellij keybindings** (not tmux-style)
- **Ctrl+a prefix** (tmux-style for familiarity)
- **Ghostty compatibility** using Alt+Super key combinations
- **Mouse support** enabled
- **Session persistence** similar to tmux-continuum

## Installation

Zellij was installed via Homebrew:
```bash
brew install zellij
```

## Configuration Files

- **Main config**: `~/.config/zellij/config.kdl`
- **Layouts**: `~/.config/zellij/layouts/`
- **Default layout**: `~/.config/zellij/layouts/default.kdl`
- **Ghostty config**: `~/.config/ghostty/config`

## Key Bindings

### Prefix Key
- `Ctrl+a` - Tmux prefix mode (similar to tmux)

### Lock Mode (Default recommended)

Lock mode is recommended to avoid key conflicts with shell and other applications.

**Lock mode keys (Ghostty compatible):**
| Key | Action |
|-----|--------|
| `Alt+Super+z` | Exit Lock mode (to Normal) |
| `Alt+Super+←/→/↑/↓` | Navigate panes/tabs |
| `Alt+Super+f` | Toggle floating panes |
| `Alt+Super+,` | Resize increase |
| `Alt+Super+.` | Resize decrease |
| `Alt+Super+p` | New pane |

### Normal Mode (Standard Zellij)
| Mode Shortcut | Action |
|---------------|--------|
| `Ctrl+p` | Enter Pane mode |
| `Ctrl+n` | Enter Resize mode |
| `Ctrl+t` | Enter Tab mode |
| `Ctrl+s` | Enter Scroll mode |
| `Ctrl+o` | Enter Session mode |
| `Alt+Super+z` | Enter Lock mode |
| `Ctrl+a` | Enter Tmux prefix mode |

### Pane Mode (`Ctrl+p`)
| Key | Action |
|-----|--------|
| `h/←`, `j/↓`, `k/↑`, `l/→` | Navigate panes |
| `n` | New pane |
| `d` | New pane down |
| `r` | New pane right |
| `s` | New pane stacked |
| `x` | Close pane |
| `f` | Toggle fullscreen |
| `w` | Toggle floating panes |
| `z` | Toggle pane frames |

### Resize Mode (`Ctrl+n`)
| Key | Action |
|-----|--------|
| `h/←`, `j/↓`, `k/↑`, `l/→` | Resize increase |
| `H`, `J`, `K`, `L` | Resize decrease |
| `=`, `+` | Resize increase |
| `-` | Resize decrease |

### Tab Mode (`Ctrl+t`)
| Key | Action |
|-----|--------|
| `n` | New tab |
| `1-9` | Go to tab 1-9 |
| `h/←/k/↑` | Previous tab |
| `l/→/j/↓` | Next tab |
| `r` | Rename tab |
| `x` | Close tab |

### Scroll Mode (`Ctrl+s`)
| Key | Action |
|-----|--------|
| `j/↓` | Scroll down |
| `k/↑` | Scroll up |
| `Ctrl+f` | Page down |
| `Ctrl+b` | Page up |
| `d` | Half page down |
| `u` | Half page up |
| `Ctrl+c` | Exit scroll mode |

### Session Mode (`Ctrl+o`)
| Key | Action |
|-----|--------|
| `d` | Detach session |
| `w` | Session manager |
| `c` | Configuration |
| `p` | Plugin manager |

### Tmux Prefix Mode (`Ctrl+a`)
| Key | Action |
|-----|--------|
| `c` | New tab |
| `%` | Split pane right |
| `"` | Split pane down |
| `n` | Next tab |
| `p` | Previous tab |
| `d` | Detach |
| `x` | Close pane |
| `h/j/k/l` or `←/↓/↑/→` | Navigate panes |
| `Ctrl+a` | Send Ctrl+a to terminal |

## Why Lock Mode?

Using Lock mode as the default is recommended because:

1. **Avoids key conflicts**: Many Zellij shortcuts conflict with shell commands, Vim, and other tools
2. **Alt+Super shortcuts**: These are less likely to conflict with other applications
3. **Seamless navigation**: Basic pane/tab navigation still works with Alt+Super+arrows

## Ghostty Compatibility

The Ghostty configuration has been updated to avoid key conflicts with Zellij:

```
# Alt key support
macos-option-as-alt = left

# Zellij key bindings (Cmd+Alt+arrows for pane/tab navigation)
keybind = cmd+alt+left=text:\x1b[1;11D
keybind = cmd+alt+right=text:\x1b[1;11C
keybind = cmd+alt+up=text:\x1b[1;11A
keybind = cmd+alt+down=text:\x1b[1;11B
```

### Key Conflict Resolution

The following conflicts have been resolved:

### Alt+Arrow Keys
- **Default Zellij**: Alt+arrows navigate panes/tabs
- **macOS**: Alt+arrows move cursor by word
- **Resolution**: Use Alt+Super+arrows in Zellij

### Ctrl+g (Lock toggle)
- **Default Zellij**: Ctrl+g toggles Lock mode
- **Shell/Emacs**: Ctrl+g is used for various purposes
- **Resolution**: Use Alt+Super+z to toggle Lock mode

## Auto-Start

Zellij is configured to auto-start when opening a new terminal session (added to `~/.zshrc.local`):

```bash
if command -v zellij &> /dev/null && [[ -z "$ZELLIJ" ]]; then
    zellij attach -c
fi
```

This will:
1. Check if zellij is available
2. Check if not already in a zellij session
3. Attach to existing session or create a new one

## Usage Examples

### Start a new session
```bash
zellij
```

### Attach to an existing session
```bash
zellij attach
```

### List sessions
```bash
zellij list-sessions
```

### Kill a session
```bash
zellij kill-session <session-name>
```

### Run a command in a new pane
```bash
zellij run -- zsh -c "ls -la"
```

### Start in Lock mode
```bash
zellij --layout default
```

## Layouts

Zellij uses a declarative layout system. Create custom layouts in `~/.config/zellij/layouts/`:

```kdl
layout {
    tab name="my-layout" {
        pane split_direction="Horizontal" {
            pane { name="left"; }
            pane split_direction="Vertical" {
                pane { name="top-right"; }
                pane { name="bottom-right"; }
            }
        }
    }
}
```

Use a custom layout:
```bash
zellij --layout my-layout
```

## Neovim Integration

To use Zellij with Neovim, standard Zellij navigation (`Ctrl+p` + `h/j/k/l`) works well with Neovim's normal mode navigation.

For seamless integration, consider using a plugin like `vim-tmux-navigator` which supports Zellij.

## Troubleshooting

### Zellij doesn't start
Check if `$ZELLIJ` environment variable is set:
```bash
echo $ZELLIJ
```

### Keybindings not working
Make sure Ghostty's `macos-option-as-alt = left` is set.

### Ghostty keybindings not working
Ensure that keybinds in `~/.config/ghostty/config` use the correct escape sequences:
```
keybind = cmd+alt+left=text:\x1b[1;11D
keybind = cmd+alt+right=text:\x1b[1;11C
keybind = cmd+alt+up=text:\x1b[1;11A
keybind = cmd+alt+down=text:\x1b[1;11B
```

### Session not saving
Check session serialization in config:
```kdl
session_serialization true
serialize_pane_viewport true
```

## Differences from Tmux

### 1. **Modes vs Direct Actions**
Zellij uses modes for complex actions:
- Press `Ctrl+p` to enter Pane mode for advanced pane operations
- Press `Ctrl+n` to enter Resize mode for resizing panes
- Press `Ctrl+t` to enter Tab mode for tab operations
- Press `Ctrl+s` to enter Scroll mode for scrollback navigation

### 2. **Built-in Plugins**
Zellij includes several built-in plugins:
- **Session Manager**: `Ctrl+o` then `w` - Manage sessions visually
- **Configuration**: `Ctrl+o` then `c` - Edit configuration
- **Plugin Manager**: Access via Session mode

### 3. **Session Persistence**
Zellij automatically serializes sessions similar to tmux-continuum:
- Sessions are saved to cache
- Automatically restore on attach
- Configurable scrollback buffer size

### 4. **Multiplayer Support**
Zellij has built-in multiplayer support for collaborative sessions (web-based).

### 5. **Web Client**
Zellij can provide a web-based terminal interface (disabled by default).

## Migrating from tmux-sessions

Zellij sessions are different from tmux sessions. To migrate:

1. **Export tmux sessions**: Use tmuxinator or manually note your session layouts
2. **Create Zellij layouts**: Convert session structures to Zellij layout files
3. **Adjust shell scripts**: Replace `tmux attach` with `zellij attach`

## Additional Resources

- [Zellij Documentation](https://zellij.dev/documentation/)
- [Zellij GitHub](https://github.com/zellij-org/zellij)
- [Ghostty Website](https://ghostty.org/)
- [Layout Examples](https://github.com/zellij-org/zellij/tree/main/example/layouts)
- [Theme Examples](https://github.com/zellij-org/zellij/tree/main/example/themes)

## Disabling Auto-Start

If you want to disable Zellij auto-start, comment out or remove the auto-start section in `~/.zshrc.local`:

```bash
# if command -v zellij &> /dev/null && [[ -z "$ZELLIJ" ]]; then
#     zellij attach -c
# fi
```

## Next Steps

1. **Test Zellij**: Open a new terminal to verify auto-start works
2. **Explore Keybindings**: Try different keybindings and modes
3. **Create Custom Layouts**: Design layouts for your workflow
4. **Configure Neovim Integration**: Ensure seamless navigation between Neovim and Zellij panes
5. **Migrate tmux Sessions**: Convert important tmux session configurations to Zellij layouts
