import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.commons

Item {
  id: root

  property string path: ""
  property string size: "normal"  // xs | small | normal | large | xl
  property bool isVertical: Settings.bar.position === "left"
  || Settings.bar.position === "right"

  // Fixed size based on size property
  implicitWidth: iconSize
  implicitHeight: iconSize

  readonly property int iconSize: {
    switch (size) {
      case "xs": return 12
      case "small": return 16
      case "normal": return 32
      case "large": return 40
      case "xl": return 50
      default: return 32
    }
  }

  Image {
    id: iconImage
    property bool hovered: false

    anchors.fill: parent
    anchors.margins: 2

    source: Directories.assetsPath + "/" + root.path
    fillMode: Image.PreserveAspectFit
    smooth: true
    mipmap: true

    scale: hovered ? 1.2 : 1.0

    Behavior on scale {
      NumberAnimation {
        duration: 150
        easing.type: Easing.OutQuad
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor

      onEntered: iconImage.hovered = true
      onExited: iconImage.hovered = false

      onClicked: {
        root.clicked()
      }
    }
  }

  signal clicked()
}
