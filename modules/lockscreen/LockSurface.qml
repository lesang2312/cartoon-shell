import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Qt5Compat.GraphicalEffects
import qs.services
import Quickshell.Wayland
import Quickshell.Io
import QtMultimedia
import qs.components
import qs.commons
import qs.modules.lockscreen

Item {
  id: root
  required property LockContext context

  // Property để kiểm soát trạng thái load
  property bool wallpaperReady: false
  property bool contentVisible: false
  property real animationProgress: 0

  // Timer fallback nếu wallpaper load quá lâu
  Timer {
    id: fallbackTimer
    interval: 1000
    running: !wallpaperReady
    repeat: false
    onTriggered: {
      if (!wallpaperReady) {
        console.log("Wallpaper load timeout, showing UI anyway")
        wallpaperReady = true
      }
    }
  }

  // Animation cho container
  SequentialAnimation on animationProgress {
    id: containerAnimation
    running: wallpaperReady
    NumberAnimation {
      from: 0
      to: 1
      duration: 300
      easing.type: Easing.OutCubic
    }
  }

  // Sửa cách lấy current screen
  property var currentScreen: {
    if (typeof screen !== 'undefined' && screen) return screen
    if (Quickshell && Quickshell.screens && Quickshell.screens.length > 0) return Quickshell.screens[0]
    return null
  }

  property string backgroundPath: {
    if (!currentScreen) return ""
    return WallpaperService.getWallpaper(currentScreen.name)
  }

  property bool isVideo: {
    if (!backgroundPath) return false
    const videoExtensions = ["mp4", "webm", "mkv", "avi", "mov", "flv", "wmv", "m4v", "mpg", "mpeg"]
    const extension = backgroundPath.toString().split('.').pop().toLowerCase()
    return videoExtensions.includes(extension)
  }

  // Background màu tạm thời (tránh màn hình đen)
  Rectangle {
    id: tempBackground
    anchors.fill: parent
    color: theme.primary.background
    z: -3
    visible: true
  }

  // Background Image cho ảnh tĩnh
  Image {
    id: backgroundImage
    anchors.fill: parent
    source: isVideo ? "" : backgroundPath
    fillMode: Image.PreserveAspectCrop
    asynchronous: true
    cache: true
    visible: !isVideo
    opacity: (status === Image.Ready && !isVideo) ? 1 : 0
    z: -2

    onStatusChanged: {
      if (status === Image.Ready) {
        console.log("Image wallpaper loaded")
        wallpaperReady = true
        fallbackTimer.stop()
      } else if (status === Image.Error) {
        console.log("Failed to load image wallpaper, using fallback")
        wallpaperReady = true
        fallbackTimer.stop()
      }
    }
  }

  // Background Video cho video wallpaper
  Video {
    id: backgroundVideo
    anchors.fill: parent
    source: isVideo ? "file://" + backgroundPath : ""
    fillMode: VideoOutput.PreserveAspectCrop
    muted: true
    loops: MediaPlayer.Infinite
    autoPlay: isVideo
    visible: isVideo
    opacity: (isVideo && playbackState === MediaPlayer.PlayingState) ? 1 : 0
    z: -2

    onPlaybackStateChanged: {
      if (isVideo && playbackState === MediaPlayer.PlayingState) {
        console.log("Video wallpaper playing")
        wallpaperReady = true
        fallbackTimer.stop()
      }
    }

    onErrorOccurred: function(error, errorString) {
      console.error("Video error:", errorString)
      wallpaperReady = true
      fallbackTimer.stop()
    }
  }

  // Blur effect (chỉ hiện khi wallpaper đã load)
  FastBlur {
    id: blurEffect
    anchors.fill: parent
    source: backgroundImage
    radius: 64
    visible: !isVideo && wallpaperReady && backgroundImage.status === Image.Ready
    cached: true
    opacity: wallpaperReady ? 1 : 0
    z: -1

    Rectangle {
      anchors.fill: parent
      color: "black"
      opacity: 0.3
    }
  }

  // Main content
  Item {
    id: mainContent
    anchors.fill: parent
    opacity: wallpaperReady ? 1 : 0
    visible: opacity > 0

    Behavior on opacity {
      NumberAnimation {
        duration: 500
        easing.type: Easing.OutQuad
      }
    }

    // Floating circles background
    Loader {
      anchors.fill: parent
      active: true
      sourceComponent: FloatingCircles {
        circleColor: theme.button.text
        anchors.fill: parent
        circleCount: 8
        minOpacity: 0.04
        maxOpacity: 0.12
      }
    }

    // Main container với animation scale và opacity
    Item {
      id: mainContainer
      anchors.centerIn: parent
      width: parent.width * 0.3
      height: parent.width * 0.2

      // Scale animation cho container
      scale: animationProgress
      opacity: animationProgress

      Behavior on scale {
        NumberAnimation {
          duration: 600
          easing.type: Easing.OutBack
        }
      }

      Behavior on opacity {
        NumberAnimation {
          duration: 500
          easing.type: Easing.OutQuad
        }
      }

      Rectangle {
        id: containerRect
        anchors.fill: parent
        color: Qt.alpha(theme.primary.background, 0.5)
        radius: ScalerService.s(Settings.appearance.radius2)

        // Border gradient
        Rectangle {
          anchors.fill: parent
          radius: parent.radius
          color: "transparent"
          border.width: Settings.appearance.enableBorder ? ScalerService.s(2) : 0
          border.color: Qt.alpha(theme.accent, animationProgress * 0.5)
        }

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: ScalerService.s(30)
          spacing: ScalerService.s(20)

          // Time Section
          Item {
            Layout.fillWidth: true
            Layout.preferredHeight: ScalerService.s(180)

            ColumnLayout {
              anchors.centerIn: parent
              spacing: ScalerService.s(10)

              // Time
              CustomText {
                text: DateTimeService.currentHour + ":" + DateTimeService.currentMinus
                size: "4xl"
                isBold: true
                Layout.alignment: Qt.AlignCenter
                color: theme.button.text

                SequentialAnimation on scale {
                  loops: Animation.Infinite
                  NumberAnimation { from: 1.0; to: 1.02; duration: 2000; easing.type: Easing.InOutSine }
                  NumberAnimation { from: 1.02; to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
                }
              }

              // Date
              CustomText {
                text: `${DateTimeService.currentDay}, ${DateTimeService.currentOfDays} ${DateTimeService.currentMonth} ${DateTimeService.currentYear}`
                size: "xl"
                isBold: true
                Layout.alignment: Qt.AlignCenter
                color: Qt.alpha(theme.button.text, 0.8)
              }
            }
          }

          // Password Section
          Rectangle {
            id: passwordContainer
            Layout.preferredWidth: ScalerService.s(450)
            Layout.preferredHeight: ScalerService.s(65)
            Layout.alignment: Qt.AlignHCenter
            radius: ScalerService.s(32)
            color: Qt.alpha(theme.button.background, 0.3)

            // Glow effect khi focus
            Rectangle {
              anchors.fill: parent
              radius: parent.radius
              color: "transparent"
              border.color: passwordBox.activeFocus ? theme.accent : "transparent"
              border.width: ScalerService.s(2)
              opacity: passwordBox.activeFocus ? 0.8 : 0
              Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            RowLayout {
              anchors.fill: parent
              anchors.margins: ScalerService.s(5)
              spacing: ScalerService.s(10)

              // Icon
              Item {
                Layout.preferredWidth: ScalerService.s(45)
                Layout.preferredHeight: ScalerService.s(45)
                IconText {
                  anchors.centerIn: parent
                  name: root.context.unlockInProgress ? "lock_open" : "lock"
                  textColor: theme.button.text
                }
              }

              // Password Input
              TextField {
                id: passwordBox
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Rectangle { color: "transparent" }
                color: theme.button.text
                font.pixelSize: ScalerService.s(16)
                font.family: "JetBrains Mono"
                verticalAlignment: TextInput.AlignVCenter
                placeholderText: "Enter your password"
                placeholderTextColor: Qt.alpha(theme.button.text, 0.5)
                focus: true
                enabled: !root.context.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData

                onTextChanged: {
                  root.context.currentText = this.text;
                  passwordContainer.scale = 1.02;
                  scaleResetTimer.restart();
                }
                onAccepted: root.context.tryUnlock();

                Timer {
                  id: scaleResetTimer
                  interval: 100
                  onTriggered: passwordContainer.scale = 1.0
                }

                Connections {
                  target: root.context
                  function onCurrentTextChanged() {
                    passwordBox.text = root.context.currentText;
                  }
                }
              }

              // Unlock Button
              Item {
                Layout.preferredWidth: ScalerService.s(50)
                Layout.preferredHeight: ScalerService.s(50)
                scale: unlockMouseArea.pressed ? 0.95 : (unlockMouseArea.containsMouse ? 1.05 : 1.0)

                Behavior on scale { NumberAnimation { duration: 150 } }

                IconText {
                  anchors.centerIn: parent
                  name: "arrow_forward"
                  color: root.context.currentText !== "" ? theme.button.text : Qt.alpha(theme.button.text, 0.3)
                  rotation: root.context.unlockInProgress ? 360 : 0
                  Behavior on rotation { NumberAnimation { duration: 500 } }
                }

                MouseArea {
                  id: unlockMouseArea
                  anchors.fill: parent
                  hoverEnabled: true
                  enabled: !root.context.unlockInProgress && root.context.currentText !== ""
                  onClicked: root.context.tryUnlock()
                  cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                }
              }
            }
          }

          Rectangle {
            Layout.preferredHeight: errorLabel.implicitHeight + ScalerService.s(15)
            Layout.fillWidth: true
            Layout.maximumWidth: ScalerService.s(400)
            Layout.alignment: Qt.AlignHCenter
            radius: ScalerService.s(8)
            color: Qt.alpha(theme.normal.red, 0.5)
            visible: root.context.showFailure
            opacity: root.context.showFailure ? 1 : 0
            scale: root.context.showFailure ? 1 : 0.8

            Behavior on opacity { NumberAnimation { duration: 200 } }
            Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

            Label {
              id: errorLabel
              anchors.centerIn: parent
              text: "✕ Authentication failed. Please try again."
              color: "white"
              font.pixelSize: ScalerService.s(11)
              font.weight: Font.Medium
            }
          }

          // Hint text
          Label {
            text: "Press ESC to cancel"
            color: Qt.alpha(theme.button.text, 0.4)
            font.pixelSize: ScalerService.s(10)
            Layout.alignment: Qt.AlignHCenter
            visible: !root.context.showFailure
          }
        }
      }
    }

    // Star field effect
    Loader {
      anchors.fill: parent
      active: true
      sourceComponent: StarField {
        starCount: 15
        shootingStarCount: 3
      }
    }
  }

  // Loading effect
  Item {
    id: loadingEffect
    anchors.fill: parent
    opacity: wallpaperReady ? 0 : 1
    visible: opacity > 0
    z: 2

    Behavior on opacity {
      NumberAnimation { duration: 500; easing.type: Easing.OutQuad }
    }

    Rectangle {
      anchors.fill: parent
      color: theme.primary.background
      opacity: 0.95
    }

    ColumnLayout {
      anchors.centerIn: parent
      spacing: ScalerService.s(20)

      Item {
        Layout.alignment: Qt.AlignCenter
        width: ScalerService.s(80)
        height: ScalerService.s(80)

        Rectangle {
          anchors.centerIn: parent
          width: ScalerService.s(60)
          height: ScalerService.s(60)
          radius: ScalerService.s(30)
          color: "transparent"
          border.color: Qt.alpha(theme.button.text, 0.5)
          border.width: ScalerService.s(3)

          RotationAnimation on rotation {
            loops: Animation.Infinite
            from: 0
            to: 360
            duration: 1000
          }
        }

        Rectangle {
          anchors.centerIn: parent
          width: ScalerService.s(40)
          height: ScalerService.s(40)
          radius: ScalerService.s(20)
          color: Qt.alpha(theme.button.text, 0.5)

          SequentialAnimation on scale {
            loops: Animation.Infinite
            NumberAnimation { from: 0.8; to: 1.2; duration: 500; easing.type: Easing.InOutQuad }
            NumberAnimation { from: 1.2; to: 0.8; duration: 500; easing.type: Easing.InOutQuad }
          }
        }
      }
    }
    Repeater {
      model: 20
      Rectangle {
        id: circle
        width: size
        height: size
        radius: width / 2
        color: Qt.alpha(theme.button.background, Math.random() * 0.5 + 0.3)

        property real size: 200 + Math.random() * 100
        property real duration: 1000 + Math.random() * 2000
        property real delay: Math.random() * 1000

        x: -width
        y: Math.random() * (parent.height - height)

        SequentialAnimation on x {
          loops: Animation.Infinite
          PauseAnimation { duration: delay }
          NumberAnimation {
            from: -width
            to: parent.parent.width + width
            duration: duration
            easing.type: Easing.InOutQuad
          }
        }

        NumberAnimation on scale {
          loops: Animation.Infinite
          from: 0.8
          to: 1.2
          duration: 1000 + Math.random() * 1000
          easing.type: Easing.InOutSine
        }
      }
    }
  }

  // Reset state khi component được tạo lại
  Component.onCompleted: {
    wallpaperReady = false
    fallbackTimer.start()
  }

  Component.onDestruction: {
    if (backgroundVideo.playbackState === MediaPlayer.PlayingState) {
      backgroundVideo.stop()
    }
  }
}
