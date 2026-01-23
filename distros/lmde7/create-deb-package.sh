#!/bin/bash
# Create a .deb package for Elementary Code on LMDE 7
# This creates a package from the already-installed files in /usr/local

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Elementary Code - DEB Package Creator for LMDE 7${NC}"
echo "===================================================="
echo ""

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

# Check if Elementary Code is installed
if [ ! -f "/usr/local/bin/io.elementary.code" ]; then
    echo -e "${RED}Error: Elementary Code not found in /usr/local${NC}"
    echo "Please install it first:"
    echo "  ./distros/lmde7/build-english-only.sh"
    echo "  sudo ninja -C build install"
    exit 1
fi

# Package version
VERSION="8.1.2"
PACKAGE_NAME="io.elementary.code"
PACKAGE_VERSION="${VERSION}-lmde7"
ARCH="amd64"
DEB_NAME="${PACKAGE_NAME}_${PACKAGE_VERSION}_${ARCH}"

echo "Package: $PACKAGE_NAME"
echo "Version: $PACKAGE_VERSION"
echo "Architecture: $ARCH"
echo ""

# Create package directory structure
PACKAGE_DIR="$PROJECT_ROOT/dist/$DEB_NAME"
echo -e "${BLUE}Creating package directory structure...${NC}"

rm -rf "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR/DEBIAN"
mkdir -p "$PACKAGE_DIR/usr/local"

# Copy installed files from /usr/local
echo -e "${BLUE}Copying installed files...${NC}"

# Copy binaries
if [ -f "/usr/local/bin/io.elementary.code" ]; then
    mkdir -p "$PACKAGE_DIR/usr/local/bin"
    cp -a /usr/local/bin/io.elementary.code "$PACKAGE_DIR/usr/local/bin/"
fi

# Copy libraries
if [ -d "/usr/local/lib/x86_64-linux-gnu" ]; then
    mkdir -p "$PACKAGE_DIR/usr/local/lib"
    cp -a /usr/local/lib/x86_64-linux-gnu "$PACKAGE_DIR/usr/local/lib/"
fi

# Copy share directory (icons, applications, etc.)
if [ -d "/usr/local/share/io.elementary.code" ]; then
    mkdir -p "$PACKAGE_DIR/usr/local/share"
    cp -a /usr/local/share/io.elementary.code "$PACKAGE_DIR/usr/local/share/"
fi

# Copy desktop file
if [ -f "/usr/local/share/applications/io.elementary.code.desktop" ]; then
    mkdir -p "$PACKAGE_DIR/usr/local/share/applications"
    cp -a /usr/local/share/applications/io.elementary.code.desktop "$PACKAGE_DIR/usr/local/share/applications/"
fi

# Copy icons
if [ -d "/usr/local/share/icons/hicolor" ]; then
    mkdir -p "$PACKAGE_DIR/usr/local/share/icons"
    cp -a /usr/local/share/icons/hicolor "$PACKAGE_DIR/usr/local/share/icons/"
fi

# Copy metainfo
if [ -d "/usr/local/share/metainfo" ]; then
    mkdir -p "$PACKAGE_DIR/usr/local/share/metainfo"
    cp -a /usr/local/share/metainfo/io.elementary.code.metainfo.xml "$PACKAGE_DIR/usr/local/share/metainfo/" 2>/dev/null || true
fi

# Copy glib schemas
if [ -d "/usr/local/share/glib-2.0/schemas" ]; then
    mkdir -p "$PACKAGE_DIR/usr/local/share/glib-2.0/schemas"
    cp -a /usr/local/share/glib-2.0/schemas/io.elementary.code*.xml "$PACKAGE_DIR/usr/local/share/glib-2.0/schemas/"
fi

# Copy gtksourceview styles
if [ -d "/usr/local/share/gtksourceview-4/styles" ]; then
    mkdir -p "$PACKAGE_DIR/usr/local/share/gtksourceview-4/styles"
    cp -a /usr/local/share/gtksourceview-4/styles/elementary-*.xml "$PACKAGE_DIR/usr/local/share/gtksourceview-4/styles/"
fi

# Copy polkit policy
if [ -f "/usr/local/share/polkit-1/actions/io.elementary.code.policy.in" ]; then
    mkdir -p "$PACKAGE_DIR/usr/local/share/polkit-1/actions"
    cp -a /usr/local/share/polkit-1/actions/io.elementary.code.policy.in "$PACKAGE_DIR/usr/local/share/polkit-1/actions/"
fi

# Copy man page
if [ -f "/usr/local/share/man/man1/io.elementary.code.1" ]; then
    mkdir -p "$PACKAGE_DIR/usr/local/share/man/man1"
    cp -a /usr/local/share/man/man1/io.elementary.code.1 "$PACKAGE_DIR/usr/local/share/man/man1/"
