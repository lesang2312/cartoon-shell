import QtQuick
import QtQuick.Layouts
import qs.components
import qs.commons
import Quickshell.Services.Pipewire
import qs.services

Item {
  id: root

  property real currentBrightness: BrightnessService.currentBrightness


  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  function getBrightnessIcon() {
    if ( currentBrightness <= 0)
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

  RowLayout {
    id: row
    anchors.fill: parent
    spacing: ScalerService.s(2)

    IconText {
      name: root.getBrightnessIcon()
      textColor: theme.button.text
      size: "normal"
    }

    CustomText {
      visible: root.style === 1
      && (Settings.bar.position === "top"
        || Settings.bar.position === "bottom")
      name: currentBrightness
      isBold: true
      size: "small"
    }
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.RightButton
    propagateComposedEvents: true
    cursorShape: Qt.PointingHandCursor

    onWheel: (wheel) => {
      let step = 0.05

      SoundService.playSound("pop")
      if (wheel.angleDelta.y > 0)
      BrightnessService.changeBright(step)
      else if (wheel.angleDelta.y < 0)
      BrightnessService.changeBright(-step)
    }

    onPressed: (mouse) => {
      if (mouse.button === Qt.RightButton) {
        toggleMute()
        mouse.accepted = true
      } else {
        mouse.accepted = false
      }
    }
  }
}

