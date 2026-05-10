import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.services
import qs.commons
import "." as Com

PanelWindow {
  id: wtDetailPanel

  property var theme: ThemeService.theme

  implicitWidth: 500
  implicitHeight: 500

  anchors {
    top: Settings.bar.position === "top"
    bottom: Settings.bar.position === "bottom"
    left: Settings.bar.position === "top" || Settings.bar.position === "bottom" || Settings.bar.position === "left"
    right: Settings.bar.position === "right"
  }

  margins {
    top: Settings.bar.position === "top" ? 10 : 0
    bottom: Settings.bar.position === "bottom" ? 10 : 0
    left: (Settings.bar.position === "top" || Settings.bar.position === "bottom") ? 800 : 10
    right: Settings.bar.position === "right" ? 10 : 0
  }
  exclusiveZone: 0
  color: "transparent"

  Rectangle {
    anchors.fill: parent
    color: theme.primary.background
    radius: 16
    border.color: theme.button.border
    border.width: 3

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 20
      spacing: 16

      Com.CalendarHeader {
        Layout.fillWidth: true
        Layout.preferredHeight: 70
      }

      Com.CalendarDislay {
        Layout.alignment: Qt.AlignHCenter
      }
    }
  }
}
