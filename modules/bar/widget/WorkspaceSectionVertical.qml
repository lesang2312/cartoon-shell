import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.commons
import qs.components

ColumnLayout {
  id: root
  spacing: ScalerService.s(0)

  property real animationProgress: 1.0
  property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"

  readonly property var sizeIcon: ({
      "style1": "normal",
      "style2": "small"
  })
  readonly property var sizeImage: ({
      "style1": "normal",
      "style2": "small",
  })
  Repeater {
    model: CompositorService.uiWorkspaces
    Loader {
      required property var modelData

      sourceComponent: Settings.bar.styleWorkspace === "icon" ? textIcon : imageIcon
    }
  }
  Component {
    id: imageIcon

    ButtonIconImage {
      size: sizeImage[Settings.bar.style ?? "normal"]
      opacity: root.animationProgress > 0.2 ? 1 : 0
      path: modelData.isActive || modelData.exists ? `workspace/${Settings.bar.iconWorkspace}/${modelData.isActive ? "active" : "exists"}.png` : "workspace/empty.png"

      onClicked: CompositorService.switchToWorkspaceById(modelData.id)

      onWheel: event => {
        CompositorService.handleScroll(event.angleDelta.y, event.angleDelta.x, root.isVertical);
      }
    }
  }
  Component {
    id: textIcon

    ButtonIconText {
      size: sizeIcon[Settings.bar.style ?? "normal"]
      textColor: theme.button.text
      name: modelData.isActive ? "circle" : (modelData.exists ? "circle_circle" : "radio_button_unchecked")
      onClicked: CompositorService.switchToWorkspaceById(modelData.id)

      onWheel: event => {
        CompositorService.handleScroll(event.angleDelta.y, event.angleDelta.x, root.isVertical);
      }
    }
  }
}
