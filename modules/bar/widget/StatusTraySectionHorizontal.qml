import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import qs.services
import qs.commons
import qs.components
import "."

RowLayout {
  id: root
  property bool isVertical: false
  anchors.fill: parent
  spacing: ScalerService.s(5)
  
  Item {
    Layout.fillWidth: true
  }

  // Tray
  StatContainer {
    Layout.fillWidth: true
    Layout.fillHeight: true
    panelName: "tray"

    visible: TrayService.hasTray

    TrayStat {
      anchors.centerIn: parent
    }
  }

  Item {
    visible: TrayService.hasTray
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
    visible: UPower.displayDevice.isLaptopBattery
  }

  // Battery
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

  Item {
    Layout.fillWidth: true
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
  Item {
    Layout.fillWidth: true
  }
}
