import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components
import qs.commons
ColumnLayout {
  GridLayout {
    columns: 4
    rowSpacing: ScalerService.s(12)
    columnSpacing: ScalerService.s(12)

    Repeater {
      model: [
        {
          name: "pacman"
        },
        {
          name: "luffy"
        },
        {
          name: "zoro"
        },
        {
          name: "nami"
        },
        {
          name: "sanji"
        }
      ]

      delegate: ButtonIconImage {
        Layout.preferredHeight: ScalerService.s(40)
        Layout.preferredWidth: ScalerService.s(80)
        path: `workspace/${modelData.name}/active.png`

        onClicked: {
          Settings.bar.iconWorkspace = modelData.name
        }
      }
    }
  }
}
