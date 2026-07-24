import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components
import qs.commons
ColumnLayout {
  CustomText{
      name: "Icon Workspace: "
    }
  GridLayout {
    columns: 8
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
          name: "usopp"
        },
        {
          name: "sanji"
        },
        {
          name: "chopper"
        },
        {
          name: "goku"
        },
        {
          name: "karin"
        }
      ]

      delegate: ButtonIconImage {
        Layout.preferredHeight: ScalerService.s(40)
        Layout.preferredWidth: ScalerService.s(40)
        path: `workspace/${modelData.name}/active.png`

        onClicked: {
          Settings.bar.iconWorkspace = modelData.name
        }
      }
    }
  }
}
