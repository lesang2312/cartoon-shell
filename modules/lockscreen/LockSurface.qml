import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Qt5Compat.GraphicalEffects
import qs.services
import Quickshell.Wayland
import Quickshell.Io
import QtMultimedia
import qs.components
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
    color: "#1a1a1a"  // Màu xám đậm thay vì đen tuyền
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
      opacity: 0.4
    }
  }

  // Nội dung chính - chỉ hiện khi wallpaper đã ready
  Item {
    id: mainContent
    anchors.fill: parent
    opacity: wallpaperReady ? 1 : 0
    visible: opacity > 0
    z: 1

    Behavior on opacity {
      NumberAnimation {
        duration: 300
        easing.type: Easing.OutQuad
      }
    }

    Loader {
      anchors.fill: parent
      active: true
      sourceComponent: FloatingCircles {
        circleColor: theme.button.text
        anchors.fill: parent
        circleCount: 6
        minOpacity: 0.06
        maxOpacity: 0.15
      }
    }

    Item {
      id: passwordSection
      anchors.centerIn: parent
      width: 450
      height: 200

      Label {
        anchors { horizontalCenter: parent.horizontalCenter; bottom: passwordContainer.top; bottomMargin: 15 }
        text: "What's password?"
        color: "white"
        opacity: 0.9
        font.pointSize: 11
        style: Text.Outline
        styleColor: "black"
      }

      Rectangle {
        id: passwordContainer
        anchors.centerIn: parent
        width: 450
        height: 65
        radius: 16
        color: "transparent"
        border.color: root.context.showFailure ? "#ff4757" : (passwordBox.focus ? "#ffffff" : "#ffffff")
        border.width: 2

        Rectangle {
          anchors.fill: parent
          radius: parent.radius
          color: "white"
          opacity: 0.1
        }

        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
        Behavior on border.color { ColorAnimation { duration: 200 } }

        Rectangle {
          anchors.fill: parent
          anchors.margins: -4
          radius: parent.radius + 2
          color: "transparent"
          border.color: passwordBox.focus ? "#ffffff" : "transparent"
          border.width: 2
          opacity: 0.3
          visible: passwordBox.focus
        }

        Row {
          anchors.fill: parent
          anchors.margins: 15
          spacing: 15

          Rectangle {
            width: 35
            height: 35
            anchors.verticalCenter: parent.verticalCenter
            radius: 8
            color: "transparent"
            border.color: "white"
            border.width: 1
            Text {
              color: "#ffffff"
              anchors.centerIn: parent
              text: root.context.unlockInProgress ? "󰩈" : "󰌾"
              font.pixelSize: 20
            }
          }

          TextField {
            id: passwordBox
            width: parent.width - 110
            height: parent.height
            background: Rectangle { color: "transparent" }
            color: "white"
            font.pixelSize: 18
            verticalAlignment: TextInput.AlignVCenter
            placeholderText: "Tell me your password"
            focus: true
            enabled: !root.context.unlockInProgress
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData

            onTextChanged: {
              root.context.currentText = this.text;
              passwordContainer.scale = 1.03;
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

          Rectangle {
            width: 50
            height: 35
            anchors.verticalCenter: parent.verticalCenter
            radius: 8
            color: "transparent"
            border.color: "white"
            border.width: !root.context.unlockInProgress && root.context.currentText !== "" ? 0 : 1
            scale: unlockMouseArea.containsMouse ? 1.1 : 1.0

            Behavior on scale { NumberAnimation { duration: 150 } }

            Text {
              anchors.centerIn: parent
              text: ""
              font.pixelSize: 24
              font.bold: true
              color: "white"
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
        anchors {
          horizontalCenter: parent.horizontalCenter
          top: passwordContainer.bottom
          topMargin: 20
        }
        width: errorLabel.width + 30
        height: 40
        radius: 12
        color: "#ff4757"
        visible: root.context.showFailure
        opacity: root.context.showFailure ? 1 : 0
        scale: root.context.showFailure ? 1 : 0.8

        Behavior on opacity { NumberAnimation { duration: 200 } }
        Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

        SequentialAnimation on x {
          running: root.context.showFailure
          NumberAnimation { to: 5; duration: 50 }
          NumberAnimation { to: -5; duration: 50 }
          NumberAnimation { to: 3; duration: 50 }
          NumberAnimation { to: -3; duration: 50 }
          NumberAnimation { to: 0; duration: 50 }
        }

        Label {
          id: errorLabel
          anchors.centerIn: parent
          text: "✕ Nah that's not your password!"
          color: "white"
          font.pointSize: 10
          font.bold: true
        }
      }
    }

    Loader {
      anchors.fill: parent
      active: true
      sourceComponent: StarField {
        starCount: 10
        shootingStarCount: 2
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
