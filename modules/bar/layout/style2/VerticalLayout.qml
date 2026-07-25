import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar
import qs.commons
import qs.services
import qs.components
import "../../widget/" as Com

ColumnLayout {
    id: vertical
    Item {
        Layout.preferredWidth: ScalerService.s(5)
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
        }
    }
    Item {
        Layout.preferredWidth: ScalerService.s(5)
    }
}
