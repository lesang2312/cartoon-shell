import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components
ColumnLayout {
  Layout.fillWidth: true
  spacing: 6

  // Progress bar
  Rectangle {
    id: parent_progress_bar
    Layout.fillWidth: true
    Layout.preferredHeight: 4
    radius: 2
    color: theme.primary.dim_background

    Rectangle {
      id: progress_bar
      width: parent.width * Players.getProgress()
      height: parent.height
      radius: 2
      color: theme.button.text

    }
  }

  // Time labels
  RowLayout {
    Layout.fillWidth: true
    spacing: 0

    CustomText{
      id: music_pos
      name: Players.formatTime(Players.mprisPlayer?.position)
      size: "xs"
      Layout.alignment: Qt.AlignLeft
      textColor: theme.primary.dim_foreground
    }

    Item {
      Layout.fillWidth: true
    }
    CustomText{
      name: Players.formatTime(Players.mprisPlayer?.length)
      size: "xs"
      Layout.alignment: Qt.AlignRight

      textColor: theme.primary.dim_foreground
    }
  }
  Timer {
    interval: 1000   // 1 giây
    running: true
    repeat: true
    onTriggered: {
      music_pos.name = Players.formatTime(Players.mprisPlayer?.position)
      progress_bar.width = parent_progress_bar.width * Players.getProgress()
    }
  }
}
