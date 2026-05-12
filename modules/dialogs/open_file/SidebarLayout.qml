import QtQuick
import QtQuick.Layouts
import qs.components
import qs.modules.dialogs.open_file as Com
Item {
  Layout.fillHeight: true
  Layout.preferredWidth: 180
  Rectangle {
    anchors.fill: parent
    border.width: 1
    border.color: theme.primary.foreground
    radius: 16
    color: theme.primary.dim_background
    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 10

      Com.ItemFolderSidebar{
        image: "filebrowser/home.png"
        name: "Home"
      }
      Com.ItemFolderSidebar{
        image: "filebrowser/documents.png"
        name: "Document"
      }
      Com.ItemFolderSidebar{
        image: "filebrowser/downloads.png"
        name: "Downloads"
      }
      Com.ItemFolderSidebar{
        image: "filebrowser/music.png"
        name: "Music"
      }
      Com.ItemFolderSidebar{
        image: "filebrowser/pictures.png"
        name: "Pictures"
      }
      Com.ItemFolderSidebar{
        image: "filebrowser/config.png"
        name: "~/.config"
      }

    }
  }
}
