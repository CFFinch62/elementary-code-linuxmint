#!/bin/bash
# Install dependencies for Elementary Code on LMDE 7 (Linux Mint Debian Edition)
# LMDE 7 is based on Debian 12/13 (no Ubuntu base)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Elementary Code - LMDE 7 Dependency Installer${NC}"
echo "=================================================="
echo ""

# Check if running on LMDE
if [ ! -f /etc/os-release ]; then
    echo -e "${RED}Error: Cannot detect OS version${NC}"
    exit 1
fi

source /etc/os-release

# Verify this is LMDE (Linux Mint with Debian base, not Ubuntu)
if [ "$ID" != "linuxmint" ]; then
    echo -e "${YELLOW}Warning: This script is designed for LMDE (Linux Mint Debian Edition)${NC}"
    echo "Detected: $PRETTY_NAME"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if this is really LMDE (Debian-based) and not regular Linux Mint (Ubuntu-based)
if [ -n "$UBUNTU_CODENAME" ]; then
    echo -e "${YELLOW}Warning: Detected Ubuntu-based Linux Mint${NC}"
    echo "This script is for LMDE (Debian Edition)."
    echo "For Ubuntu-based Linux Mint, use: distros/linux-mint/install-dependencies.sh"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "Detected: $PRETTY_NAME"
echo "Debian-based: Yes"
echo ""

# LMDE uses Debian package names (no Ubuntu PPAs)
LIBPEAS_PKG="libpeas-dev"      # Debian uses libpeas-1
VALA_PKG="libvala-dev"         # Debian uses generic libvala-dev

echo "Using Debian package names:"
echo "  libpeas: $LIBPEAS_PKG"
echo "  libvala: $VALA_PKG"
echo ""

# Update package lists
echo -e "${GREEN}Updating package lists...${NC}"
if ! sudo apt update 2>&1 | tee /tmp/apt-update.log; then
    echo ""
    echo -e "${YELLOW}Warning: apt update encountered some errors${NC}"
    echo "This is usually caused by broken third-party repositories (e.g., Cursor, VSCode)."
    echo "The installation will continue, but some packages may not be up-to-date."
    echo ""
    read -p "Continue anyway? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "Installation cancelled. Please fix your APT repositories and try again."
        exit 1
    fi
fi

# Check if Granite is available in Debian repos
echo -e "${GREEN}Checking for Granite library...${NC}"
if ! apt-cache show libgranite-dev &>/dev/null; then
    echo -e "${YELLOW}Warning: libgranite-dev not found in Debian repositories${NC}"
    echo ""
    echo "Granite is an Elementary OS library that may not be available in Debian."
    echo "Options:"
    echo "  1. Try Debian backports (if available)"
    echo "  2. Build Granite from source"
    echo "  3. Skip for now and handle build errors later"
    echo ""
    read -p "Try to continue without Granite for now? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Please install Granite manually, then re-run this script."
        exit 1
    fi
    SKIP_GRANITE=true
else
    echo "Granite found in repositories!"
    SKIP_GRANITE=false
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
    "libhandy-1-dev"
    "$LIBPEAS_PKG"
    "libsoup-3.0-dev"
    "$VALA_PKG"
    "libvte-2.91-dev"
    "libwebkit2gtk-4.1-dev"
    "itstool"
    "git"
)

# Add Granite if not skipping
if [ "$SKIP_GRANITE" = false ]; then
    PACKAGES+=("libgranite-dev")
fi

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
    echo "  2. Enable Debian backports: sudo apt install debian-backports"
    echo "  3. Install these packages manually"
    echo "  4. Build missing libraries from source"
    echo ""
    exit 1
fi

# Handle Granite if skipped
if [ "$SKIP_GRANITE" = true ]; then
    echo -e "${YELLOW}Note: Granite was not installed${NC}"
    echo "You will need to either:"
    echo "  1. Build Granite from source: https://github.com/elementary/granite"
    echo "  2. Modify the build to work without Granite (advanced)"
    echo ""
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
for lib in libhandy-1 gtksourceview-4; do
    if pkg-config --exists $lib 2>/dev/null; then
        VERSION=$(pkg-config --modversion $lib)
        echo -e "  $lib: ${GREEN}$VERSION ✓${NC}"
    else
        echo -e "  $lib: ${RED}NOT FOUND ✗${NC}"
    fi
done

# Check Granite separately
if pkg-config --exists granite 2>/dev/null; then
    VERSION=$(pkg-config --modversion granite)
    echo -e "  granite: ${GREEN}$VERSION ✓${NC}"
else
    echo -e "  granite: ${YELLOW}NOT FOUND (may need manual install)${NC}"
fi

echo ""
echo -e "${GREEN}Dependency installation complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Run: ../../scripts/common/build.sh"
echo "  2. Run: ../../scripts/common/install.sh"
echo ""
echo "Or use the quick installer:"
echo "  ./quick-install.sh"
