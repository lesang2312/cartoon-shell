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
  Item {
    visible: TrayService.hasTray
    Layout.fillHeight: true
  }

  // System Tray Icons
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
    Layout.fillHeight: true
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
    Layout.fillHeight: true
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
    Layout.fillHeight: true
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
    Layout.fillHeight: true
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
    Layout.fillHeight: true
  }

  StatContainer {
    Layout.fillWidth: true
    Layout.fillHeight: true
    panelName: "battery"

    BatteryIcon {
      anchors.centerIn: parent
      textColor: theme.primary.foreground
      iconWidth: ScalerService.s(28)
      iconHeight: ScalerService.s(18)
    }
  }

  Item {
    Layout.fillHeight: true
  }


  StatContainer {
    Layout.fillWidth: true
    Layout.fillHeight: true
    panelName: "dashboard"

    IconImage {
      path: '/system/poweroff.png'
      anchors.centerIn: parent
    }
  }
  Item {
    visible: TrayService.hasTray
    Layout.fillHeight: true
  }
}
