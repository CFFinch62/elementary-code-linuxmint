# Distribution-Specific Scripts

This directory contains installation scripts and documentation for specific Linux distributions.

## Available Distributions

### [linux-mint/](linux-mint/)
**Linux Mint 21.x and 22.x (Ubuntu-based)**

- Quick install: `./linux-mint/quick-install.sh`
- Dependencies: `./linux-mint/install-dependencies.sh`
- Documentation: [linux-mint/INSTALL.md](linux-mint/INSTALL.md)

Based on Ubuntu 22.04/24.04, uses Ubuntu PPAs for Elementary libraries.

---

### [lmde7/](lmde7/)
**LMDE 7 - Linux Mint Debian Edition (Debian-based)**

- Quick install: `./lmde7/quick-install.sh`
- Dependencies: `./lmde7/install-dependencies.sh`
- Documentation: [lmde7/INSTALL.md](lmde7/INSTALL.md)

Based on Debian 12/13, uses Debian package names. Granite may require manual installation.

---

## Adding a New Distribution

To add support for a new distribution:

1. Create a new directory: `distros/your-distro/`
2. Add the following files:
   - `install-dependencies.sh` - Install distro-specific dependencies
   - `quick-install.sh` - One-command installer
   - `INSTALL.md` - Installation guide
3. Update the main [README.md](../README.md) to reference your distro
4. Update this README with your distro info

### Template Structure

```bash
distros/your-distro/
├── INSTALL.md              # Installation guide
├── install-dependencies.sh # Dependency installer
└── quick-install.sh        # Quick installer
```

The quick-install script should:
1. Call `install-dependencies.sh`
2. Call `../../scripts/common/build.sh`
3. Call `../../scripts/common/install.sh`

## Common Scripts

All distros share the same build, install, and uninstall scripts located in `scripts/common/`:

- `scripts/common/build.sh` - Build Elementary Code
- `scripts/common/install.sh` - Install to system
- `scripts/common/uninstall.sh` - Remove from system

## Key Differences Between Distros

| Feature | Linux Mint (Ubuntu) | LMDE 7 (Debian) |
|---------|---------------------|-----------------|
| Base | Ubuntu 22.04/24.04 | Debian 12/13 |
| PPAs | ✓ Supported | ✗ Not available |
| libpeas | `libpeas-2-dev` | `libpeas-dev` |
| libvala | `libvala-0.56-dev` | `libvala-dev` |
| Granite | Elementary PPA | Build from source |
