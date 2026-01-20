# Installing Elementary Code on Linux Mint

This guide will help you compile and install Elementary Code (io.elementary.code) on Linux Mint 21.x and 22.x.

## Quick Installation (Recommended)

For a one-command installation on Linux Mint, run:

```bash
./scripts/quick-install-mint.sh
```

This script will automatically:
1. Install all required dependencies
2. Build the application
3. Install it to your system
4. Set up desktop integration

## System Requirements

- **Linux Mint 21.x** (based on Ubuntu 22.04) or **Linux Mint 22.x** (based on Ubuntu 24.04)
- At least 2GB of free disk space for building
- Internet connection for downloading dependencies

## Manual Installation

If you prefer to install step-by-step or the quick installer doesn't work for you:

### Step 1: Install Dependencies

Run the dependency installation script:

```bash
./scripts/install-dependencies-mint.sh
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
    libgranite-dev \
    libhandy-1-dev \
    libpeas-2-dev \
    libsoup-3.0-dev \
    libvala-0.56-dev \
    libvte-2.91-dev \
    git
```

> [!NOTE]
> The exact package names may vary slightly between Linux Mint versions. The script handles these differences automatically.

### Step 2: Build the Application

```bash
./scripts/build.sh
```

Or build manually:

```bash
meson setup build --prefix=/usr
cd build
ninja
```

### Step 3: Install

```bash
./scripts/install.sh
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

### Missing Dependencies

If you get errors about missing packages, check [DEPENDENCIES.md](DEPENDENCIES.md) for the complete list and alternative package names.

### Granite Version Issues

Linux Mint may have an older version of libgranite. If you encounter version errors:

```bash
# Add Elementary PPA for newer Granite
sudo add-apt-repository ppa:elementary-os/stable
sudo apt update
sudo apt install libgranite-dev
```

### libpeas-2 Not Found

On older Linux Mint versions, `libpeas-2-dev` might not be available. Try:

```bash
sudo apt install libpeas-dev
```

Then modify `meson.build` to use `libpeas-1.0` instead of `libpeas-2`.

### Build Fails with Vala Errors

Ensure you have a compatible Vala version (0.48 or higher):

```bash
valac --version
```

If your version is too old, you may need to add a PPA:

```bash
sudo add-apt-repository ppa:vala-team/next
sudo apt update
sudo apt install valac
```

### Permission Denied During Installation

Make sure you're using `sudo` for the installation step:

```bash
sudo ./scripts/install.sh
```

### Application Doesn't Appear in Menu

Update the desktop database:

```bash
sudo update-desktop-database
sudo gtk-update-icon-cache /usr/share/icons/hicolor
```

## Uninstalling

To remove Elementary Code from your system:

```bash
./scripts/uninstall.sh
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
   ./scripts/build.sh
   ./scripts/install.sh
   ```

## Getting Help

- **Build Issues**: Check [FAQ.md](FAQ.md) for common problems
- **Bug Reports**: Open an issue on GitHub with your Linux Mint version and error messages
- **Dependencies**: See [DEPENDENCIES.md](DEPENDENCIES.md) for detailed dependency information

## Differences from Elementary OS Version

This build is designed to work on standard Linux distributions. Some Elementary OS-specific integrations may not be available:

- Contractor integration (Elementary's sharing system)
- Some Elementary-specific styling
- Elementary OS system settings integration

The core editing functionality remains fully intact.
