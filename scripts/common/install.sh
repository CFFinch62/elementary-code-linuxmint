#!/bin/bash
# Install Elementary Code to the system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Elementary Code - Installation Script${NC}"
echo "======================================"
echo ""

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Script is in scripts/common/, so go up two levels to get to project root
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

# Check if build directory exists
if [ ! -d "build" ]; then
    echo -e "${RED}Error: Build directory not found${NC}"
    echo "Please build the project first:"
    echo "  ./scripts/build.sh"
    exit 1
fi

# Check if build was successful
if [ ! -f "build/src/io.elementary.code" ]; then
    echo -e "${RED}Error: Built binary not found${NC}"
    echo "Please build the project first:"
    echo "  ./scripts/build.sh"
    exit 1
fi

cd build

# Check if we need sudo
PREFIX=$(meson introspect --buildoptions | grep -A 3 '"option": "prefix"' | grep '"value"' | cut -d'"' -f4)
echo "Installation prefix: $PREFIX"
echo ""

if [ -w "$PREFIX" ]; then
    SUDO=""
    echo -e "${GREEN}Installing without sudo (you have write access to $PREFIX)${NC}"
else
    SUDO="sudo"
    echo -e "${YELLOW}Installing with sudo (required for $PREFIX)${NC}"
    echo "You may be prompted for your password"
fi

echo ""

# Install
echo -e "${BLUE}Installing Elementary Code...${NC}"
echo ""

if $SUDO ninja install; then
    echo ""
    echo -e "${GREEN}✓ Installation successful!${NC}"
else
    echo ""
    echo -e "${RED}✗ Installation failed${NC}"
    exit 1
fi

# Update desktop database and icon cache
echo ""
echo -e "${BLUE}Updating desktop database and icon cache...${NC}"

if [ "$SUDO" = "sudo" ]; then
    sudo update-desktop-database /usr/share/applications 2>/dev/null || true
    sudo gtk-update-icon-cache /usr/share/icons/hicolor 2>/dev/null || true
else
    update-desktop-database "$PREFIX/share/applications" 2>/dev/null || true
    gtk-update-icon-cache "$PREFIX/share/icons/hicolor" 2>/dev/null || true
fi

echo -e "${GREEN}✓ Database updates complete${NC}"

cd "$PROJECT_ROOT"

echo ""
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo ""
echo "You can now run Elementary Code:"
echo "  - From application menu: Look for 'Code'"
echo "  - From terminal: io.elementary.code"
echo ""
echo "To uninstall:"
echo "  ./scripts/uninstall.sh"
echo ""

# Try to detect the binary location
BINARY_PATH=$(which io.elementary.code 2>/dev/null || echo "")
if [ -n "$BINARY_PATH" ]; then
    echo "Binary installed at: $BINARY_PATH"
else
    echo -e "${YELLOW}Note: Binary not in PATH. You may need to log out and back in.${NC}"
fi
