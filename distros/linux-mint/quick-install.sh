#!/bin/bash
# Quick installer for Elementary Code on Linux Mint
# This script runs all installation steps in sequence

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo ""
echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║  Elementary Code - Quick Installer        ║${NC}"
echo -e "${BOLD}${GREEN}║  for Linux Mint                           ║${NC}"
echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

# Check if running on Linux Mint
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [ "$ID" != "linuxmint" ]; then
        echo -e "${YELLOW}Warning: This script is optimized for Linux Mint${NC}"
        echo "Detected: $PRETTY_NAME"
        echo ""
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
        echo ""
    fi
fi

# Estimate time
echo -e "${BLUE}This installer will:${NC}"
echo "  1. Install all required dependencies"
echo "  2. Build Elementary Code from source"
echo "  3. Install it to your system"
echo ""
echo "Estimated time: 5-10 minutes (depending on your system)"
echo "You will be prompted for your password (sudo access required)"
echo ""

read -p "Continue? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    exit 0
fi

echo ""

# Step 1: Install dependencies
echo -e "${BOLD}${BLUE}[1/3] Installing Dependencies${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -f "$SCRIPT_DIR/install-dependencies.sh" ]; then
    bash "$SCRIPT_DIR/install-dependencies.sh"
else
    echo -e "${RED}Error: install-dependencies.sh not found${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""
sleep 2

# Step 2: Build
echo -e "${BOLD}${BLUE}[2/3] Building Elementary Code${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -f "$PROJECT_ROOT/scripts/common/build.sh" ]; then
    bash "$PROJECT_ROOT/scripts/common/build.sh"
else
    echo -e "${RED}Error: build.sh not found${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Build complete${NC}"
echo ""
sleep 2

# Step 3: Install
echo -e "${BOLD}${BLUE}[3/3] Installing to System${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -f "$PROJECT_ROOT/scripts/common/install.sh" ]; then
    bash "$PROJECT_ROOT/scripts/common/install.sh"
else
    echo -e "${RED}Error: install.sh not found${NC}"
    exit 1
fi

echo ""

# Final message
echo ""
echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║  Installation Complete! 🎉                 ║${NC}"
echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Elementary Code has been successfully installed!${NC}"
echo ""
echo "Launch it by:"
echo "  • Opening your application menu and searching for 'Code'"
echo "  • Running 'io.elementary.code' from the terminal"
echo ""
echo "Enjoy coding! 💻"
echo ""
