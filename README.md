# Tmux Workspace Utility

A simple utility to create tmux workspaces from YAML configuration files.

## Installation

1. Download the `tmux-workspace.py` script
2. Make it executable:
   ```
   chmod +x tmux-workspace.py
   ```
3. Optionally, move it to your PATH:
   ```
   sudo mv tmux-workspace.py /usr/local/bin/tmux-workspace
   ```

## Dependencies

- Python 3.6+
- PyYAML (`pip install pyyaml`)
- tmux (installed and in your PATH)

## Usage

```
tmux-workspace.py [options] config.yaml
```

### Options

- `--session-name`, `-s`: Override the session name from the config file
- `--attach`, `-a`: Attach to the session after creating it
- `--debug`, `-d`: Show tmux commands without executing them
- `--session-index`, `-i`: Index of the session to create when config has multiple sessions
- `--all-sessions`, `-A`: Create all sessions defined in the config

### Examples

```bash
# Create a tmux workspace from a configuration file
tmux-workspace.py my-workspace.yaml

# Create and attach to the session
tmux-workspace.py --attach my-workspace.yaml

# Override the session name
tmux-workspace.py --session-name custom-name my-workspace.yaml

# Debug mode - show commands without executing them
tmux-workspace.py --debug my-workspace.yaml

# Multiple sessions support
# Create the first session from a multi-session config
tmux-workspace.py multi-session.yaml

# Create a specific session by index
tmux-workspace.py --session-index 1 multi-session.yaml

# Create all sessions defined in the config
tmux-workspace.py --all-sessions multi-session.yaml
```

## Configuration Format

The configuration file is in YAML format and supports either a single session or multiple sessions.

### Single Session Configuration

```yaml
session: my-session-name # Name of the tmux session
working_directory: ~/projects/app # Default working directory for all windows

focus: # Optional - specifies which window/pane to focus on when attaching
  window: window-name
  pane: 0

windows:
  - name: window-name # Name of the window
    directory: ~/custom/path # Optional - override working directory for this window
    command: echo "Hello" # Optional - command to run when window is created

    panes: # Optional - additional panes in this window
      - command: vim . # Command for the first pane (already exists)

      - split: vertical # Create a new pane with vertical split (or "horizontal")
        size: 30 # Optional - size as percentage
        directory: ~/another/path # Optional - override directory for this pane
        command: npm run dev # Optional - command to run in this pane
```

### Multiple Sessions Configuration

```yaml
sessions:
  - session: session1 # First session configuration
    working_directory: ~/projects/app

    windows:
      - name: window1
        command: echo "Session 1"
      # More windows...

  - session: session2 # Second session configuration
    working_directory: ~/other-project

    windows:
      - name: window1
        command: echo "Session 2"
      # More windows...

  # More sessions...
```

Each session in the list follows the same format as the single session configuration.

### Supported Features

- Define multiple windows with custom names
- Set default working directory for the session
- Override working directory for specific windows or panes
- Specify initial commands for each window and pane
- Create vertical or horizontal splits
- Set custom sizes for splits (as percentage)
- Specify which window/pane should have focus when attaching

## Examples

See the accompanying files for comprehensive examples:

- `example-workspace.yaml` - Single session example
- `multi-session-example.yaml` - Multiple sessions example

## Notes

- If a session with the specified name already exists, the script will exit without making changes
- You can use environment variables and `~` in paths, they will be expanded
- Commands are sent as-is to the terminal, so you can use complex shell commands
