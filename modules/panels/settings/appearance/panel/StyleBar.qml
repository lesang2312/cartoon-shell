import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components
import qs.commons

ColumnLayout {
    id: root
    property real animationProgress: 0
    spacing: ScalerService.s(20)
    Repeater {
        model: [
            {
                name: "style1"
            },
            {
                name: "style2"
            }
        ]
        delegate: Item {
            id: delegateItem
            Layout.fillWidth: true
            Layout.preferredHeight: ScalerService.s(50)
            Rectangle {
                id: container
                anchors.fill: parent
                anchors.margins: ScalerService.s(2)
                radius: ScalerService.s(12)

                color: {
                    if (Settings.bar.style === modelData.name) {
                        return Qt.alpha(theme.button.text, 0.15);
                    }
                    return mouseArea.containsMouse ? Qt.alpha(theme.button.background_select, 0.4) : Qt.alpha(theme.button.background, 0.2);
                }

                border.color: {
                    if (Settings.bar.style === modelData.name) {
                        return Qt.alpha(theme.button.text, 0.8);
                    }
                    return mouseArea.containsPress ? Qt.alpha(theme.button.border_select, 0.6) : Qt.alpha(theme.button.border, 0.3);
                }
                border.width: ScalerService.s(2)

                // Animation cho border và background
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
                Behavior on border.color {
                    ColorAnimation {
                        duration: 200
                    }
                }

                // Mouse area
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        SoundService.playSound("pick");
                        Settings.bar.style = modelData.name;
                    }
                }

                // Animation hiển thị khi load
                SequentialAnimation on opacity {
                    running: root.animationProgress > 0.2
                    PauseAnimation {
                        duration: index * 20
                    }
                    NumberAnimation {
                        from: 0
                        to: 1
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }

                // Animation scale khi load
                SequentialAnimation on scale {
                    running: root.animationProgress > 0.2
                    PauseAnimation {
                        duration: index * 20
                    }
                    NumberAnimation {
                        from: 0.5
                        to: 1.0
                        duration: 400
                        easing.type: Easing.OutBack
                    }
                }
            }
        }
    }
}
