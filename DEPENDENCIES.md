# Dependencies for Elementary Code

This document provides detailed information about all dependencies required to build and run Elementary Code.

## Build Dependencies

These are required to compile the application:

| Dependency | Minimum Version | Purpose | Debian/Ubuntu Package | Fedora Package | Arch Package |
|------------|----------------|---------|----------------------|----------------|--------------|
| **meson** | 0.58.0 | Build system | `meson` | `meson` | `meson` |
| **valac** | 0.48 | Vala compiler | `valac` | `vala` | `vala` |
| **git** | - | Version control | `git` | `git` | `git` |

## Runtime Dependencies

These libraries are required for the application to function:

### Core Libraries

| Dependency | Minimum Version | Purpose | Debian/Ubuntu Package | Fedora Package | Arch Package |
|------------|----------------|---------|----------------------|----------------|--------------|
| **glib** | 2.74.0 | Core library | `libglib2.0-dev` | `glib2-devel` | `glib2` |
| **gio-unix** | 2.20 | I/O library | (included in glib) | (included in glib) | (included in glib) |
| **gtk+3** | 3.6.0 | GUI toolkit | `libgtk-3-dev` | `gtk3-devel` | `gtk3` |
| **gee** | 0.8.5 | Collection library | `libgee-0.8-dev` | `libgee-devel` | `libgee` |

### Elementary/GNOME Libraries

| Dependency | Minimum Version | Purpose | Debian/Ubuntu Package | Fedora Package | Arch Package |
|------------|----------------|---------|----------------------|----------------|--------------|
| **granite** | 6.0.0 | Elementary widgets | `libgranite-dev` | `granite-devel`* | `granite` |
| **libhandy** | 0.90.0 | Adaptive widgets | `libhandy-1-dev` | `libhandy-devel` | `libhandy` |
| **gtksourceview** | 4.x | Source code editing | `libgtksourceview-4-dev` | `gtksourceview4-devel` | `gtksourceview4` |
| **libpeas** | 2.x | Plugin system | `libpeas-2-dev`** | `libpeas-devel` | `libpeas` |

\* May require additional repositories on Fedora  
\*\* Use `libpeas-dev` on older Ubuntu/Debian versions

### Additional Features

| Dependency | Minimum Version | Purpose | Debian/Ubuntu Package | Fedora Package | Arch Package |
|------------|----------------|---------|----------------------|----------------|--------------|
| **libgit2-glib** | 1.2.0 | Git integration | `libgit2-glib-1.0-dev` | `libgit2-glib-devel` | `libgit2-glib` |
| **editorconfig** | - | EditorConfig support | `libeditorconfig-dev` | `editorconfig-devel` | `editorconfig-core-c` |
| **gtkspell3** | - | Spell checking | `libgtkspell3-3-dev` | `gtkspell3-devel` | `gtkspell3` |
| **vte** | 2.91 | Terminal emulation | `libvte-2.91-dev` | `vte291-devel` | `vte3` |
| **libsoup** | 3.0 | HTTP library | `libsoup-3.0-dev` | `libsoup3-devel` | `libsoup3` |
| **webkit2gtk** | 4.1 | Markdown preview | `libwebkit2gtk-4.1-dev` | `webkit2gtk4.1-devel` | `webkit2gtk-4.1` |
| **fontconfig** | - | Font configuration | `libfontconfig-dev` | `fontconfig-devel` | `fontconfig` |
| **pangoft2** | - | Font rendering | `libpango1.0-dev` | `pango-devel` | `pango` |

### Development Libraries

| Dependency | Purpose | Debian/Ubuntu Package | Fedora Package | Arch Package |
|------------|---------|----------------------|----------------|--------------|
| **libvala** | Vala runtime | `libvala-0.56-dev`* | `vala-devel` | (included in vala) |
| **libgail** | Accessibility | `libgail-3-dev` | (included in gtk3) | (included in gtk3) |

\* Version number matches your Vala version (e.g., 0.48, 0.52, 0.56)

## Optional Dependencies

These are not strictly required but enable additional features:

| Dependency | Purpose | Package Name |
|------------|---------|--------------|
| **ctags** | Code navigation | `universal-ctags` or `exuberant-ctags` |
| **pkexec** | Elevated privileges | `policykit-1` (Debian/Ubuntu) or `polkit` (Fedora/Arch) |

## Installation by Distribution

### Linux Mint 21.x / 22.x / Ubuntu 22.04 / 24.04

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
    libwebkit2gtk-4.1-dev \
    git
