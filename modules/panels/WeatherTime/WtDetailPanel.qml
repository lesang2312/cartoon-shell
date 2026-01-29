import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.services
import qs.commons
import "./" as Components

PanelWindow {
    id: wtDetailPanel

    property var theme : ThemeService.theme


    implicitWidth: 500
    implicitHeight: 500

    anchors {
        top: Settings.bar.position === "top"
        bottom: Settings.bar.position === "bottom"
    }

    margins {
        top: Settings.bar.position === "top" ? 10 : 0
        bottom: Settings.bar.position === "bottom" ? 10 : 0
        left: 800
    }
    exclusiveZone: 0
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: 8
        border.color: theme.button.border
        border.width: 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16

            Components.WtDetailHeader {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
            }

            Components.WtDetailCalendar {
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
