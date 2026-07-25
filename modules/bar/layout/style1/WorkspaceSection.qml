import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.commons
import qs.components

Rectangle {
    id: root

    // Properties thuần cho layout / UI State
    property real animationProgress: 0
    property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"

    border.color: theme.button.border
    border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
    radius: ScalerService.s(Settings.appearance.radius2)
    color: theme.primary.background
    anchors.centerIn: parent

    implicitWidth: root.animationProgress > 0.1 ? parent.width : 0
    implicitHeight: root.animationProgress > 0.1 ? parent.height : 0

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 500
            easing.type: Easing.OutCubic
        }
    }
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 500
            easing.type: Easing.OutCubic
        }
    }

    Loader {
        anchors.centerIn: parent
        sourceComponent: isVertical ? verticalLayout : horizontalLayout
    }

    // Layout Ngang
    Component {
        id: horizontalLayout

        RowLayout {
            spacing: ScalerService.s(4)

            Repeater {
                model: CompositorService.uiWorkspaces

                Rectangle {
                    required property var modelData

                    Layout.preferredWidth: ScalerService.s(32)
                    Layout.preferredHeight: ScalerService.s(32)
                    radius: ScalerService.s(6)
                    color: "transparent"

                    IconImage {
                        opacity: root.animationProgress > 0.2 ? 1 : 0
                        path: modelData.isActive || modelData.exists ? `workspace/${Settings.bar.iconWorkspace}/${modelData.isActive ? "active" : "exists"}.png` : "workspace/empty.png"
                        size: "large"
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            SoundService.playSound("pick");
                            CompositorService.switchToWorkspaceById(modelData.id);
                        }
                        onEntered: {
                            if (modelData.id !== CompositorService.activeWorkspace)
                                parent.scale = 1.1;
                        }
                        onExited: {
                            if (modelData.id !== CompositorService.activeWorkspace)
                                parent.scale = 1.0;
                        }
                        onWheel: event => {
                            CompositorService.handleScroll(event.angleDelta.y, event.angleDelta.x, root.isVertical);
                        }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 100
                        }
                    }
                }
            }
        }
    }

    // Layout Dọc
    Component {
        id: verticalLayout

        ColumnLayout {
            spacing: ScalerService.s(2)

            Repeater {
                model: CompositorService.uiWorkspaces

                Rectangle {
                    required property var modelData

                    Layout.preferredWidth: ScalerService.s(24)
                    Layout.preferredHeight: ScalerService.s(24)
                    radius: ScalerService.s(6)
                    color: "transparent"

                    IconImage {
                        path: modelData.isActive || modelData.exists ? `workspace/${Settings.bar.iconWorkspace}/${modelData.isActive ? "active" : "exists"}.png` : "workspace/empty.png"
                        opacity: root.animationProgress > 0.2 ? 1 : 0
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            SoundService.playSound("pick");
                            CompositorService.switchToWorkspaceById(modelData.id);
                        }
                        onEntered: {
                            if (modelData.id !== CompositorService.activeWorkspace)
                                parent.scale = 1.1;
                        }
                        onExited: {
                            if (modelData.id !== CompositorService.activeWorkspace)
                                parent.scale = 1.0;
                        }
                        onWheel: event => {
                            CompositorService.handleScroll(event.angleDelta.y, event.angleDelta.x, root.isVertical);
                        }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 100
                        }
                    }
                }
            }
        }
    }
}
