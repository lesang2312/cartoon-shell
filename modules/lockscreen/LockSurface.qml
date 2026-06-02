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

  // Properties for exit animation state
  property bool isExiting: false

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

  // Animation cho container khi load vào
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

  // ── EXIT ANIMATION ──────────────────────────────────────────────────────────
  // Sequence:
  //  1) Ripple ring expands from center + particles burst
  //  2) Container implodes (scale → 0, opacity → 0)
  //  3) Whole overlay fades out
  //  4) PauseAnimation lets compositor prepare the desktop frame
  //  5) ScriptAction releases WlSessionLock
  // ────────────────────────────────────────────────────────────────────────────
  SequentialAnimation {
    id: exitAnimation
    running: false

    // Step 1: show ripple and particles
    PauseAnimation { duration: 60 }
    ScriptAction { script: { ripple.visible = true; particleSystem.burst() } }

    // Step 2: let the ripple + particles play for a moment
    PauseAnimation { duration: 320 }

    // Step 3: implode container + fade overlay simultaneously
    ParallelAnimation {

      // Container implodes with a spring-back feel
      SequentialAnimation {
        // Tiny scale-up "breath" before the suck-in
        NumberAnimation {
          target: mainContainer; property: "scale"
          to: 1.08; duration: 120; easing.type: Easing.OutQuad
        }
        // Hard suck-in
        NumberAnimation {
          target: mainContainer; property: "scale"
          to: 0.0; duration: 380; easing.type: Easing.InBack
        }
      }

      NumberAnimation {
        target: mainContainer; property: "opacity"
        to: 0; duration: 420; easing.type: Easing.InQuad
      }

      // Password box zooms out faster than the container
      NumberAnimation {
        target: passwordContainer; property: "scale"
        to: 0.5; duration: 280; easing.type: Easing.InBack
      }

      // Blur opens up — peels back to reveal wallpaper underneath
      NumberAnimation {
        target: blurEffect; property: "radius"
        to: 0; duration: 600; easing.type: Easing.InOutCubic
      }

      // Dim overlay fades out
      NumberAnimation {
        target: blurOverlay; property: "opacity"
        to: 0; duration: 500; easing.type: Easing.InQuad
      }

      // Floating circles + stars fade with the overlay
      NumberAnimation {
        target: mainContent; property: "opacity"
        to: 0; duration: 500; easing.type: Easing.InCubic
      }
    }

    // Hold the wallpaper fully visible for one compositor repaint cycle
    PauseAnimation { duration: 140 }

    // Safe to release — compositor has had time to prepare the desktop frame
    ScriptAction {
      script: {
        console.log("Exit animation done — releasing WlSessionLock")
        root.context.releaseLock()
      }
    }
  }

  // Watch LockContext for the unlocked() signal and play exit animation
  Connections {
    target: root.context

    // unlocked() fires when PAM succeeds — start exit animation.
    // Lock.qml's onUnlocked is intentionally empty; we drive teardown timing here.
    function onUnlocked() {
      console.log("LockContext.onUnlocked — starting exit animation")
      if (!root.isExiting) {
        root.isExiting = true
        exitAnimation.start()
      }
    }

    // Keep password field in sync with context.currentText (multi-surface support)
    function onCurrentTextChanged() {
      if (passwordBox.text !== root.context.currentText) {
        passwordBox.text = root.context.currentText
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

    // Separate dim overlay so we can animate it independently from the blur
    Rectangle {
      id: blurOverlay
      anchors.fill: parent
      color: "black"
      opacity: 0.3
    }
  }

  // ── RIPPLE RING (transparent) ─────────────────────────────────────────────────
  // Expands from the center of the screen on unlock, like a shockwave
  Item {
    id: ripple
    anchors.fill: parent
    visible: false
    z: 3

    Repeater {
      model: 3
      Rectangle {
        anchors.centerIn: parent
        width: 10
        height: 10
        radius: width / 2
        color: "transparent"
        border.color: Qt.rgba(255, 255, 255, 0.15) // transparent white
        border.width: 2

        SequentialAnimation on width {
          running: ripple.visible
          PauseAnimation { duration: index * 120 }
          NumberAnimation {
            from: 10
            to: Math.max(parent.parent.width, parent.parent.height) * 1.6
            duration: 700
            easing.type: Easing.OutCubic
          }
        }
        SequentialAnimation on height {
          running: ripple.visible
          PauseAnimation { duration: index * 120 }
          NumberAnimation {
            from: 10
            to: Math.max(parent.parent.width, parent.parent.height) * 1.6
            duration: 700
            easing.type: Easing.OutCubic
          }
        }
        SequentialAnimation on opacity {
          running: ripple.visible
          PauseAnimation { duration: index * 120 }
          NumberAnimation { from: 1; to: 0; duration: 700; easing.type: Easing.OutCubic }
        }
        SequentialAnimation on radius {
          running: ripple.visible
          PauseAnimation { duration: index * 120 }
          NumberAnimation {
            from: 5
            to: Math.max(parent.parent.width, parent.parent.height) * 0.8
            duration: 700
            easing.type: Easing.OutCubic
          }
        }
      }
    }
  }

  // ── PARTICLE BURST (transparent stars) ──────────────────────────────────────────
  // Small glowing dots that shoot outward from center on unlock
  Item {
    id: particleSystem
    anchors.fill: parent
    visible: false
    z: 3

    property int particleCount: 18

    function burst() {
      particleSystem.visible = true
      for (let i = 0; i < particleRepeater.count; i++) {
        particleRepeater.itemAt(i).launch()
      }
    }

    Repeater {
      id: particleRepeater
      model: particleSystem.particleCount

      Item {
        id: particle
        x: parent.width / 2
        y: parent.height / 2
        width: 0
        height: 0

        property real angle: (index / particleSystem.particleCount) * Math.PI * 2
        property real speed: 180 + Math.random() * 220
        property real size: 5 + Math.random() * 8
        property real life: 550 + Math.random() * 250

        function launch() {
          dot.width = size
          dot.height = size
          dot.radius = size / 2
          dot.opacity = 1
          xAnim.to = Math.cos(angle) * speed
          yAnim.to = Math.sin(angle) * speed
          xAnim.duration = life
          yAnim.duration = life
          fadeAnim.duration = life
          xAnim.start()
          yAnim.start()
          fadeAnim.start()
        }

        Rectangle {
          id: dot
          anchors.centerIn: parent
          width: 0; height: 0; radius: 0
          color: Qt.rgba(255, 255, 255, 0.5) // transparent white
          opacity: 0

          layer.enabled: true
          layer.effect: Glow {
            samples: 8
            radius: dot.width
            color: Qt.rgba(255, 255, 255, 0.3)
            spread: 0.3
          }
        }

        NumberAnimation { id: xAnim; target: particle; property: "x"; easing.type: Easing.OutCubic }
        NumberAnimation { id: yAnim; target: particle; property: "y"; easing.type: Easing.OutCubic }
        NumberAnimation { id: fadeAnim; target: dot; property: "opacity"; to: 0; easing.type: Easing.InQuad }
      }
    }
  }

  // ── MAIN CONTENT ─────────────────────────────────────────────────────────────
  // Only this layer is animated out on exit.
  // Wallpaper stays visible so WlSessionLock releases without a black flash.
  Item {
    id: mainContent
    anchors.fill: parent
    opacity: wallpaperReady ? 1 : 0
    visible: opacity > 0

    Behavior on opacity {
      NumberAnimation { duration: 500; easing.type: Easing.OutQuad }
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

      scale: animationProgress
      opacity: animationProgress

      Behavior on scale {
        NumberAnimation { duration: 600; easing.type: Easing.OutBack }
      }

      Behavior on opacity {
        NumberAnimation { duration: 500; easing.type: Easing.OutQuad }
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

              // Icon: shows lock_open while PAM is actively authenticating
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
                enabled: !root.context.unlockInProgress && !root.isExiting
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData

                onTextChanged: {
                  root.context.currentText = this.text
                  passwordContainer.scale = 1.02
                  scaleResetTimer.restart()
                }

                // Enter key: delegate to LockContext which owns the PamContext
                onAccepted: root.context.tryUnlock()

                Timer {
                  id: scaleResetTimer
                  interval: 100
                  onTriggered: passwordContainer.scale = 1.0
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
                  // Spin the arrow while PAM is processing
                  rotation: root.context.unlockInProgress ? 360 : 0
                  Behavior on rotation { NumberAnimation { duration: 500 } }
                }

                MouseArea {
                  id: unlockMouseArea
                  anchors.fill: parent
                  hoverEnabled: true
                  enabled: !root.context.unlockInProgress && !root.isExiting && root.context.currentText !== ""
                  onClicked: root.context.tryUnlock()
                  cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                }
              }
            }
          }

          // Error badge: driven by LockContext.showFailure
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