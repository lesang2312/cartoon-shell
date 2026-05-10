import QtQuick

Item {
  id: root

  // Properties
  property string name: "undefined"
  property string size: "normal"  // xs | small | normal | large | xl
  property bool hovered: false
  property color textColor: theme.primary.foreground
  property string fontFamily: "Material Symbols Rounded"

  // Fixed size based on the maximum (hovered) size
  implicitWidth: maxSize
  implicitHeight: maxSize

  // Calculate max size to prevent layout shifting
  readonly property int maxSize: {
    switch (size) {
      case "xs": return 20     // Max hovered size
      case "small": return 26  // Max hovered size
      case "normal": return 40 // Max hovered size
      case "large": return 58  // Max hovered size
      case "xl": return 72     // Max hovered size
      default: return 46       // Max hovered size
    }
  }

  Text {
    id: iconText
    anchors.centerIn: parent

    // Font configuration
    font.variableAxes: { "FILL": 1 }
    renderType: Text.NativeRendering
    font.family: root.fontFamily

    // Bind to root properties
    text: root.name
    color: root.hovered ? Qt.lighter(root.textColor, 1.2) : root.textColor

    // Smooth animations
    Behavior on font.pixelSize {
      NumberAnimation {
        duration: 150
        easing.type: Easing.OutQuad
      }
    }

    Behavior on color {
      ColorAnimation { duration: 150 }
    }

    // Dynamic pixel size based on hover state
    font.pixelSize: {
      switch (root.size) {
        case "xs":
        return root.hovered ? 20 : 16
        case "small":
        return root.hovered ? 26 : 22
        case "normal":
        return root.hovered ? 42 : 38
        case "large":
        return root.hovered ? 58 : 52
        case "xl":
        return root.hovered ? 72 : 64
        default:
        return root.hovered ? 46 : 40
      }
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
