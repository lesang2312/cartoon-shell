import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services
import qs.commons
import "." as Com

PanelWindow {
  id: root

  implicitWidth: root.animationProgress > 0.1 ? 450 : 100
  implicitHeight: root.animationProgress > 0.1 ?  800 : 100
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
    // Anchor theo vị trí của bar
    left: Settings.bar.position === "left"
    right: Settings.bar.position === "right" || Settings.bar.position === "top" || Settings.bar.position === "bottom"
    top: Settings.bar.position === "top"
    bottom: Settings.bar.position === "left" || Settings.bar.position === "right" || Settings.bar.position === "bottom"
  }

  margins {
    top: Settings.bar.position === "top" ? 10 : 0
    bottom: (Settings.bar.position === "bottom" || Settings.bar.position === "left" || Settings.bar.position === "right") ? 10 : 0
    left: Settings.bar.position === "left" ? 10 : 0
    right: (Settings.bar.position === "right" || Settings.bar.position === "top" || Settings.bar.position === "bottom") ?  10 : 0
  }

  color: "transparent"
  focusable: true
  Com.WifiManager {
    id: wifiManager
  }

  Rectangle {
    anchors.fill: parent
    color: theme.primary.background
    radius: Settings.appearance.radius1
    border.width: Settings.appearance.enableBorder ? 3 : 0
    border.color: theme.button.border
    clip: true

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 12
      Com.WifiHeader {
        Layout.fillWidth: true
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
