import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Qt5Compat.GraphicalEffects
import Quickshell.Wayland
import Quickshell.Io

Rectangle {
  id: root
  required property LockContext context

  property string backgroundImagePath: "/home/crystalforceix/Pictures/Wallpapers/default-wallpaper.jpg"

  color: "#0a0e27"

  gradient: Gradient {
    GradientStop { position: 0.0; color: "#0a0e27" }
    GradientStop { position: 0.5; color: "#1a1f3a" }
    GradientStop { position: 1.0; color: "#0f1329" }
  }

  Image {
    id: backgroundImage
    anchors.fill: parent
    source: root.backgroundImagePath
    fillMode: Image.PreserveAspectCrop
    visible: false
    asynchronous: true
    cache: true
  }

  FastBlur {
    id: blurEffect
    anchors.fill: parent
    source: backgroundImage
    radius: 64
    visible: root.backgroundImagePath !== ""
    opacity: 1
    cached: true

    Rectangle {
      anchors.fill: parent
      color: "black"
      opacity: 0.4
    }
  }

  // --- PASSWORD INPUT ---
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
          placeholderText: "Tell me your password:33"
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
}
