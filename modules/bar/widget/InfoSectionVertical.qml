import qs.components
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.components
import qs.commons

Item {
  id: root
  property real animationProgress: 0
  ColumnLayout {
    anchors.fill: parent
    spacing: ScalerService.s(8)
    anchors.margins: ScalerService.s(10)
    Item {
      id: timeContainerVertical

      Layout.fillWidth: parent
      Layout.preferredHeight: ScalerService.s(60)

      // Xoay container để hiển thị theo chiều dọc
      Item {
        anchors.centerIn: parent
        implicitWidth: parent.width
        implicitHeight: parent.height

        ColumnLayout {
          anchors.centerIn: parent
          id: contenTime
          spacing: ScalerService.s(2)

          CustomText {
            name: DateTimeService.currentHour
            isBold: true
            opacity: root.animationProgress > 0.3 ? 1 : 0
          }
          CustomText {
            name: DateTimeService.currentMinus
            isBold: true
            opacity: root.animationProgress > 0.35 ? 1 : 0
          }
        }
      }

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          SoundService.playSound("pick")
          VisibleService.togglePanel("calendar");
        }
      }
    }
    Item {
      Layout.fillHeight: true
    }
    Item {
      id: weatherContainerVertical
      Layout.preferredHeight: ScalerService.s(50)
      Layout.fillWidth: true

      Item {
        anchors.centerIn: parent
        implicitWidth: parent.width
        implicitHeight: parent.height
        transformOrigin: Item.Center

        ColumnLayout {
          anchors.centerIn: parent
          spacing: ScalerService.s(8)

          IconImage {
            path: WeatherService.getWeatherIcon(
              WeatherService.dataModel.current.condition.code,
              WeatherService.dataModel.current.is_day
            )
            opacity: root.animationProgress > 0.4 ? 1 : 0
            Layout.alignment: Qt.AlignHCenter
          }

          ColumnLayout {
            spacing: ScalerService.s(1)
            CustomText {
              opacity: root.animationProgress > 0.45 ? 1 : 0
              name: `${WeatherService.dataModel.current.temp_c}°C` || "Đang tải..."
              Layout.alignment: Qt.AlignHCenter
              size: "xs"
            }
          }
        }
      }

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          SoundService.playSound("pick")
          VisibleService.togglePanel("weather");
        }

        onEntered: {
          weatherContainerVertical.opacity = 0.8;
        }
        onExited: {
          weatherContainerVertical.opacity = 1.0;
        }
      }

      Behavior on opacity {
        NumberAnimation {
          duration: 100
        }
      }
    }

    Item {
      Layout.fillHeight: true
    }
    // Flag ở trên cùng
    Item {
      id: flagContainer
      Layout.fillWidth: parent
      Layout.preferredHeight: ScalerService.s(24)

      ButtonIconImage{
        opacity: root.animationProgress > 0.5 ? 1 : 0
        path:  `flags/${root.selectedFlag}.png`
        anchors.centerIn: parent
        onClicked: VisibleService.togglePanel("flag");
      }
    }
  }
}
