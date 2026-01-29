pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.commons
import qs.services

Singleton {
  id: root

  readonly property string themesDirectory: Quickshell.shellDir + "/assets/themes"
  readonly property string stateFilePath: Directories.shellConfigColoursPath
  readonly property string matugenFilePath: Directories.assetsPath + "/themes/matugen.json"

  property list<string> themeFiles: []
  property bool loading: false
  property alias palette: adapter

  // For compatibility - thêm property theme
  property var theme: getThemeFromPalette()
  
  readonly property bool isInitialized: true
  property Timer reloadTimer: Timer {
    interval: 200
    repeat: false
    onTriggered: {
      root.refresh()
    }
  }

  signal themeReloaded()

  readonly property list<string> validMatugenSchemes: ["scheme-content", "scheme-expressive", "scheme-fidelity", "scheme-fruit-salad", "scheme-monochrome", "scheme-neutral", "scheme-rainbow", "scheme-tonal-spot", "scheme-vibrant"]

  readonly property var matugenMap: ({
      primary: "mPrimary",
      on_primary: "mOnPrimary",
      primary_container: "mPrimaryContainer",
      on_primary_container: "mOnPrimaryContainer",
      secondary: "mSecondary",
      on_secondary: "mOnSecondary",
      tertiary: "mTertiary",
      on_tertiary: "mOnTertiary",
      background: "mBackground",
      on_background: "mOnBackground",
      surface: "mSurface",
      on_surface: "mOnSurface",
      surface_variant: "mSurfaceVariant",
      on_surface_variant: "mOnSurfaceVariant",
      surface_container: "mSurfaceContainer",
      surface_container_low: "mSurfaceContainerLow",
      surface_container_high: "mSurfaceContainerHigh",
      surface_container_highest: "mSurfaceContainerHighest",
      surface_tint: "mSurfaceTint",
      outline: "mOutline",
      shadow: "mShadow",
      error: "mError",
      on_error: "mOnError",
      error_container: "mErrorContainer",
      on_error_container: "mOnErrorContainer"
    })

  // Thêm các functions cho compatibility
  function init() {
    console.log("ThemeService initialized")
    root.loading = true;
    findProcess.running = true;
  }

  // Đổi tên hàm này để tránh trùng
  function loadThemeFile() {
    // Alias cho compatibility
    root.refresh()
  }

  function changeTheme(newTheme) {
    if (newTheme !== Settings.appearance.theme) {
      Settings.appearance.theme = newTheme
      // If theme is matugen, set dynamic to true
      Settings.appearance.dynamic = (newTheme === "matugen")
    }
    return getThemeFromPalette()
  }

  function getFallbackTheme() {
    return {
      "type": "dark",
      "primary": { 
        "background": "#13140d", 
        "foreground": "#e5e3d6",
        "dim_background": "#101410",
        "dim_foreground": "#b1cead",
        "bright_foreground": "#92d792"
      },
      "button": {
        "background": "#41493f",
        "text": "#92d792",
        "background_select": "#8a9387",
        "border": "#c0c9bc",
        "border_select": "#c0c9bc"
      },
      "cursor": {
        "cursor": "#cad3f5",
        "text": "#24273a"
      },
      "normal": {
        "black": "#494d64",
        "red": "#ed8796",
        "green": "#a6da95",
        "yellow": "#eed49f",
        "blue": "#8aadf4",
        "magenta": "#f5bde6",
        "cyan": "#8bd5ca",
        "white": "#b8c0e0"
      },
      "bright": {
        "black": "#5b6078",
        "red": "#ed8796",
        "green": "#a6da95",
        "yellow": "#eed49f",
        "blue": "#8aadf4",
        "magenta": "#f5bde6",
        "cyan": "#8bd5ca",
        "white": "#a5adcb"
      }
    }
  }

  // Hàm chuyển đổi từ theme file sang palette format
  function convertThemeToPalette(themeData) {
    console.log("Converting theme to palette format...")
    
    var paletteData = {}
    
    // Map từ theme structure sang palette structure
    // Primary colors
    if (themeData.primary) {
      paletteData.mBackground = themeData.primary.background || "#24273a"
      paletteData.mOnBackground = themeData.primary.foreground || "#cad3f5"
      paletteData.mSurface = themeData.primary.background || "#24273a"
      paletteData.mOnSurface = themeData.primary.foreground || "#cad3f5"
      paletteData.mSurfaceVariant = themeData.primary.dim_background || "#1e2030"
      paletteData.mOnSurfaceVariant = themeData.primary.dim_foreground || "#8087a2"
      paletteData.mSurfaceTint = themeData.primary.bright_foreground || "#cad3f5"
    }
    
    // Button colors
    if (themeData.button) {
      paletteData.mOutline = themeData.button.border || "#b8c0e0"
      paletteData.mSurfaceContainer = themeData.button.background || "#494d64"
      paletteData.mSurfaceContainerLow = themeData.button.background || "#494d64"
      paletteData.mSurfaceContainerHigh = themeData.button.background_select || "#5b6078"
      paletteData.mSurfaceContainerHighest = themeData.button.background_select || "#5b6078"
    }
    
    // Normal colors
    if (themeData.normal) {
      paletteData.mPrimary = themeData.normal.blue || "#8aadf4"
      paletteData.mError = themeData.normal.red || "#ed8796"
      paletteData.mTertiary = themeData.normal.cyan || "#8bd5ca"
    }
    
    // Các màu mặc định khác
    paletteData.mOnPrimary = "#2e3300"
    paletteData.mPrimaryContainer = "#444b05"
    paletteData.mOnPrimaryContainer = "#e0e994"
    paletteData.mSecondary = "#c7c9a7"
    paletteData.mOnSecondary = "#2f321a"
    paletteData.mOnTertiary = "#06372d"
    paletteData.mShadow = "#000000"
    paletteData.mOnError = "#690005"
    paletteData.mErrorContainer = "#93000a"
    paletteData.mOnErrorContainer = "#ffdad6"
    
    console.log("Palette conversion completed")
    return paletteData
  }

  function getThemeFromPalette() {
    // Convert palette colors to theme format for compatibility
    var currentMode = Settings.appearance.mode || "dark"
    
    return {
      "type": currentMode,
      "primary": {
        "background": adapter.mBackground ? adapter.mBackground.toString() : "#13140d",
        "foreground": adapter.mOnBackground ? adapter.mOnBackground.toString() : "#e5e3d6",
        "dim_background": adapter.mSurfaceContainerLow ? adapter.mSurfaceContainerLow.toString() : "#101410",
        "dim_foreground": adapter.mOnSurfaceVariant ? adapter.mOnSurfaceVariant.toString() : "#b1cead",
        "bright_foreground": adapter.mPrimary ? adapter.mPrimary.toString() : "#92d792"
      },
      "button": {
        "background": adapter.mSurfaceVariant ? adapter.mSurfaceVariant.toString() : "#41493f",
        "text": adapter.mPrimary ? adapter.mPrimary.toString() : "#92d792",
        "background_select": adapter.mOutline ? adapter.mOutline.toString() : "#8a9387",
        "border": adapter.mOnSurfaceVariant ? adapter.mOnSurfaceVariant.toString() : "#c0c9bc",
        "border_select": adapter.mOnSurfaceVariant ? adapter.mOnSurfaceVariant.toString() : "#c0c9bc"
      },
      "cursor": {
        "cursor": "#cad3f5",
        "text": "#24273a"
      },
      "normal": {
        "black": "#494d64",
        "red": adapter.mError ? adapter.mError.toString() : "#ed8796",
        "green": adapter.mPrimary ? adapter.mPrimary.toString() : "#a6da95",
        "yellow": adapter.mTertiary ? adapter.mTertiary.toString() : "#eed49f",
        "blue": "#8aadf4",
        "magenta": "#f5bde6",
        "cyan": adapter.mTertiary ? adapter.mTertiary.toString() : "#8bd5ca",
        "white": adapter.mOnSurface ? adapter.mOnSurface.toString() : "#b8c0e0"
      },
      "bright": {
        "black": "#5b6078",
        "red": adapter.mError ? adapter.mError.toString() : "#ed8796",
        "green": adapter.mPrimary ? adapter.mPrimary.toString() : "#a6da95",
        "yellow": adapter.mTertiary ? adapter.mTertiary.toString() : "#eed49f",
        "blue": "#8aadf4",
        "magenta": "#f5bde6",
        "cyan": adapter.mTertiary ? adapter.mTertiary.toString() : "#8bd5ca",
        "white": adapter.mOnSurface ? adapter.mOnSurface.toString() : "#a5adcb"
      }
    }
  }

  function refresh() {
    root.loading = true;
    
    console.log("Refreshing theme. Current theme:", Settings.appearance.theme, "dynamic:", Settings.appearance.dynamic)
    
    // Check if theme is matugen or dynamic
    if (Settings.appearance.theme === "matugen" || Settings.appearance.dynamic) {
      console.log("Running matugen theme")
      generateFromWallpaper(Settings.appearance.mode, Settings.appearance.matugenType);
    } else {
      // Load static theme
      var themeName = Settings.appearance.theme
      if (themeName) {
        console.log("Loading static theme:", themeName)
        loadThemeByName(themeName);
      } else {
        console.log("No theme name specified")
        root.loading = false;
      }
    }
  }

  // Sửa hàm này để dùng XMLHttpRequest thay vì FileView
  function loadThemeByName(name) {
    if (!name) {
      root.loading = false;
      return;
    }
    
    console.log("Attempting to load theme:", name)
    
    // Sử dụng XMLHttpRequest để load theme file
    var filePath = Qt.resolvedUrl("../assets/themes/" + name + ".json")
    console.log("Loading theme from:", filePath)
    
    var xhr = new XMLHttpRequest()
    xhr.open("GET", filePath, false)
    xhr.send()

    if (xhr.status === 200) {
      try {
        var themeData = JSON.parse(xhr.responseText)
        console.log("Successfully parsed theme:", name)
        
        // Chuyển đổi từ theme format sang palette format
        var paletteData = convertThemeToPalette(themeData)
        console.log("Converted palette data:", Object.keys(paletteData))
        
        // Cập nhật palette
        updateColors(paletteData)
        
      } catch (e) {
        console.error("Failed to parse theme JSON:", e)
        // Fallback to default theme
        console.log("Falling back to default theme")
        loadDefaultTheme()
      }
    } else {
      console.error("Failed to load theme file. Status:", xhr.status, "Path:", filePath)
      // Fallback to default theme
      console.log("Falling back to default theme")
      loadDefaultTheme()
    }
  }

  // Hàm load default theme
  function loadDefaultTheme() {
    // Create default theme palette
    var defaultPalette = {
      "mPrimary": "#c4cd7b",
      "mOnPrimary": "#2e3300",
      "mPrimaryContainer": "#444b05",
      "mOnPrimaryContainer": "#e0e994",
      "mSecondary": "#c7c9a7",
      "mOnSecondary": "#2f321a",
      "mTertiary": "#a2d0c1",
      "mOnTertiary": "#06372d",
      "mBackground": "#13140d",
      "mOnBackground": "#e5e3d6",
      "mSurface": "#13140d",
      "mOnSurface": "#e5e3d6",
      "mSurfaceVariant": "#47483b",
      "mOnSurfaceVariant": "#c8c7b7",
      "mSurfaceTint": "#c4cd7b",
      "mOutline": "#929282",
      "mShadow": "#000000",
      "mError": "#ffb4ab",
      "mOnError": "#690005",
      "mErrorContainer": "#93000a",
      "mOnErrorContainer": "#ffdad6",
      "mSurfaceContainer": "#202018",
      "mSurfaceContainerLow": "#1c1c14",
      "mSurfaceContainerHigh": "#2a2b22",
      "mSurfaceContainerHighest": "#35352d"
    }
    
    updateColors(defaultPalette)
  }

  function updateColors(data) {
    if (!data) {
      root.loading = false;
      return;
    }

    console.log("Updating colors with data:", Object.keys(data))
    
    let changed = false;
    for (const key in data) {
      if (palette.hasOwnProperty(key) && palette[key] !== data[key]) {
        palette[key] = data[key];
        changed = true;
      }
    }
    
    if (changed) {
      stateFileView.writeAdapter();
      // Tạo file matugen.json từ palette hiện tại
      createMatugenJsonFile();
    }

    root.loading = false;
    themeReloaded()
    console.log("Theme reloaded successfully")
  }

  function generateFromWallpaper(mode, type) {
    if (!ProgramCheckerService.matugenAvailable) {
      console.warn("Matugen not available");
      root.loading = false;
      // Fall back to static theme
      var fallbackTheme = Settings.appearance.mode === "light" ? Settings.appearance.light : Settings.appearance.dark
      loadThemeByName(fallbackTheme)
      return;
    }
    
    // Get wallpaper from primary screen
    var wallpaper = ""
    for (let i = 0; i < Quickshell.screens.length; i++) {
      if (Quickshell.screens[i].primary) {
        wallpaper = WallpaperService.getWallpaper(Quickshell.screens[i].name);
        break;
      }
    }
    // If no primary, get from first screen
    if (!wallpaper && Quickshell.screens.length > 0) {
      wallpaper = WallpaperService.getWallpaper(Quickshell.screens[0].name);
    }
    
    if (!wallpaper || wallpaper === "") {
      console.warn("No wallpaper found");
      root.loading = false;
      // Fall back to static theme
      var fallbackTheme = Settings.appearance.mode === "light" ? Settings.appearance.light : Settings.appearance.dark
      loadThemeByName(fallbackTheme)
      return;
    }

    const matugenType = validMatugenSchemes.includes(type) ? type : "scheme-tonal-spot";
    const targetMode = mode === "light" ? "light" : "dark";
    
    console.log("Running matugen with wallpaper:", wallpaper, "mode:", targetMode, "type:", matugenType)
    
    generateProcess.command = ["matugen", "image", wallpaper, "-j", "hex", "-m", targetMode, "-t", matugenType];
    generateProcess.running = true;
  }

  function parseMatugen(json) {
    const result = {};
    const colors = json.colors || {};
    const mode = Settings.appearance.mode === "light" ? "light" : "dark";

    for (const key in matugenMap) {
      const colorVal = colors[key]?.[mode];
      if (colorVal)
        result[matugenMap[key]] = colorVal;
    }
    return result;
  }

  function getDisplayName(path) {
    if (!path)
      return "";
    return path.split("/").pop().replace(/\.json$/i, "").split("-").map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(" ");
  }

  // Tạo file matugen.json từ palette hiện tại
  function createMatugenJsonFile() {
    const themeData = getThemeFromPalette()
    const themeJson = JSON.stringify(themeData, null, 2)
    
    console.log("Creating matugen.json file at:", matugenFilePath)
    
    // Create a temporary file and then move it
    var tempFile = "/tmp/matugen_temp_" + Date.now() + ".json"
    var cmd = `echo '${themeJson.replace(/'/g, "'\"'\"'")}' > "${tempFile}" && mv "${tempFile}" "${matugenFilePath}"`
    
    try {
      var writeProcess = Qt.createQmlObject(`
        import QtQuick
        import Quickshell.Io
        Process {
          id: writeProcess
          command: ["bash", "-c", "${cmd.replace(/"/g, '\\"')}"]
          onExited: function(exitCode) {
            if (exitCode === 0) {
              console.log("matugen.json created successfully")
            } else {
              console.error("Failed to create matugen.json")
            }
            writeProcess.destroy()
          }
        }
      `, root, "CreateMatugenFileProcess")
      
      writeProcess.running = true
    } catch (e) {
      console.error("Error creating matugen.json:", e)
    }
  }

  // Functions cho compatibility với code cũ
  function triggerMatugenOnThemeChange(themeMode) {
    console.log("ThemeService: triggerMatugenOnThemeChange called with mode:", themeMode)
    
    if (Settings.appearance) {
      Settings.appearance.mode = themeMode
      Settings.appearance.theme = "matugen"
      Settings.appearance.dynamic = true
    }
    
    root.refresh()
  }

  function triggerMatugenOnWallpaperChange(currentWallpaper) {
    console.log("ThemeService: triggerMatugenOnWallpaperChange called")
    
    if (!currentWallpaper || currentWallpaper === "") {
      console.log("No wallpaper path provided")
      return
    }
    
    if (Settings.appearance.theme === "matugen" || Settings.appearance.dynamic) {
      root.refresh()
    }
  }

  // Simple connection to Settings changes
  Connections {
    target: Settings
    
    function onReadyChanged() {
      if (Settings.ready) {
        // When settings are ready, refresh theme
        Qt.callLater(function() {
          root.refresh()
        })
      }
    }
  }

  Connections {
    target: Settings.appearance
    
    function onThemeChanged() {
      console.log("Theme changed to:", Settings.appearance.theme)
      Qt.callLater(function() {
        root.refresh()
      })
    }
    
    function onModeChanged() {
      console.log("Mode changed to:", Settings.appearance.mode)
      Qt.callLater(function() {
        root.refresh()
      })
    }
    
    function onDynamicChanged() {
      console.log("Dynamic changed to:", Settings.appearance.dynamic)
      Qt.callLater(function() {
        root.refresh()
      })
    }
    
    function onMatugenTypeChanged() {
      console.log("MatugenType changed to:", Settings.appearance.matugenType)
      if (Settings.appearance.dynamic || Settings.appearance.theme === "matugen") {
        Qt.callLater(function() {
          root.refresh()
        })
      }
    }
  }

  Connections {
    target: WallpaperService
    function onWallpaperChanged() {
      if (Settings.appearance.dynamic || Settings.appearance.theme === "matugen") {
        Qt.callLater(function() {
          root.refresh()
        })
      }
    }
  }

  Process {
    id: findProcess
    command: ["find", root.themesDirectory, "-name", "*.json", "-type", "f"]
    onExited: exitCode => {
      if (exitCode === 0) {
        themeFiles = stdout.text.trim().split("\n").filter(Boolean);
        console.log("Found theme files:", themeFiles.length)
        console.log("First theme file:", themeFiles[0])
      } else {
        console.error("Find Theme Error:", stderr.text);
      }
      // Don't call refresh here - it will be called when settings are ready
      root.loading = false;
    }
    stdout: StdioCollector {}
    stderr: StdioCollector {}
  }

  Process {
    id: generateProcess
    workingDirectory: Quickshell.shellDir
    running: false
    onExited: exitCode => {
      if (exitCode === 0) {
        try {
          var jsonText = stdout.text.trim()
          console.log("Matugen output received, length:", jsonText.length)
          if (jsonText) {
            var jsonData = JSON.parse(jsonText)
            root.updateColors(root.parseMatugen(jsonData))
          } else {
            console.error("Matugen returned empty output")
            root.loading = false
          }
        } catch (e) {
          console.error("Matugen Parse Error:", e)
          root.loading = false
        }
      } else {
        console.error("Matugen Error:", stderr.text)
        root.loading = false
      }
    }
    stdout: StdioCollector {}
    stderr: StdioCollector {}
  }

  FileView {
    id: themeReader
    onLoaded: {
      try {
        var jsonText = text()
        if (jsonText) {
          // Giả sử file theme đã ở định dạng palette
          root.updateColors(JSON.parse(jsonText))
        } else {
          console.error("Theme file is empty")
          root.loading = false
        }
      } catch (e) {
        console.error("Theme Load Error:", e)
        root.loading = false
      }
    }
  }

  FileView {
    id: stateFileView
    path: root.stateFilePath
    watchChanges: true
    onFileChanged: reload()
    onLoadFailed: error => {
      if (error === FileViewError.FileNotFound)
        writeAdapter();
      else
        console.error("State File Error:", error);
    }

    JsonAdapter {
      id: adapter
      property color mPrimary: "#c4cd7b"
      property color mOnPrimary: "#2e3300"
      property color mPrimaryContainer: "#444b05"
      property color mOnPrimaryContainer: "#e0e994"
      property color mSecondary: "#c7c9a7"
      property color mOnSecondary: "#2f321a"
      property color mTertiary: "#a2d0c1"
      property color mOnTertiary: "#06372d"
      property color mBackground: "#13140d"
      property color mOnBackground: "#e5e3d6"
      property color mSurface: "#13140d"
      property color mOnSurface: "#e5e3d6"
      property color mSurfaceVariant: "#47483b"
      property color mOnSurfaceVariant: "#c8c7b7"
      property color mSurfaceTint: "#c4cd7b"
      property color mOutline: "#929282"
      property color mShadow: "#000000"
      property color mError: "#ffb4ab"
      property color mOnError: "#690005"
      property color mErrorContainer: "#93000a"
      property color mOnErrorContainer: "#ffdad6"
      property color mSurfaceContainer: "#202018"
      property color mSurfaceContainerLow: "#1c1c14"
      property color mSurfaceContainerHigh: "#2a2b22"
      property color mSurfaceContainerHighest: "#35352d"
    }
  }

  Component.onCompleted: {
    // Khởi động service
    init()
    
    // Tạo file matugen.json khi khởi động nếu chưa có
    Qt.callLater(function() {
      // Wait for settings to be ready
      if (Settings.ready) {
        createMatugenJsonFile()
      } else {
        // If settings not ready, wait for them
        Settings.settingsLoaded.connect(function() {
          createMatugenJsonFile()
        })
      }
    })
  }
}
