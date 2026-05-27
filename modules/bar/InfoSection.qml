import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.services
import qs.commons
import qs.components

Rectangle {
  id: root
  color: theme.primary.background
  radius: ScalerService.s(Settings.appearance.radius2)
  border.color: theme.button.border
  border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0

  property string selectedFlag: Settings.appearance.countryFlag
  property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"

  // UI Layout
  Loader {
    anchors.fill: parent
    anchors.margins: isVertical ? ScalerService.s(8) : ScalerService.s(10)
    sourceComponent: isVertical ? verticalLayout : horizontalLayout
  }

  Component {
    id: horizontalLayout

    RowLayout {
      anchors.fill: parent
      anchors {
        leftMargin: ScalerService.s(10)
        rightMargin: ScalerService.s(10)
      }
      spacing: ScalerService.s(5)

      // Phần datetime - căn trái
      Item {
        id: timeContainer
        Layout.preferredWidth: textCurrentDate.implicitWidth + ScalerService.s(20)
        Layout.fillHeight: true

        ColumnLayout {
          anchors.fill: parent
          anchors.leftMargin: ScalerService.s(10)
          spacing: 0
          CustomText{
            name: DateTimeService.currentTime
            isBold: true
            size: "small"
          }
          CustomText {
            id: textCurrentDate

            name : DateTimeService.currentDate
            size: "xs"
            color: theme.primary.dim_foreground

          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            VisibleService.togglePanel("calendar");
          }

          // Hiệu ứng hover
          onEntered: {
            timeContainer.scale = 1.04;
          }
          onExited: {
            timeContainer.scale = 1.0;
          }
        }

        Behavior on scale {
          NumberAnimation {
            duration: 100
          }
        }
      }

      // Spacer để đẩy phần giữa ra chính giữa
      Item {
        Layout.fillWidth: true
      }

      // Phần weather - căn giữa
      Item {
        id: weatherContainer
        Layout.preferredWidth: contentWeather.implicitWidth
        Layout.fillHeight: true

        RowLayout {
          id: contentWeather
          anchors.centerIn: parent
          IconImage {
            path: WeatherService.icon
            size: "normal"
          }

          ColumnLayout {
            spacing: ScalerService.s(1)
            CustomText {
              name: WeatherService.temperature || "Đang tải..."
              Layout.alignment: Qt.AlignVCenter
              size: "small"
            }
            CustomText {
              id: textCondition

              name: WeatherService.condition.slice(0, 15) || "..."
              size: "xs"
              elide: Text.ElideRight
              maximumLineCount: 1
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            VisibleService.togglePanel("weather");
          }

          onEntered: {
            weatherContainer.scale = 1.04;
          }
          onExited: {
            weatherContainer.scale = 1.0;
          }
        }

        Behavior on scale {
          NumberAnimation {
            duration: 100
          }
        }
      }

      // Spacer để đẩy phần flag sang bên phải
      Item {
        Layout.fillWidth: true
      }

      // Flag Selector - căn phải
      Item {
        id: flagContainer
        Layout.preferredWidth: ScalerService.s(32)
        Layout.fillHeight: parent

        ButtonIconImage{
          path: root.selectedFlag ? `flags/${root.selectedFlag}.png` : ""
          size: "large"
          anchors.centerIn: parent
          onClicked: VisibleService.togglePanel("flag");
        }
      }
    }
  }

  Component {
    id: verticalLayout

    ColumnLayout {
      anchors.fill: parent
      spacing: ScalerService.s(8)
      anchors.margins: ScalerService.s(10)
      Item {
        id: timeContainerVertical
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(50)

        // Xoay container để hiển thị theo chiều dọc
        Item {
          anchors.centerIn: parent
          width: parent.height  // Đảo width và height
          height: parent.width
          transformOrigin: Item.Center

          ColumnLayout {
            anchors.centerIn: parent
            spacing: ScalerService.s(2)

            Text {
              text: DateTimeService.currentHour
              color: theme.primary.foreground
              font {
                pixelSize: ScalerService.s(20)
                bold: true
                family: "ComicShannsMono Nerd Font"
              }
            }
            Text {
              text: DateTimeService.currentMinus
              color: theme.primary.foreground
              font {
                pixelSize: ScalerService.s(20)
                bold: true
                family: "ComicShannsMono Nerd Font"
              }
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            VisibleService.togglePanel("calendar");
          }

          // Hiệu ứng hover
          onEntered: {
            timeContainerVertical.opacity = 0.8;
          }
          onExited: {
            timeContainerVertical.opacity = 1.0;
          }
        }

        Behavior on opacity {
          NumberAnimation {
            duration: 100
          }
        }
      }
      Item {
        id: weatherContainerVertical
        Layout.fillWidth: true
        Layout.fillHeight: true

        // Xoay container để hiển thị theo chiều dọc
        Item {
          anchors.centerIn: parent
          width: parent.height  // Đảo width và height
          height: parent.width
          transformOrigin: Item.Center

          ColumnLayout {
            anchors.centerIn: parent
            spacing: ScalerService.s(8)

            IconImage {
              path: WeatherService.icon
            }

            ColumnLayout {
              spacing: ScalerService.s(1)
              Text {
                text: WeatherService.temperature || "Đang tải..."
                color: theme.primary.foreground
                Layout.alignment: Qt.AlignVCenter
                font {
                  pixelSize: ScalerService.s(14)
                  bold: true
                  family: "ComicShannsMono Nerd Font"
                }
              }
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
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

      // Flag ở trên cùng
      Item {
        id: flagContainerVertical
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(40)

        Image {
          source: root.selectedFlag ? `../../assets/flags/${root.selectedFlag}.png` : ""
          width: ScalerService.s(30)
          height: ScalerService.s(30)
          fillMode: Image.PreserveAspectFit
          smooth: true
          anchors.centerIn: parent
          visible: root.selectedFlag !== ""
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            VisibleService.togglePanel("flag");
          }

          onEntered: {
            flagContainerVertical.scale = 1.1;
          }
          onExited: {
            flagContainerVertical.scale = 1.0;
          }
        }

        Behavior on scale {
          NumberAnimation {
            duration: 100
          }
        }
      }
    }
  }
}
