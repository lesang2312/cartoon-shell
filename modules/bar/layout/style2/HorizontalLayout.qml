import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar
import qs.commons
import qs.services
import qs.components
import "../../widget/" as Com

RowLayout {
    id: root
    property real animationProgress: 0

    SequentialAnimation on animationProgress {
        running: true
        NumberAnimation {
            from: 0
            to: 1
            duration: 500
            easing.type: Easing.Linear
        }
    }
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
            anchors.centerIn: parent
            implicitWidth: root.animationProgress > 0.1 ? parent.width : 0
            implicitHeight: root.animationProgress > 0.1 ? parent.height : 0

            RowLayout {
                spacing: ScalerService.s(12)
                anchors.fill: parent
                Com.WorkspaceSectionHorizontal {
                    sizeIcon: "normal"
                }
            }
        }
    }

    Item {
        Layout.preferredWidth: ScalerService.s(12)
    }
}
