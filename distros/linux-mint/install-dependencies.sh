#!/bin/bash
# Install dependencies for Elementary Code on Linux Mint
# Supports Linux Mint 21.x and 22.x

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Elementary Code - Linux Mint Dependency Installer${NC}"
echo "=================================================="
echo ""

# Check if running on Linux Mint
if [ ! -f /etc/os-release ]; then
    echo -e "${RED}Error: Cannot detect OS version${NC}"
    exit 1
fi

source /etc/os-release

if [ "$ID" != "linuxmint" ]; then
    echo -e "${YELLOW}Warning: This script is designed for Linux Mint${NC}"
    echo "Detected: $PRETTY_NAME"
    echo "You may want to use install-dependencies-ubuntu.sh or install-dependencies-debian.sh instead"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "Detected: $PRETTY_NAME"
echo ""

# Determine Ubuntu base version
UBUNTU_BASE=""
if [ "$VERSION_ID" = "21" ] || [ "$VERSION_ID" = "21.1" ] || [ "$VERSION_ID" = "21.2" ] || [ "$VERSION_ID" = "21.3" ]; then
    UBUNTU_BASE="22.04"
    LIBPEAS_PKG="libpeas-dev"  # Ubuntu 22.04 has libpeas-1
    VALA_PKG="libvala-0.56-dev"
elif [ "$VERSION_ID" = "22" ] || [ "$VERSION_ID" = "22.1" ] || [ "$VERSION_ID" = "22.2" ] || [ "$VERSION_ID" = "22.3" ]; then
    UBUNTU_BASE="24.04"
    LIBPEAS_PKG="libpeas-2-dev"  # Ubuntu 24.04 has libpeas-2
    VALA_PKG="libvala-0.56-dev"
else
    echo -e "${YELLOW}Warning: Unknown Linux Mint version${NC}"
    echo "Assuming newer version, using libpeas-2"
    LIBPEAS_PKG="libpeas-2-dev"
    VALA_PKG="libvala-0.56-dev"
fi

echo "Based on Ubuntu: $UBUNTU_BASE"
echo "Using libpeas package: $LIBPEAS_PKG"
echo ""

# Update package lists
echo -e "${GREEN}Updating package lists...${NC}"
if ! sudo apt update 2>&1 | tee /tmp/apt-update.log; then
    echo ""
    echo -e "${YELLOW}Warning: apt update encountered some errors${NC}"
    echo "This is usually caused by broken third-party repositories."
    echo "The installation will continue, but some packages may not be up-to-date."
    echo ""
    read -p "Continue anyway? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "Installation cancelled. Please fix your APT repositories and try again."
        exit 1
    fi
fi

# Check if we need Elementary PPA for Granite
echo -e "${GREEN}Checking for Granite library...${NC}"
if ! dpkg -l | grep -q libgranite-dev; then
    echo -e "${YELLOW}Granite not found in default repositories${NC}"
    echo "Adding Elementary OS PPA for Granite..."
    
    if ! grep -q "elementary-os/stable" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
        sudo add-apt-repository -y ppa:elementary-os/stable
        sudo apt update
    else
        echo "Elementary PPA already added"
    fi
fi

# Install dependencies
echo -e "${GREEN}Installing build dependencies...${NC}"
echo ""

PACKAGES=(
    "meson"
    "valac"
    "libeditorconfig-dev"
    "libgail-3-dev"
    "libgee-0.8-dev"
    "libgit2-glib-1.0-dev"
    "libgtksourceview-4-dev"
    "libgtkspell3-3-dev"
    "libgranite-dev"
    "libhandy-1-dev"
    "$LIBPEAS_PKG"
    "libsoup-3.0-dev"
    "$VALA_PKG"
    "libvte-2.91-dev"
    "itstool"
    "git"
)

# Try to install all packages
FAILED_PACKAGES=()
for pkg in "${PACKAGES[@]}"; do
    echo -n "Installing $pkg... "
    if sudo apt install -y "$pkg" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
        FAILED_PACKAGES+=("$pkg")
    fi
done

echo ""

# Check for failures
if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
    echo -e "${RED}Failed to install the following packages:${NC}"
    for pkg in "${FAILED_PACKAGES[@]}"; do
        echo "  - $pkg"
    done
    echo ""
    echo "You may need to:"
    echo "  1. Check your internet connection"
    echo "  2. Enable additional repositories"
    echo "  3. Install these packages manually"
    echo ""
    exit 1
fi

# Verify installations
echo -e "${GREEN}Verifying installations...${NC}"
echo ""

# Check Vala version
VALA_VERSION=$(valac --version | grep -oP '\d+\.\d+' || echo "unknown")
echo "Vala version: $VALA_VERSION"
if [ "$VALA_VERSION" != "unknown" ]; then
    VALA_MAJOR=$(echo $VALA_VERSION | cut -d. -f1)
    VALA_MINOR=$(echo $VALA_VERSION | cut -d. -f2)
    if [ "$VALA_MAJOR" -eq 0 ] && [ "$VALA_MINOR" -lt 48 ]; then
        echo -e "${YELLOW}Warning: Vala version may be too old (need 0.48+)${NC}"
    else
        echo -e "${GREEN}✓ Vala version OK${NC}"
    fi
fi

# Check Meson version
MESON_VERSION=$(meson --version || echo "unknown")
echo "Meson version: $MESON_VERSION"

# Check for key libraries
echo ""
echo "Checking libraries:"
for lib in granite libhandy-1 gtksourceview-4; do
    if pkg-config --exists $lib 2>/dev/null; then
        VERSION=$(pkg-config --modversion $lib)
        echo -e "  $lib: ${GREEN}$VERSION ✓${NC}"
    else
        echo -e "  $lib: ${RED}NOT FOUND ✗${NC}"
    fi
done

echo ""
echo -e "${GREEN}Dependency installation complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Run: ./scripts/build.sh"
echo "  2. Run: ./scripts/install.sh"
echo ""
echo "Or use the quick installer:"
echo "  ./scripts/quick-install-mint.sh"
