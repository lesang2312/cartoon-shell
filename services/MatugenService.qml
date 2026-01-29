import QtQuick
import Quickshell
import Quickshell.Io
import qs.commons

pragma Singleton

Singleton {
    id: root
    
    property var settings: Settings
    property var theme: settings ? settings.appearance : null
    property Process matugenProcess: Process {
        command: ["bash", "-c", ""]
        stdout: StdioCollector {
            onTextChanged: {
                if (text && text.trim() !== "") {
                    console.log("Matugen output received")
                    try {
                        var jsonData = JSON.parse(text)
                        processMatugenOutput(jsonData)
                    } catch (e) {
                        console.error("Failed to parse matugen output:", e)
                    }
                }
            }
        }
        stderr: StdioCollector {
            onTextChanged: {
                if (text) {
                    console.log("Matugen error:", text)
                }
            }
        }
        onRunningChanged: {
            if (!running) {
                console.log("Matugen completed")
            }
        }
    }

    property Timer reloadTimer: Timer {
        interval: 200
        repeat: false
        onTriggered: {
            if (typeof ThemeService !== 'undefined' && ThemeService.loadTheme) {
                ThemeService.loadTheme()
                console.log("Triggered ThemeService.loadTheme()")
            }
        }
    }

    // Function to process matugen JSON output and create theme
    function processMatugenOutput(jsonData) {
        console.log("Processing matugen output for theme generation")
        
        if (!jsonData || !jsonData.colors) {
            console.error("Invalid matugen output")
            return
        }
        
        var mode = jsonData.mode || "dark"
        var colors = jsonData.colors
        var palettes = jsonData.palettes || {}
        
        // Create theme structure based on template
        var theme = {
            "type": mode,
            "primary": {
                "background": colors.surface ? colors.surface.default : "#101410",
                "dim_background": colors.surface_dim ? colors.surface_dim.default : "#101410",
                "foreground": colors.on_surface_variant ? colors.on_surface_variant.default : "#c0c9bc",
                "dim_foreground": colors.secondary_fixed_dim ? colors.secondary_fixed_dim.default : "#b1cead",
                "bright_foreground": colors.primary ? colors.primary.default : "#92d792"
            },
            "button": {
                "background": colors.outline_variant ? colors.outline_variant.default : "#41493f",
                "text": colors.primary ? colors.primary.default : "#92d792",
                "background_select": colors.outline ? colors.outline.default : "#8a9387",
                "border": colors.on_surface_variant ? colors.on_surface_variant.default : "#c0c9bc",
                "border_select": colors.on_surface_variant ? colors.on_surface_variant.default : "#c0c9bc"
            },
            "cursor": {
                "cursor": "#cad3f5",
                "text": "#24273a"
            },
            "normal": {
                "black": palettes.neutral ? palettes.neutral[40] || "#494d64" : "#494d64",
                "red": colors.error ? colors.error.default : "#ed8796",
                "green": colors.primary ? colors.primary.default : "#a6da95",
                "yellow": colors.tertiary ? colors.tertiary.default : "#eed49f",
                "blue": "#8aadf4",
                "magenta": "#f5bde6",
                "cyan": colors.tertiary ? colors.tertiary.default : "#8bd5ca",
                "white": colors.on_surface ? colors.on_surface.default : "#b8c0e0"
            },
            "bright": {
                "black": palettes.neutral ? palettes.neutral[60] || "#5b6078" : "#5b6078",
                "red": colors.error ? colors.error.default : "#ed8796",
                "green": colors.primary ? colors.primary.default : "#a6da95",
                "yellow": colors.tertiary ? colors.tertiary.default : "#eed49f",
                "blue": "#8aadf4",
                "magenta": "#f5bde6",
                "cyan": colors.tertiary ? colors.tertiary.default : "#8bd5ca",
                "white": colors.on_surface ? colors.on_surface.default : "#a5adcb"
            }
        }
        
        // Save theme to file
        saveThemeToFile(theme)
    }
    
    // Function to save theme to JSON file
    function saveThemeToFile(theme) {
        var themeJson = JSON.stringify(theme, null, 2)
        // Sử dụng cùng đường dẫn với ThemeService
        var filePath = Directories.assetsPath + "/themes/matugen.json"
        
        console.log("Saving theme to:", filePath)
        
        try {
            var file = Qt.createQmlObject('import QtQuick; import Quickshell.Io; File { }', root)
            file.path = filePath
            file.text = themeJson
            
            if (file.write()) {
                console.log("Theme saved successfully")
                
                // Update current theme to matugen if not already set
                if (settings && settings.appearance.theme !== "matugen") {
                    settings.appearance.theme = "matugen"
                }
                
                // Trigger theme reload
                reloadTimer.restart()
            } else {
                console.error("Failed to save theme file")
                // Thử cách khác
                saveThemeAlternative(themeJson, filePath)
            }
            
            file.destroy()
        } catch (e) {
            console.error("Error creating File object:", e)
            saveThemeAlternative(themeJson, filePath)
        }
    }
    
    function saveThemeAlternative(content, filePath) {
        var command = "mkdir -p $(dirname '" + filePath + "') && echo '" + content.replace(/'/g, "'\"'\"'").replace(/\n/g, '\\n') + "' > '" + filePath + "'"
        console.log("Using alternative method to save theme")
        
        var process = Qt.createQmlObject(`
            import QtQuick
            import Quickshell.Io
            Process {
                id: saveProcess
                command: ["bash", "-c", "${command}"]
                onExited: {
                    if (exitCode === 0) {
                        console.log("Theme saved successfully via alternative method")
                        if (settings && settings.appearance.theme !== "matugen") {
                            settings.appearance.theme = "matugen"
                        }
                        reloadTimer.restart()
                    } else {
                        console.error("Failed to save theme via alternative method")
                    }
                    saveProcess.destroy()
                }
            }
        `, root, "SaveThemeProcess")
        
        process.running = true
    }

    // Function run matugen with JSON output
    function runMatugen(currentWallpaper, themeMode) {
        if (!currentWallpaper || currentWallpaper === "") {
            console.log("No wallpaper path provided")
            return
        }
        
        // Run matugen with JSON output format
        var command = "matugen image '" + currentWallpaper + "' -j hex --mode " + themeMode
        console.log("Running matugen command:", command)
        matugenProcess.command = ["bash", "-c", command]
        matugenProcess.running = true
    }

    function triggerMatugenOnThemeChange(themeMode) {
        console.log("Theme changed to:", themeMode)
        
        // Update Settings mode first
        if (settings && settings.appearance) {
            settings.appearance.mode = themeMode
        }
        
        // Only run matugen if theme is set to "matugen"
        if (!settings || settings.appearance.theme !== "matugen") {
            console.log("Current theme is not matugen, skipping")
            return
        }
        
        // Lấy wallpaper từ màn hình chính hoặc màn hình đầu tiên
        var currentWallpaper = ""
        
        if (Quickshell.screens.length > 0) {
            var primaryScreenName = ""
            
            // Tìm màn hình chính
            for (let i = 0; i < Quickshell.screens.length; i++) {
                if (Quickshell.screens[i].primary) {
                    primaryScreenName = Quickshell.screens[i].name
                    break
                }
            }
            
            // Nếu không tìm thấy màn hình chính, lấy màn hình đầu tiên
            if (primaryScreenName === "" && Quickshell.screens.length > 0) {
                primaryScreenName = Quickshell.screens[0].name
            }
            
            // Lấy wallpaper từ WallpaperService
            if (primaryScreenName !== "" && typeof WallpaperService !== 'undefined') {
                currentWallpaper = WallpaperService.getWallpaper(primaryScreenName)
            }
        }
        
        console.log("Current wallpaper path:", currentWallpaper)
        
        if (currentWallpaper && currentWallpaper !== "") {
            runMatugen(currentWallpaper, themeMode)
        } else {
            console.log("No wallpaper set, skipping matugen")
        }
    }

    function triggerMatugenOnWallpaperChange(currentWallpaper) {
        if (!currentWallpaper || currentWallpaper === "") {
            console.log("No wallpaper path provided")
            return
        }
        
        // Only run matugen if theme is set to "matugen"
        if (!settings || settings.appearance.theme !== "matugen") {
            console.log("Current theme is not matugen, skipping")
            return
        }
        
        var themeMode = settings.appearance.mode || "dark"
        console.log("Running matugen for wallpaper change, mode:", themeMode)
        runMatugen(currentWallpaper, themeMode)
    }

    // Hàm khởi tạo
    function init() {
        console.log("MatugenService initialized")
        
        // Chạy matugen lần đầu khi khởi động nếu theme là matugen
        if (settings && settings.appearance.theme === "matugen") {
            Qt.callLater(function() {
                triggerMatugenOnThemeChange(settings.appearance.mode)
            })
        }
    }

    Component.onCompleted: {
        // Đợi Settings được load
        if (settings && settings.ready) {
            init()
        } else {
            // Kết nối signal nếu Settings có sẵn
            if (settings) {
                settings.settingsLoaded.connect(init)
            } else {
                // Nếu settings chưa có, thử lại sau
                Qt.callLater(function() {
                    if (Settings && Settings.ready) {
                        settings = Settings
                        init()
                    }
                })
            }
        }
    }
}
