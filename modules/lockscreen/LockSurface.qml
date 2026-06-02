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

    // Main container với hiệu ứng glassmorphism
    Rectangle {
      id: mainContainer
      anchors.centerIn: parent
      width: parent.width * 0.4
      implicitHeight: parent.width * 0.2
      color: Qt.alpha(theme.primary.background, 0.5)
      radius: ScalerService.s(Settings.appearance.radius1)

      // Border gradient
      Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        border.width: Settings.appearance.enableBorder ? ScalerService.s(2) : 0
        border.color: Qt.alpha(theme.button.border, 0.5)

        // Gradient border effect
        Rectangle {
          anchors.fill: parent
          radius: parent.radius
          gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.alpha(theme.accent, 0.3) }
            GradientStop { position: 0.5; color: Qt.alpha(theme.button.text, 0.1) }
            GradientStop { position: 1.0; color: Qt.alpha(theme.accent, 0.3) }
          }
          visible: Settings.appearance.enableBorder
        }
      }

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: ScalerService.s(30)
        spacing: ScalerService.s(20)

        // Time Section
        Item {
          Layout.fillWidth: true
          Layout.preferredHeight: ScalerService.s(200)

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
              text: DateTimeService.currentDay + ", " + DateTimeService.currentDate
              size: "xl"
              isBold: true
              Layout.alignment: Qt.AlignCenter
              color: Qt.alpha(theme.button.text, 0.8)
            }
          }
        }

        // Password Section với thiết kế đẹp hơn
        Rectangle {
          id: passwordContainer
          Layout.preferredWidth: ScalerService.s(500)
          Layout.preferredHeight: ScalerService.s(70)
          Layout.alignment: Qt.AlignHCenter
          radius: ScalerService.s(35)
          color: Qt.alpha(theme.button.background, 0.5)

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
            Rectangle {
              Layout.preferredWidth: ScalerService.s(50)
              Layout.preferredHeight: ScalerService.s(50)
              radius: ScalerService.s(25)
              color: Qt.alpha(theme.button.background, root.context.unlockInProgress ? 0.3 : 0.1)

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
              font.pixelSize: ScalerService.s(18)
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

        // Error Message
        Rectangle {
          Layout.preferredHeight: errorLabel.implicitHeight + ScalerService.s(20)
          Layout.fillWidth: true
          Layout.maximumWidth: ScalerService.s(400)
          Layout.alignment: Qt.AlignHCenter
          radius: ScalerService.s(10)
          color: Qt.alpha("#ff4757", 0.9)
          visible: root.context.showFailure
          opacity: root.context.showFailure ? 1 : 0
          scale: root.context.showFailure ? 1 : 0.8

          Behavior on opacity { NumberAnimation { duration: 200 } }
          Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

          SequentialAnimation on x {
            running: root.context.showFailure
            NumberAnimation { to: 10; duration: 50 }
            NumberAnimation { to: -10; duration: 50 }
            NumberAnimation { to: 5; duration: 50 }
            NumberAnimation { to: -5; duration: 50 }
            NumberAnimation { to: 0; duration: 50 }
          }

          Label {
            id: errorLabel
            anchors.centerIn: parent
            text: "✕ Authentication failed. Please try again."
            color: "white"
            font.pixelSize: ScalerService.s(12)
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

    Loader {
      anchors.fill: parent
      active: true
      sourceComponent: StarField {
        starCount: 15
        shootingStarCount: 3
      }
    }
  }
  Item {
    id: loadingEffect
    anchors.fill: parent
    opacity: wallpaperReady ? 0 : 1
    visible: opacity > 0
    z: 2

    Behavior on opacity {
      NumberAnimation { duration: 500; easing.type: Easing.OutQuad }
    }

    // Background mờ khi loading
    Rectangle {
      anchors.fill: parent
      color: theme.primary.background
      opacity: 0.85
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

        // Hiệu ứng xoay
        RotationAnimator on rotation {
          loops: Animation.Infinite
          from: 0
          to: 360
          duration: 3000 + Math.random() * 2000
        }

        // Hiệu ứng scale nhẹ
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

  // Loading effect đẹp hơn

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
