import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "." as Com
import qs.services
import qs.services.cpu

PanelWindow {
  id: root
  implicitWidth: 1300
  implicitHeight: 600

  property real animationProgress: 0
  PackageService{
    id: packageService
    simplePackage: true
  }
  SequentialAnimation on animationProgress {
    running: true

    NumberAnimation {
      from: 0
      to: 2
      duration: 1000
      easing.type: Easing.Linear
    }
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
          opacity: root.animationProgress > 0.05 ? 1 : 0

        }

        Com.SystemSlider {
          Layout.fillWidth: true
          nameIcon: "memory"
          iconColor: theme.primary.background
          value: CpuSimpleService.cpuPercent / 100
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
              opacity: root.animationProgress > 0.25 ? 1 : 0
              animationProgress: root.animationProgress
            }

            Com.SleepTimerCard {
              opacity: root.animationProgress > 0.3 ? 1 : 0
              animationProgress: root.animationProgress
            }
          }

          Com.WeatherCard {
            opacity: root.animationProgress > 0.35 ? 1 : 0
            animationProgress: root.animationProgress

          }

          Com.ListQuickActionButton {
            opacity: root.animationProgress > 0.4 ? 1 : 0
            animationProgress: root.animationProgress
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
                opacity: root.animationProgress > 0.3 ? 1 : 0

              }

              Com.AppGridCard {
                opacity: root.animationProgress > 0.35 ? 1 : 0
                animationProgress: root.animationProgress
              }
            }

            RowLayout {
              Layout.fillWidth: true
              spacing: 15

              Com.SocialIcon {
                image: "lockscreen/appicons/youtube.png"
                bgColor: root.animationProgress > 0.55 ? "#d20f39" : theme.primary.background
                revealThreshold: 0.6
                linkSocial: "https://www.youtube.com/"
                opacity: root.animationProgress > 0.4 ? 1 : 0
                animationProgress: root.animationProgress

              }
              Com.SocialIcon {
                image: "lockscreen/appicons/reddit.png"
                bgColor: root.animationProgress > 0.6 ? "#fe640b" : theme.primary.background
                revealThreshold: 0.65
                linkSocial: "https://www.reddit.com/"
                opacity: root.animationProgress > 0.45 ? 1 : 0
                animationProgress: root.animationProgress
              }
              Com.SocialIcon {
                image: "lockscreen/appicons/facebook.png"
                bgColor: root.animationProgress > 0.65 ? "#04a5e5" : theme.primary.background
                revealThreshold: 0.7
                linkSocial: "https://www.facebook.com/"
                opacity: root.animationProgress > 0.5 ? 1 : 0
                animationProgress: root.animationProgress
              }
              Com.SocialIcon {
                image: "lockscreen/appicons/tiktok.png"
                bgColor: root.animationProgress > 0.65 ? "#eff1f5" : theme.primary.background
                revealThreshold: 0.75
                linkSocial: "https://www.tiktok.com/"
                opacity: root.animationProgress > 0.55 ? 1 : 0
                animationProgress: root.animationProgress
              }

              Com.PackageCard {
                count: packageService.totalPackage
                animationProgress: root.animationProgress
                opacity: root.animationProgress > 0.6 ? 1 : 0
              }
            }
          }

          // Right side: File Browser
          Com.FileBrowserCard {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            animationProgress: root.animationProgress
            opacity: root.animationProgress > 0.65 ? 1 : 0
          }
        }
      }
    }
  }
}
