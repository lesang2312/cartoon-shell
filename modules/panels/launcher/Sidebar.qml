import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import qs.services
import qs.components
import qs.commons

Rectangle {
  id: root
  Layout.preferredWidth: ScalerService.s(210)
  property real animationProgress: 0

  SequentialAnimation on animationProgress {
    running: true

    NumberAnimation {
      from: 0
      to: 0.8
      duration: 400
      easing.type: Easing.Linear
    }
  }
  Layout.fillHeight: true
  color: theme.primary.dim_background
  border.color: theme.button.border
  radius: ScalerService.s(Settings.appearance.radius2)
  border.width: Settings.appearance.enableBorder ? ScalerService.s(2) : 0

  signal confirmRequested(string action, string actionLabel)

  function showConfirmDialog(action, actionLabel) {
    // Emit signal để parent components xử lý
    confirmRequested(action, actionLabel);
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: ScalerService.s(12)
    spacing: ScalerService.s(10)

    // Tiêu đề Menu
    Rectangle {
      id: launcherButton
      opacity: root.animationProgress > 0.1 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
      Layout.fillWidth: true
      Layout.preferredHeight: ScalerService.s(60)
      color: mouseAreaLauncher.containsMouse ? theme.button.background_select : theme.button.background
      border.color: mouseAreaLauncher.containsPress ? theme.button.border_select : theme.button.border
      border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0
      radius: ScalerService.s(Settings.appearance.radius3)

      scale: mouseAreaLauncher.containsPress ? 0.98 : 1.0
      Behavior on scale {
        NumberAnimation {
          duration: 100
        }
      }
      Behavior on color {
        ColorAnimation {
          duration: 200
        }
      }
      Behavior on border.color {
        ColorAnimation {
          duration: 100
        }
      }

      RowLayout {
        anchors.fill: parent
        anchors.margins: ScalerService.s(8)

        IconImage {
          path: "launcher/dashboard"
          rotation: mouseAreaLauncher.containsMouse ? 0 : 90
          Behavior on rotation {
            NumberAnimation {
              duration: 500
              easing.type: Easing.OutCubic
            }
          }
        }

        CustomText {
          text: lang.system.application
          scale: mouseAreaLauncher.containsMouse ? 1.05 : 1.0
          textColor: mouseAreaLauncher.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
          isBold: mouseAreaLauncher.containsMouse
          size: "small"
          Behavior on scale {
            NumberAnimation {
              duration: 200
            }
          }
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }

        Item {
          Layout.fillWidth: true
        }

        // Indicator khi selected
        Rectangle {
          Layout.preferredWidth: ScalerService.s(4)
          Layout.preferredHeight: ScalerService.s(20)
          radius: ScalerService.s(2)
          color: theme.normal.green
          visible: false // Sẽ được điều khiển bởi trạng thái selected
          opacity: mouseAreaLauncher.containsMouse ? 1.0 : 0.8

          scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
          Behavior on scale {
            NumberAnimation {
              duration: 300
              easing.type: Easing.OutBack
            }
          }
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
      }

      MouseArea {
        id: mouseAreaLauncher
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          VisibleService.togglePanel("listLauncher");
        }
      }
    }

    // Cài đặt
    Rectangle {
      id: settingsButton
      opacity: root.animationProgress > 0.2 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
      Layout.fillWidth: true
      Layout.preferredHeight: ScalerService.s(60)
      border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0
      radius: ScalerService.s(Settings.appearance.radius3)
      color: mouseAreaSettings.containsMouse ? theme.button.background_select : theme.button.background
      border.color: mouseAreaSettings.containsPress ? theme.button.border_select : theme.button.border

      scale: mouseAreaSettings.containsPress ? 0.98 : 1.0
      Behavior on scale {
        NumberAnimation {
          duration: 100
        }
      }
      Behavior on color {
        ColorAnimation {
          duration: 200
        }
      }
      Behavior on border.color {
        ColorAnimation {
          duration: 100
        }
      }

      RowLayout {
        anchors.fill: parent
        anchors.margins: ScalerService.s(8)

        IconImage {
          path: "system/setting.png"
          rotation: mouseAreaSettings.containsMouse ? 360 : 0
          Behavior on rotation {
            NumberAnimation {
              duration: 500
              easing.type: Easing.OutCubic
            }
          }
        }

        CustomText {
          text: lang.settings.title
          textColor: mouseAreaSettings.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
          isBold: mouseAreaSettings.containsMouse
          size: "small"
          scale: mouseAreaSettings.containsMouse ? 1.05 : 1.0
          Behavior on scale {
            NumberAnimation {
              duration: 200
            }
          }
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }

        Item {
          Layout.fillWidth: true
        }

        // Indicator khi selected
        Rectangle {
          Layout.preferredWidth: ScalerService.s(4)
          Layout.preferredHeight: ScalerService.s(20)
          radius: ScalerService.s(2)
          color: theme.normal.blue
          visible: false // Sẽ được điều khiển bởi trạng thái selected
          opacity: mouseAreaSettings.containsMouse ? 1.0 : 0.8

          scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
          Behavior on scale {
            NumberAnimation {
              duration: 300
              easing.type: Easing.OutBack
            }
          }
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
      }

      MouseArea {
        id: mouseAreaSettings
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          VisibleService.togglePanel("setting");
        }
      }
    }

    // Chế độ ngủ
    Rectangle {
      id: sleepButton
      opacity: root.animationProgress > 0.3 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
      Layout.fillWidth: true
      Layout.preferredHeight: ScalerService.s(60)
      color: mouseAreaSleep.containsMouse ? theme.button.background_select : theme.button.background
      border.color: mouseAreaSleep.containsPress ? theme.button.border_select : theme.button.border
      border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0
      radius: ScalerService.s(Settings.appearance.radius3)

      scale: mouseAreaSleep.containsPress ? 0.98 : 1.0
      Behavior on scale {
        NumberAnimation {
          duration: 100
        }
      }
      Behavior on color {
        ColorAnimation {
          duration: 200
        }
      }
      Behavior on border.color {
        ColorAnimation {
          duration: 100
        }
      }

      RowLayout {
        anchors.fill: parent
        anchors.margins: ScalerService.s(8)

        IconImage {
          path: "system/sys-sleep.png"
          rotation: mouseAreaSleep.containsMouse ? 5 : 0
          Behavior on rotation {
            NumberAnimation {
              duration: 200
            }
          }
        }

        CustomText {
          text: lang.system.sleep
          textColor: mouseAreaSleep.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
          isBold: mouseAreaSleep.containsMouse
          size: "small"
          scale: mouseAreaSleep.containsMouse ? 1.05 : 1.0
          Behavior on scale {
            NumberAnimation {
              duration: 200
            }
          }
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }

        Item {
          Layout.fillWidth: true
        }

        // Indicator khi selected
        Rectangle {
          Layout.preferredWidth: ScalerService.s(4)
          Layout.preferredHeight: ScalerService.s(20)
          radius: ScalerService.s(2)
          color: theme.normal.blue
          visible: false // Sẽ được điều khiển bởi trạng thái selected
          opacity: mouseAreaSleep.containsMouse ? 1.0 : 0.8

          scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
          Behavior on scale {
            NumberAnimation {
              duration: 300
              easing.type: Easing.OutBack
            }
          }
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
      }

      MouseArea {
        id: mouseAreaSleep
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          showConfirmDialog("sleep", lang?.confirm?.sleep || "chuyển sang chế độ ngủ");
        }
      }
    }

    // Khóa màn hình
    Rectangle {
      opacity: root.animationProgress > 0.4 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
      id: lockButton
      Layout.fillWidth: true
      Layout.preferredHeight: ScalerService.s(60)
      color: mouseAreaLock.containsMouse ? theme.button.background_select : theme.button.background
      border.color: mouseAreaLock.containsPress ? theme.button.border_select : theme.button.border
      border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0
      radius: ScalerService.s(Settings.appearance.radius3)

      scale: mouseAreaLock.containsPress ? 0.98 : 1.0
      Behavior on scale {
        NumberAnimation {
          duration: 100
        }
      }
      Behavior on color {
        ColorAnimation {
          duration: 200
        }
      }
      Behavior on border.color {
        ColorAnimation {
          duration: 100
        }
      }

      RowLayout {
        anchors.fill: parent
        anchors.margins: ScalerService.s(8)

        IconImage {
          path: "system/sys-lock.png"
          rotation: mouseAreaLock.containsMouse ? 5 : 0
          Behavior on rotation {
            NumberAnimation {
              duration: 200
            }
          }
        }

        CustomText {
          text: lang.system.lock
          textColor: mouseAreaLock.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
          isBold: mouseAreaLock.containsMouse
          size: "small"
          scale: mouseAreaLock.containsMouse ? 1.05 : 1.0
          Behavior on scale {
            NumberAnimation {
              duration: 200
            }
          }
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }

        Item {
          Layout.fillWidth: true
        }

        // Indicator khi selected
        Rectangle {
          Layout.preferredWidth: ScalerService.s(4)
          Layout.preferredHeight: ScalerService.s(20)
          radius: ScalerService.s(2)
          color: theme.normal.blue
          visible: false // Sẽ được điều khiển bởi trạng thái selected
          opacity: mouseAreaLock.containsMouse ? 1.0 : 0.8

          scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
          Behavior on scale {
            NumberAnimation {
              duration: 300
              easing.type: Easing.OutBack
            }
          }
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
      }

      MouseArea {
        id: mouseAreaLock
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          showConfirmDialog("lock", lang?.confirm?.lock || "khóa màn hình");
        }
      }
    }

    // Đăng xuất
    Rectangle {
      opacity: root.animationProgress > 0.5 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
      id: logoutButton
      Layout.fillWidth: true
      Layout.preferredHeight: ScalerService.s(60)
      color: mouseAreaLogout.containsMouse ? theme.button.background_select : theme.button.background
      border.color: mouseAreaLogout.containsPress ? theme.button.border_select : theme.button.border
      border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0
      radius: ScalerService.s(Settings.appearance.radius3)

      scale: mouseAreaLogout.containsPress ? 0.98 : 1.0
      Behavior on scale {
        NumberAnimation {
          duration: 100
        }
      }
      Behavior on color {
        ColorAnimation {
          duration: 200
        }
      }
      Behavior on border.color {
        ColorAnimation {
          duration: 100
        }
      }

      RowLayout {
        anchors.fill: parent
        anchors.margins: ScalerService.s(8)

        IconImage {
          path: "system/sys-exit.png"
          rotation: mouseAreaLogout.containsMouse ? -5 : 0
          Behavior on rotation {
            NumberAnimation {
              duration: 200
            }
          }
        }

        CustomText {
          text: lang.system.logout
          textColor: mouseAreaLogout.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
          isBold: mouseAreaLogout.containsMouse
          size: "small"
          scale: mouseAreaLogout.containsMouse ? 1.05 : 1.0
          Behavior on scale {
            NumberAnimation {
              duration: 200
            }
          }
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }

        Item {
          Layout.fillWidth: true
        }

        // Indicator khi selected
        Rectangle {
          Layout.preferredWidth: ScalerService.s(4)
          Layout.preferredHeight: ScalerService.s(20)
          radius: ScalerService.s(2)
          color: theme.normal.blue
          visible: false // Sẽ được điều khiển bởi trạng thái selected
          opacity: mouseAreaLogout.containsMouse ? 1.0 : 0.8

          scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
          Behavior on scale {
            NumberAnimation {
              duration: 300
              easing.type: Easing.OutBack
            }
          }
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
      }

      MouseArea {
        id: mouseAreaLogout
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          showConfirmDialog("logout", lang?.confirm?.logout || "đăng xuất");
        }
      }
    }

    // Khởi động lại
    Rectangle {
      id: restartButton
      opacity: root.animationProgress > 0.6 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
      Layout.fillWidth: true
      Layout.preferredHeight: ScalerService.s(60)
      color: mouseAreaRestart.containsMouse ? theme.button.background_select : theme.button.background
      border.color: mouseAreaRestart.containsPress ? theme.button.border_select : theme.button.border
      border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0
      radius: ScalerService.s(Settings.appearance.radius3)

      scale: mouseAreaRestart.containsPress ? 0.98 : 1.0
      Behavior on scale {
        NumberAnimation {
          duration: 100
        }
      }
      Behavior on color {
        ColorAnimation {
          duration: 200
        }
      }
      Behavior on border.color {
        ColorAnimation {
          duration: 100
        }
      }

      RowLayout {
        anchors.fill: parent
        anchors.margins: ScalerService.s(8)

        IconImage {
          path: "system/sys-reboot.png"
          rotation: mouseAreaRestart.containsMouse ? 180 : 0
          Behavior on rotation {
            NumberAnimation {
              duration: 400
              easing.type: Easing.InOutCubic
            }
          }
        }

        CustomText {
          text: lang.system.restart
          textColor: mouseAreaRestart.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
          isBold: mouseAreaRestart.containsMouse
          size: "small"
          scale: mouseAreaRestart.containsMouse ? 1.05 : 1.0
          Behavior on scale {
            NumberAnimation {
              duration: 200
            }
          }
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }

        Item {
          Layout.fillWidth: true
        }

        // Indicator khi selected
        Rectangle {
          Layout.preferredWidth: ScalerService.s(4)
          Layout.preferredHeight: ScalerService.s(20)
          radius: ScalerService.s(2)
          color: theme.normal.blue
          visible: false // Sẽ được điều khiển bởi trạng thái selected
          opacity: mouseAreaRestart.containsMouse ? 1.0 : 0.8

          scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
          Behavior on scale {
            NumberAnimation {
              duration: 300
              easing.type: Easing.OutBack
            }
          }
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
      }

      MouseArea {
        id: mouseAreaRestart
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          showConfirmDialog("restart", lang?.confirm?.restart || "khởi động lại");
        }
      }
    }

    // Tắt máy
    Rectangle {
      opacity: root.animationProgress > 0.7 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
      id: shutdownButton
      Layout.fillWidth: true
      Layout.preferredHeight: ScalerService.s(60)
      color: mouseAreaShutdown.containsMouse ? theme.button.background_select : theme.button.background
      border.color: mouseAreaShutdown.containsPress ? theme.button.border_select : theme.button.border
      border.width: Settings.appearance.enableBorder ? ScalerService.s(1) : 0
      radius: ScalerService.s(Settings.appearance.radius3)

      scale: mouseAreaShutdown.containsPress ? 0.98 : 1.0
      Behavior on scale {
        NumberAnimation {
          duration: 100
        }
      }
      Behavior on color {
        ColorAnimation {
          duration: 200
        }
      }
      Behavior on border.color {
        ColorAnimation {
          duration: 100
        }
      }

      RowLayout {
        anchors.fill: parent
        anchors.margins: ScalerService.s(8)

        IconImage {
          path: "system/poweroff.png"
          scale: mouseAreaShutdown.containsMouse ? 1.1 : 1.0
          Behavior on scale {
            NumberAnimation {
              duration: 200
            }
          }
        }

        CustomText {
          text: lang.system.shutdown
          textColor: mouseAreaShutdown.containsMouse ? theme.primary.bright_foreground : theme.primary.foreground
          isBold: mouseAreaShutdown.containsMouse
          size: "small"
          scale: mouseAreaShutdown.containsMouse ? 1.05 : 1.0
          Behavior on scale {
            NumberAnimation {
              duration: 200
            }
          }
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }

        Item {
          Layout.fillWidth: true
        }

        // Indicator khi selected
        Rectangle {
          Layout.preferredWidth: ScalerService.s(4)
          Layout.preferredHeight: ScalerService.s(20)
          radius: ScalerService.s(2)
          color: theme.normal.blue
          visible: false // Sẽ được điều khiển bởi trạng thái selected
          opacity: mouseAreaShutdown.containsMouse ? 1.0 : 0.8

          scale: false ? 1.0 : 0.0 // Thay false bằng điều kiện selected thực tế
          Behavior on scale {
            NumberAnimation {
              duration: 300
              easing.type: Easing.OutBack
            }
          }
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
      }

      MouseArea {
        id: mouseAreaShutdown
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          showConfirmDialog("shutdown", lang?.confirm?.shutdown || "tắt máy");
        }
      }
    }

    Item {
      Layout.fillHeight: true
    }
  }
}
