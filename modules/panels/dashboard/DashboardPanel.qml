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

        Com.UserProfileCard {
          animationProgress: root.animationProgress
        }

        Com.SystemSlider {
          Layout.fillWidth: true
          nameIcon: "memory"
          iconColor: theme.primary.background
          value: cpuService.cpuPercent / 100
          revealThreshold: 0.25
          animationProgress: root.animationProgress
        }

        Com.SystemSlider {
          Layout.fillWidth: true
          nameIcon: "memory_alt"
          iconColor: theme.primary.background
          value: ramService.memPercent / 100
          revealThreshold: 0.3
          animationProgress: root.animationProgress
        }

        Com.SystemSlider {
          Layout.fillWidth: true
          nameIcon: "hard_disk"
          iconColor: theme.primary.background
          value: diskService.diskPercents / 100
          revealThreshold: 0.35
          animationProgress: root.animationProgress
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
              animationProgress: root.animationProgress
            }

            Com.SleepTimerCard {
              animationProgress: root.animationProgress
            }
          }

          Com.WeatherCard {
            animationProgress: root.animationProgress

          }

          Com.ListQuickActionButton {
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
                animationProgress: root.animationProgress
              }

              Com.AppGridCard {
              }
            }

            RowLayout {
              Layout.fillWidth: true
              spacing: 15

              Com.SocialIcon {
                image: "../../../assets/lockscreen/appicons/youtube.png"
                bgColor: "#d20f39"
                linkSocial: "https://www.youtube.com/"
              }
              Com.SocialIcon {
                image: "../../../assets/lockscreen/appicons/reddit.png"
                bgColor: "#fe640b"
                linkSocial: "https://www.reddit.com/"
              }
              Com.SocialIcon {
                image: "../../../assets/lockscreen/appicons/facebook.png"
                bgColor: "#04a5e5"
                linkSocial: "https://www.facebook.com/"
              }
              Com.SocialIcon {
                image: "../../../assets/lockscreen/appicons/tiktok.png"
                bgColor: "#eff1f5"
                linkSocial: "https://www.tiktok.com/"
              }

              Com.GmailCard {
                emailCount: 230
              }
            }
          }

          // Right side: File Browser
          Com.FileBrowserCard {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
          }
        }
      }
    }
  }

  // Staggered animation trigger
  SequentialAnimation on animationProgress {
    running: true

    NumberAnimation {
      from: 0
      to: 2
      duration: 1000
      easing.type: Easing.Linear
    }
  }

  Component.onCompleted: {
    staggerAnimation.start()
  }
}
