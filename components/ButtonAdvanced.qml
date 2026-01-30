import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services

Rectangle {
    property var theme: ThemeService.theme
    property var lang: currentLanguage
    property bool hovered: false
    
    id: advancedButton
    visible: !panelManager.fullsetting
    width: 25
    height: 25
    radius: 5
    color: theme.primary.dim_background
    border{
      color: theme.button.border
      width: 2
    }
    
    // Hình vuông với border
    Rectangle {
        id: square
        anchors.centerIn: parent
        width: 13 // Kích thước nhỏ hơn button
        height: 13
        color: theme.primary.dim_background
        border.color: theme.primary.foreground  // Màu border lấy từ theme
        border.width: 2
        radius: 2  // Bo góc nhẹ (có thể đặt = 0 nếu muốn góc vuông)
        
        // Thêm thuộc tính scale
        property real normalScale: 1.0
        property real hoverScale: 1.2  // Tăng 20% khi hover
        scale: hovered ? hoverScale : normalScale
        
        // Thêm hiệu ứng mượt mà khi scale thay đổi
        Behavior on scale {
            NumberAnimation {
                duration: 150  // Thời gian animation (ms)
                easing.type: Easing.InOutQuad  // Hiệu ứng easing
            }
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: advancedButton.hovered = true
        onExited: advancedButton.hovered = false
        onClicked: {
            panelManager.togglePanel("fullsetting")
            // Thêm xử lý khi click vào đây
        }
    }
}
