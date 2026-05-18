import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.components

Rectangle {
  id: root

  property var theme: ThemeService.theme
  property var lang: LanguageService.translations

  required property string apiKey
  required property string location
  required property bool isSearchingLocation
  required property var locationSearchResults
  required property int currentLocationIndex
  required property bool isUserSearching
  required property string errorMessage
  property real animationProgress: 0

  signal apiKeyEdited(string newKey)
  signal locationTextEdited(string newText)
  signal searchLocationRequested(string query)
  signal locationSelected(string locationName)
  signal locationFocusStatusChanged(bool hasFocus)

  Layout.fillWidth: true
  Layout.fillHeight: true
  Layout.preferredWidth: parent.width * 0.4

  radius: 16
  color: theme.primary.dim_background
  border.color: theme.primary.foreground
  border.width: 1
  opacity: root.animationProgress > 0.15 ? 1 : 0
  Behavior on opacity {
    NumberAnimation {
      duration: 200
    }
  }

  ScrollView {
    anchors.fill: parent
    anchors.margins: 20
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

    ColumnLayout {
      width: parent.parent.width - 2
      spacing: 20

      // API Key Section
      ColumnLayout {
        Layout.fillWidth: true
        spacing: 12

        CustomText {
          name: lang?.weather?.apiKeyLabel || "API Key (weatherapi.com)"
          size: "small"
          isBold: true
          opacity: root.animationProgress > 0.2 ? 1 : 0
        }

        Rectangle {
          opacity: root.animationProgress > 0.25 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
          Layout.fillWidth: true
          height: 44
          radius: 10
          color: theme.primary.dim_background
          border.color: apiKeyInput.activeFocus ? theme.normal.blue : theme.primary.dim_foreground
          border.width: 1

          TextField {
            id: apiKeyInput
            anchors.fill: parent
            anchors.margins: 5
            text: root.apiKey
            palette.text: theme.primary.foreground
            font {
              pixelSize: 14
              family: "ComicShannsMono Nerd Font"
            }
            background: Rectangle {
              color: "transparent"
            }
            verticalAlignment: TextInput.AlignVCenter
            selectByMouse: true
            clip: true
            placeholderText: lang?.weather?.apiKeyPlaceholder || "Nhập API key của bạn..."
            palette.placeholderText: theme.primary.dim_foreground

            onTextChanged: {
              root.apiKeyEdited(text);
            }
          }
        }

        CustomText {
          opacity: root.animationProgress > 0.3 ? 1 : 0
          name: lang?.weather?.apiKeyHint || "Nhận API key miễn phí tại: weatherapi.com\nAPI key sẽ tự động lưu và kiểm tra khi bạn nhập"

          size: "xs"
          font.italic: true
          wrapMode: Text.WordWrap
          Layout.fillWidth: true
        }
      }

      // Location Section
      ColumnLayout {
        Layout.fillWidth: true
        spacing: 12

        CustomText {
          name: lang?.weather?.locationLabel || "Địa điểm"
          size: "small"
          isBold: true
          opacity: root.animationProgress > 0.35 ? 1 : 0
        }

        RowLayout {
          Layout.fillWidth: true
          spacing: 10

          Rectangle {
            opacity: root.animationProgress > 0.4 ? 1 : 0
            Behavior on opacity {
              NumberAnimation {
                duration: 200
              }
            }
            Layout.fillWidth: true
            height: 44
            radius: 10
            color: theme.primary.dim_background
            border.color: locationInput.activeFocus ? theme.normal.blue : theme.primary.dim_foreground
            border.width: 1

            TextField {
              id: locationInput
              anchors.fill: parent
              anchors.margins: 5
              text: root.location
              color: theme.primary.foreground
              font {
                pixelSize: 14
                family: "ComicShannsMono Nerd Font"
              }
              palette.text: theme.primary.foreground
              background: Rectangle {
                color: "transparent"
              }
              verticalAlignment: TextInput.AlignVCenter
              selectByMouse: true
              clip: true
              placeholderText: lang?.weather?.locationPlaceholder || "Tìm kiếm thành phố..."
              palette.placeholderText: theme.primary.dim_foreground

              onActiveFocusChanged: {
                root.locationFocusStatusChanged(activeFocus);
              }

              onTextChanged: {
                root.locationTextEdited(text);
              }
            }
          }

          Rectangle {
            width: 100
            height: 44
            radius: 10
            opacity: root.animationProgress > 0.45 ? 1 : 0
            Behavior on opacity {
              NumberAnimation {
                duration: 200
              }
            }

            color: theme.button.background

            border.color: theme.button.border
            border.width: 1

            IconText{
              name: "search"
              size: "small"
              anchors.centerIn: parent
              textColor: theme.button.text
            }
            MouseArea {
              id: saveLocMouseArea
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              enabled: !root.isSearchingLocation
              onClicked: root.searchLocationRequested(locationInput.text)
            }
          }
        }

        // Location search results
        ListView {
          id: locationResultsList
          visible: root.isUserSearching && configSection.locationSearchResults.length > 0
          Layout.fillWidth: true
          Layout.preferredHeight: Math.min(count * 52, 208)
          clip: true
          spacing: 4
          model: root.locationSearchResults
          currentIndex: root.currentLocationIndex

          delegate: Rectangle {
            width: ListView.view.width
            height: 50
            radius: 10

            gradient: Gradient {
              GradientStop {
                position: 0.0
                color: (ListView.isCurrentItem || locationResultMouseArea.containsMouse) ? Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.15) : "transparent"
              }
              GradientStop {
                position: 1.0
                color: (ListView.isCurrentItem || locationResultMouseArea.containsMouse) ? Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.05) : "transparent"
              }
            }

            border.color: (ListView.isCurrentItem || locationResultMouseArea.containsMouse) ? Qt.rgba(theme.normal.blue.r, theme.normal.blue.g, theme.normal.blue.b, 0.3) : "transparent"
            border.width: 1

            RowLayout {
              anchors.fill: parent
              anchors.margins: 12
              spacing: 12

              Column {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 2

                Text {
                  text: modelData.name
                  color: theme.primary.foreground
                  font {
                    pixelSize: 14
                    family: "ComicShannsMono Nerd Font"
                    bold: true
                  }
                  width: parent.width
                  elide: Text.ElideRight
                }

                Text {
                  text: `${modelData.region}, ${modelData.country}`
                  color: theme.primary.dim_foreground
                  font {
                    pixelSize: 12
                    family: "ComicShannsMono Nerd Font"
                  }
                  width: parent.width
                  elide: Text.ElideRight
                }
              }
            }

            MouseArea {
              id: locationResultMouseArea
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onPressed: {
                // Stop hide timer khi user click vào result
                hideResultsTimer.stop();
              }
              onClicked: {
                locationInput.text = `${modelData.name},${modelData.country}`;
                root.locationSelected(locationInput.text);
              }
            }
          }
        }
      }

      // Error message (nếu có)
      Rectangle {
        visible: root.errorMessage !== ""
        Layout.fillWidth: true
        Layout.preferredHeight: root.errorMessage !== "" ? 60 : 0
        radius: 12

        gradient: Gradient {
          GradientStop {
            position: 0.0
            color: Qt.rgba(theme.normal.red.r, theme.normal.red.g, theme.normal.red.b, 0.1)
          }
          GradientStop {
            position: 1.0
            color: Qt.rgba(theme.normal.red.r, theme.normal.red.g, theme.normal.red.b, 0.05)
          }
        }

        border.color: Qt.rgba(theme.normal.red.r, theme.normal.red.g, theme.normal.red.b, 0.3)
        border.width: 1

        RowLayout {
          anchors.fill: parent
          anchors.margins: 12
          spacing: 12

          Text {
            text: "⚠️"
            font.pixelSize: 18
            color: theme.normal.red
            Layout.alignment: Qt.AlignVCenter
          }

          Text {
            text: root.errorMessage
            color: theme.normal.red
            font {
              pixelSize: 13
              family: "ComicShannsMono Nerd Font"
            }
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
          }
        }
      }
    }
  }
}
