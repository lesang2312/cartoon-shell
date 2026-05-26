// components/Settings/SettingsPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "." as Com
import qs.services
import qs.commons

Rectangle {
  id: rootSettings
  property var launcherPanel: null  // Reference to LauncherPanel
  property int currentTab: 0
  signal backRequested

  color: theme.primary.background

  // Shadow effect
  layer.enabled: true

  RowLayout {
    anchors.fill: parent
    spacing: 20

    // Sidebar
    Com.Sidebar {
      onCategoryChanged: function (index) {
        rootSettings.currentTab = 0;
        settingsStack.currentIndex = index;
      }
      onBackRequested: function () {
        rootSettings.backRequested();
      }
      Layout.fillHeight: true
    }

    // Content Area
    Rectangle {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: theme.primary.dim_background
      radius: Settings.appearance.radius2
      border {
        color: theme.button.border
        width: Settings.appearance.enableBorder ? 2 : 0
      }
      StackLayout {
        id: settingsStack
        anchors.fill: parent
        anchors.margins: 8
        currentIndex: 0
        Loader {
          id: settingsGeneral
          Layout.fillWidth: true
          Layout.fillHeight: true
          active: settingsStack.currentIndex === 0
          source: "./General.qml"
          onLoaded: {
            item.visible = Qt.binding(function () {
                return settingsStack.currentIndex === 0;
            });
            item.currentTab = rootSettings.currentTab;
          }
        }
        Loader {
          id: settingsAppearance
          Layout.fillWidth: true
          Layout.fillHeight: true
          active: settingsStack.currentIndex === 1
          source: "./Appearance.qml"
          onLoaded: {
            item.visible = Qt.binding(function () {
                return settingsStack.currentIndex === 1;
            });
            item.currentTab = rootSettings.currentTab;
          }
        }

        // Network Settings
        Com.Network {}

        // Audio Settings
        Com.Audio {}

        // Performance Settings
        Com.Performance {}

        // Shortcuts Settings
        Com.Shortcuts {}

        // System Settings
        Com.System {}
      }
    }
  }
}
