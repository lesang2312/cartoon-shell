import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

Rectangle {
  id: root

  property string image: ""
  property string value: "Value"

  radius: 16
  color: theme.primary.dim_background
  border.color: theme.primary.foreground
  border.width: 1

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 15
    spacing: 10

    IconImage{
      path: root.image
      size: "large"
      Layout.alignment: Qt.AlignHCenter

    }
    CustomText{
      name: root.value
      isBold: true
      size: "small"
      Layout.alignment: Qt.AlignHCenter
    }
  }
}
