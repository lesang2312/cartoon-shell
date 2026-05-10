import QtQuick

Text {
  property string name: "undefined"

  // xs | small | normal | large | xl
  property string size: "normal"

  property color textColor: theme.primary.foreground
  property string fontFamily: "Material Symbols Rounded"
  font.variableAxes: {
    "FILL": 1,
  }
  renderType: Text.NativeRendering

  text: name
  color: textColor

  font.family: fontFamily

  font.pixelSize: {
    switch (size) {
      case "xs":
      return 16

      case "small":
      return 22

      case "normal":
      return 32

      case "large":
      return 52

      case "xl":
      return 64

      default:
      return 40
    }
  }
}
