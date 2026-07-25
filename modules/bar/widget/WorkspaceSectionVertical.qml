import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.commons
import qs.components

ColumnLayout {
    id: root
    spacing: ScalerService.s(0)

    property string sizeIcon: "normal"
    property real animationProgress: 1.0
    property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"

    Repeater {
        model: CompositorService.uiWorkspaces

        ButtonIconImage {
            required property var modelData

            size: root.sizeIcon
            opacity: root.animationProgress > 0.2 ? 1 : 0
            path: modelData.isActive || modelData.exists ? `workspace/${Settings.bar.iconWorkspace}/${modelData.isActive ? "active" : "exists"}.png` : "workspace/empty.png"

            // Nhận tín hiệu trực tiếp từ ButtonIconImage
            onClicked: {
                CompositorService.switchToWorkspaceById(modelData.id);
            }

            onWheel: event => {
                CompositorService.handleScroll(event.angleDelta.y, event.angleDelta.x, root.isVertical);
            }
        }
    }
}
