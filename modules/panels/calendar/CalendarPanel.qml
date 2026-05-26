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

  property real animationProgress: 0
  SequentialAnimation on animationProgress {
    id: staggerAnimation
    running: true
    loops: 1

    PropertyAction { value: 0 }

    NumberAnimation { to: 0.2; duration: 50 }
  }

  implicitWidth: wtDetailPanel.animationProgress > 0.1 ?  500 : 100
  implicitHeight: wtDetailPanel.animationProgress > 0.1 ?  500 : 100
  Behavior on implicitHeight {
    NumberAnimation {
      duration: 60
      easing.type: Easing.OutCubic
    }
  }
  Behavior on implicitWidth {
    NumberAnimation {
      duration: 60
      easing.type: Easing.OutCubic
    }
  }

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
    border.color: theme.button.border
    radius: Settings.appearance.radius1
    border.width: Settings.appearance.enableBorder ? 3 : 0

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
