# Installing Elementary Code on Linux

This guide covers installation of Elementary Code (io.elementary.code) on various Linux distributions.

## Distribution-Specific Quick Guides

- **[Linux Mint (Ubuntu-based)](distros/linux-mint/INSTALL.md)** - For Linux Mint 21.x and 22.x
- **[LMDE 7 (Debian-based)](distros/lmde7/INSTALL.md)** - For Linux Mint Debian Edition 7
- **Ubuntu/Debian** - See below
- **Fedora/RHEL** - See below
- **Arch Linux** - See below

## Ubuntu / Debian-based Distributions

### Ubuntu 22.04 / 24.04 / Debian 12+

#### Install Dependencies

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
> For Ubuntu 22.04 or Debian 12, you may need to use `libpeas-dev` instead of `libpeas-2-dev`.

#### Build and Install

```bash
meson setup build --prefix=/usr
cd build
ninja
sudo ninja install
```

#### Run

```bash
io.elementary.code
```

## Fedora / RHEL-based Distributions

### Fedora 38+

#### Install Dependencies

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
    git
```

> [!WARNING]
> Granite and libhandy may not be available in default Fedora repositories. You may need to build them from source or use Flatpak instead.

#### Build and Install

```bash
meson setup build --prefix=/usr
cd build
ninja
sudo ninja install
```

## Arch Linux / Manjaro

### Using AUR (Recommended)

If available in AUR, install using your preferred AUR helper:

```bash
yay -S elementary-code
# or
paru -S elementary-code
```

### Manual Build

#### Install Dependencies

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
    git
```

#### Build and Install

```bash
meson setup build --prefix=/usr
cd build
ninja
sudo ninja install
```

## openSUSE

### Tumbleweed

#### Install Dependencies

```bash
sudo zypper install -y \
    meson \
    vala \
    libeditorconfig-devel \
    gtk3-devel \
    libgee-devel \
    libgit2-glib-devel \
    gtksourceview4-devel \
    gtkspell3-devel \
    granite-devel \
    libhandy-devel \
    libpeas-devel \
    libsoup-devel \
    vte-devel \
    git
```

> [!NOTE]
> Package availability may vary. Check openSUSE Build Service for granite and libhandy.

## Universal Installation Methods

### Flatpak (All Distributions)

If available, Flatpak provides the easiest installation:

```bash
flatpak install flathub io.elementary.code
```

### AppImage (All Distributions)

Download the AppImage from the releases page:

```bash
# Download the latest AppImage
wget https://github.com/YOUR_USERNAME/code-8.1.2-lm/releases/latest/download/elementary-code-x86_64.AppImage

# Make it executable
chmod +x elementary-code-x86_64.AppImage

# Run it
./elementary-code-x86_64.AppImage
```

## Dependency Reference

See [DEPENDENCIES.md](DEPENDENCIES.md) for a complete list of dependencies and their purposes.

## Common Issues

### Missing Granite or libhandy

These are Elementary OS-specific libraries that may not be in your distribution's repositories:

**Option 1**: Add Elementary PPA (Ubuntu/Debian):
```bash
sudo add-apt-repository ppa:elementary-os/stable
sudo apt update
sudo apt install libgranite-dev libhandy-1-dev
```

**Option 2**: Build from source:
- [Granite](https://github.com/elementary/granite)
- [libhandy](https://gitlab.gnome.org/GNOME/libhandy)

**Option 3**: Use Flatpak instead

### libpeas Version Mismatch

The project requires libpeas-2, but some distributions only have libpeas-1:

1. Try installing `libpeas-dev` or `libpeas-devel`
2. If that doesn't work, you may need to modify `meson.build` to use `libpeas-1.0`

### Vala Version Too Old

Minimum required: Vala 0.48

Check your version:
```bash
valac --version
```

If too old, check if your distribution has a newer package or consider using Flatpak.

## Uninstalling

From the build directory:

```bash
cd build
sudo ninja uninstall
```

## Building Packages

See the `packaging/` directory for scripts to build distribution-specific packages:

- **DEB packages**: `packaging/build-deb.sh`
- **AppImage**: `packaging/build-appimage.sh`
- **Flatpak**: `packaging/flatpak/`

## Getting Help

- **General Issues**: Check [FAQ.md](FAQ.md)
- **Build Problems**: Open an issue with your distribution name and version
- **Dependencies**: See [DEPENDENCIES.md](DEPENDENCIES.md)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for information on reporting issues and contributing improvements.
