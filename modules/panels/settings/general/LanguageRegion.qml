import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.commons
import qs.services
import qs.components

Item {
  id: root
  property var theme: ThemeService.theme
  property var lang: LanguageService.translations

  function setLanguageEditor(name) {
    Settings.general.lang = name;
  }
  property real animationProgress: 0
  SequentialAnimation on animationProgress {
    running: true

    NumberAnimation {
      from: 0
      to: 1
      duration: 500
      easing.type: Easing.Linear
    }
  }

  ScrollView {
    anchors.fill: parent
    anchors.margins: 20
    clip: true
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: parent.width
      spacing: 15

      RowLayout {
        Layout.fillWidth: true
        spacing: 10

        // Tiêu đề
        HeaderSettings {
          name: "Language Region"
          opacity: root.animationProgress > 0.1 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
      }

      Rectangle {
        Layout.fillWidth: true
        height: 1
        color: theme.primary.foreground
        opacity: root.animationProgress > 0.2 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
      }

      // Language Selection
      ColumnLayout {
        Layout.fillWidth: true
        spacing: 10

        CustomText {
          name: lang.general?.language_label || "Ngôn ngữ:"
          size: "small"
          opacity: root.animationProgress > 0.3 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }

        Grid {
          Layout.fillWidth: true
          columns: 6
          columnSpacing: 6
          rowSpacing: 6

          Repeater {
            model: [
            {
              code: "vi",
              name: "Tiếng Việt",
              flagImg: "vietnam"
            },
            {
              code: "en",
              name: "English",
              flagImg: "britain"
            },
            {
              code: "zh",
              name: "中文",
              flagImg: "china"
            },
            {
              code: "ja",
              name: "日本語",
              flagImg: "japan"
            },
            {
              code: "ko",
              name: "한국어",
              flagImg: "korea"
            },
            {
              code: "ru",
              name: "Русский",
              flagImg: "russia"
            },
            {
              code: "hi",
              name: "हिन्दी",
              flagImg: "india"
            },
            {
              code: "es",
              name: "Español",
              flagImg: "spain"
            },
            {
              code: "pt",
              name: "Português",
              flagImg: "portugal"
            },
            {
              code: "fr",
              name: "Français",
              flagImg: "france"
            },
            {
              code: "de",
              name: "Deutsch",
              flagImg: "german"
            },
            {
              code: "it",
              name: "Italiano",
              flagImg: "italy"
            },
            {
              code: "ar",
              name: "العربية",
              flagImg: "saudi_arabia"
            },
            {
              code: "tr",
              name: "Türkçe",
              flagImg: "turkey"
            },
            {
              code: "nl",
              name: "Nederlands",
              flagImg: "netherlands"
            },
            {
              code: "pl",
              name: "Polski",
              flagImg: "poland"
            },
            {
              code: "sv",
              name: "Svenska",
              flagImg: "sweden"
            },
            {
              code: "th",
              name: "ไทย",
              flagImg: "thailand"
            },
            {
              code: "uk",
              name: "Українська",
              flagImg: "ukraine"
            },
            {
              code: "no",
              name: "Norsk",
              flagImg: "norway"
            },
            {
              code: "da",
              name: "Dansk",
              flagImg: "denmark"
            },
            {
              code: "fi",
              name: "Suomi",
              flagImg: "finland"
            },
            {
              code: "id",
              name: "Indonesia",
              flagImg: "indonesia"
            },
            {
              code: "cs",
              name: "Čeština",
              flagImg: "czech"
            },
            {
              code: "el",
              name: "Ελληνικά",
              flagImg: "greece"
            },
            {
              code: "he",
              name: "עברית",
              flagImg: "israel"
            },
            {
              code: "ro",
              name: "Română",
              flagImg: "romania"
            },
            {
              code: "hu",
              name: "Magyar",
              flagImg: "hungary"
            },
            {
              code: "bg",
              name: "Български",
              flagImg: "bulgaria"
            },
            {
              code: "sk",
              name: "Slovenčina",
              flagImg: "slovakia"
            },
            ]

            delegate: Rectangle {
              opacity: 0

              SequentialAnimation on opacity {
                running: root.animationProgress > 0.2

                PauseAnimation {
                  duration: index * 15
                }

                NumberAnimation {
                  to: 1
                  duration: 200
                  easing.type: Easing.OutCubic
                }
              }
              width: root.width / 7  // Đã sửa từ !panelManager.fullsetting ? root.width/6 : root.width/12
              height: root.width / 7  // Đã sửa từ !panelManager.fullsetting ? root.width/6 : root.width/12
              radius: 10
              color: Settings.general.lang === modelData.code ? theme.normal.blue : (langMouseArea.containsMouse ? theme.button.background_select : theme.button.background)
              border.color: Settings.general.lang === modelData.code ? theme.normal.blue : (langMouseArea.containsPress ? theme.button.border_select : theme.button.border)
              border.width: 2

              ColumnLayout {
                anchors.centerIn: parent
                spacing: 4

                IconImage {
                  path: `flags/${modelData.flagImg}.png`
                  size : "large"
                  Layout.alignment: Qt.AlignHCenter
                  opacity: 0

                  SequentialAnimation on opacity {
                    running: root.animationProgress > 0.4

                    PauseAnimation {
                      duration: index * 15
                    }

                    NumberAnimation {
                      to: 1
                      duration: 200
                      easing.type: Easing.OutCubic
                    }
                  }
                }

                CustomText {
                  name: modelData.name
                  textColor: Settings.general.lang === modelData.code ? theme.primary.background : theme.primary.foreground
                  isBold: Settings.general.lang === modelData.code
                  size: "xs"
                  Layout.alignment: Qt.AlignHCenter
                  opacity: 0

                  SequentialAnimation on opacity {
                    running: root.animationProgress > 0.5

                    PauseAnimation {
                      duration: index * 15
                    }

                    NumberAnimation {
                      to: 1
                      duration: 200
                      easing.type: Easing.OutCubic
                    }
                  }
                }
              }

              MouseArea {
                id: langMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  setLanguageEditor(modelData.code);
                }
              }

              // Checkmark for selected language
              Rectangle {
                visible: Settings.general.lang === modelData.code
                width: 18
                height: 18
                radius: 9
                color: theme.normal.blue
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 4

                Text {
                  text: "✓"
                  color: theme.primary.background
                  font.pixelSize: 12
                  font.bold: true
                  anchors.centerIn: parent
                }
              }
            }
          }
        }
      }

      Item {
        Layout.fillHeight: true
      } // Spacer
    }
  }
}
