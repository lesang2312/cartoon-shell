import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import qs.services
import qs.components
import qs.commons

import "." as Com

ColumnLayout {
  Layout.preferredWidth: ScalerService.s(90)
  spacing: ScalerService.s(15)
  property real animationProgress: 0
  RowLayout {
    spacing: ScalerService.s(15)
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: ScalerService.s(110)
      color: mouseAreaLogout.containsMouse ? theme.button.background_select : theme.primary.background
      border.color: mouseAreaLogout.containsPress ? theme.button.border_select : theme.button.border
      radius: ScalerService.s(Settings.appearance.radius1)
      border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0

      IconImage {
        path: "system/sys-exit.png"
        size: "2xl"
        rotation: mouseAreaLogout.containsMouse ? -5 : 0
        anchors.centerIn: parent
        opacity: root.animationProgress > 0.9 ? 1 : 0

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
      Layout.preferredHeight: ScalerService.s(110)
      color: mouseAreaSleep.containsMouse ? theme.button.background_select : theme.primary.background
      border.color: mouseAreaSleep.containsPress ? theme.button.border_select : theme.button.border
      radius: ScalerService.s(Settings.appearance.radius1)
      border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0

      IconImage {
        path: "system/sys-sleep.png"
        anchors.centerIn: parent
        size: "2xl"
        rotation: mouseAreaSleep.containsMouse ? 5 : 0
        opacity: root.animationProgress > 0.95 ? 1 : 0
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
    spacing: ScalerService.s(15)
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: ScalerService.s(110)
      color: mouseAreaRestart.containsMouse ? theme.button.background_select : theme.primary.background
      border.color: mouseAreaRestart.containsPress ? theme.button.border_select : theme.button.border
      radius: ScalerService.s(Settings.appearance.radius1)
      border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0

      IconImage {
        path: "system/sys-reboot.png"
        rotation: mouseAreaRestart.containsMouse ? 180 : 0
        anchors.centerIn: parent
        size: "2xl"
        opacity: root.animationProgress > 1 ? 1 : 0
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
      Layout.preferredHeight: ScalerService.s(110)
      color: mouseAreaShutdown.containsMouse ? theme.button.background_select : theme.primary.background
      border.color: mouseAreaShutdown.containsPress ? theme.button.border_select : theme.button.border
      radius: ScalerService.s(Settings.appearance.radius1)
      border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0

      IconImage {
        path: "system/poweroff.png"
        scale: mouseAreaShutdown.containsMouse ? 1.1 : 1
        anchors.centerIn: parent
        size: "2xl"
        opacity: root.animationProgress > 1.05 ? 1 : 0
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
