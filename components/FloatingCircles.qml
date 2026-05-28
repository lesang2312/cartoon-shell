// FloatingCircles.qml
import QtQuick

Item {
  id: root

  property color circleColor: theme.button.text
  property int circleCount: 5
  property real minRadius: 80
  property real maxRadius: 250
  property real minOpacity: 0.03
  property real maxOpacity: 0.15
  property real minDuration: 40000
  property real maxDuration: 80000
  property bool startFromCenter: true  // Thêm property để điều khiển

  anchors.fill: parent
  clip: true

  Repeater {
    id: circlesRepeater
    model: root.circleCount

    Rectangle {
      id: circle

      // Kích thước ngẫu nhiên
      property real circleRadius: Math.random() * (root.maxRadius - root.minRadius) + root.minRadius
      property real circleOpacity: Math.random() * (root.maxOpacity - root.minOpacity) + root.minOpacity
      property real moveDuration: Math.random() * (root.maxDuration - root.minDuration) + root.minDuration
      property bool hasStarted: false  // Đánh dấu đã bắt đầu di chuyển chưa

      width: circleRadius * 2
      height: circleRadius * 2
      radius: circleRadius
      color: root.circleColor
      opacity: circleOpacity

      // Vị trí ban đầu: từ chính giữa
      x: (parent.width / 2) - (width / 2)
      y: (parent.height / 2) - (height / 2)

      // Animation di chuyển - chỉ bắt đầu sau khi khởi tạo
      ParallelAnimation {
        id: moveAnimation
        loops: Animation.Infinite
        running: false  // Tạm thời chưa chạy

        NumberAnimation {
          id: xAnimation
          target: circle
          property: "x"
          to: Math.random() * (circle.parent.width - circle.width)
          duration: circle.moveDuration
          easing.type: Easing.InOutQuad
        }

        NumberAnimation {
          id: yAnimation
          target: circle
          property: "y"
          to: Math.random() * (circle.parent.height - circle.height)
          duration: circle.moveDuration
          easing.type: Easing.InOutQuad
        }
      }

      // Animation scale
      SequentialAnimation {
        id: scaleSeqAnimation
        loops: Animation.Infinite
        running: false  // Tạm thời chưa chạy

        NumberAnimation {
          target: circle
          property: "scale"
          to: 1.15
          duration: Math.random() * 8000 + 4000
          easing.type: Easing.InOutSine
        }

        NumberAnimation {
          target: circle
          property: "scale"
          to: 0.85
          duration: Math.random() * 8000 + 4000
          easing.type: Easing.InOutSine
        }
      }

      // Delay trước khi bắt đầu di chuyển để tạo hiệu ứng tuần tự
      Timer {
        id: startDelay
        interval: index * 2000  // Mỗi circle delay khác nhau
        running: true
        repeat: false
        onTriggered: {
          moveAnimation.running = true
          scaleSeqAnimation.running = true
          hasStarted = true
        }
      }

      // Thay đổi hướng di chuyển định kỳ
      Timer {
        interval: circle.moveDuration
        running: moveAnimation.running
        repeat: true

        onTriggered: {
          if (hasStarted) {
            // Cập nhật thời gian mới
            circle.moveDuration = Math.random() * (root.maxDuration - root.minDuration) + root.minDuration

            // Cập nhật target mới
            xAnimation.to = Math.random() * (circle.parent.width - circle.width)
            yAnimation.to = Math.random() * (circle.parent.height - circle.height)
            xAnimation.duration = circle.moveDuration
            yAnimation.duration = circle.moveDuration

            // Khởi tạo lại animation
            moveAnimation.stop()
            moveAnimation.start()
          }
        }
      }

      Component.onCompleted: {
        console.log("Circle created at center - Radius:", circleRadius, "Opacity:", circleOpacity)
      }
    }
  }
}
