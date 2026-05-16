import qs.components
import QtQuick.Layouts
import QtQuick
import qs.services

Item {
  Layout.fillWidth: true
  height: 70
  property real animationProgress: 0

  RowLayout {
    Layout.fillWidth: true
    anchors.centerIn: parent
    spacing: 10

    IconImage {

      path: "panel/earth.png"
      size: "xl"
      opacity: root.animationProgress > 0.2 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
    }

    CustomText {
      name: "Country Flag"
      isBold: true
      size: "large"
      opacity: root.animationProgress > 0.3 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
    }

  }
  CloseButton {
    opacity: root.animationProgress > 0.4 ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 200
      }
    }
    onClicked: VisibleService.togglePanel("flag")

  }

}
