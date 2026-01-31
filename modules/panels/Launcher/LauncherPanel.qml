import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.services
import qs.commons

// Import các thành phần phụ trong cùng thư mục
import "../../../components/" as Components
import "./" as LauncherComponents

PanelWindow {
    id: launcherPanel
    implicitWidth: {
         if (panelManager.setting) {
            return 1000
        } else {
            return 600
        }
    }
    implicitHeight: {
         if (panelManager.setting) {
            return 700
        } else {
            return 640
        }
    }
    color: "transparent"
    focusable: true

    signal confirmRequested(string action, string actionLabel)

    Behavior on width { NumberAnimation { duration: 10 } }
    Behavior on height { NumberAnimation { duration: 10 } }

    property var theme : ThemeService.theme
    property bool settingsPanelVisible: false
    property var lang : currentLanguage
    property bool launcherPanelVisible: true

    // Sửa hàm closePanel

    function togglePanel() {
        launcherPanel.visible = !launcherPanel.visible
        if (launcherPanel.visible) {
            openLauncher()
        }
    }

    anchors {
        // Xác định vị trí anchor dựa trên position của bar
        left: (Settings.bar.position === "left" || Settings.bar.position === "top" || Settings.bar.position === "bottom")
        right: Settings.bar.position === "right"
        top: (Settings.bar.position === "top" || Settings.bar.position === "left" || Settings.bar.position === "right")
        bottom: Settings.bar.position === "bottom"
    }

    margins {
        top: Settings.bar.position === "top" ? 10 : 0
        bottom: Settings.bar.position === "bottom" ? 10 : 0
        left: (Settings.bar.position === "left" || Settings.bar.position === "top" || Settings.bar.position === "bottom") ? 10 : 0
        right: Settings.bar.position === "right" ? 10 : 0
    }

    // Focus scope để quản lý focus
        Rectangle {
            anchors.fill: parent
            radius: {
                if (panelManager.fullsetting && panelManager.setting) {
                    return 10 // Radius nhỏ hơn khi full screen
                }
                return 20
            }
            color: theme.primary.background
            border.color: theme.button.border
            border.width: 3
            ColumnLayout{
                anchors.fill: parent
                Item {
                  Layout.fillWidth: true
                  Layout.fillHeight: true
                    RowLayout {
                      anchors.fill: parent
                      anchors.margins: {
                        if (panelManager.fullsetting && settingsPanelVisible) {
                          return 20 // Margin lớn hơn khi full screen
                        }
                        return 16
                      }
                spacing: 12

                LauncherComponents.Sidebar {
                    id: sidebar
                    visible: !(panelManager.fullsetting && panelManager.setting)
                    onConfirmRequested: (action, actionLabel) => {
                        launcherPanel.confirmRequested(action, actionLabel)
                    }
                }

                Loader {
                    id: settingsPanelLoader
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    active: panelManager.setting
                    source: "../settings/SettingsPanel.qml"
                    onLoaded: {
                        item.launcherPanel = launcherPanel
                        item.visible = Qt.binding(function() { return panelManager.setting })
                    }
                }

                ColumnLayout {
                    visible: !panelManager.setting
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 10

                    Text {
                        text: lang.system.application
                        color: theme.primary.foreground
                        font.pixelSize: 40
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    LauncherComponents.LauncherSearch {
                        id: searchBox
                        onSearchChanged: (text) => launcherList.runSearch(text)
                        onAccepted: (text) => launcherList.runSearch(text)
                    }

                    LauncherComponents.LauncherList {
                        id: launcherList
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }}
            }
            
    }

    // Khi panel trở nên visible, focus vào search field
    onVisibleChanged: {
        if (visible && launcherPanelVisible) {
            Qt.callLater(function() {
                if (searchBox && searchBox.searchField) {
                    searchBox.searchField.forceActiveFocus()
                    searchBox.searchField.selectAll()
                }
            })
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: panelManager.togglePanel("launcher")
    }

    Component.onCompleted: {
        // Đảm bảo panel không visible khi khởi động
        visible = false
    }
}
