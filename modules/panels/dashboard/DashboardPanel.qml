import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "." as Com
import qs.services

PanelWindow {
  id: root
  implicitWidth: 1300
  implicitHeight: 600

  property var theme: ThemeService.theme
  property real animationProgress: 0

  CpuService {
    id: cpuService
    enableCpuHistory: true
  }

  DiskService{
    id: diskService
  }
  RamService {
    id: ramService
    useSimpleCalculation: true
  }

  color: "transparent"

  Rectangle {
    anchors.fill: parent
    color: "transparent"

    RowLayout {
      anchors.fill: parent
      spacing: 15

      // Left Column - Staggered animation
      ColumnLayout {
        Layout.preferredWidth: 240
        Layout.fillHeight: true
        spacing: 15

        Behavior on opacity { NumberAnimation { duration: 600 } }

        Com.UserProfileCard {
          opacity: root.animationProgress > 0.1 ? 1 : 0
          Behavior on opacity { NumberAnimation { duration: 500 } }
        }

        Com.SystemSlider {
          Layout.fillWidth: true
          nameIcon: "memory"
          iconColor: theme.primary.background
          value: cpuService.cpuPercent / 100
          opacity: root.animationProgress > 0.2 ? 1 : 0
          Behavior on opacity { NumberAnimation { duration: 500 } }
        }

        Com.SystemSlider {
          Layout.fillWidth: true
          nameIcon: "memory_alt"
          iconColor: theme.primary.background
          value: ramService.memPercent / 100
          opacity: root.animationProgress > 0.3 ? 1 : 0
          Behavior on opacity { NumberAnimation { duration: 500 } }
        }

        Com.SystemSlider {
          Layout.fillWidth: true
          nameIcon: "hard_disk"
          iconColor: theme.primary.background
          value: diskService.diskPercents / 100
          opacity: root.animationProgress > 0.4 ? 1 : 0
          Behavior on opacity { NumberAnimation { duration: 500 } }
        }
      }

      // Right Main Column
      ColumnLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        spacing: 15

        // Top Row
        RowLayout {
          Layout.fillHeight: true
          Layout.fillWidth: true
          spacing: 15

          ColumnLayout {
            Layout.fillHeight: true
            Layout.preferredWidth: 100

            Com.TimeCard {
              opacity: root.animationProgress > 0.15 ? 1 : 0
              Behavior on opacity { NumberAnimation { duration: 500 } }
            }

            Com.SleepTimerCard {
              opacity: root.animationProgress > 0.25 ? 1 : 0
              Behavior on opacity { NumberAnimation { duration: 500 } }
            }
          }

          Com.WeatherCard {
            opacity: root.animationProgress > 0.2 ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 500 } }
          }

          Com.ListQuickActionButton {
            opacity: root.animationProgress > 0.3 ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 500 } }
          }
        }

        // Bottom Row
        RowLayout {
          Layout.fillHeight: true
          Layout.fillWidth: true
          spacing: 15

          // Left side: Media Player + App Grid + Social Icons
          ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 15

            RowLayout {
              Layout.fillWidth: true
              spacing: 15

              Com.MediaPlayerCard {
                opacity: root.animationProgress > 0.35 ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 500 } }
              }

              Com.AppGridCard {
                opacity: root.animationProgress > 0.4 ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 500 } }
              }
            }

            RowLayout {
              Layout.fillWidth: true
              spacing: 15

              Com.SocialIcon {
                image: "../../../assets/lockscreen/appicons/youtube.png"
                bgColor: "#d20f39"
                linkSocial: "https://www.youtube.com/"
                opacity: root.animationProgress > 0.45 ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 450 } }
              }
              Com.SocialIcon {
                image: "../../../assets/lockscreen/appicons/reddit.png"
                bgColor: "#fe640b"
                linkSocial: "https://www.reddit.com/"
                opacity: root.animationProgress > 0.5 ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 450 } }
              }
              Com.SocialIcon {
                image: "../../../assets/lockscreen/appicons/facebook.png"
                bgColor: "#04a5e5"
                linkSocial: "https://www.facebook.com/"
                opacity: root.animationProgress > 0.55 ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 450 } }
              }
              Com.SocialIcon {
                image: "../../../assets/lockscreen/appicons/tiktok.png"
                bgColor: "#eff1f5"
                linkSocial: "https://www.tiktok.com/"
                opacity: root.animationProgress > 0.6 ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 450 } }
              }

              Com.GmailCard {
                emailCount: 230
                opacity: root.animationProgress > 0.65 ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 500 } }
              }
            }
          }

          // Right side: File Browser
          Com.FileBrowserCard {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            opacity: root.animationProgress > 0.5 ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 600 } }
          }
        }
      }
    }
  }

  // Staggered animation trigger
  SequentialAnimation on animationProgress {
    id: staggerAnimation
    running: true
    loops: 1

    PropertyAction { value: 0 }

    // Animate each threshold
    NumberAnimation { to: 0.1; duration: 50 }
    NumberAnimation { to: 0.2; duration: 100 }
    NumberAnimation { to: 0.3; duration: 100 }
    NumberAnimation { to: 0.4; duration: 100 }
    NumberAnimation { to: 0.5; duration: 100 }
    NumberAnimation { to: 0.6; duration: 100 }
    NumberAnimation { to: 0.7; duration: 100 }
    NumberAnimation { to: 1.0; duration: 100 }
  }

  Component.onCompleted: {
    staggerAnimation.start()
  }
}
