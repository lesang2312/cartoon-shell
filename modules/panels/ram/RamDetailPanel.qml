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
        left: true
    }

    margins {
        top: Settings.bar.position === "top" ? 10 : 0
        bottom: Settings.bar.position === "bottom" ? 10 : 0
        left: Math.round((Quickshell.screens.primary?.width ?? 1920) / 2 - implicitWidth / 2)
    }

    exclusiveZone: 0
    color: "transparent"

    property var theme : ThemeService.theme
    property var lang : currentLanguage
    
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
