# Installing Elementary Code on LMDE 7

This guide will help you compile and install Elementary Code (io.elementary.code) on **LMDE 7 (Linux Mint Debian Edition)**.

> [!IMPORTANT]
> LMDE 7 is **Debian-based** (not Ubuntu-based). This means:
> - No Ubuntu PPAs available
> - Different package names (e.g., `libpeas-dev` instead of `libpeas-2-dev`)
> - Granite library may require manual installation

## Quick Installation (Recommended)

### Option 1: Install from DEB Package (Easiest)

If you have the pre-built `.deb` package:

```bash
sudo dpkg -i io.elementary.code_8.1.2-lmde7_amd64.deb
sudo apt-get install -f  # Install any missing dependencies
```

This is the easiest method and doesn't require building from source.

### Option 2: Build from Source

For a one-command build and installation on LMDE 7:

```bash
./distros/lmde7/build-english-only.sh
sudo ninja -C build install
```

This script will automatically:
1. Install all required dependencies (using Debian package names)
2. Build the application (English-only, bypassing translation issues)
3. Install it to your system
4. Set up desktop integration

## System Requirements

- **LMDE 7 (Faye)** - Based on Debian 12/13
- At least 2GB of free disk space for building
- Internet connection for downloading dependencies

## Manual Installation

If you prefer to install step-by-step or the quick installer doesn't work for you:

### Step 1: Install Dependencies

Run the dependency installation script:

```bash
./distros/lmde7/install-dependencies.sh
```

Or install manually:

```bash
sudo apt update
sudo apt install -y \
    meson \
    valac \
    libeditorconfig-dev \
    libgail-3-dev \
    libgee-0.8-dev \
    libgit2-glib-1.0-dev \
    libgtksourceview-4-dev \
    libgtkspell3-3-dev \
    libhandy-1-dev \
    libpeas-dev \
    libsoup-3.0-dev \
    libvala-dev \
    libvte-2.91-dev \
    git
```

> [!WARNING]
> **Granite Library Issue**: `libgranite-dev` may not be available in Debian repositories. See the Granite section below for solutions.

### Step 2: Build the Application

```bash
../../scripts/common/build.sh
```

Or build manually:

```bash
meson setup build --prefix=/usr
cd build
ninja
```

### Step 3: Install

```bash
../../scripts/common/install.sh
```

Or install manually:

```bash
cd build
sudo ninja install
```

### Step 4: Run the Application

Launch from your application menu or run from terminal:

```bash
io.elementary.code
```

## Troubleshooting

### APT Update Errors

If you see errors during `apt update` like:

```
Error: The repository 'https://downloads.cursor.com/aptrepo stable InRelease' is not signed.
```

This is caused by broken third-party repositories (Cursor, VSCode, etc.) and is **not related to Elementary Code**. The installation script will detect this and ask if you want to continue.

**Solutions:**
1. **Continue anyway** - The script will proceed with available packages
2. **Fix the repository** - Remove or fix the broken repository:
   ```bash
   # List repository files
   ls /etc/apt/sources.list.d/
   
   # Remove problematic repository (example for Cursor)
   sudo rm /etc/apt/sources.list.d/cursor.list
   
   # Update again
   sudo apt update
   ```

### Granite Library Not Available

Granite is an Elementary OS library that may not be in Debian repositories. You have several options:

#### Option 1: Build Granite from Source (Recommended)

```bash
# Install Granite build dependencies
sudo apt install -y meson valac libgee-0.8-dev libgtk-3-dev

# Clone and build Granite
git clone https://github.com/elementary/granite.git
cd granite
meson setup build --prefix=/usr
cd build
ninja
sudo ninja install
sudo ldconfig
```

#### Option 2: Check Debian Backports

```bash
# Enable Debian backports
sudo apt install debian-backports

# Try to install Granite
sudo apt install -t bookworm-backports libgranite-dev
```

#### Option 3: Modify Build to Skip Granite

This is advanced and may break some features. You would need to modify `meson.build` to make Granite optional.

### libpeas Version

LMDE 7 uses **libpeas-1** (not libpeas-2). The dependency script automatically uses `libpeas-dev` which is correct for Debian.

### Vala Version

Check your Vala version (need 0.48+):

```bash
valac --version
```

If too old, Debian usually has recent versions:

```bash
sudo apt install valac
```

### Missing Dependencies

If you get errors about missing packages:

1. Update package lists: `sudo apt update`
2. Check package availability: `apt-cache search <package-name>`
3. Enable Debian backports if needed
4. Check [DEPENDENCIES.md](../../DEPENDENCIES.md) for alternative package names

### Build Fails with Granite Errors

If the build fails due to missing Granite:

1. Install Granite from source (see above)
2. Make sure `pkg-config --exists granite` returns successfully
3. Re-run the build

## Uninstalling

To remove Elementary Code from your system:

```bash
../../scripts/common/uninstall.sh
```

Or manually:

```bash
cd build
sudo ninja uninstall
```

## Updating

To update to a newer version:

1. Pull the latest changes:
   ```bash
   git pull
   ```

2. Clean the old build:
   ```bash
   rm -rf build
   ```

3. Rebuild and reinstall:
   ```bash
   ./distros/lmde7/quick-install.sh
   ```

## Differences from Ubuntu-based Linux Mint

| Aspect | Linux Mint (Ubuntu) | LMDE 7 (Debian) |
|--------|---------------------|-----------------|
| Base | Ubuntu 22.04/24.04 | Debian 12/13 |
| PPAs | ✓ Supported | ✗ Not supported |
| libpeas | `libpeas-2-dev` | `libpeas-dev` |
| libvala | `libvala-0.56-dev` | `libvala-dev` |
| Granite | From Elementary PPA | Build from source |

## Getting Help

- **Build Issues**: Check [FAQ.md](../../FAQ.md) for common problems
- **Bug Reports**: Open an issue on GitHub with your LMDE version and error messages
- **Dependencies**: See [DEPENDENCIES.md](../../DEPENDENCIES.md) for detailed dependency information
- **Granite Issues**: See the Granite section above

## About LMDE

LMDE (Linux Mint Debian Edition) is a Debian-based version of Linux Mint, unlike the main Linux Mint which is Ubuntu-based. This means it follows Debian's package ecosystem and release cycle.

---

**Enjoy coding on LMDE 7!** 💻
