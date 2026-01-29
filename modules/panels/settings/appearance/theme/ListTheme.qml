import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import qs.commons
import qs.services

ColumnLayout {
    id: presetThemesContainer
    property var theme : ThemeService.theme
    property var panelConfig
    
    width: parent.width
    spacing: 15
    
    Text {
        text: "Preset Themes"
        color: theme.primary ? theme.primary.foreground : "#d8dee9"
        font {
            family: "ComicShannsMono Nerd Font"
            pixelSize: 18
            bold: true
        }
        Layout.alignment: Qt.AlignLeft
    }
    
    GridLayout {
        Layout.fillWidth: true
        columns: panelManager.fullsetting ? 5 : 3
        columnSpacing: panelManager.fullsetting ? 15 : 10
        rowSpacing: panelManager.fullsetting ? 15 : 10
        
        Repeater {
            model: [
                { name: "Auto", type: "matugen", accent: "black" },
                { name: "Macchiato", type: "macchiato", accent: "#24273a" },
                { name: "Gruvbox", type: "gruvbox", accent: "#f5eee6" },
                { name: "Tokyonight Storm", type: "tokyonightStorm", accent: "#7aa2f7" },
                { name: "Nord", type: "nord", accent: "#88c0d0" }
            ]
            
            delegate: Rectangle {
                id: themeDelegate
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                radius: 8
                color: theme.button ? theme.button.background : "#434c5e"
                border {
                    color: theme.button ? theme.button.border : "#4c566a"
                    width: 2
                }

                property var modal: ({
                    name: modelData.name,
                    type: modelData.type,
                    accent: modelData.accent
                })

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Chỉ đổi theme nếu khác theme hiện tại
                        if (Settings.appearance.theme !== modal.type) {
                            Settings.appearance.theme = modal.type
                            
                            // Nếu theme là "matugen", bật dynamic, ngược lại tắt dynamic
                            if (modal.type === "matugen") {
                                Settings.appearance.dynamic = true
                            } else {
                                Settings.appearance.dynamic = false
                            }
                            
                            // Không cần gọi reloadTimer vì ThemeService sẽ tự động load
                            console.log("Theme changed to:", modal.type, "dynamic:", Settings.appearance.dynamic)
                        }
                    }
                }

                // ✔ checkmark theme đang active
                Rectangle {
                    visible: Settings.appearance.theme === modal.type
                    width: 20
                    height: 20
                    radius: 10
                    color: theme.normal ? theme.normal.blue : "#81a1c1"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 5

                    Text {
                        text: "✓"
                        color: theme.primary ? theme.primary.background : "#2e3440"
                        font.pixelSize: 12
                        font.bold: true
                        anchors.centerIn: parent
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        radius: 6
                        color: modal.accent
                    }

                    Text {
                        text: modal.name
                        color: theme.primary ? theme.primary.foreground : "#d8dee9"
                        wrapMode: Text.WordWrap
                        width: 40
                        horizontalAlignment: Text.AlignLeft
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: panelManager.fullsetting ? 16 : 12
                            bold: true
                        }
                    }
                }
            }
        }
    }
}
