// components/Settings/PanelPositionSelector.qml
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components
import qs.commons

ColumnLayout {
  spacing: 20
  Layout.fillWidth: true
  CustomText {
    name: root.lang?.appearance?.panel_position || "Panel Position"
    isBold: true
  }
  GridLayout {
    columns: 2
    rowSpacing: 15
    columnSpacing: 15
    Layout.fillWidth: true

    // Top position
    Rectangle {
      id: topOption
      Layout.fillWidth: true
      Layout.preferredHeight: 80
      radius: 10
      color: theme.primary.dim_background
      border.color: Settings.bar.position === "top" ? theme.normal.blue : "transparent"
      border.width: 2

      ColumnLayout {
        anchors.centerIn: parent
        spacing: 5

        Rectangle {
          Layout.alignment: Qt.AlignHCenter
          width: 60
          height: 10
          radius: 3
          color: Settings.bar.position === "top" ? theme.normal.blue : theme.primary.dim_foreground
        }

        Text {
          text: root.lang?.appearance?.top || "Top"
          color: Settings.bar.position === "top" ? theme.normal.blue : theme.primary.foreground
          font {
            family: "ComicShannsMono Nerd Font"
            pixelSize: 14
          }
          Layout.alignment: Qt.AlignHCenter
        }
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          Settings.bar.position = "top";
        }
        onEntered: parent.opacity = 0.9
        onExited: parent.opacity = 1.0
      }

      Behavior on opacity {
        NumberAnimation {
          duration: 100
        }
      }
    }

    // Bottom position
    Rectangle {
      id: bottomOption
      Layout.fillWidth: true
      Layout.preferredHeight: 80
      radius: 10
      color: theme.primary.dim_background
      border.color: Settings.bar.position === "bottom" ? theme.normal.blue : "transparent"
      border.width: 2

      ColumnLayout {
        anchors.centerIn: parent
        spacing: 5

        Rectangle {
          Layout.alignment: Qt.AlignHCenter
          width: 60
          height: 10
          radius: 3
          color: Settings.bar.position === "bottom" ? theme.normal.blue : theme.primary.dim_foreground
        }

        Text {
          text: root.lang?.appearance?.bottom || "Bottom"
          color: Settings.bar.position === "bottom" ? theme.normal.blue : theme.primary.foreground
          font {
            family: "ComicShannsMono Nerd Font"
            pixelSize: 14
          }
          Layout.alignment: Qt.AlignHCenter
        }
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          Settings.bar.position = "bottom";
        }
        onEntered: parent.opacity = 0.9
        onExited: parent.opacity = 1.0
      }

      Behavior on opacity {
        NumberAnimation {
          duration: 100
        }
      }
    }

    // Left position
    Rectangle {
      id: leftOption
      Layout.fillWidth: true
      Layout.preferredHeight: 80
      radius: 10
      color: theme.primary.dim_background
      border.color: Settings.bar.position === "left" ? theme.normal.blue : "transparent"
      border.width: 2

      RowLayout {
        anchors.centerIn: parent
        spacing: 10

        Rectangle {
          Layout.alignment: Qt.AlignVCenter
          width: 10
          height: 40
          radius: 3
          color: Settings.bar.position === "left" ? theme.normal.blue : theme.primary.dim_foreground
        }

        Text {
          text: root.lang?.appearance?.left || "Left"
          color: Settings.bar.position === "left" ? theme.normal.blue : theme.primary.foreground
          font {
            family: "ComicShannsMono Nerd Font"
            pixelSize: 14
          }
          Layout.alignment: Qt.AlignVCenter
        }
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          Settings.bar.position = "left";
        }
        onEntered: parent.opacity = 0.9
        onExited: parent.opacity = 1.0
      }

      Behavior on opacity {
        NumberAnimation {
          duration: 100
        }
      }
    }

    // Right position
    Rectangle {
      id: rightOption
      Layout.fillWidth: true
      Layout.preferredHeight: 80
      radius: 10
      color: theme.primary.dim_background
      border.color: Settings.bar.position === "right" ? theme.normal.blue : "transparent"
      border.width: 2

      RowLayout {
        anchors.centerIn: parent
        spacing: 10

        Text {
          text: root.lang?.appearance?.right || "Right"
          color: Settings.bar.position === "right" ? theme.normal.blue : theme.primary.foreground
          font {
            family: "ComicShannsMono Nerd Font"
            pixelSize: 14
          }
          Layout.alignment: Qt.AlignVCenter
        }

        Rectangle {
          Layout.alignment: Qt.AlignVCenter
          width: 10
          height: 40
          radius: 3
          color: Settings.bar.position === "right" ? theme.normal.blue : theme.primary.dim_foreground
        }
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          Settings.bar.position = "right";
        }
        onEntered: parent.opacity = 0.9
        onExited: parent.opacity = 1.0
      }

      Behavior on opacity {
        NumberAnimation {
          duration: 100
        }
      }
    }
  }
}
