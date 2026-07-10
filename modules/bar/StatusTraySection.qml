import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import QtQuick.Controls
import qs.services
import qs.commons
import qs.components
import "./widget/" as Com

Rectangle {
  id: root
  border.color: theme.button.border
  border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
  radius: ScalerService.s(Settings.appearance.radius2)
  color: theme.primary.background
  anchors.centerIn: parent
  property real animationProgress: 0
  SequentialAnimation on animationProgress {
    running: true
    NumberAnimation {
      from: 0
      to: 1
      duration: 1000
      easing.type: Easing.Linear
    }
  }
  implicitWidth: root.animationProgress > 0.5 ? parent.width : 0
  implicitHeight: root.animationProgress > 0.5 ? parent.height : 0
  Behavior on implicitHeight {
    NumberAnimation {
      id: heightAnim
      duration: 500
      easing.type: Easing.OutCubic
    }
  }
  Behavior on implicitWidth {
    NumberAnimation {
      id: widthAnim
      duration: 500
      easing.type: Easing.OutCubic
    }
  }

  property string bluetooth_icon: Directories.assetsPath + "/settings/bluetooth.png"
  property real currentVolume: Pipewire.defaultAudioSink?.audio.volume ?? 0
  property bool isMuted: Pipewire.defaultAudioSink?.audio.mute ?? false
  property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"
  property bool shouldShowOsd: false





  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  Connections {
    target: Pipewire.defaultAudioSink?.audio ?? null
  }

  Loader {
    anchors.fill: parent
    anchors.margins: isVertical ? ScalerService.s(6) : ScalerService.s(5)
    sourceComponent: isVertical ? verticalLayout : horizontalLayout
  }

  Component {
    id: horizontalLayout

    RowLayout {
      anchors.fill: parent
      spacing: ScalerService.s(5)

      Com.StatContainer {
        Layout.fillWidth: true
        Layout.fillHeight: true
        panelName: "tray"

        Com.TrayStat {
          anchors.centerIn: parent
        }
      }


      Item {
        Layout.preferredWidth: trayRepeater.count > 0 ? ScalerService.s(5) : 0
      }

      // Bluetooth
      Com.StatContainer {
        Layout.fillWidth: true
        Layout.fillHeight: true
        panelName: "bluetooth"

        Com.BluetoothStat {
          anchors.centerIn: parent
        }
      }

      Item {
        Layout.fillWidth: true
      }

      Com.StatContainer {
        Layout.fillWidth: true
        Layout.fillHeight: true
        panelName: "wifi"

        Com.WifiStat {
          anchors.centerIn: parent
        }
      }

      Item {
        Layout.fillWidth: true
      }

      Com.StatContainer {
        Layout.fillWidth: true
        Layout.fillHeight: true
        panelName: "mixer"

        Com.VolumeStat {
          anchors.centerIn: parent
        }
      }

      Item {
        Layout.fillWidth: true
      }

      Com.StatContainer {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Com.BrightnessStat {
          anchors.centerIn: parent
        }
      }

      Item {
        Layout.fillWidth: true
        visible: UPower.displayDevice.isLaptopBattery
      }

      BatteryIcon {
          id: batteryContainer
          percent: Math.round(UPower.displayDevice.percentage * 100)
          status : UPowerDeviceState.toString(UPower.displayDevice.state)
          textColor: theme.primary.foreground
          Layout.preferredWidth: ScalerService.s(28)
          Layout.preferredHeight: ScalerService.s(18)
          visible: UPower.displayDevice.isLaptopBattery

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: batteryContainer.scale = 1.1
            onExited: batteryContainer.scale = 1.0
            onPressed: batteryContainer.scale = 0.95
            onReleased: batteryContainer.scale = 1.1
            onClicked: VisibleService.togglePanel("battery")
          }
      }

      Item {
        Layout.fillWidth: true
      }

      // Power Off
      Rectangle {
        id: powerContainer
        Layout.preferredWidth: powerIcon.width
        Layout.fillHeight: true
        color: "transparent"
        radius: ScalerService.s(6)
        transformOrigin: Item.Center

        Image {
          id: powerIcon
          source: Directories.assetsPath + '/system/poweroff.png'
          width: ScalerService.s(30)
          height: ScalerService.s(30)
          sourceSize: Qt.size(ScalerService.s(30), ScalerService.s(30))
          anchors.centerIn: parent
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor

          onEntered: powerContainer.scale = 1.2
          onExited: powerContainer.scale = 1.0
          onPressed: powerContainer.scale = 0.9
          onReleased: powerContainer.scale = 1.2

          onClicked: VisibleService.togglePanel("dashboard")
        }

        Behavior on scale {
          NumberAnimation {
            duration: 100
          }
        }
      }
    }
  }

  Component {
    id: verticalLayout

    ColumnLayout {
      anchors.fill: parent
      spacing: ScalerService.s(8)

      // System Tray Icons (vertical)
      Com.StatContainer {
        Layout.fillWidth: true
        Layout.fillHeight: true
        panelName: "tray"

        Com.TrayStat {
          anchors.centerIn: parent
        }
      }
      Item {
        Layout.fillWidth: true
      }

      // Bluetooth (vertical)
      Com.StatContainer {
        Layout.fillWidth: true
        Layout.fillHeight: true
        panelName: "bluetooth"

        Com.BluetoothStat {
          anchors.centerIn: parent
        }
      }

      Item {
        Layout.fillWidth: true
      }

      Com.StatContainer {
        Layout.fillWidth: true
        Layout.fillHeight: true
        panelName: "wifi"

        Com.WifiStat {
          anchors.centerIn: parent
        }
      }

      Item {
        Layout.fillWidth: true
      }

      Com.StatContainer {
        Layout.fillWidth: true
        Layout.fillHeight: true
        panelName: "mixer"

        Com.VolumeStat {
          anchors.centerIn: parent
        }
      }
      Item {
        Layout.fillWidth: true
      }

      Com.StatContainer {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Com.BrightnessStat {
          anchors.centerIn: parent
        }
      }
      Item {
        Layout.fillWidth: true
      }

      // Battery (vertical, UPower displayDevice)
      BatteryIcon {
          id: batteryContainer
          percent: Math.round(UPower.displayDevice.percentage * 100)
          status : UPowerDeviceState.toString(UPower.displayDevice.state)
          textColor: theme.primary.foreground
          Layout.preferredWidth: ScalerService.s(28)
          Layout.preferredHeight: ScalerService.s(18)
          visible: UPower.displayDevice.isLaptopBattery

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: batteryContainer.scale = 1.1
            onExited: batteryContainer.scale = 1.0
            onPressed: batteryContainer.scale = 0.95
            onReleased: batteryContainer.scale = 1.1
            onClicked: VisibleService.togglePanel("battery")
          }
      }

      // Power (vertical)
      Item {
        width: ScalerService.s(25)
        height: ScalerService.s(25)

        Item {
          anchors.centerIn: parent
          width: parent.height
          height: parent.width
          transformOrigin: Item.Center

          Image {
            id: powerIconVertical
            anchors.centerIn: parent
            source: Directories.assetsPath + '/system/poweroff.png'
            width: ScalerService.s(25)
            height: ScalerService.s(25)
            sourceSize: Qt.size(ScalerService.s(25), ScalerService.s(25))
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: VisibleService.togglePanel("dashboard")
          onEntered: parent.opacity = 0.8
          onExited: parent.opacity = 1.0
        }

        Behavior on opacity {
          NumberAnimation {
            duration: 100
          }
        }
      }
    }
  }
}

