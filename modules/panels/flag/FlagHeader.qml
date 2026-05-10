import qs.components
import QtQuick.Layouts
import QtQuick
import qs.services

Item {
  Layout.fillWidth: true
  height: 70

  RowLayout {
    Layout.fillWidth: true
    anchors.centerIn: parent
    spacing: 10

    IconImage {

      path: "panel/earth.png"
      size: "xl"
    }

    CustomText {
      name: "Country Flag"
      isBold: true
      size: "large"
    }

  }
  CloseButton {
    onClicked: VisibleService.togglePanel("flag")

  }

}
