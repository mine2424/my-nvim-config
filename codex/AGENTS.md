# Codex Agents / Layout Helpers

This repository does not define Claude subagents. Instead, it ships **tmux layout helpers** you can use as “agent-style” entry points for daily work.

## Available helpers

- `scripts/dev`
  - Neovim + Tmux dev layout (left: Neovim, right: 2 terminals)
  - Usage: `dev [SESSION_NAME] [PROJECT_DIR]`

- `scripts/agent`
  - 5-pane tmux layout for multi-task / Claude-assisted workflows
  - Usage: `agent [SESSION_NAME] [PROJECT_DIR]`

- `scripts/ocdev`
  - OpenCode + Tmux layout (default/split/full)
  - Usage: `ocdev [SESSION_NAME] [PROJECT_DIR]`

## Related configuration

- `tmux/.tmux.conf` - tmux configuration (Prefix: `Ctrl+A`)
- `wezterm/wezterm.lua` - WezTerm configuration
- `nvim/` - Neovim (LazyVim) configuration

## Notes

- These scripts expect `tmux` to be installed and available in PATH.
- Use `--help` on each script for layout diagrams and options.
