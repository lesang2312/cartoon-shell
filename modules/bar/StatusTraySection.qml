import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick.Controls
import Quickshell.Services.SystemTray
import qs.services
import qs.commons

Rectangle {
  id: root
  border.color: theme.button.border
  border.width: 3
  radius: 10
  color: theme.primary.background

  property string bluetooth_icon: Directories.assetsPath + "/settings/bluetooth.png"
  property string status_battery: "Unknown"
  property string capacity_battery: "..."
  property bool shouldShowOsd: false
  property bool visibleMixerPanel: false
  property bool visibleBatteryPanel: false
  property bool wifiPanelVisible: false
  property bool visibleDashboard: false
  property bool bluetoothVisible: true
  property real currentVolume: Pipewire.defaultAudioSink?.audio.volume ?? 0
  property bool isMuted: Pipewire.defaultAudioSink?.audio.mute ?? false
  property var theme: ThemeService.theme
  property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"

  NetworkService {
    id: networkService
  }

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  Connections {
    target: Pipewire.defaultAudioSink?.audio ?? null
    function onVolumeChanged() {
      root.shouldShowOsd = true;
      hideTimer.restart();
    }
  }

  Timer {
    id: hideTimer
    interval: 1000
    onTriggered: root.shouldShowOsd = false
  }

  // Battery processes
  Process {
    id: batteryCapacityProcess
    command: ["cat", "/sys/class/power_supply/BAT*/capacity"]
    running: false
    stdout: StdioCollector {}
    onRunningChanged: {
      if (!running && stdout.text) {
        var result = stdout.text.trim();
        root.capacity_battery = result;
        updateBatteryIcon();
      }
    }
  }

  Process {
    id: batteryStatusProcess
    command: ["cat", "/sys/class/power_supply/BAT*/status"]
    running: false
    stdout: StdioCollector {}
    onRunningChanged: {
      if (!running && stdout.text) {
        var result = stdout.text.trim();
        root.status_battery = result;
        updateBatteryIcon();
      }
    }
  }

  // Functions
  function updateBatteryCappacityProcess() {
    if (!batteryCapacityProcess.running) {
      batteryCapacityProcess.running = true;
    }
  }

  function updateBatteryIcon() {
    var capacity = parseInt(root.capacity_battery) || 0;
    var status = root.status_battery;

    if (status === "Charging") {
      batteryIcon.source = Directories.assetsPath + '/battery/battery-1.png';
    } else if (capacity <= 20) {
      batteryIcon.source = Directories.assetsPath + '/battery/battery-2.png';
    } else if (capacity <= 50) {
      batteryIcon.source = Directories.assetsPath + '/battery/battery-2.png';
    } else if (capacity <= 80) {
      batteryIcon.source = Directories.assetsPath + '/battery/battery-3.png';
    } else {
      batteryIcon.source = Directories.assetsPath + '/battery/full.png';
    }
  }

  // UI Layout
  Loader {
    anchors.fill: parent
    anchors.margins: isVertical ? 6 : 5
    sourceComponent: isVertical ? verticalLayout : horizontalLayout
  }

  Component {
    id: horizontalLayout

    RowLayout {
      anchors.fill: parent
      spacing: 5

      // System Tray Icons
      Repeater {
        id: trayRepeater
        model: SystemTray.items

        Rectangle {
          id: trayItemContainer
          Layout.preferredWidth: 35
          Layout.fillHeight: true
          color: "transparent"
          radius: 6
          transformOrigin: Item.Center

          visible: modelData.icon !== ""
          property var trayItem: modelData

          Image {
            id: trayIcon
            anchors.centerIn: parent
            width: 25
            height: 25
            source: trayItemContainer.trayItem?.icon || ""

            ToolTip {
              id: trayTooltip
              visible: trayTooltipArea.containsMouse && trayItemContainer.trayItem?.tooltipTitle
              text: trayItemContainer.trayItem?.tooltipTitle || ""
              delay: 1000
            }
          }

          MouseArea {
            id: trayTooltipArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

            onEntered: trayItemContainer.scale = 1.1
            onExited: trayItemContainer.scale = 1.0
            onPressed: trayItemContainer.scale = 0.95
            onReleased: trayItemContainer.scale = containsMouse ? 1.1 : 1.0

            onClicked: function (mouse) {
              if (!trayItemContainer.trayItem)
              return;
              if (mouse.button === Qt.LeftButton) {
                trayItemContainer.trayItem.activate();
              } else if (mouse.button === Qt.RightButton) {
                if (trayItemContainer.trayItem.hasMenu && trayItemContainer.trayItem.menu) {
                  trayItemContainer.trayItem.display(root, mouse.x, mouse.y);
                }
              } else if (mouse.button === Qt.MiddleButton) {
                trayItemContainer.trayItem.secondaryActivate();
              }
            }

            onWheel: function (wheel) {
              if (!trayItemContainer.trayItem)
              return;
              trayItemContainer.trayItem.scroll(wheel.angleDelta.y, wheel.angleDelta.x !== 0);
            }
          }

          Behavior on scale {
            NumberAnimation {
              duration: 100
              easing.type: Easing.OutCubic
            }
          }
        }
      }

      Item {
        Layout.preferredWidth: trayRepeater.count > 0 ? 5 : 0
      }

      // Bluetooth
      Rectangle {
        id: bluetoothContainer
        Layout.preferredWidth: bluetoothContent.width
        Layout.fillHeight: true
        color: "transparent"
        radius: 6
        transformOrigin: Item.Center

        RowLayout {
          id: bluetoothContent
          anchors.centerIn: parent
          spacing: 8

          Image {
            id: bluetoothImage
            source: root.bluetooth_icon
            width: 35
            height: 35
            sourceSize: Qt.size(35, 35)
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          preventStealing: true

          onEntered: bluetoothContainer.scale = 1.1
          onExited: bluetoothContainer.scale = 1.0
          onPressed: bluetoothContainer.scale = 0.95
          onReleased: bluetoothContainer.scale = containsMouse ? 1.1 : 1.0
          onClicked: VisibleService.togglePanel("bluetooth")
        }

        Behavior on scale {
          NumberAnimation {
            duration: 100
            easing.type: Easing.OutCubic
          }
        }
      }

      Item {
        Layout.fillWidth: true
      }

      // Network Status
      Rectangle {
        id: networkContainer
        Layout.preferredWidth: networkContent.width
        Layout.fillHeight: true
        color: "transparent"
        radius: 6
        transformOrigin: Item.Center

        RowLayout {
          id: networkContent
          anchors.centerIn: parent
          spacing: 8

          Image {
            id: wifiImage
            source: networkService.wifi_icon
            width: 35
            height: 35
            sourceSize: Qt.size(35, 35)
          }

        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          preventStealing: true

          onEntered: networkContainer.scale = 1.1
          onExited: networkContainer.scale = 1.0
          onPressed: networkContainer.scale = 0.95
          onReleased: networkContainer.scale = containsMouse ? 1.1 : 1.0
          onClicked: VisibleService.togglePanel("wifi")
        }

        Behavior on scale {
          NumberAnimation {
            duration: 100
            easing.type: Easing.OutCubic
          }
        }
      }

      Item {
        Layout.fillWidth: true
      }

      // Volume
      Rectangle {
        id: volumeContainer
        Layout.preferredWidth: volumeContent.width
        Layout.fillHeight: true
        color: "transparent"
        radius: 6
        transformOrigin: Item.Center

        RowLayout {
          id: volumeContent
          anchors.centerIn: parent

          Image {
            id: volumeIcon
            source: isMuted || currentVolume === 0 ? Directories.assetsPath + "/volume/mute.png" : Directories.assetsPath + "/volume/volume.png"
            width: 35
            height: 35
            sourceSize: Qt.size(35, 35)
          }
          Text {
            text: isMuted ? "Muted" : Math.round(currentVolume * 100) + "%"
            color: theme.primary.foreground
            font {
              pixelSize: 16
              bold: true
            }
            verticalAlignment: Text.AlignVCenter
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          preventStealing: true

          onEntered: volumeContainer.scale = 1.1
          onExited: volumeContainer.scale = 1.0
          onPressed: volumeContainer.scale = 0.95
          onReleased: volumeContainer.scale = containsMouse ? 1.1 : 1.0
          onClicked: VisibleService.togglePanel("mixer")
          onWheel: {
            var delta = wheel.angleDelta.y / 120;
            if (delta > 0) {
              Qt.createQmlObject('import Quickshell; Process { command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"]; running: true }', root);
            } else {
              Qt.createQmlObject('import Quickshell; Process { command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"]; running: true }', root);
            }
          }
        }

        Behavior on scale {
          NumberAnimation {
            duration: 100
            easing.type: Easing.OutCubic
          }
        }
      }

      Item {
        Layout.fillWidth: true
      }

      // Battery
      Rectangle {
        id: batteryContainer
        Layout.preferredWidth: batteryContent.width
        Layout.fillHeight: true
        color: "transparent"
        radius: 6
        transformOrigin: Item.Center

        RowLayout {
          id: batteryContent
          anchors.centerIn: parent
          spacing: 8

          Image {
            id: batteryIcon
            source: Directories.assetsPath + '/battery/full.png'
            width: 30
            height: 30
            sourceSize: Qt.size(30, 30)
          }
          Text {
            text: root.capacity_battery + "%"
            color: theme.primary.foreground
            font {
              pixelSize: 16
              bold: true
            }
            verticalAlignment: Text.AlignVCenter
          }
        }

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
        Behavior on scale {
          NumberAnimation {
            duration: 100
          }
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
        radius: 6
        transformOrigin: Item.Center

        Image {
          id: powerIcon
          source: Directories.assetsPath + '/system/poweroff.png'
          width: 30
          height: 30
          sourceSize: Qt.size(30, 30)
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
      spacing: 8

      // System Tray Icons (vertical)
      Item {
        Layout.fillWidth: true
        Layout.preferredHeight: contentVerticalTray.height

        // Xoay container cho tray icons
        Item {
          anchors.centerIn: parent
          width: parent.height
          height: parent.width
          transformOrigin: Item.Center

          ColumnLayout {
            id: contentVerticalTray
            anchors.centerIn: parent
            spacing: 4

            Repeater {
              model: SystemTray.items

              Rectangle {
                id: trayItemContainerVertical
                Layout.preferredWidth: 25
                Layout.preferredHeight: 25
                color: "transparent"
                radius: 4

                visible: modelData.icon !== ""
                property var trayItem: modelData

                Image {
                  anchors.centerIn: parent
                  width: 20
                  height: 20
                  source: trayItemContainerVertical.trayItem?.icon || ""
                }

                MouseArea {
                  anchors.fill: parent
                  hoverEnabled: true
                  cursorShape: Qt.PointingHandCursor

                  onEntered: trayItemContainerVertical.scale = 1.1
                  onExited: trayItemContainerVertical.scale = 1.0
                  onClicked: function (mouse) {
                    if (!trayItemContainerVertical.trayItem)
                    return;
                    if (mouse.button === Qt.LeftButton) {
                      trayItemContainerVertical.trayItem.activate();
                    }
                  }
                }

                Behavior on scale {
                  NumberAnimation {
                    duration: 100
                  }
                }
              }
            }
          }
        }
      }

      // Bluetooth (vertical)
      Item {
        width: 25
        height: 25
        Item {
          anchors.centerIn: parent
          width: parent.height
          height: parent.width
          transformOrigin: Item.Center

          Image {
            id: bluetoothImageVertical
            anchors.centerIn: parent
            source: root.bluetooth_icon
            width: 25
            height: 25
            sourceSize: Qt.size(25, 25)
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: VisibleService.togglePanel("bluetooth")
          onEntered: parent.opacity = 0.8
          onExited: parent.opacity = 1.0
        }

        Behavior on opacity {
          NumberAnimation {
            duration: 100
          }
        }
      }

      // Network (vertical - chỉ icon)
      Item {
        width: 25
        height: 25

        Item {
          anchors.centerIn: parent
          width: parent.height
          height: parent.width
          transformOrigin: Item.Center

          ColumnLayout {
            anchors.centerIn: parent
            spacing: 2

            Image {
              id: wifiImageVertical
              source: networkService.wifi_icon
              width: 25
              height: 25
              sourceSize: Qt.size(25, 25)
              Layout.alignment: Qt.AlignHCenter
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: VisibleService.togglePanel("wifi")
          onEntered: parent.opacity = 0.8
          onExited: parent.opacity = 1.0
        }

        Behavior on opacity {
          NumberAnimation {
            duration: 100
          }
        }
      }

      // Volume (vertical)
      Item {
        width: 25
        height: 25

        Item {
          anchors.centerIn: parent
          width: parent.height
          height: parent.width
          transformOrigin: Item.Center

          ColumnLayout {
            anchors.centerIn: parent
            spacing: 2

            Image {
              id: volumeIconVertical
              source: isMuted || currentVolume === 0 ? Directories.assetsPath + "/volume/mute.png" : Directories.assetsPath + "/volume/volume.png"
              width: 25
              height: 25
              sourceSize: Qt.size(25, 25)
              Layout.alignment: Qt.AlignHCenter
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: VisibleService.togglePanel("mixer")
          onEntered: parent.opacity = 0.8
          onExited: parent.opacity = 1.0
          onWheel: {
            var delta = wheel.angleDelta.y / 120;
            if (delta > 0) {
              Qt.createQmlObject('import Quickshell; Process { command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"]; running: true }', root);
            } else {
              Qt.createQmlObject('import Quickshell; Process { command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"]; running: true }', root);
            }
          }
        }

        Behavior on opacity {
          NumberAnimation {
            duration: 100
          }
        }
      }

      // Battery (vertical)
      Item {
        width: 25
        height: 25

        Item {
          anchors.centerIn: parent
          width: parent.height
          height: parent.width
          transformOrigin: Item.Center

          ColumnLayout {
            anchors.centerIn: parent
            spacing: 2

            Image {
              id: batteryIconVertical
              source: Directories.assetsPath + '/battery/full.png'
              width: 25
              height: 25
              sourceSize: Qt.size(25, 25)
              Layout.alignment: Qt.AlignHCenter
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: VisibleService.togglePanel("battery")
          onEntered: parent.opacity = 0.8
          onExited: parent.opacity = 1.0
        }

        Behavior on opacity {
          NumberAnimation {
            duration: 100
          }
        }
      }

      // Power (vertical)
      Item {
        width: 25
        height: 25

        Item {
          anchors.centerIn: parent
          width: parent.height
          height: parent.width
          transformOrigin: Item.Center

          Image {
            id: powerIconVertical
            anchors.centerIn: parent
            source: Directories.assetsPath + '/system/poweroff.png'
            width: 25
            height: 25
            sourceSize: Qt.size(25, 25)
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

  // Initialization & Timers
  Component.onCompleted: {
    updateBatteryCappacityProcess();
    if (!batteryStatusProcess.running) {
      batteryStatusProcess.running = true;
    }
  }

  Timer {
    interval: 30000
    running: true
    repeat: true
    onTriggered: updateBatteryCappacityProcess()
  }

  Timer {
    interval: 10000
    running: true
    repeat: true
    onTriggered: {
      if (!batteryStatusProcess.running) {
        batteryStatusProcess.running = true;
      }
    }
  }
}
