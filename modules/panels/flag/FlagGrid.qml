import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.commons
import "." as Com

Flickable {
  id: flagGridView

  property var flagList: []
  property string selectedFlag: ""
  property real animationProgress: 0

  width: parent.width
  height: ScalerService.s(234)
  contentWidth: flowContainer.width
  contentHeight: flowContainer.height
  clip: true

  // Cho phép kéo thả và quán tính
  flickableDirection: Flickable.HorizontalFlick
  boundsBehavior: Flickable.DragAndOvershootBounds
  rebound: Transition {
    NumberAnimation { properties: "x"; duration: 300; easing.type: Easing.OutQuad }
  }

  Flow {
    id: flowContainer
    width: Math.max(flagGridView.width, implicitWidth)  // Quan trọng: đảm bảo width đủ lớn
    height: ScalerService.s(234)
    spacing: ScalerService.s(12)
    flow: Flow.TopToBottom

    Repeater {
      model: flagGridView.flagList

      Com.FlagItem {
        opacity: 0

        SequentialAnimation on opacity {
          running: root.animationProgress > 0.5

          PauseAnimation {
            duration: index * 25
          }

          NumberAnimation {
            to: 1
            duration: 200
            easing.type: Easing.OutCubic
          }
        }
        flagName: modelData.name
        displayName: modelData.displayName
        isSelected: flagGridView.selectedFlag === modelData.name

        onClicked: {
          Settings.appearance.countryFlag = flagName
        }
      }
    }
  }
}
