// components/PanelLoaders.qml
import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.panels
import qs.commons

Item {
    id: root

    Loader {
        source: "../modules/panels/WeatherTime/WtDetailPanel.qml"
        active: panelManager.calendar
        onLoaded: {
            item.visible = Qt.binding(function() { return panelManager.calendar })
        }
      }

    // Flag Selection Panel
    Loader {
        source: "../modules/panels/FlagSelectionPanel.qml"
        active: panelManager.flag
        onLoaded: {
            item.visible = Qt.binding(function() { return panelManager.flag })
            item.selectedFlag = Qt.binding(function() { return root.selectedFlag })
        }
      }

      
    property bool anchorsTop: Settings.clock.positionWidget === "top" || Settings.clock.positionWidget === "topLeft" || Settings.clock.positionWidget === "topRight"
    property bool anchorsBottom: Settings.clock.positionWidget === "bottom" || Settings.clock.positionWidget === "bottomLeft" || Settings.clock.positionWidget === "bottomRight"
    property bool anchorsRight: Settings.clock.positionWidget === "right" || Settings.clock.positionWidget === "topRight" || Settings.clock.positionWidget === "bottomRight"
    property bool anchorsLeft: Settings.clock.positionWidget === "left" || Settings.clock.positionWidget === "topLeft" || Settings.clock.positionWidget === "bottomLeft"


      ClockPanel {
        id: clockPanel
        visible: Settings.clock.enableWidget
        anchors {
        top: anchorsTop
        bottom: anchorsBottom
        left: anchorsLeft
        right: anchorsRight
    }
    }

    // Weather Panel
    Loader {
        source: "../modules/panels/weather/WeatherPanel.qml"
        active: panelManager.weather
        onLoaded: {
            item.visible = Qt.binding(function() { return panelManager.weather })
        }
      }
          Loader {
        source: "../modules/panels/cpu/CpuDetailPanel.qml"
        active: panelManager.cpu
        onLoaded: {
            item.visible = Qt.binding(function() { return panelManager.cpu })
        }
      }
      Loader {
        source: "../modules/panels/ram/RamDetailPanel.qml"
        active: panelManager.ram
        onLoaded: {
            item.visible = Qt.binding(function() { return panelManager.ram })
        }
      }
          Loader {
        active: panelManager.music
        source: "../modules/panels/MusicPanel.qml"
        onLoaded: {
            item.visible = panelManager.music
        }
      }
            Loader {
        source: "../modules/panels/WifiPanel/WifiPanel.qml"
        active: panelManager.wifi
        onLoaded: {
          item.visible = Qt.binding(function() { return panelManager.wifi})
        }
      }



      Loader {
        source: "../modules/panels/Bluetooth/BluetoothPanel.qml"
        active: panelManager.bluetooth
        onLoaded: {
          item.visible = Qt.binding(function() { return panelManager.bluetooth})
        }
      }

      Loader {
        source: "../modules/panels/Mixer/MixerPanel.qml"
        active: panelManager.mixer
        onLoaded: {
            item.visible = Qt.binding(function() { return panelManager.mixer })
        }
      }
      Loader {
        source: "../modules/panels/Battery/BatteryDetailPanel.qml"
        active: panelManager.battery
        onLoaded: {
            item.visible = Qt.binding(function() { return panelManager.battery })
        }
      }

      Loader {
        source: "../modules/panels/dashboard/DashboardPanel.qml"
        active: panelManager.dashboard
        onLoaded: {
            item.visible = Qt.binding(function() { return panelManager.dashboard })
        }
      }
      Loader {
        id: launcherPanelLoader
        source: "../modules/panels/Launcher/LauncherPanel.qml"
        active: panelManager.launcher
        onLoaded: {
            item.visible = panelManager.launcher
            item.confirmRequested.connect(function(action, actionLabel) {
                confirmDialog.show(action, actionLabel)
            })
        }
      }
      IpcHandler {
        id: ipc
        target: "rect"
        function getToggle() {
            if (launcherPanelLoader.status == Loader.Ready) {
                panelManager.launcher = !panelManager.launcher
                if (panelManager.launcher && launcherPanelLoader.item) {
                    launcherPanelLoader.item.forceActiveFocus()
                    launcherPanelLoader.item.openLauncher()
                }
            } else {
                panelManager.launcher = true
            }
            return 0
        }
    }
}

