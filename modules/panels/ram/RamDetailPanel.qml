import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "." as Components
import qs.services
import qs.commons

PanelWindow {
    id: root

    implicitWidth: 930
    implicitHeight: 960

    anchors {
        top: Settings.bar.position === "top"
        bottom: Settings.bar.position === "bottom"
        left: Settings.bar.position === "top" || Settings.bar.position === "bottom" || Settings.bar.position === "left"
        right: Settings.bar.position === "right"
    }

    margins {
        top: Settings.bar.position === "top" ? 10 : 0
        bottom: Settings.bar.position === "bottom" ? 10 : 0
        left: (Settings.bar.position === "top" || Settings.bar.position === "bottom") ? 400 : 10
        right: Settings.bar.position === "right" ? 10 : 0
    }

    exclusiveZone: 0
    color: "transparent"

    property var theme : ThemeService.theme
    property var lang : LanguageService.translations
    
    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: 8
        border.color: theme.button.border
        border.width: 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 30

            Components.RamDetailHeader {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
            }

            Components.RamDisplay {
                Layout.fillWidth: true
                Layout.preferredHeight: 330
            }

            Components.RamTaskManager {
                Layout.fillWidth: true
                Layout.preferredHeight: 500
            }

        }
    }
}
