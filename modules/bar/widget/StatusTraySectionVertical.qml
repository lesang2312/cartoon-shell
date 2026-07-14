import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import qs.services
import qs.commons
import qs.components
import "."

ColumnLayout {
  id: root
  property bool isVertical: true
  anchors.fill: parent
  spacing: ScalerService.s(8)

  // System Tray Icons
  StatContainer {
    Layout.fillWidth: true
    Layout.fillHeight: true
    panelName: "tray"

    TrayStat {
      anchors.centerIn: parent
    }
  }
  
  Item {
    Layout.fillWidth: true
  }

  // Bluetooth
  StatContainer {
    Layout.fillWidth: true
    Layout.fillHeight: true
    panelName: "bluetooth"

    BluetoothStat {
      anchors.centerIn: parent
    }
  }

  Item {
    Layout.fillWidth: true
  }

  // Wifi
  StatContainer {
    Layout.fillWidth: true
    Layout.fillHeight: true
    panelName: "wifi"

    WifiStat {
      anchors.centerIn: parent
    }
  }

  Item {
    Layout.fillWidth: true
  }

  // Volume
  StatContainer {
    Layout.fillWidth: true
    Layout.fillHeight: true
    panelName: "mixer"

    VolumeStat {
      anchors.centerIn: parent
    }
  }
  
  Item {
    Layout.fillWidth: true
  }

  // Brightness
  StatContainer {
    Layout.fillWidth: true
    Layout.fillHeight: true

    BrightnessStat {
      anchors.centerIn: parent
    }
  }
  
  Item {
    Layout.fillWidth: true
  }

  StatContainer {
    Layout.fillWidth: true
    Layout.fillHeight: true
    panelName: "battery"
    visible: UPower.displayDevice.isLaptopBattery

    BatteryIcon {
      anchors.centerIn: parent
      textColor: theme.primary.foreground
      Layout.preferredWidth: ScalerService.s(28)
      Layout.preferredHeight: ScalerService.s(18)
    }
  }


  // Power Off
  StatContainer {
    Layout.fillWidth: true
    Layout.fillHeight: true
    panelName: "dashboard"

    IconImage {
      path: '/system/poweroff.png'
      size: "large"
      anchors.centerIn: parent
    }
  }
}
