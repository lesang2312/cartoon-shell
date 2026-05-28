import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.services
import qs.commons
import "." as Com
import qs.components

PanelWindow {
  id: root

  property real animationProgress: 0
  SequentialAnimation on animationProgress {
    running: true

    NumberAnimation {
      from: 0
      to: 1
      duration: 500
      easing.type: Easing.Linear
    }
  }

  implicitWidth: ScalerService.s(500)
  implicitHeight: ScalerService.s(500)

  anchors {
    top: Settings.bar.position === "top"
    bottom: Settings.bar.position === "bottom"
    left: Settings.bar.position === "top" || Settings.bar.position === "bottom" || Settings.bar.position === "left"
    right: Settings.bar.position === "right"
  }

  margins {
    top: Settings.bar.position === "top" ? ScalerService.s(10) : 0
    bottom: Settings.bar.position === "bottom" ? ScalerService.s(10) : 0
    left: (Settings.bar.position === "top" || Settings.bar.position === "bottom") ? ScalerService.s(800) : ScalerService.s(10)
    right: Settings.bar.position === "right" ? ScalerService.s(10) : 0
  }
  exclusiveZone: 0
  color: "transparent"

  // Background layer với các hình tròn di chuyển

  // Main content layer
  Rectangle {
    anchors.centerIn: parent
    implicitWidth: root.animationProgress > 0 ? parent.width : 0
    implicitHeight: root.animationProgress > 0 ? parent.height : 0

    Behavior on implicitHeight {
      NumberAnimation {
        duration: 500
        easing.type: Easing.OutCubic
      }
    }
    Behavior on implicitWidth {
      NumberAnimation {
        duration: 500
        easing.type: Easing.OutCubic
      }
    }

    color: theme.primary.background
    border.color: theme.button.border
    radius: ScalerService.s(Settings.appearance.radius1)
    border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0

    FloatingCircles {
      circleColor: theme.button.text
      circleCount: 3  // Số lượng hình tròn
      minRadius: 80
      maxRadius: 250
      minOpacity: 0.03
      maxOpacity: 0.12
      minDuration: 40000
      maxDuration: 80000
    }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: ScalerService.s(20)
      spacing: ScalerService.s(16)

      Com.CalendarHeader {
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(40)
      }

      Com.CalendarDislay {
        Layout.alignment: Qt.AlignHCenter
      }
    }
    StarField {
      starCount: 10
      shootingStarCount: 5
      starColor: theme.button.text
      shootingStarColor: theme.button.text
      starMinOpacity: 0.2
      starMaxOpacity: 0.6
      shootingStarMinSpeed: 0.8
      shootingStarMaxSpeed: 1.3
    }
  }
}
