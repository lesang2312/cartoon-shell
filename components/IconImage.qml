import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.commons

Item {
  property var path: ""

  // xs | small | normal | large | xl
  property string size: "normal"

  property bool isVertical: Settings.bar.position === "left"
  || Settings.bar.position === "right"

  width: {
    switch (size) {
      case "xs":
      return 12

      case "small":
      return 16

      case "normal":
      return 32

      case "large":
      return 40

      case "xl":
      return 50

      case "2xl":
      return 64

      case "3xl":
      return 84

      default:
      return 32
    }
  }

  height: width

  Layout.preferredWidth: width
  Layout.preferredHeight: height

  Image {
    anchors.fill: parent
    anchors.margins: 2

    source: Directories.assetsPath + "/" + path

    fillMode: Image.PreserveAspectFit
    smooth: true
    mipmap: true
  }
}
