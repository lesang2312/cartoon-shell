import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

RowLayout {
  id: header
  property var wifiManager
  property real animationProgress: 0

  spacing: ScalerService.s(20)

  Rectangle {
    width: ScalerService.s(70)
    height: ScalerService.s(70)
    radius: ScalerService.s(12)
    color: "transparent"

    IconImage{
      path: "wifi/wifi.png"
      size: "xl"
      anchors.centerIn: parent
    }
  }

  CustomText {
    name: "WIFI"
    size: "2xl"
    isBold: true
    opacity: root.animationProgress > 0.2 ? 1 : 0
  }

  Item {
    Layout.fillWidth: true
  }

  Rectangle {
    id: scanButton
    Layout.preferredWidth: ScalerService.s(55)
    Layout.preferredHeight: ScalerService.s(55)
    radius: ScalerService.s(28)
    visible: wifiManager.wifiEnabled || false
    color: {
      if (wifiManager.isScanning)
      return theme.normal.red;
      if (scanButtonMouse.containsMouse)
      return theme.normal.blue;
      return theme.primary.dim_background;
    }

    opacity: root.animationProgress > 0.3 ? 1 : 0

    scale: scanButtonMouse.containsPress ? 0.95 : (scanButtonMouse.containsMouse ? 1.1 : 1.0)
    Behavior on scale {
      NumberAnimation {
        duration: 200
        easing.type: Easing.OutCubic
      }
    }
    Behavior on opacity {
      NumberAnimation {
        duration: 200
        easing.type: Easing.OutCubic
      }
    }
    Behavior on color {
      ColorAnimation {
        duration: 200
      }
    }

    // Sử dụng icon search giống Bluetooth
    Image {
      source: "../../../assets/launcher/search.png"
      width: ScalerService.s(40)
      height: ScalerService.s(40)
      sourceSize: Qt.size(ScalerService.s(40), ScalerService.s(40))
      anchors.centerIn: parent
    }

    // Animation khi đang quét mạng - giống hệt Bluetooth
    Rectangle {
      anchors.fill: parent
      radius: ScalerService.s(28)
      color: "transparent"
      border.width: ScalerService.s(2)
      border.color: theme.normal.green
      visible: wifiManager.isScanning
      rotation: scanRotation

      RotationAnimator on rotation {
        id: scanRotation
        from: 0
        to: 360
        duration: 1000
        loops: Animation.Infinite
        running: wifiManager.isScanning
      }

      Rectangle {
        width: ScalerService.s(4)
        height: ScalerService.s(4)
        radius: ScalerService.s(2)
        color: theme.normal.green
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: ScalerService.s(-2)
      }
    }

    MouseArea {
      id: scanButtonMouse
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        if (wifiManager.wifiEnabled) {
          wifiManager.scanWifiNetworks();
        }
      }
    }
  }
}
