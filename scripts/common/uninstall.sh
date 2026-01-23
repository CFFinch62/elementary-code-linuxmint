#!/bin/bash
# Uninstall Elementary Code from the system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Elementary Code - Uninstallation Script${NC}"
echo "========================================"
echo ""

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Script is in scripts/common/, so go up two levels to get to project root
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

# Check if build directory exists
if [ ! -d "build" ]; then
    echo -e "${RED}Error: Build directory not found${NC}"
    echo "Cannot uninstall without build directory"
    echo ""
    echo "If you installed from a different location, you'll need to:"
    echo "  1. Rebuild: ./scripts/build.sh"
    echo "  2. Then uninstall: ./scripts/uninstall.sh"
    exit 1
fi

cd build

# Check if we need sudo
PREFIX=$(meson introspect --buildoptions | grep -A 3 '"option": "prefix"' | grep '"value"' | cut -d'"' -f4)
echo "Installation prefix: $PREFIX"
echo ""

if [ -w "$PREFIX" ]; then
    SUDO=""
else
    SUDO="sudo"
    echo "Uninstalling with sudo (required for $PREFIX)"
    echo "You may be prompted for your password"
    echo ""
fi

# Confirm uninstallation
read -p "Are you sure you want to uninstall Elementary Code? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled"
    exit 0
fi

echo ""
echo -e "${BLUE}Uninstalling Elementary Code...${NC}"
echo ""

if $SUDO ninja uninstall; then
    echo ""
    echo -e "${GREEN}✓ Uninstallation successful!${NC}"
else
    echo ""
    echo -e "${RED}✗ Uninstallation failed${NC}"
    echo ""
    echo "You may need to manually remove files from $PREFIX"
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
echo -e "${GREEN}Elementary Code has been uninstalled${NC}"
echo ""
echo "To reinstall:"
echo "  ./scripts/install.sh"
