# Zellij Configuration Guide

This document explains the Zellij setup with Ghostty compatibility.

## Overview

Zellij has been installed and configured with:
- **Ctrl+a** as the prefix key (tmux-style)
- **Standard Zellij keybindings** (not tmux-like)
- **Ghostty key conflict resolution** using Alt+Super combinations
- **Tokyo Night** theme (inherited from Ghostty)
- **Mouse support** enabled

## Ghostty Configuration

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

## Zellij Key Bindings

### Prefix Key
- `Ctrl+a` - Tmux prefix mode (similar to tmux)

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

### Lock Mode (Default recommended)
Lock mode is recommended to avoid key conflicts with the shell and other applications.

**Lock mode keys (Ghostty compatible):**
| Key | Action |
|-----|--------|
| `Alt+Super+z` | Exit Lock mode (to Normal) |
| `Alt+Super+←/→/↑/↓` | Navigate panes/tabs |
| `Alt+Super+f` | Toggle floating panes |
| `Alt+Super+,` | Resize increase |
| `Alt+Super+.` | Resize decrease |
| `Alt+Super+p` | New pane |

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

## Installation

Zellij was installed via Homebrew:
```bash
brew install zellij
```

## Configuration Files

- **Zellij config**: `~/.config/zellij/config.kdl`
- **Zellij layouts**: `~/.config/zellij/layouts/`
- **Ghostty config**: `~/.config/ghostty/config`

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

## Key Conflict Resolution

The following conflicts have been resolved:

### Alt+Arrow Keys
- **Default Zellij**: Alt+arrows navigate panes/tabs
- **macOS**: Alt+arrows move cursor by word
- **Resolution**: Use Alt+Super+arrows in Zellij

### Ctrl+g (Lock toggle)
- **Default Zellij**: Ctrl+g toggles Lock mode
- **Shell/Emacs**: Ctrl+g is used for various purposes
- **Resolution**: Use Alt+Super+z to toggle Lock mode

## Customization

### Change Default Mode

To start in Lock mode by default, add to `~/.config/zellij/config.kdl`:

```kdl
default_mode "locked"
```

### Change Theme

Zellij uses the system theme (default). To customize, add a theme section to the config and set it:

```kdl
themes {
    mytheme {
        fg 192 202 245
        bg 36 40 59
        red 247 118 142
        green 158 206 106
        yellow 224 175 104
        blue 122 162 247
        magenta 187 154 247
        cyan 125 207 255
        orange 255 158 100
        black 26 27 38
        white 192 202 245
    }
}

theme "mytheme"
```

## Neovim Integration

To use Zellij with Neovim, the standard Zellij navigation (`Ctrl+p` + `h/j/k/l`) works well with Neovim's normal mode navigation.

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
Ensure the keybinds in `~/.config/ghostty/config` use the correct escape sequences:
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

## Additional Resources

- [Zellij Documentation](https://zellij.dev/documentation/)
- [Zellij GitHub](https://github.com/zellij-org/zellij)
- [Layout Examples](https://github.com/zellij-org/zellij/tree/main/example/layouts)
- [Ghostty Website](https://ghostty.org/)

## Disabling Auto-Start

If you want to disable Zellij auto-start, comment out or remove the auto-start section in `~/.zshrc.local`:

```bash
# if command -v zellij &> /dev/null && [[ -z "$ZELLIJ" ]]; then
#     zellij attach -c
# fi
```
