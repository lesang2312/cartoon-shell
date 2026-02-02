import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Effects
import Quickshell.Io
import qs.services
import qs.commons

Rectangle {
    id: root
    width: 200
    height: 50
    color: theme.primary.background
    radius: 10
    border.color: theme.button.border
    border.width: 3
    property var theme: ThemeService.theme
    property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"
    RowLayout {
        anchors.centerIn: parent
        spacing: 15
        Image {
            source: "../../assets/launcher/dashboard.png"
            Layout.preferredWidth: isVertical ? 24 : 32
            Layout.preferredHeight: isVertical ? 24 : 32
            fillMode: Image.PreserveAspectFit
            smooth: true

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    VisibleService.togglePanel("launcher");
                }
            }
        }
    }
}
