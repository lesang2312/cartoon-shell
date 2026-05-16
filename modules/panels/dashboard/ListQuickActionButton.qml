import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import qs.services
import qs.components

import "." as Com

ColumnLayout {
  Layout.preferredWidth: 90
  spacing: 15
  property var theme: ThemeService.theme
  RowLayout {
    spacing: 15
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 110
      radius: 28
      color: mouseAreaLogout.containsMouse ? theme.button.background_select : theme.primary.background
      border.color: mouseAreaLogout.containsPress ? theme.button.border_select : theme.button.border
      border.width: 3

      IconImage {
        path: "system/sys-exit.png"
        size: "2xl"
        rotation: mouseAreaLogout.containsMouse ? -5 : 0
        anchors.centerIn: parent

        Behavior on rotation {
          NumberAnimation {
            duration: 200
          }
        }
      }

      MouseArea {
        id: mouseAreaLogout
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {}
      }
    }

    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 110
      radius: 28
      color: mouseAreaSleep.containsMouse ? theme.button.background_select : theme.primary.background
      border.color: mouseAreaSleep.containsPress ? theme.button.border_select : theme.button.border
      border.width: 3

      IconImage {
        path: "system/sys-sleep.png"
        anchors.centerIn: parent
        size: "2xl"
        rotation: mouseAreaSleep.containsMouse ? 5 : 0
        Behavior on rotation {
          NumberAnimation {
            duration: 200
          }
        }
      }

      MouseArea {
        id: mouseAreaSleep
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {}
      }
    }
  }
  RowLayout {
    spacing: 15
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 110
      radius: 28
      color: mouseAreaRestart.containsMouse ? theme.button.background_select : theme.primary.background
      border.color: mouseAreaRestart.containsPress ? theme.button.border_select : theme.button.border
      border.width: 3

      IconImage {
        path: "system/sys-reboot.png"
        rotation: mouseAreaRestart.containsMouse ? 180 : 0
        anchors.centerIn: parent
        size: "2xl"
        Behavior on rotation {
          NumberAnimation {
            duration: 400
            easing.type: Easing.InOutCubic
          }
        }
      }

      MouseArea {
        id: mouseAreaRestart
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {}
      }
    }
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 110
      radius: 28
      color: mouseAreaShutdown.containsMouse ? theme.button.background_select : theme.primary.background
      border.color: mouseAreaShutdown.containsPress ? theme.button.border_select : theme.button.border
      border.width: 3

      IconImage {
        path: "system/poweroff.png"
        scale: mouseAreaShutdown.containsMouse ? 1.1 : 1
        anchors.centerIn: parent
        size: "2xl"
        Behavior on scale {
          NumberAnimation {
            duration: 200
            easing.type: Easing.InOutCubic
          }
        }
      }

      MouseArea {
        id: mouseAreaShutdown
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {}
      }
    }
  }
}
