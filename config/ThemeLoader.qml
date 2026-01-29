// components/ThemeLoader.qml
import QtQuick 2.15
import qs.commons
import Quickshell
import Quickshell.Io

QtObject {
    id: themeLoader

    property string currentTheme: Settings.appearance.theme
    property var theme: ({})  // theme hiện tại
    property var matugenTheme: ({}) // theme từ matugen
    property bool useMatugen: currentTheme === "matugen"

    signal themeReloaded()     // signal thông báo theme đã thay đổi

    function loadTheme() {
        if (useMatugen) {
            // Load theme từ file matugen.json
            var filePath = Directories.shellConfigPath + "/themes/matugen.json"
            var file = Qt.createQmlObject('import QtQuick; import Quickshell.Io; File { }', themeLoader)
            file.path = filePath
            
            if (file.exists) {
                file.read()
                try {
                    theme = JSON.parse(file.text)
                    console.log("Loaded matugen theme from file")
                } catch (e) {
                    console.error("Failed to parse matugen theme:", e)
                    theme = getFallbackTheme()
                }
            } else {
                console.log("Matugen theme file not found, using fallback")
                theme = getFallbackTheme()
            }
            
            file.destroy()
        } else {
            // Load theme từ file JSON thông thường
            var filePath = Qt.resolvedUrl("themes/" + currentTheme + ".json")
            var xhr = new XMLHttpRequest()
            xhr.open("GET", filePath, false)
            xhr.send()

            if (xhr.status === 200) {
                try {
                    theme = JSON.parse(xhr.responseText)
                } catch (e) {
                    theme = getFallbackTheme()
                }
            } else {
                theme = getFallbackTheme()
            }
        }

        themeReloaded()
        return theme
    }

    function changeTheme(newTheme) {
        currentTheme = newTheme
        useMatugen = (newTheme === "matugen")
        return loadTheme()
    }

    function getFallbackTheme() {
        return {
            "type": Settings.appearance.mode || "dark",
            "primary": { 
                "background": Settings.appearance.mode === "dark" ? "#101410" : "#f7faf2",
                "dim_background": Settings.appearance.mode === "dark" ? "#101410" : "#d8dbd3",
                "foreground": Settings.appearance.mode === "dark" ? "#c0c9bc" : "#41493f",
                "dim_foreground": Settings.appearance.mode === "dark" ? "#b1cead" : "#4b654a",
                "bright_foreground": Settings.appearance.mode === "dark" ? "#92d792" : "#185b24"
            },
            "button": {
                "background": Settings.appearance.mode === "dark" ? "#41493f" : "#dce5d7",
                "text": Settings.appearance.mode === "dark" ? "#92d792" : "#185b24",
                "background_select": Settings.appearance.mode === "dark" ? "#8a9387" : "#717a6e",
                "border": Settings.appearance.mode === "dark" ? "#c0c9bc" : "#41493f",
                "border_select": Settings.appearance.mode === "dark" ? "#c0c9bc" : "#41493f"
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

    // Kết nối để tự động reload khi theme matugen được cập nhật
    Connections {
        target: MatugenService
        function onReloadTimerTriggered() {
            if (useMatugen) {
                loadTheme()
            }
        }
    }

    Component.onCompleted: loadTheme()
}
