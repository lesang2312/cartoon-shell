import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar
import qs.commons
import qs.services
import qs.components
import "." as Com

RowLayout {
    id: root
    Item {
        Layout.preferredWidth: ScalerService.s(12)
    }
    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
        CustomRectangle {
            color: theme.primary.background
            radius: ScalerService.s(Settings.appearance.radius2)
            border.color: theme.button.border
            border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
            anchors.fill: parent
            RowLayout {
                spacing: ScalerService.s(12)
            }
        }
    }

    Item {
        Layout.preferredWidth: ScalerService.s(12)
    }
}
