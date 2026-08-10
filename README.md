
## 🎯 Introduction

**Cartoon Shell** is a modern Wayland panel built entirely with **QuickShell** (QML) specifically for **Hyprland window manager**. The panel provides a smooth user experience with highly customizable interface, multi-language support, and multi-resolution display compatibility.


## 💻 System Requirements

### Operating System
- **Linux** (developed on Arch Linux)
- **Wayland** compositor (X11 not supported)
- **Hyprland(Lua)** window manager (required)

## 🔧 Installation

### Install dependencies (Arch Linux)

#### Full setup with dotfiles
```bash
cd ~
git clone https://github.com/lesang2312/dotfiles-hyprland
cd dotfiles-hyprland
chmod +x setup.sh
./setup.sh
```

## 🎨 Dashboard App Grid Customization

You can fully customize the applications, display names, and replace the default pixel-art icons inside the App Grid by modifying the configuration file.

### Configuration File Path:
```bash
~/.config/cartoon-shell/settings.json
```

### Grid Layout Preview
Here is how the 3x3 App Grid looks inside the dashboard panel with custom pixel-art icons applied:

<img width="163" height="171" alt="screenshot_2026-08-10_22-08-06" src="https://github.com/user-attachments/assets/0ef85876-1a17-4b86-9d69-2c5d43ae4555" />

### How to Change Application Icons:

* **Step 1**: Prepare your custom icon files (ideally in `.png` format for transparency).
* **Step 2**: Copy your new icons directly into the project's icon directory:
  ```bash
  ~/.config/quickshell/cartoon-shell/icons/
  ```
* **Step 3**: Open your `settings.json` file using any text editor (e.g., VS Code, VSCodium, or Nano).
* **Step 4**: Locate the `"dashboard"` object and look for the `"appGrid"` array.
* **Step 5**: Update the `"name"` and `"icon"` values with your preferred app titles and full image file paths.

#### Configuration Example (`settings.json`):
```json
"dashboard": {
    "appGrid": [
        {
            "name": "Brave",
            "icon": "/home/linux-sieu-cap-pro-cua-le/.config/quickshell/cartoon-shell/icons/animal.png"
        },
        {
            "name": "Cốc Cốc",
            "icon": "/home/linux-sieu-cap-pro-cua-le/.config/quickshell/cartoon-shell/icons/anime.png"
        },
        {
            "name": "Terminal",
            "icon": "kitty"
        }
    ],
    "fullname": "Your fullname",
    "username": "Your username",
}
```
*Note: For built-in system applications, you can just input the native icon theme name (like `"kitty"`) instead of using an absolute file path.*

* **Step 6**: Save the file. **Cartoon Shell** will instantly refresh and apply your new application names and custom graphics.


## 🔔 Customizing Alarm Sounds

You can fully customize your alarm clock notifications by adding any audio file format (.mp3, .wav, .ogg, etc.) directly into the panel's system directory.

### Sound Assets Directory:
```bash
~/.config/quickshell/cartoon-shell/modules/panels/calendar/sounds/
```

### How to Change the Alarm Sound:

* **Step 1**: Prepare your favorite audio file (All popular formats like `.mp3`, `.wav`, or `.ogg` are supported).
* **Step 2**: Copy your audio file directly into the calendar sounds folder:
  ```bash
  ~/.config/quickshell/cartoon-shell/modules/panels/calendar/sounds/
  ```
* **Step 3**: Rename the audio file or update the calendar configuration files to point to your newly added file.
* **Step 4**: Restart the **Cartoon Shell** panel, and your custom audio track will now play whenever the alarm goes off.


