#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_NAME="tmux-workspace"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}Installing tmux-workspace...${NC}"

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo -e "${RED}Error: tmux is not installed. Please install tmux first.${NC}"
    echo "On macOS: brew install tmux"
    echo "On Ubuntu/Debian: sudo apt install tmux"
    echo "On CentOS/RHEL: sudo yum install tmux"
    exit 1
fi

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is not installed. Please install Python 3 first.${NC}"
    exit 1
fi

# Check Python version (require 3.6+)
python_version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
required_version="3.6"
if ! python3 -c "import sys; exit(0 if sys.version_info >= (3, 6) else 1)"; then
    echo -e "${RED}Error: Python 3.6 or higher is required. Found Python $python_version${NC}"
    exit 1
fi

echo -e "${GREEN}✓ tmux found${NC}"
echo -e "${GREEN}✓ Python $python_version found${NC}"

# Create install directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
fi

# Install Python dependencies
echo "Installing Python dependencies..."
if command -v pip3 &> /dev/null; then
    pip3 install --user -r "$SCRIPT_DIR/requirements.txt"
elif command -v pip &> /dev/null; then
    pip install --user -r "$SCRIPT_DIR/requirements.txt"
else
    echo -e "${RED}Error: pip is not installed. Please install pip first.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Python dependencies installed${NC}"

# Copy the script to the install directory
echo "Installing script to $INSTALL_DIR..."
cp "$SCRIPT_DIR/$SCRIPT_NAME" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo -e "${GREEN}✓ Script installed to $INSTALL_DIR/$SCRIPT_NAME${NC}"

# Check if the install directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "${YELLOW}Warning: $INSTALL_DIR is not in your PATH${NC}"
    echo "To add it to your PATH, add this line to your shell configuration file:"
    echo ""
    
    # Detect shell and provide appropriate instructions
    if [[ "$SHELL" == *"zsh"* ]]; then
        echo -e "${BLUE}  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc${NC}"
        echo -e "${BLUE}  source ~/.zshrc${NC}"
    elif [[ "$SHELL" == *"bash"* ]]; then
        echo -e "${BLUE}  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc${NC}"
        echo -e "${BLUE}  source ~/.bashrc${NC}"
    else
        echo -e "${BLUE}  export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
    fi
    echo ""
    echo "Or run the script directly: $INSTALL_DIR/$SCRIPT_NAME"
else
    echo -e "${GREEN}✓ $INSTALL_DIR is already in your PATH${NC}"
fi

# Create examples directory in user's home
EXAMPLES_DIR="$HOME/.config/tmux-workspace/examples"
if [ ! -d "$EXAMPLES_DIR" ]; then
    echo "Creating examples directory..."
    mkdir -p "$EXAMPLES_DIR"
    
    # Copy example files if they exist
    if [ -d "$SCRIPT_DIR/examples" ]; then
        cp "$SCRIPT_DIR/examples"/* "$EXAMPLES_DIR/" 2>/dev/null || true
        echo -e "${GREEN}✓ Example configurations copied to $EXAMPLES_DIR${NC}"
    fi
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Usage:"
echo "  $SCRIPT_NAME <config.yaml>              # Create workspace from config"
echo "  $SCRIPT_NAME <config.yaml> --attach     # Create and attach to workspace"
echo "  $SCRIPT_NAME <config.yaml> --debug      # Show commands without executing"
echo ""
echo "Examples:"
if [ -d "$EXAMPLES_DIR" ] && [ "$(ls -A "$EXAMPLES_DIR" 2>/dev/null)" ]; then
    echo "  Example configurations are available in: $EXAMPLES_DIR"
    echo "  Try: $SCRIPT_NAME $EXAMPLES_DIR/example-workspace.yaml"
else
    echo "  Create a YAML configuration file with your workspace layout"
fi
echo ""
echo "For more information, run: $SCRIPT_NAME --help"