fi

# Copy vapi files
if [ -d "/usr/local/share/vala/vapi" ]; then
    mkdir -p "$PACKAGE_DIR/usr/local/share/vala/vapi"
    cp -a /usr/local/share/vala/vapi/codecore.* "$PACKAGE_DIR/usr/local/share/vala/vapi/" 2>/dev/null || true
fi

# Copy pkgconfig
if [ -d "/usr/local/lib/x86_64-linux-gnu/pkgconfig" ]; then
    mkdir -p "$PACKAGE_DIR/usr/local/lib/x86_64-linux-gnu/pkgconfig"
    cp -a /usr/local/lib/x86_64-linux-gnu/pkgconfig/codecore.pc "$PACKAGE_DIR/usr/local/lib/x86_64-linux-gnu/pkgconfig/" 2>/dev/null || true
fi

echo "✓ Files copied to package directory"

# Create DEBIAN/control file
echo -e "${BLUE}Creating package metadata...${NC}"

cat > "$PACKAGE_DIR/DEBIAN/control" << EOF
Package: $PACKAGE_NAME
Version: $PACKAGE_VERSION
Section: editors
Priority: optional
Architecture: $ARCH
Maintainer: Elementary Code for LMDE <noreply@example.com>
Depends: libgranite6 (>= 6.0.0), libhandy-1-0 (>= 1.0.0), libgtksourceview-4-0 (>= 4.0.0), libpeas-2-0 | libpeas-1.0-0, libgit2-glib-1.0-0, libvte-2.91-0, libgtkspell3-3-0, libsoup-3.0-0
Description: Fast, lightweight code editor for LMDE 7
 Elementary Code is a fast and lightweight code editor designed for
 Elementary OS, now available for LMDE 7 (Linux Mint Debian Edition).
 .
 This package is built specifically for LMDE 7 with English-only
 policy file translations due to Debian packaging differences.
 .
 Features:
  - Syntax highlighting for 300+ languages
  - Git integration
  - Plugin system
  - Integrated terminal
  - Multiple panes and split view
  - Auto-save
  - EditorConfig support
Homepage: https://github.com/elementary/code
EOF

# Create postinst script
cat > "$PACKAGE_DIR/DEBIAN/postinst" << 'EOF'
#!/bin/bash
set -e

# Update desktop database
if [ -x /usr/bin/update-desktop-database ]; then
    update-desktop-database /usr/local/share/applications || true
fi

# Update icon cache
if [ -x /usr/bin/gtk-update-icon-cache ]; then
    gtk-update-icon-cache /usr/local/share/icons/hicolor || true
fi

# Compile glib schemas
if [ -x /usr/lib/x86_64-linux-gnu/glib-2.0/glib-compile-schemas ]; then
    /usr/lib/x86_64-linux-gnu/glib-2.0/glib-compile-schemas /usr/local/share/glib-2.0/schemas || true
fi

exit 0
EOF

chmod 755 "$PACKAGE_DIR/DEBIAN/postinst"

# Create postrm script
cat > "$PACKAGE_DIR/DEBIAN/postrm" << 'EOF'
#!/bin/bash
set -e

if [ "$1" = "remove" ] || [ "$1" = "purge" ]; then
    # Update desktop database
    if [ -x /usr/bin/update-desktop-database ]; then
        update-desktop-database /usr/local/share/applications || true
    fi

    # Update icon cache
    if [ -x /usr/bin/gtk-update-icon-cache ]; then
        gtk-update-icon-cache /usr/local/share/icons/hicolor || true
    fi
fi

exit 0
EOF

chmod 755 "$PACKAGE_DIR/DEBIAN/postrm"

echo "✓ Package metadata created"

# Build the .deb package
echo ""
echo -e "${BLUE}Building .deb package...${NC}"

cd "$PROJECT_ROOT/dist"
dpkg-deb --build --root-owner-group "$DEB_NAME"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Package created successfully!${NC}"
    echo ""
    echo "Package location:"
    echo "  $(pwd)/${DEB_NAME}.deb"
    echo ""
    echo "Package size:"
    du -h "${DEB_NAME}.deb"
    echo ""
    echo "To install on another LMDE 7 system:"
    echo "  sudo dpkg -i ${DEB_NAME}.deb"
    echo "  sudo apt-get install -f  # Install any missing dependencies"
    echo ""
    echo "To distribute:"
    echo "  Upload ${DEB_NAME}.deb to GitHub releases or file sharing"
else
    echo -e "${RED}✗ Package creation failed${NC}"
    exit 1
fi

# Clean up package directory
rm -rf "$PACKAGE_DIR"
