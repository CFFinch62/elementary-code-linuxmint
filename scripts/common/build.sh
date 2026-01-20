#!/bin/bash
# Build Elementary Code
# Works on all Linux distributions after dependencies are installed

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Elementary Code - Build Script${NC}"
echo "==============================="
echo ""

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Script is in scripts/common/, so go up two levels to get to project root
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

# Check if we're in the right directory
if [ ! -f "meson.build" ]; then
    echo -e "${RED}Error: meson.build not found${NC}"
    echo "Please run this script from the project root or scripts directory"
    exit 1
fi

# Check for required tools
echo -e "${BLUE}Checking build tools...${NC}"
for tool in meson ninja valac; do
    if ! command -v $tool &> /dev/null; then
        echo -e "${RED}Error: $tool not found${NC}"
        echo "Please install dependencies first:"
        echo "  ./scripts/install-dependencies-mint.sh"
        exit 1
    fi
done
echo -e "${GREEN}✓ Build tools found${NC}"
echo ""

# Clean old build if requested
if [ "$1" = "--clean" ] || [ "$1" = "-c" ]; then
    if [ -d "build" ]; then
        echo -e "${YELLOW}Cleaning old build directory...${NC}"
        rm -rf build
        echo -e "${GREEN}✓ Clean complete${NC}"
        echo ""
    fi
fi

# Configure build
if [ ! -d "build" ]; then
    echo -e "${BLUE}Configuring build with Meson...${NC}"
    echo ""
    
    # Use /usr/local as default prefix to avoid conflicts with system packages
    PREFIX="${PREFIX:-/usr/local}"
    
    if meson setup build --prefix="$PREFIX"; then
        echo ""
        echo -e "${GREEN}✓ Configuration successful${NC}"
    else
        echo ""
        echo -e "${RED}✗ Configuration failed${NC}"
        echo ""
        echo "Common issues:"
        echo "  - Missing dependencies (run ./scripts/install-dependencies-mint.sh)"
        echo "  - Incompatible library versions"
        echo "  - Check DEPENDENCIES.md for version requirements"
        exit 1
    fi
else
    echo -e "${YELLOW}Build directory exists, using existing configuration${NC}"
    echo "Use --clean flag to reconfigure from scratch"
fi

echo ""

# Build
echo -e "${BLUE}Building Elementary Code...${NC}"
echo ""

cd build

if ninja; then
    echo ""
    echo -e "${GREEN}✓ Build successful!${NC}"
else
    echo ""
    echo -e "${RED}✗ Build failed${NC}"
    echo ""
    echo "Check the error messages above for details"
    exit 1
fi

# Run tests
echo ""
echo -e "${BLUE}Running tests...${NC}"
echo ""

if ninja test; then
    echo ""
    echo -e "${GREEN}✓ All tests passed${NC}"
else
    echo ""
    echo -e "${YELLOW}⚠ Some tests failed${NC}"
    echo "This may not prevent installation, but could indicate issues"
fi

cd "$PROJECT_ROOT"

echo ""
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}Build Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo "  1. Install: ./scripts/install.sh"
echo "  2. Or run from build directory: ./build/src/io.elementary.code"
echo ""
echo "To rebuild:"
echo "  ./scripts/build.sh --clean"
