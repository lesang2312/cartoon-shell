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
  property real animationProgress: 0
  property real revealThreshold: 0.6

  implicitWidth: 180
  Layout.fillHeight: true
  radius: 12
  color: theme.primary.dim_background
  border.color: theme.primary.foreground
  border.width: 1
  clip: true
  Behavior on opacity {
    NumberAnimation {
      duration: 200
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 16
    spacing: 8

    // Day name
    CustomText{
      name: root.dayName
      size: "normal"
      Layout.alignment: Qt.AlignHCenter
      opacity: root.animationProgress > root.revealThreshold ? 1 : 0
    }
    Item {Layout.fillWidth: true}

    // Date
    CustomText{
      name: root.dateText
      textColor: theme.primary.dim_foreground
      size: "normal"
      Layout.alignment: Qt.AlignHCenter
      opacity: root.animationProgress > root.revealThreshold + 0.03 ? 1 : 0
    }
    Item {Layout.fillWidth: true}

    // Weather icon
    IconImage {
      path: root.icon
      Layout.alignment: Qt.AlignHCenter
      size: "2xl"
      opacity: root.animationProgress > root.revealThreshold + 0.06 ? 1 : 0
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
        opacity: root.animationProgress > root.revealThreshold + 0.07 ? 1 : 0
      }

      CustomText{
        name: "/ "
        textColor: theme.primary.dim_foreground
        size: "small"
        opacity: root.animationProgress > root.revealThreshold + 0.08 ? 1 : 0
      }

      CustomText {
        name: root.maxTemp
        textColor: theme.normal.red
        size: "small"
        isBold: true
        opacity: root.animationProgress > root.revealThreshold + 0.09 ? 1 : 0
      }
    }
  }
}
