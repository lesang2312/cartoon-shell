import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Effects

import qs.config
import qs.components
import qs.modules.dialogs
import qs.modules.panels
import qs.modules.bar
import qs.modules.background
import qs.services
import qs.commons

ShellRoot {
    id: root

    PanelManager { id: panelManager }
    PanelLoaders{ id: panelLoaders}

    ConfirmDialog {id: confirmDialog}

    // Function để hiển thị confirm dialog từ bất kỳ đâu
    function showConfirmDialog(action, actionLabel) {
        confirmDialog.show(action, actionLabel)
    }

    property bool settingsLoaded: false


PanelWindow {
    visible: panelManager.hasPanel
    color: "transparent"

    implicitWidth: (Settings.bar.position === "left" || Settings.bar.position === "right") ? Screen.width - 40 : Screen.width
    implicitHeight: (Settings.bar.position === "top" || Settings.bar.position === "bottom") ? Screen.height - 50 : Screen.height

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: panelManager.closeAllPanels()
    }
}
      Connections {
    target: Settings ? Settings : null
    function onSettingsLoaded() {
      root.settingsLoaded = true;
    }
  }
        Loader {
    active: root.settingsLoaded && Directories.ready
    sourceComponent: Item {
      Component.onCompleted: {
        ThemeService.init()
        WallpaperService.init();
        ProgramCheckerService.init();
        LanguageService.init();
      }

      Background {}
      Bar{}
      NotificationPopup{}
      VolumeOsd { }
    }
  }
}
