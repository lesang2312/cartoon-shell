import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.services
import qs.commons
import qs.components

// Import các thành phần phụ trong cùng thư mục
import "../../../components/" as Components
import "./" as LauncherComponents

PanelWindow {
  id: launcherPanel
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

  implicitWidth: {
    if (VisibleService.setting) {
      return 1000;
    } else {
      if (launcherPanel.animationProgress > 0.1) {
        return 600;
      } else {
        return 100;
      }
    }
  }
  implicitHeight: {
    if (VisibleService.setting) {
      return 700;
    } else {
      if (launcherPanel.animationProgress > 0.1) {
        return 640;
      } else {
        return 100;
      }
    }
  }
  Behavior on implicitWidth {
    NumberAnimation {
      duration: 50
      easing.type: Easing.OutCubic

    }
  }
  Behavior on implicitHeight {
    NumberAnimation {
      duration: 100
      easing.type: Easing.OutCubic
    }
  }
  color: "transparent"
  focusable: true

  signal confirmRequested(string action, string actionLabel)

  Behavior on width {
    NumberAnimation {
      duration: 10
    }
  }
  Behavior on height {
    NumberAnimation {
      duration: 10
    }
  }

  property var theme: ThemeService.theme
  property bool settingsPanelVisible: false
  property var lang: LanguageService.translations
  property bool launcherPanelVisible: true

  // Sửa hàm closePanel

  function togglePanel() {
    launcherPanel.visible = !launcherPanel.visible;
    if (launcherPanel.visible) {
      openLauncher();
    }
  }

  anchors {
    // Xác định vị trí anchor dựa trên position của bar
    left: (Settings.bar.position === "left" || Settings.bar.position === "top" || Settings.bar.position === "bottom")
    right: Settings.bar.position === "right"
    top: (Settings.bar.position === "top" || Settings.bar.position === "left" || Settings.bar.position === "right")
    bottom: Settings.bar.position === "bottom"
  }

  margins {
    top: Settings.bar.position === "top" ? 10 : 0
    bottom: Settings.bar.position === "bottom" ? 10 : 0
    left: (Settings.bar.position === "left" || Settings.bar.position === "top" || Settings.bar.position === "bottom") ? 10 : 0
    right: Settings.bar.position === "right" ? 10 : 0
  }

  // Focus scope để quản lý focus
  Rectangle {
    anchors.fill: parent
    radius: 12
    color: theme.primary.background
    border.color: theme.button.border
    border.width: 3
    ColumnLayout {
      anchors.fill: parent
      Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
        RowLayout {
          anchors.fill: parent
          anchors.margins: {
            if (VisibleService.fullsetting && settingsPanelVisible) {
              return 20; // Margin lớn hơn khi full screen
            }
            return 16;
          }
          spacing: 12

          LauncherComponents.Sidebar {
            id: sidebar
            visible: !(VisibleService.fullsetting && VisibleService.setting)
            onConfirmRequested: (action, actionLabel) => {
              launcherPanel.confirmRequested(action, actionLabel);
            }
          }

          Loader {
            id: settingsPanelLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            active: VisibleService.setting
            source: "../settings/SettingsPanel.qml"
            onLoaded: {
              item.launcherPanel = launcherPanel;
              item.visible = Qt.binding(function () {
                  return VisibleService.setting;
              });
            }
          }

          ColumnLayout {
            visible: !VisibleService.setting
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            CustomText{
              text: lang.system.application
              isBold: true
              Layout.alignment: Qt.AlignHCenter
              size: "2xl"
              opacity: launcherPanel.animationProgress > 0.2 ? 1 : 0
              Behavior on opacity {
                NumberAnimation {
                  duration: 200
                }
              }

            }

            LauncherComponents.LauncherSearch {
              id: searchBox
              onSearchChanged: text => launcherList.runSearch(text)
              onAccepted: text => launcherList.runSearch(text)
              opacity: launcherPanel.animationProgress > 0.3 ? 1 : 0
              Behavior on opacity {
                NumberAnimation {
                  duration: 200
                }
              }
            }

            LauncherComponents.LauncherList {
              id: launcherList
              Layout.fillWidth: true
              Layout.fillHeight: true
              opacity: launcherPanel.animationProgress > 0.4 ? 1 : 0
              Behavior on opacity {
                NumberAnimation {
                  duration: 200
                }
              }
            }
          }
        }
      }
    }
  }

  // Khi panel trở nên visible, focus vào search field
  onVisibleChanged: {
    if (visible && launcherPanelVisible) {
      Qt.callLater(function () {
          if (searchBox && searchBox.searchField) {
            searchBox.searchField.forceActiveFocus();
            searchBox.searchField.selectAll();
          }
      });
    }
  }

  Shortcut {
    sequence: "Escape"
    onActivated: VisibleService.togglePanel("launcher")
  }

  Component.onCompleted: {
    // Đảm bảo panel không visible khi khởi động
    visible = false;
  }

}
