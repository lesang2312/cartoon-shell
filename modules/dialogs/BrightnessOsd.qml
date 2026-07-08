import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.commons
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import qs.components
import qs.services

Scope {
  id: root

  property var theme: ThemeService.theme
  property var lang: LanguageService.translations
  property bool shouldShowOsd: false
  property real currentBrightness: 0.5
  property bool isBrightnessMuted: false

  // Hàm để lấy độ sáng từ hệ thống
  function getBrightness() {
    const result = Shell.Process.exec("brightnessctl", ["g"]);
    if (result.success) {
      const maxBright = Shell.Process.exec("brightnessctl", ["m"]);
      if (maxBright.success) {
        const current = parseInt(result.stdout.trim());
        const max = parseInt(maxBright.stdout.trim());
        if (max > 0) {
          return current / max;
        }
      }
    }
    return 0.5;
  }

  // Hàm để set độ sáng
  function setBrightness(value) {
    const clampedValue = Math.max(0, Math.min(1, value));
    const percent = Math.round(clampedValue * 100);
    Shell.Process.exec("brightnessctl", ["s", percent + "%"]);
    root.currentBrightness = clampedValue;
    root.shouldShowOsd = true;
    hideTimer.restart();
  }

  // Hàm tăng độ sáng
  function increaseBrightness(step = 0.05) {
    const newValue = Math.min(root.currentBrightness + step, 1.0);
    setBrightness(newValue);
  }

  // Hàm giảm độ sáng
  function decreaseBrightness(step = 0.05) {
    const newValue = Math.max(root.currentBrightness - step, 0.0);
    setBrightness(newValue);
  }

  // IPC Handlers cho Brightness
  IpcHandler {
    target: "brightness"
    // Handler cho tăng độ sáng
    function set(value: real) {
      root.shouldShowOsd = true;
      root.currentBrightness = value;
      hideTimer.restart();
      return;
    }
  }

  Timer {
    id: hideTimer
    interval: 1500
    onTriggered: root.shouldShowOsd = false
  }

  Component.onCompleted: {
    root.currentBrightness = getBrightness();
  }

  function lerpColor(a, b, t) {
    const ar = parseInt(a.slice(1,3),16), ag = parseInt(a.slice(3,5),16), ab = parseInt(a.slice(5,7),16);
    const br = parseInt(b.slice(1,3),16), bg = parseInt(b.slice(3,5),16), bb = parseInt(b.slice(5,7),16);
    const r  = Math.round(ar + (br-ar)*t);
    const g  = Math.round(ag + (bg-ag)*t);
    const bl = Math.round(ab + (bb-ab)*t);
    return `#${r.toString(16).padStart(2,'0')}${g.toString(16).padStart(2,'0')}${bl.toString(16).padStart(2,'0')}`;
  }

  function barColor() {
    if (isBrightnessMuted) return theme.normal.black;
    const v = Math.min(currentBrightness / 1.0, 1.0);
    if (v < 0.20) return lerpColor(theme.normal.blue, theme.normal.cyan, v / 0.20);
    if (v < 0.40) return lerpColor(theme.normal.cyan, theme.normal.green, (v-0.20) / 0.20);
    if (v < 0.58) return lerpColor(theme.normal.green, theme.normal.yellow, (v-0.40) / 0.18);
    if (v < 0.73) return lerpColor(theme.normal.yellow, theme.normal.red, (v-0.58) / 0.15);
    if (v < 0.88) return lerpColor(theme.normal.red, theme.bright.red, (v-0.73) / 0.15);
    return lerpColor(theme.bright.red, theme.bright.red, (v-0.88) / 0.12);
  }

  LazyLoader {
    active: root.shouldShowOsd

    PanelWindow {
      anchors {
        bottom: true
      }
      margins {
        bottom: ScalerService.s(120)
      }
      exclusiveZone: 0
      implicitWidth: ScalerService.s(280)
      implicitHeight: ScalerService.s(100)
      color: "transparent"
      mask: Region {}

      Rectangle {
        anchors.fill: parent
        border.color: theme.button.border
        radius: ScalerService.s(Settings.appearance.radius1)
        border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
        color: theme.primary.background

        ColumnLayout {
          anchors {
            fill: parent
            leftMargin: ScalerService.s(15)
            rightMargin: ScalerService.s(15)
            bottomMargin: ScalerService.s(15)
          }
          spacing: ScalerService.s(12)

          RowLayout {
            IconText {
              name: root.getBrightnessIcon()
              textColor: theme.button.text
              size: "normal"
            }
            CustomText {
              name: Math.round(currentBrightness * 100) + "%"
              color: currentBrightness > 1.0 ? theme.normal.red : theme.primary.foreground
              size: "large"
              isBold: true
              Behavior on color {
                ColorAnimation { duration: 150 }
              }
            }
            Rectangle {
              color: "transparent"
              Layout.fillWidth: true
              Layout.fillHeight: true
              CustomText {
                name: " " + (lang?.brightness?.title || "Độ sáng")
                anchors.margins: ScalerService.s(10)
                anchors.top: parent.top
                anchors.right: parent.right
              }
            }
          }

          ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: ScalerService.s(4)

            Rectangle {
              Layout.fillWidth: true
              Layout.preferredHeight: ScalerService.s(20)
              radius: ScalerService.s(20)
              color: theme.primary.dim_background
              Rectangle {
                anchors {
                  left: parent.left
                  top: parent.top
                  bottom: parent.bottom
                }
                width: parent.width * Math.min(currentBrightness / 1.0, 1.0)
                radius: parent.radius
                color: root.barColor()
                Behavior on width {
                  NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
                Behavior on color {
                  ColorAnimation { duration: 100 }
                }
              }

              Rectangle {
                visible: currentBrightness > 1.0
                x: parent.width * (1.0 / 1.0) - width / 2
                width: ScalerService.s(3)
                height: parent.height
                radius: ScalerService.s(1.5)
                color: "white"
                opacity: 0.6
              }
            }
          }
        }
      }
    }
  }

  function getBrightnessIcon() {
    if (isBrightnessMuted || currentBrightness <= 0)
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
}
