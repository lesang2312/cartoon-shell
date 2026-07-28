import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import QtQuick.Effects
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
        Layout.fillWidth: true
        Layout.fillHeight: true
        CustomRectangle {
            color: theme.primary.background
            anchors.centerIn: parent
            implicitWidth: root.animationProgress > 0.1 ? parent.width : 0
            implicitHeight: root.animationProgress > 0.1 ? parent.height : 0
            RowLayout {
                spacing: ScalerService.s(12)
                anchors.leftMargin: ScalerService.s(12)
                anchors.rightMargin: ScalerService.s(12)
                anchors.topMargin: ScalerService.s(5)
                anchors.bottomMargin: ScalerService.s(5)
                anchors.fill: parent
                RowLayout {
                  spacing: ScalerService.s(20)
                  IconImage{
                    path: "launcher/win11.svg"
                  }

                    IconText {
                        fontFamily: "Symbols Nerd Font"
                        name: ""
                        textColor: theme.button.text
                        Layout.alignment: Qt.AlignVCenter
                      }
                      IconText {
                        fontFamily: "Symbols Nerd Font"
                        name: ""
                        textColor: theme.button.text
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
                Item {
                    Layout.fillWidth: true
                }
                ColumnLayout {
                  Layout.fillHeight: true
                  Layout.preferredWidth: ScalerService.s(100)
                  CustomText {
                    name: DateTimeService.currentTime
                        Layout.alignment: Qt.AlignHCenter
                    size: "xs"
                }
                  CustomText {
                    name: DateTimeService.currentDate1
                        Layout.alignment: Qt.AlignHCenter
                    size: "xs"
                }
                

                }
                
            }
        }
    }
}
