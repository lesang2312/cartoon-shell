import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components
import qs.commons

Rectangle {
    id: optionContainer
    property string optionId: ""
    property string label: ""
    property bool isHorizontal: true
    property string position: ""
    property bool isSelected: false

    radius: ScalerService.s(10)
    color: theme.primary.dim_background
    border.color: isSelected ? theme.button.text : "transparent"
    border.width: ScalerService.s(2)

    // Layout chính
    RowLayout {
        anchors.centerIn: parent
        spacing: ScalerService.s(10)

        // Thanh bar indicator
        Rectangle {
            id: barIndicator
            Layout.preferredWidth: isHorizontal ? ScalerService.s(60) : ScalerService.s(10)
            Layout.preferredHeight: isHorizontal ? ScalerService.s(10) : ScalerService.s(40)
            radius: ScalerService.s(3)
            color: isSelected ? theme.button.text : theme.primary.dim_foreground

            // Layout order cho left/right
            Layout.alignment: {
                if (position === "left")
                    return Qt.AlignVCenter | Qt.AlignRight;
                if (position === "right")
                    return Qt.AlignVCenter | Qt.AlignLeft;
                return Qt.AlignHCenter;
            }
        }

        // Label
        Text {
            text: label
            color: isSelected ? theme.button.text : theme.primary.foreground
            font {
                family: "ComicShannsMono Nerd Font"
                pixelSize: ScalerService.s(14)
            }

            Layout.alignment: {
                if (position === "left")
                    return Qt.AlignVCenter | Qt.AlignLeft;
                if (position === "right")
                    return Qt.AlignVCenter | Qt.AlignRight;
                return Qt.AlignHCenter;
            }
        }
    }

    // Interaction
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: {
            optionContainer.clicked();
        }
        onEntered: parent.opacity = 0.9
        onExited: parent.opacity = 1.0
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 100
        }
    }

    signal clicked
}
