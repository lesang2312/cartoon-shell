import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import qs.services
import qs.components
import qs.commons

Rectangle {
  id: root
  property int count: 230
  property int index: 0

  Layout.fillWidth: true
  Layout.fillHeight: true
  color: theme.primary.background
  radius: Settings.appearance.radius1
  border.width: Settings.appearance.enableBorder ? 3 : 0
  border.color: theme.button.border
  opacity: 0

  SequentialAnimation on index {
    running: root.animationProgress > 0.9

    PauseAnimation {
      duration: 200
    }

    NumberAnimation {
      to: root.count
      duration: 400
      easing.type: Easing.OutCubic
    }
  }
  property real animationProgress: 0
  Behavior on opacity {
    NumberAnimation {
      duration: 200
    }
  }

  RowLayout {
    anchors.centerIn: parent
    spacing: 20

    IconImage {
      path: "workspace/pacman.png"
      size: "xl"
      opacity: root.animationProgress > 0.8 ? 1 : 0
    }

    CustomText{
      name: index
      isBold: true
      opacity: root.animationProgress > 0.85 ? 1 : 0
    }
  }
  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onClicked: {
      VisibleService.togglePanel("packagePanel")
    }
  }
}
