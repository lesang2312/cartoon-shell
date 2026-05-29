// StarField.qml
import QtQuick

Item {
  id: root

  property int starCount: 50
  property real starMinSize: 2
  property real starMaxSize: 5
  property color starColor: theme.button.text
  property real starMinOpacity: 0.3
  property real starMaxOpacity: 1.0
  property int starFadeDuration: 1000

  property int shootingStarCount: 10
  property color shootingStarColor: theme.button.text
  property real shootingStarMinSpeed: 0.4
  property real shootingStarMaxSpeed: 1
  property int shootingStarMinDelay: 0
  property int shootingStarMaxDelay: 1000
  property int shootingStarTrailMinLength: 80
  property int shootingStarTrailMaxLength: 230

  anchors.fill: parent

  Item {
    id: starsLayer
    anchors.fill: parent

    Repeater {
      model: root.starCount

      Rectangle {
        id: star
        x: Math.random() * root.width
        y: Math.random() * root.height
        width: Math.random() * (root.starMaxSize - root.starMinSize) + root.starMinSize
        height: width
        radius: width / 2
        color: root.starColor
        opacity: 0

        SequentialAnimation on opacity {
          loops: Animation.Infinite
          running: true

          PauseAnimation {
            duration: Math.random() * 2000
          }
          NumberAnimation {
            to: Math.random() * (root.starMaxOpacity - root.starMinOpacity) + root.starMinOpacity
            duration: root.starFadeDuration
          }
          NumberAnimation {
            to: 0
            duration: root.starFadeDuration
          }
        }
      }
    }
  }

  // Layer chứa sao băng
  Item {
    id: shootingStarsLayer
    anchors.fill: parent

    Repeater {
      model: root.shootingStarCount

      Item {
        id: shootingStar

        property real speed: Math.random() * (root.shootingStarMaxSpeed - root.shootingStarMinSpeed) + root.shootingStarMinSpeed
        property real startX: 0
        property real startY: 0
        property real endX: 0
        property real endY: 0
        property int trailLength: Math.random() * (root.shootingStarTrailMaxLength - root.shootingStarTrailMinLength) + root.shootingStarTrailMinLength

        visible: opacity > 0
        opacity: 0
        rotation: 135

        // Thân sao băng
        Rectangle {
          width: 6
          height: 6
          radius: 3
          color: root.shootingStarColor

          // Đuôi sao băng
          Rectangle {
            anchors.right: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: shootingStar.trailLength
            height: 3
            opacity: 0.7
            gradient: Gradient {
              orientation: Gradient.Horizontal
              GradientStop { position: 0.0; color: "transparent" }
              GradientStop { position: 1.0; color: root.shootingStarColor }
            }
          }
        }

        // Animation cho sao băng
        SequentialAnimation {
          id: shootingStarAnimation
          loops: Animation.Infinite
          running: true

          ScriptAction {
            script: {
              // Tính toán vị trí bắt đầu và kết thúc ngẫu nhiên
              var offsetX = Math.random() * 600 - 300
              var offsetY = Math.random() * 400 - 200

              shootingStar.startX = root.width + 400 + offsetX
              shootingStar.startY = -300 + offsetY
              shootingStar.endX = -1000 + (Math.random() * 1000 - 500)
              shootingStar.endY = root.height + 800 + (Math.random() * 800 - 400)

              shootingStar.x = shootingStar.startX
              shootingStar.y = shootingStar.startY

              // Random lại speed mỗi lần
              shootingStar.speed = Math.random() * (root.shootingStarMaxSpeed - root.shootingStarMinSpeed) + root.shootingStarMinSpeed
              shootingStar.trailLength = Math.random() * (root.shootingStarTrailMaxLength - root.shootingStarTrailMinLength) + root.shootingStarTrailMinLength
            }
          }

          // Xuất hiện
          NumberAnimation {
            target: shootingStar
            property: "opacity"
            from: 0
            to: 1
            duration: 200
          }

          // Di chuyển
          ParallelAnimation {
            NumberAnimation {
              target: shootingStar
              property: "x"
              to: shootingStar.endX
              duration: 2500 / shootingStar.speed
              easing.type: Easing.Linear
            }
            NumberAnimation {
              target: shootingStar
              property: "y"
              to: shootingStar.endY
              duration: 2500 / shootingStar.speed
              easing.type: Easing.Linear
            }
          }

          // Biến mất
          NumberAnimation {
            target: shootingStar
            property: "opacity"
            to: 0
            duration: 200
          }
        }
      }
    }
  }
}
