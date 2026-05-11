import QtQuick
import QtQuick.Layouts
import qs.components
Rectangle {
  id: root
  property var minTemp: ""
  property var maxTemp: ""
  property var dateText: ""
  property var dayName: ""
  property var icon: ""
  implicitWidth: 180
  Layout.fillHeight: true
  radius: 12
  color: theme.primary.dim_background
  border.color: theme.primary.foreground
  border.width: 1
  clip: true

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 16
    spacing: 8

    // Day name
    CustomText{
      name: root.dayName
      size: "normal"
      Layout.alignment: Qt.AlignHCenter

    }
    Item {Layout.fillWidth: true}

    // Date
    CustomText{
      name: root.dateText
      textColor: theme.primary.dim_foreground
      size: "normal"
      Layout.alignment: Qt.AlignHCenter

    }
    Item {Layout.fillWidth: true}

    // Weather icon
    IconImage {
      path: root.icon
      Layout.alignment: Qt.AlignHCenter
      size: "2xl"
    }

    Item {Layout.fillWidth: true}

    // Temperature range
    RowLayout {
      Layout.alignment: Qt.AlignHCenter
      spacing: 0

      CustomText {
        name: root.minTemp
        textColor: theme.normal.cyan
        size: "small"
        isBold: true
      }

      CustomText{
        name: "/ "
        textColor: theme.primary.dim_foreground
        size: "small"

      }

      CustomText {
        name: root.maxTemp
        textColor: theme.normal.red
        size: "small"
        isBold: true
      }
    }

  }
}
