import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services
import qs.commons
import "." as Com

PanelWindow {
  id: root

  implicitWidth: ScalerService.s(450)
  implicitHeight: ScalerService.s(800)
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

  anchors {
    // Anchor theo vị trí của bar
    left: Settings.bar.position === "left"
    right: Settings.bar.position === "right" || Settings.bar.position === "top" || Settings.bar.position === "bottom"
    top: Settings.bar.position === "top"
    bottom: Settings.bar.position === "left" || Settings.bar.position === "right" || Settings.bar.position === "bottom"
  }

  margins {
    top: Settings.bar.position === "top" ? ScalerService.s(10) : 0
    bottom: (Settings.bar.position === "bottom" || Settings.bar.position === "left" || Settings.bar.position === "right") ? ScalerService.s(10) : 0
    left: Settings.bar.position === "left" ? ScalerService.s(10) : 0
    right: (Settings.bar.position === "right" || Settings.bar.position === "top" || Settings.bar.position === "bottom") ? ScalerService.s(10) : 0
  }

  color: "transparent"
  focusable: true
  WifiService {
    id: wifiManager
  }

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
    radius: ScalerService.s(Settings.appearance.radius1)
    border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
    border.color: theme.button.border
    clip: true

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: ScalerService.s(16)
      spacing: ScalerService.s(12)
      Com.WifiHeader {
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(40)
        wifiManager: wifiManager
        animationProgress: root.animationProgress
      }

      Com.WifiStatus {
        Layout.fillWidth: true
        wifiManager: wifiManager
        animationProgress: root.animationProgress
      }

      Com.WifiNetworkList {
        Layout.fillWidth: true
        Layout.fillHeight: true
        wifiManager: wifiManager
        visible: wifiManager.wifiEnabled
        animationProgress: root.animationProgress
      }

      Com.WifiEmptyState {
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: !wifiManager.wifiEnabled
      }
    }
  }
}
