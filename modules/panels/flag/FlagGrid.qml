import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.commons
import "." as Com

ScrollView {
  id: flagGridView

  property var flagList: []
  property string selectedFlag: ""
  property var theme: ThemeService.theme

  clip: true
  ScrollBar.vertical.policy: ScrollBar.AlwaysOff
  ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
  property real animationProgress: 0

  Flow {
    height: 234
    width: parent.width
    spacing: 12
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
        theme: flagGridView.theme

        onClicked: {
          Settings.appearance.countryFlag = flagName
        }
      }
    }
  }
}
