#!/bin/bash
# Build Elementary Code on LMDE 7 without policy file translations
# This patches the meson.build to skip the problematic policy translation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Elementary Code - LMDE 7 Build Script (English-only)${NC}"
echo "=========================================================="
echo ""
echo -e "${YELLOW}Note: Building without policy file translations due to LMDE 7 packaging differences${NC}"
echo "The application will work perfectly, just without translated policy messages."
echo ""

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

# Backup and patch data/meson.build
echo -e "${BLUE}Patching build files...${NC}"
if [ ! -f "data/meson.build.bak" ]; then
    cp data/meson.build data/meson.build.bak
    
    # Comment out the policy file i18n.merge_file section (lines 78-84)
    sed -i '78,84s/^/#/' data/meson.build
    
    # Also install the policy file directly without translation
    sed -i '84a\\n    # Install policy file without translation (LMDE 7 workaround)\n    install_data(\n        policy_in,\n        install_dir: get_option('\''datadir'\'') / '\''polkit-1'\'' / '\''actions'\'',\n        rename: meson.project_name() + '\''.policy'\''\n    )' data/meson.build
    
    echo "✓ Build files patched"
fi

echo ""

# Clean old build
if [ -d "build" ]; then
    echo -e "${YELLOW}Cleaning old build...${NC}"
    rm -rf build
fi

# Configure build
echo -e "${BLUE}Configuring build with Meson...${NC}"
echo ""

if meson setup build --prefix=/usr/local; then
    echo ""
    echo -e "${GREEN}✓ Configuration successful${NC}"
else
    echo ""
    echo -e "${RED}✗ Configuration failed${NC}"
    
    # Restore original
    if [ -f "data/meson.build.bak" ]; then
        mv data/meson.build.bak data/meson.build
    fi
    
    exit 1
fi

echo ""

# Build
echo -e "${BLUE}Building Elementary Code...${NC}"
echo ""

cd build

if ninja; then
    echo ""
    echo -e "${GREEN}✓ Build successful!${NC}"
    BUILD_SUCCESS=true
else
    echo ""
    echo -e "${RED}✗ Build failed${NC}"
    BUILD_SUCCESS=false
fi

cd "$PROJECT_ROOT"

# Restore original meson.build
echo ""
echo -e "${BLUE}Restoring original build files...${NC}"
if [ -f "data/meson.build.bak" ]; then
    mv data/meson.build.bak data/meson.build
    echo "✓ Build files restored"
fi

if [ "$BUILD_SUCCESS" = false ]; then
    exit 1
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}Build Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo "  1. Install: sudo ninja -C build install"
echo "  2. Or run: ./scripts/common/install.sh"
echo ""
echo -e "${YELLOW}Note: Policy file installed without translations (LMDE 7 workaround)${NC}"
echo "The application will work perfectly for English users."
echo ""
