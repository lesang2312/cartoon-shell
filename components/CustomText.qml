import QtQuick

Text {
  property string name: "undefined"

  // xs | small | normal | large | xl
  property string size: "normal"

  property bool isBold: false
  property color textColor: theme.primary.foreground
  property string fontFamily: "ComicShannsMono Nerd Font"

  text: name
  color: textColor

  font.family: fontFamily
  font.bold: isBold

  font.pixelSize: {
    switch (size) {
      case "xs":
      return 12

      case "small":
      return 16

      case "normal":
      return 22

      case "large":
      return 32

      case "xl":
      return 40

      default:
      return 32
    }
  }
}
