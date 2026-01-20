# Elementary Code for Linux Mint
[![Translation status](https://l10n.elementary.io/widgets/code/-/svg-badge.svg)](https://l10n.elementary.io/projects/code/?utm_source=widget)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](COPYING)

![Screenshot](data/screenshot.png?raw=true)

A fast, lightweight code editor designed for Elementary OS, now easily installable on **Linux Mint**, **LMDE 7**, and other Linux distributions.

## Quick Installation

### Linux Mint (Ubuntu-based 21.x/22.x)

```bash
./distros/linux-mint/quick-install.sh
```

### LMDE 7 (Debian Edition)

**Option 1: Install from DEB package** (easiest):
```bash
# Download the .deb file from releases, then:
sudo dpkg -i io.elementary.code_8.1.2-lmde7_amd64.deb
sudo apt-get install -f
```

**Option 2: Build from source**:
```bash
./distros/lmde7/build-english-only.sh
sudo ninja -C build install
```

These scripts will automatically install dependencies, build, and install Elementary Code on your system.

## Installation Guides

- **[Linux Mint Installation Guide](distros/linux-mint/INSTALL.md)** - For Linux Mint 21.x and 22.x (Ubuntu-based)
- **[LMDE 7 Installation Guide](distros/lmde7/INSTALL.md)** - For Linux Mint Debian Edition 7
- **[General Linux Installation Guide](INSTALL_LINUX.md)** - For Ubuntu, Debian, Fedora, Arch, and other distributions
- **[Dependencies Reference](DEPENDENCIES.md)** - Complete dependency list and cross-distribution package names

## Manual Installation

### Install Dependencies

**Linux Mint (Ubuntu-based):**
```bash
./distros/linux-mint/install-dependencies.sh
```

**LMDE 7 (Debian-based):**
```bash
./distros/lmde7/install-dependencies.sh
```

Or install manually (see [DEPENDENCIES.md](DEPENDENCIES.md) for your distribution).

### Build

```bash
./scripts/common/build.sh
```

Or manually:
```bash
meson setup build --prefix=/usr
cd build
ninja
```

### Install

```bash
./scripts/common/install.sh
```

Or manually:
```bash
cd build
sudo ninja install
```

### Run

```bash
io.elementary.code
```

Or find "Code" in your application menu.

## Features

- **Syntax Highlighting** - Support for 300+ programming languages
- **Git Integration** - Built-in Git support
- **Plugin System** - Extensible with plugins
- **Terminal** - Integrated terminal emulator
- **Multiple Panes** - Split view editing
- **Auto-save** - Never lose your work
- **EditorConfig** - Respect project coding styles
- **Spell Checking** - Built-in spell checker

## Documentation

- **[FAQ](FAQ.md)** - Frequently asked questions and troubleshooting
- **[Contributing](CONTRIBUTING.md)** - How to contribute to this project
- **[License](COPYING)** - GPL-3.0 License

## System Requirements

- Linux Mint 21.x, 22.x (Ubuntu-based) or LMDE 7 (Debian-based)
- 2GB free disk space for building
- GTK 3.6+
- See [DEPENDENCIES.md](DEPENDENCIES.md) for complete requirements

## Uninstalling

```bash
./scripts/common/uninstall.sh
```

## Getting Help

- Check [FAQ.md](FAQ.md) for common issues
- Read the installation guides
- Open an issue on GitHub with your distribution and error details

## About This Project

This project provides build scripts, documentation, and packaging to make Elementary Code easily accessible on Linux Mint and other Linux distributions. The core Elementary Code is developed by [Elementary](https://github.com/elementary/code).

## License

Elementary Code is licensed under the [GNU General Public License v3.0](COPYING).

---

**Enjoy coding!** 💻
