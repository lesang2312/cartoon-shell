# 🎨 Cartoon Shell - QuickShell Panel for Hyprland

<div align="center">

[Cartoon Shell Screenshot](https://github.com/user-attachments/assets/5d26eb04-14fa-42c2-a8a8-3d8ddafc04c7)

*A modern, feature-rich Wayland panel built with QuickShell for Hyprland*

[![Hyprland](https://img.shields.io/badge/Hyprland-Compatible-blue)](https://hyprland.org/)
[![QuickShell](https://img.shields.io/badge/QuickShell-Wayland-green)](https://github.com/outfoxxed/quickshell)

</div>

---


## 🎯 Introduction

**Cartoon Shell** is a modern Wayland panel built entirely with **QuickShell** (QML) specifically for **Hyprland window manager**. The panel provides a smooth user experience with highly customizable interface, multi-language support, and multi-resolution display compatibility.

### ✨ Highlights

- 🎨 **2 Themes**: Dark (Catppuccin Mocha) and Light (Catppuccin Latte)
- 🌍 **30 Languages**: Full multi-language support across the globe
- 📐 **10 Size Profiles**: Support from HD (1280px) to 4K (3840px)
- 🎥 **Video Wallpaper**: Support both image and video wallpapers (mp4, mkv, webm, gif)
- ⚡ **Real-time Updates**: Workspace tracking, Music player, Weather, System stats
- 🔧 **Settings Panel**: Complete configuration interface without file editing
- 🎵 **Media Control**: Integrated playerctl for Spotify/MPD
- 🌦️ **Weather Widget**: Real-time weather API
- 💻 **System Monitor**: CPU, RAM, Network, Battery tracking

---

## 💻 System Requirements

### Operating System
- **Linux** (developed on Arch Linux)
- **Wayland** compositor (X11 not supported)
- **Hyprland** window manager (required)

### Main Dependencies

#### QuickShell & Qt
```bash
# QuickShell framework
quickshell

# Qt modules (usually bundled with QuickShell)
qt6-base
qt6-declarative
qt6-wayland
```

#### System utilities
```bash
# Hyprland (Required)
hyprland              # Wayland compositor
hyprctl               # Hyprland control (bundled with hyprland)

# Wallpaper (Required)
hyprpaper             # Image wallpaper (bundled with hyprland)
mpvpaper              # Video wallpaper support
ffmpeg                # Video thumbnail generation

# Media player (Required)
playerctl             # MPRIS media control
cava                  # Audio visualizer for Music Panel

# Network (Required)
networkmanager        # WiFi/Network management
bluez                 # Bluetooth
bluez-utils           # Bluetooth utilities

# System monitoring (Usually pre-installed)
procps-ng             # top, free commands
iproute2              # ip command

# Audio (Usually pre-installed)
pipewire              # Audio server
wireplumber           # PipeWire session manager

# Other (Required)
curl                  # API calls (weather)
jq                    # JSON processing
python3               # Python scripts
```

#### Font
```bash
# Nerd Font (required for icons)
ttf-comicshannsmono-nerd  # or similar name in your distro
```

### Weather API
- **weatherapi.com** API key (free: 1M calls/month)
- Sign up at: https://www.weatherapi.com/signup.aspx

---

## 🔧 Installation

### 1. Install dependencies (Arch Linux)

#### Full setup with dotfiles
```bash
cd ~
git clone https://github.com/mailong2401/dotfiles-hyprland
cd dotfiles-hyprland
chmod +x setup.sh
./setup.sh
```

#### Or manual installation
```bash
# Install main packages (Arch Linux)
sudo pacman -S hyprland hyprpaper playerctl networkmanager \
               bluez bluez-utils pipewire wireplumber curl python \
               jq ffmpeg

# Install AUR packages
yay -S quickshell-git cava mpvpaper ttf-comicshannsmono-nerd
```

### 2. Clone Cartoon Shell
```bash
# Clone to QuickShell config directory
git clone git@github.com:mailong2401/cartoon-shell.git \
    ~/.config/quickshell/cartoon-shell

cd ~/.config/quickshell/cartoon-shell
```

### 3. Configure Weather API (Optional)
```bash
# Edit config file
nano config/configs/default.json

# Change:
{
  "weatherApiKey": "YOUR_API_KEY_HERE",
  "weatherLocation": "Your City,Country"
}
```

### 4. Run QuickShell
```bash
# Run directly
quickshell --path ~/.config/quickshell/cartoon-shell

# Or add to Hyprland config
echo "quickshell --path ~/.config/quickshell/cartoon-shell" \
    >> ~/.config/hypr/hyprland.conf
```


### Available Languages (30)

---


### Wallpaper Management

The wallpaper settings support both **images** and **videos**:

#### Supported Formats
- **Images**: `.jpg`, `.jpeg`, `.png`, `.bmp`, `.webp`, `.gif`
- **Videos**: `.mp4`, `.webm`, `.mkv`, `.avi`, `.mov`, `.flv`, `.wmv`, `.m4v`, `.mpg`, `.mpeg`

#### Wallpaper Tools
- **hyprpaper**: Used for image wallpapers (via hyprctl commands)
- **mpvpaper**: Used for video wallpapers with hardware acceleration
- **ffmpeg**: Generates thumbnails from video files automatically


---


### Font icons not displaying
```bash
# Install Nerd Font
yay -S ttf-comicshannsmono-nerd

# Rebuild font cache
fc-cache -fv

# Check font
fc-list | grep -i comic
```

## Star History

<a href="https://www.star-history.com/#mailong2401/cartoon-shell&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=mailong2401/cartoon-shell&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=mailong2401/cartoon-shell&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=mailong2401/cartoon-shell&type=date&legend=top-left" />
 </picture>
</a>
