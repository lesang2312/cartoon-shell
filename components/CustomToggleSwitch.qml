import QtQuick

Rectangle {
  id: root
  width: 56
  height: 32
  implicitWidth: 56
  implicitHeight: 32
  radius: 16
  color: adapter ? theme.button.text : theme.button.background

  scale: toggleMouseArea.containsPress ? 0.95 : (toggleMouseArea.containsMouse ? 1.05 : 1.0)
  property bool adapter: true
  signal clicked()

  Behavior on scale {
    NumberAnimation {
      duration: 150
      easing.type: Easing.OutBack
    }
  }
  Behavior on color {
    ColorAnimation {
      duration: 300
    }
  }
  Behavior on opacity {
    NumberAnimation {
      duration: 200
    }
  }

  Rectangle {
    id: toggleIndicator
    x: root.adapter ? parent.width - width - 4 : 4
    y: 4
    width: 24
    height: 24
    radius: 24 / 2
    color: theme.primary.dim_background
    border.width: 1
    border.color: theme.normal.black

    Behavior on x {
      NumberAnimation {
        duration: 200
        easing.type: Easing.OutCubic
      }
    }
  }

  MouseArea {
    id: toggleMouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