```

> [!NOTE]
> On Ubuntu 22.04 or older, use `libpeas-dev` instead of `libpeas-2-dev`

### Debian 12 (Bookworm)

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
    libpeas-dev \
    libsoup-3.0-dev \
    libvala-dev \
    libvte-2.91-dev \
    libwebkit2gtk-4.1-dev \
    git
```

### Fedora 38+

```bash
sudo dnf install -y \
    meson \
    vala \
    editorconfig-devel \
    gtk3-devel \
    libgee-devel \
    libgit2-glib-devel \
    gtksourceview4-devel \
    gtkspell3-devel \
    granite-devel \
    libhandy-devel \
    libpeas-devel \
    libsoup3-devel \
    vte291-devel \
    webkit2gtk4.1-devel \
    git
```

> [!WARNING]
> `granite-devel` may not be available in default Fedora repos. You may need to build from source or use COPR.

### Arch Linux / Manjaro

```bash
sudo pacman -S --needed \
    meson \
    vala \
    editorconfig-core-c \
    gtk3 \
    libgee \
    libgit2-glib \
    gtksourceview4 \
    gtkspell3 \
    granite \
    libhandy \
    libpeas \
    libsoup3 \
    vte3 \
    webkit2gtk-4.1 \
    git
```

## Dependency Details

### Why Granite?

Granite is Elementary's extension library for GTK that provides:
- Additional widgets (e.g., Welcome screen, Mode switches)
- Styling utilities
- Common UI patterns

**Availability**: Primarily in Elementary OS and Ubuntu PPAs. May need to build from source on other distributions.

### Why libhandy?

Libhandy provides adaptive widgets that work across different screen sizes:
- Responsive layouts
- Mobile-friendly components
- Adaptive containers

**Availability**: Available in most modern distributions (GNOME 40+).

### libpeas Version Notes

The project uses **libpeas-2** (the newer version), but many distributions still ship **libpeas-1**:

- **Ubuntu 24.04+**: Has libpeas-2
- **Ubuntu 22.04**: Only has libpeas-1 (use `libpeas-dev`)
- **Debian 12+**: Has libpeas-2
- **Fedora 38+**: Has libpeas-2
- **Arch**: Has libpeas-2

If your distribution only has libpeas-1, you may need to modify `meson.build` to use `libpeas-1.0` instead of `libpeas-2`.

### Vala Version Compatibility

The project requires **Vala 0.48 or higher**. The build system automatically detects your installed Vala version and uses the corresponding libvala library.

Common Vala versions:
- **Ubuntu 22.04**: Vala 0.56
- **Ubuntu 24.04**: Vala 0.56
- **Debian 12**: Vala 0.56
- **Fedora 38+**: Vala 0.56
- **Arch**: Latest (usually 0.56+)

## Troubleshooting Dependencies

### Package Not Found

If a package is not found:

1. **Update package lists**: `sudo apt update` (or equivalent)
2. **Check package name**: Package names vary between distributions
3. **Enable additional repositories**: Some packages require PPAs or COPR
4. **Build from source**: Last resort for unavailable packages

### Version Too Old

If your distribution has an older version:

1. **Check for backports**: Some distributions offer newer versions
2. **Add PPAs/COPR**: Third-party repositories may have newer versions
3. **Build from source**: Clone and build the dependency
4. **Use Flatpak**: Flatpak bundles all dependencies

### Conflicting Packages

If you encounter conflicts:

1. **Check for multiple versions**: Remove old versions
2. **Use virtual packages**: Some distributions offer alternatives
3. **Build in container**: Use Docker/Podman for isolated builds

## Verifying Dependencies

After installation, verify all dependencies are present:

```bash
# Check Vala version
valac --version

# Check meson version
meson --version

# Check if libraries are installed (example for Ubuntu/Debian)
pkg-config --modversion granite
pkg-config --modversion libhandy-1
pkg-config --modversion gtksourceview-4
```

## Minimal Build

For a minimal build without optional features, you can skip:
- `libgtkspell3-*-dev` (no spell checking)
- `libvte-*-dev` (no integrated terminal)
- `libgit2-glib-*-dev` (no Git integration)

However, this requires modifying the build configuration.

## Getting Help

If you're having dependency issues:

1. Check [FAQ.md](FAQ.md) for common problems
2. Open an issue with:
   - Your distribution and version (`cat /etc/os-release`)
   - Error messages
   - Output of `pkg-config --list-all | grep <package>`
