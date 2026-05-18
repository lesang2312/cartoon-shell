import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

Rectangle {
  id: root

  property string image: ""
  property string value: "Value"
  property real animationProgress: 0
  property real revealThreshold: 0.6

  radius: 16
  color: theme.primary.dim_background
  border.color: theme.primary.foreground
  border.width: 1
  Behavior on opacity {
    NumberAnimation {
      duration: 200
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 15
    spacing: 10

    IconImage{
      path: root.image
      size: "large"
      Layout.alignment: Qt.AlignHCenter
      opacity: root.animationProgress > root.revealThreshold ? 1 : 0
    }
    CustomText{
      name: root.value
      isBold: true
      size: "small"
      Layout.alignment: Qt.AlignHCenter
      opacity: root.animationProgress > root.revealThreshold + 0.05 ? 1 : 0
    }
  }
}
