import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Effects
import qs.modules.bar
import qs.commons
import qs.services
import qs.services.ram
import qs.services.cpu
import qs.components
import Quickshell.Services.Pipewire
import "../../widget/" as Com

RowLayout {
    id: root
    property real animationProgress: 0
    readonly property var sink: Pipewire.defaultAudioSink
    property real currentBrightness: BrightnessService.currentBrightness
    function getBrightnessIcon() {
        if (currentBrightness <= 0)
            return "brightness_1";
        if (currentBrightness <= 1 / 7)
            return "brightness_2";
        if (currentBrightness <= 2 / 7)
            return "brightness_3";
        if (currentBrightness <= 3 / 7)
            return "brightness_4";
        if (currentBrightness <= 4 / 7)
            return "brightness_5";
        if (currentBrightness <= 5 / 7)
            return "brightness_6";
        return "brightness_7";
    }

    function getIcon(volPercent) {
        if (volPercent < 10)
            return "volume_mute";
        if (volPercent < 60)
            return "volume_down";
        return "volume_up";
    }
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
            implicitWidth: root.animationProgress > 0.1 ? parent.width * 0.8 : 0
            implicitHeight: root.animationProgress > 0.1 ? parent.height : 0

            RowLayout {
                spacing: ScalerService.s(20)
                anchors.margins: ScalerService.s(5)
                anchors.fill: parent
                ButtonIconText {
                    fontFamily: "Symbols Nerd Font"
                    name: "󰣇 "
                    textColor: theme.button.text
                    size: "small"
                }
                Item {
                    Layout.fillWidth: true
                }
                CustomRectangle {
                    color: theme.primary.dim_background
                    implicitWidth: contentRam.implicitWidth + ScalerService.s(15)
                    radius: ScalerService.s(Settings.appearance.radius2)
                    Layout.fillHeight: true
                    RowLayout {
                        id: contentRam
                        anchors.centerIn: parent
                        IconText {
                            name: " "
                            fontFamily: "Symbols Nerd Font"
                            textColor: theme.normal.green
                            size: "xs"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        CustomText {
                            size: "small"
                            name: RamSimpleService.ramPercent + "%"
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                }
                CustomRectangle {
                    color: theme.primary.dim_background
                    implicitWidth: contentCpu.implicitWidth + ScalerService.s(15)
                    radius: ScalerService.s(Settings.appearance.radius2)
                    Layout.fillHeight: true
                    RowLayout {
                        id: contentCpu
                        anchors.centerIn: parent
                        IconText {
                            name: " "
                            fontFamily: "Symbols Nerd Font"
                            textColor: theme.normal.red
                            size: "xs"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        CustomText {
                            size: "small"
                            name: CpuSimpleService.cpuPercent + "%"
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                }

                Com.WorkspaceSectionHorizontal {}
                Item {
                    Layout.preferredWidth: ScalerService.s(12)
                }
                CustomText {
                    size: "small"
                    name: `${DateTimeService.currentHour}:${DateTimeService.currentMinus} · ${DateTimeService.currentDate}`
                    Layout.alignment: Qt.AlignVCenter
                }
                Item {
                    Layout.preferredWidth: ScalerService.s(12)
                }
                CustomRectangle {
                    color: theme.primary.dim_background
                    implicitWidth: contentBri.implicitWidth + ScalerService.s(15)
                    radius: ScalerService.s(Settings.appearance.radius2)
                    Layout.fillHeight: true
                    RowLayout {
                        id: contentBri
                        anchors.centerIn: parent
                        IconText {
                            name: root.getBrightnessIcon()
                            textColor: theme.button.text
                            size: "small"
                        }
                        CustomText {
                            name: Math.floor(BrightnessService.currentBrightness * 100) + "%"
                            isBold: true
                            size: "small"
                        }
                    }
                }

                CustomRectangle {
                    color: theme.primary.dim_background
                    implicitWidth: contentVlo.implicitWidth + ScalerService.s(15)
                    radius: ScalerService.s(Settings.appearance.radius2)
                    Layout.fillHeight: true
                    RowLayout {
                        id: contentVlo
                        anchors.centerIn: parent
                        IconText {
                            size: "small"
                            name: {
                                if (!sink || sink.audio.muted)
                                    return "volume_off";
                                return getIcon(Math.round(sink.audio.volume * 100));
                            }
                            textColor: theme.button.text
                        }
                        CustomText {
                            name: sink ? Math.round(sink.audio.volume * 100) + "%" : "0%"
                            isBold: true
                            size: "small"
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }
                ButtonIconText {
                    fontFamily: "Symbols Nerd Font"
                    name: "󰐥 "
                    size: "small"
                    textColor: theme.normal.red
                }
            }
        }
    }

    Item {
        Layout.preferredWidth: ScalerService.s(12)
    }
}
