import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import qs.services

Rectangle {
  id: root
  property string iconSource: ""
  property color bgColor: "white"
  property real animationProgress: 0
  property real revealThreshold: 0.6

  Layout.fillWidth: true
  Layout.fillHeight: true
  radius: 18
  color: bgColor
  border.color: theme.button.border
  border.width: 3
  opacity: root.animationProgress > revealThreshold ? 1 : 0
  Behavior on opacity {
    NumberAnimation {
      duration: 200
    }
  }

  Image {
    anchors.centerIn: parent
    anchors.margins: 8
    width: parent.width * 0.6
    height: parent.height * 0.6
    source: "image://icon/" + root.iconSource
    fillMode: Image.PreserveAspectFit
    smooth: true
    visible: status === Image.Ready
    opacity: root.animationProgress > revealThreshold + 0.5 ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 200
      }
    }

    // Placeholder when no icon
    Text {
      anchors.centerIn: parent
      text: "?"
      color: theme.primary.dim_foreground
      font.pixelSize: 24
      font.family: "ComicShannsMono Nerd Font"
      visible: parent.status !== Image.Ready
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onEntered: {
      root.scale = 1.05;
    }

    onExited: {
      root.scale = 1.0;
    }

    Behavior on scale {
      NumberAnimation {
        duration: 150
        easing.type: Easing.OutCubic
      }
    }
  }

  Behavior on scale {
    NumberAnimation {
      duration: 150
      easing.type: Easing.OutCubic
    }
  }
}
