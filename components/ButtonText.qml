import QtQuick

Rectangle {
  id: root

  // Properties
  property string name: "undefined"
  property string size: "normal"  // xs | small | normal | large | xl
  property bool hovered: false
  property color textColor: theme.button.text
  property string fontFamily: "ComicShannsMono Nerd Font"

  radius: 8

  border.width: 1
  border.color: root.hovered ? theme.button.border_select : theme.button.border

  color: root.hovered ? theme.button.background_select : theme.button.background

  // Fixed size based on the size property (no hover effect)
  implicitWidth: iconText.width + 20
  implicitHeight: iconText.height + 5

  Text {
    id: iconText
    anchors.centerIn: parent

    // Font configuration
    font.family: root.fontFamily
    font.pixelSize: {
      switch (root.size) {
        case "xs": return 16
        case "small": return 22
        case "normal": return 38
        case "large": return 52
        case "xl": return 64
        default: return 40
      }
    }

    // Bind to root properties
    text: root.name
    color: root.hovered ? Qt.lighter(root.textColor, 1.2) : root.textColor

    // Smooth animation for color only
    Behavior on color {
      ColorAnimation { duration: 150 }
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onEntered: root.hovered = true
    onExited: root.hovered = false

    onClicked: {
      root.clicked()
    }
  }

  signal clicked()
}
