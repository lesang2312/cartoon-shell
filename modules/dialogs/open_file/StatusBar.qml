import QtQuick
import QtQuick.Controls

import QtQuick.Layouts
import qs.components

Rectangle {
  id: root
  Layout.fillWidth: true
  Layout.preferredHeight: 120

  height: 30
  color: theme.primary.dim_background
  property var selectedFile: ""

  radius: 16
  border.width: 1
  border.color: theme.primary.foreground

  ColumnLayout{
    anchors.fill: parent
    anchors.margins: 20
    RowLayout {
      Layout.fillWidth: true
      Layout.preferredHeight: parent.width/2
      anchors.margins: 5

      CustomText {
        Layout.preferredWidth: parent.width * 0.2
        name: "File open: "
        size: "small"
      }
      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 35
        radius: 12
        color: theme.primary.dim_background
        border.color: theme.button.border
        border.width: 2
        RowLayout {
          anchors.fill: parent
          anchors.margins: 2
          anchors.leftMargin: 10
          spacing: 8

          TextField {
            Layout.fillWidth: true
            placeholderText: "Tìm kiếm thư mục..."
            text: root.selectedFile.toString().replace("file://", "")
            palette.text: theme.primary.foreground       // màu chữ chính
            palette.placeholderText: theme.primary.dim_foreground  // sửa thành dim_foreground
            font.pixelSize: 14
            font.family: "ComicShannsMono Nerd Font"
            background: Rectangle {
              color: "transparent"
            }
            selectByMouse: true

            onTextChanged: {
              // restart debounce timer mỗi khi gõ
            }

            Keys.onReturnPressed: {
              // gọi ngay (bỏ qua debounce) khi nhấn Enter

            }

            Keys.onEscapePressed: {
              // Khi nhấn Escape trong search field, đóng panel
            }

            // Helper function để tìm LauncherPanel
          }
        }

      }
      ButtonText{
        Layout.preferredWidth: 100
        Layout.preferredHeight: 35
        radius: 12
        border.width: 2
        name: "Open"
        size: "small"
      }
    }
    RowLayout {
      Layout.fillWidth: true
      Layout.preferredHeight: parent.width/2
      anchors.margins: 5

      CustomText {
        Layout.preferredWidth: parent.width * 0.2
        name: "File of types: "
        size: "small"
      }
      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 35
        radius: 12
        color: theme.primary.dim_background
        border.color: theme.button.border
        border.width: 2
        RowLayout {
          anchors.fill: parent
          anchors.margins: 2
          anchors.leftMargin: 10
          spacing: 8

          TextField {
            Layout.fillWidth: true
            placeholderText: "Tìm kiếm thư mục..."
            palette.text: theme.primary.foreground       // màu chữ chính
            palette.placeholderText: theme.primary.dim_foreground  // sửa thành dim_foreground
            font.pixelSize: 14
            font.family: "ComicShannsMono Nerd Font"
            background: Rectangle {
              color: "transparent"
            }
            selectByMouse: true

            onTextChanged: {
              // restart debounce timer mỗi khi gõ
            }

            Keys.onReturnPressed: {
              // gọi ngay (bỏ qua debounce) khi nhấn Enter

            }

            Keys.onEscapePressed: {
              // Khi nhấn Escape trong search field, đóng panel
            }

            // Helper function để tìm LauncherPanel
          }
        }

      }
      ButtonText{
        Layout.preferredWidth: 100
        Layout.preferredHeight: 35
        radius: 12
        border.width: 2
        name: "Cancel"
        size: "small"
      }
    }
  }
}
