import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.services
import qs.commons

Item {
  id: effectsSettings
  property string homePath: {
    try {
      return Directories.home;
    } catch (e) {
      console.log("Directories.home không khả dụng, dùng $HOME thay thế:", e);
      return Quickshell.env ? (Quickshell.env("HOME") || "") : "";
    }
  }

  // Danh sách hiệu ứng cuộn Workspace độc quyền, sử dụng đúng Bezier/Spring từ dotfiles
  property var effectsModel: [
    {
      key: "android",
      name: lang?.effects?.android_name || "Android Fluent",
      desc: lang?.effects?.android_desc || "Trượt cực nhanh kèm độ phai nhẹ (slidefade), phản hồi tức thì. Dùng curve 'quick'.",
      glyph: "📱",
      previewType: "android",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 4.0, bezier = \"quick\", style = \"slidefade 20%\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 4.0, bezier = \"quick\", style = \"slidefade 20%\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 4.0, bezier = \"quick\", style = \"slidefade 20%\" })"
    },
    {
      key: "zorin",
      name: lang?.effects?.zorin_name || "Zorin OS Glide",
      desc: lang?.effects?.zorin_desc || "Chuyển cảnh chậm rãi, từ từ tăng và giảm tốc vô cùng mượt mà. Dùng curve 'easeInOutCubic'.",
      glyph: "❄",
      previewType: "zorin",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 6.0, bezier = \"easeInOutCubic\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 6.0, bezier = \"easeInOutCubic\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 6.0, bezier = \"easeInOutCubic\", style = \"slide\" })"
    },
    {
      key: "jelly",
      name: lang?.effects?.jelly_name || "Jelly Bounce",
      desc: lang?.effects?.jelly_desc || "Chuyển động có độ nảy mạnh (wobbly). Sử dụng bộ nhún (spring) 'easy' có sẵn trong dotfiles.",
      glyph: "🍮",
      previewType: "jelly",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 5.0, spring = \"easy\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 5.0, spring = \"easy\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 5.0, spring = \"easy\", style = \"slide\" })"
    },
    {
      key: "deck",
      name: lang?.effects?.deck_name || "Vertical Deck",
      desc: lang?.effects?.deck_desc || "Các workspace trượt dọc từ dưới lên (slidevert) như đang xếp bài. Dùng curve 'easeOutQuint'.",
      glyph: "🃏",
      previewType: "deck",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 5.0, bezier = \"easeOutQuint\", style = \"slidevert\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 5.0, bezier = \"easeOutQuint\", style = \"slidevert\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 5.0, bezier = \"easeOutQuint\", style = \"slidevert\" })"
    },
    {
      key: "tunnel",
      name: lang?.effects?.tunnel_name || "3D Tunnel Warp",
      desc: lang?.effects?.tunnel_desc || "Hiệu ứng lùi sâu vào nền (fade 80%) tạo cảm giác hầm 3D. Dùng curve 'easeInOutCubic'.",
      glyph: "🕳",
      previewType: "tunnel",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 5.0, bezier = \"easeInOutCubic\", style = \"slidefade 80%\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 5.0, bezier = \"easeInOutCubic\", style = \"slidefade 80%\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 5.0, bezier = \"easeInOutCubic\", style = \"slidefade 80%\" })"
    },
    {
      key: "cinematic",
      name: lang?.effects?.cinematic_name || "Cinematic Fade",
      desc: lang?.effects?.cinematic_desc || "Chỉ mờ dần (fade), hoàn toàn không có hiệu ứng trượt. Sang trọng và tĩnh lặng.",
      glyph: "🎬",
      previewType: "cinematic",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 3.5, bezier = \"almostLinear\", style = \"fade\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 3.5, bezier = \"almostLinear\", style = \"fade\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 3.5, bezier = \"almostLinear\", style = \"fade\" })"
    },
    {
      key: "swift",
      name: lang?.effects?.swift_name || "Swift Glitch",
      desc: lang?.effects?.swift_desc || "Chuyển cảnh tuyến tính cực nhanh, dứt khoát. Sử dụng curve 'linear'.",
      glyph: "⚡",
      previewType: "swift",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 1.8, bezier = \"linear\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 1.8, bezier = \"linear\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 1.8, bezier = \"linear\", style = \"slide\" })"
    },
    {
      key: "zorin-plus",
      name: lang?.effects?.zorinplus_name || "Zorin Glide+ (Deluxe)",
      desc: lang?.effects?.zorinplus_desc || "Phiên bản mượt hơn của Zorin Glide, dùng curve 'silk' riêng, chuyển động chậm rãi và liền mạch hơn hẳn.",
      glyph: "🧊",
      previewType: "zorinPlus",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 7.0, bezier = \"silk\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 7.0, bezier = \"silk\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 7.0, bezier = \"silk\", style = \"slide\" })"
    },
    {
      key: "zorin-bounce",
      name: lang?.effects?.zorinbounce_name || "Zorin Soft Bounce",
      desc: lang?.effects?.zorinbounce_desc || "Vẫn giữ chất lướt mượt của Zorin nhưng thêm chút nảy nhẹ cuối chuyển động. Dùng curve 'overshot'.",
      glyph: "🎈",
      previewType: "zorinBounce",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 5.2, bezier = \"overshot\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 5.2, bezier = \"overshot\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 5.2, bezier = \"overshot\", style = \"slide\" })"
    },
    {
      key: "zorin-depth",
      name: lang?.effects?.zorindepth_name || "Zorin Depth Glide",
      desc: lang?.effects?.zorindepth_desc || "Kết hợp độ mượt InOutCubic của Zorin với hiệu ứng mờ nhẹ (slidefade 40%) tạo cảm giác có chiều sâu.",
      glyph: "🌫",
      previewType: "zorinDepth",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 6.3, bezier = \"easeInOutCubic\", style = \"slidefade 40%\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 6.3, bezier = \"easeInOutCubic\", style = \"slidefade 40%\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 6.3, bezier = \"easeInOutCubic\", style = \"slidefade 40%\" })"
    },
    {
      key: "cube-3d",
      name: lang?.effects?.cube3d_name || "Cube 3D",
      desc: lang?.effects?.cube3d_desc || "Hiệu ứng xoay khối 3D không gian, kết hợp sự uyển chuyển InOutCubic của Zorin và độ nảy nhẹ overshot.",
      glyph: "🎲",
      previewType: "cube3d",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 6.0, bezier = \"easeInOutCubic\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 6.0, bezier = \"easeInOutCubic\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 6.0, bezier = \"easeInOutCubic\", style = \"slide\" })"
    },
    {
      key: "card-stack",
      name: lang?.effects?.cardstack_name || "Card Stack",
      desc: lang?.effects?.cardstack_desc || "Chuyển cảnh như những lá bài xếp chồng, mang trọn chất mượt Zorin kết hợp điểm nhấn nảy nhẹ overshot.",
      glyph: "🎴",
      previewType: "cardStack",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 5.8, bezier = \"easeInOutCubic\", style = \"slidefade 50%\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 5.8, bezier = \"easeInOutCubic\", style = \"slidefade 50%\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 5.8, bezier = \"easeInOutCubic\", style = \"slidefade 50%\" })"
    },
    {
      key: "zoom-block",
      name: lang?.effects?.zoomblock_name || "Zoom Block",
      desc: lang?.effects?.zoomblock_desc || "Khối phóng to thu nhỏ có chiều sâu, tối ưu hóa độ mượt InOutCubic kết hợp hiệu ứng nảy overshot.",
      glyph: "🔍",
      previewType: "zoomBlock",
      hyprConfig: "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 6.2, bezier = \"overshot\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesIn\", enabled = true, speed = 6.2, bezier = \"overshot\", style = \"slide\" })\nhl.animation({ leaf = \"workspacesOut\", enabled = true, speed = 6.2, bezier = \"overshot\", style = \"slide\" })"
    }
  ]

  property string currentEffect: {
    try {
      return Settings.effects.workspaceAnimation || "android";
    } catch (e) {
      return "android";
    }
  }

  Process {
    id: applyEffectProcess

    stdout: StdioCollector {
      onTextChanged: {}
    }

    onRunningChanged: {
      if (!running) {
        showNotification(lang?.effects?.success_apply || "Đã áp dụng hiệu ứng thành công!");
      }
    }
  }

  function applyEffect(effectData) {
    var confDir = homePath + "/.config/hypr/custom/effects";
    var confFile = confDir + "/workspace-animation.lua";

    var script = "mkdir -p '" + confDir + "' && cat > '" + confFile + "' <<'EOF'\n"
      + effectData.hyprConfig + "\nEOF\nhyprctl reload";

    applyEffectProcess.command = ["bash", "-c", script];
    applyEffectProcess.running = true;

    try {
      Settings.effects.workspaceAnimation = effectData.key;
    } catch (e) {
      console.log("Settings.effects.workspaceAnimation chưa khởi tạo.");
    }

    effectsSettings.currentEffect = effectData.key;
  }

  ScrollView {
    id: scrollView
    anchors.fill: parent
    anchors.margins: ScalerService.s(20)
    clip: true
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: parent.width
      spacing: ScalerService.s(15)

      // Header
      RowLayout {
        Layout.fillWidth: true
        spacing: ScalerService.s(10)

        Text {
          text: lang?.effects?.title || "Hiệu ứng Hyprland (Advanced)"
          color: theme.primary.foreground
          font.pixelSize: ScalerService.s(24)
          font.bold: true
          font.family: "ComicShannsMono Nerd Font"
        }

        Item { Layout.fillWidth: true }
      }

      Rectangle {
        Layout.fillWidth: true
        height: ScalerService.s(1)
        color: theme.primary.foreground
      }

      Text {
        Layout.fillWidth: true
        text: lang?.effects?.subtitle || "Di chuột vào thẻ để xem mô phỏng chân thực animation. Nhấn nút để thay đổi cấu hình Hyprland."
        color: theme.primary.dim_foreground
        font.pixelSize: ScalerService.s(13)
        font.family: "ComicShannsMono Nerd Font"
        wrapMode: Text.WordWrap
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: ScalerService.s(10)

        // Lưới Effect (Grid 3 Cột)
        Grid {
          id: effectsGrid
          Layout.fillWidth: true
          columns: 3
          columnSpacing: ScalerService.s(12)
          rowSpacing: ScalerService.s(12)

          Repeater {
            model: effectsSettings.effectsModel

            delegate: Rectangle {
              id: effectCard
              width: (effectsGrid.width - ScalerService.s(24)) / 3
              height: ScalerService.s(235)
              radius: ScalerService.s(12)
              color: Qt.alpha(theme.button.background, 0.5)
              border.color: cardMouseArea.containsMouse ? theme.normal.blue : theme.button.border
              border.width: ScalerService.s(effectsSettings.currentEffect === modelData.key ? 2 : 1)

              property var effectData: modelData
              property bool isCurrent: effectsSettings.currentEffect === modelData.key

              Column {
                anchors.fill: parent
                anchors.margins: ScalerService.s(10)
                spacing: ScalerService.s(8)

                // 1. Khung Preview Animation
                Rectangle {
                  id: previewBox
                  width: parent.width
                  height: ScalerService.s(95)
                  radius: ScalerService.s(8)
                  clip: true
                  color: Qt.alpha(theme.primary.background, 0.6)

                  Row {
                    anchors.centerIn: parent
                    spacing: ScalerService.s(25)
                    Repeater {
                      model: 3
                      delegate: Rectangle {
                        width: ScalerService.s(8)
                        height: ScalerService.s(8)
                        radius: ScalerService.s(4)
                        color: theme.primary.dim_foreground
                        opacity: 0.3
                      }
                    }
                  }

                  // Khối lập phương động mô phỏng Workspace
                  Rectangle {
                    id: previewBlock
                    width: ScalerService.s(22)
                    height: ScalerService.s(22)
                    radius: ScalerService.s(6)
                    color: theme.normal.blue
                    anchors.verticalCenter: parent.verticalCenter
                    x: ScalerService.s(12)

                    // Animation Độc Lập Được Tinh Chỉnh Sát Thực Tế
                    
                    // 1. Android (Vuốt nhanh 'quick', outQuart)
                    PropertyAnimation {
                      id: animAndroid
                      target: previewBlock; property: "x"
                      to: previewBox.width - previewBlock.width - ScalerService.s(12)
                      duration: 350; easing.type: Easing.OutQuart
                    }

                    // 2. Zorin (InOutCubic mượt mà)
                    PropertyAnimation {
                      id: animZorin
                      target: previewBlock; property: "x"
                      to: previewBox.width - previewBlock.width - ScalerService.s(12)
                      duration: 750; easing.type: Easing.InOutCubic
                    }

                    // 3. Jelly (Mô phỏng Spring 'easy' nảy cực mạnh)
                    PropertyAnimation {
                      id: animJelly
                      target: previewBlock; property: "x"
                      to: previewBox.width - previewBlock.width - ScalerService.s(12)
                      duration: 650; easing.type: Easing.OutBack; easing.overshoot: 2.0
                    }

                    // 4. Deck (Trượt dọc 'slidevert')
                    SequentialAnimation {
                      id: animDeck
                      PropertyAnimation { target: previewBlock; property: "anchors.verticalCenterOffset"; to: previewBox.height; duration: 250; easing.type: Easing.InQuint }
                      PropertyAnimation { target: previewBlock; property: "x"; to: previewBox.width - previewBlock.width - ScalerService.s(12); duration: 1 }
                      PropertyAnimation { target: previewBlock; property: "anchors.verticalCenterOffset"; to: 0; duration: 250; easing.type: Easing.OutQuint }
                    }

                    // 5. Tunnel (Scale nhỏ lại, trượt rồi phóng to 'slidefade 80%')
                    ParallelAnimation {
                      id: animTunnel
                      SequentialAnimation {
                        PropertyAnimation { target: previewBlock; property: "scale"; to: 0.2; duration: 300; easing.type: Easing.InOutCubic }
                        PropertyAnimation { target: previewBlock; property: "x"; to: previewBox.width - previewBlock.width - ScalerService.s(12); duration: 1 }
                        PropertyAnimation { target: previewBlock; property: "scale"; to: 1.0; duration: 300; easing.type: Easing.InOutCubic }
                      }
                      SequentialAnimation {
                        PropertyAnimation { target: previewBlock; property: "opacity"; to: 0.1; duration: 300 }
                        PropertyAnimation { target: previewBlock; property: "opacity"; to: 1.0; duration: 300 }
                      }
                    }

                    // 6. Cinematic (Chỉ Fade, không trượt)
                    SequentialAnimation {
                      id: animCinematic
                      PropertyAnimation { target: previewBlock; property: "opacity"; to: 0.0; duration: 350; easing.type: Easing.Linear }
                      PropertyAnimation { target: previewBlock; property: "x"; to: previewBox.width - previewBlock.width - ScalerService.s(12); duration: 1 }
                      PropertyAnimation { target: previewBlock; property: "opacity"; to: 1.0; duration: 350; easing.type: Easing.Linear }
                    }

                    // 7. Swift (Giật khấc, tốc độ chớp nhoáng 'linear')
                    PropertyAnimation {
                      id: animSwift
                      target: previewBlock; property: "x"
                      to: previewBox.width - previewBlock.width - ScalerService.s(12)
                      duration: 150; easing.type: Easing.Linear
                    }

                    // 8. Zorin Glide+ (InOutCubic siêu chậm & mượt, mô phỏng curve 'silk')
                    PropertyAnimation {
                      id: animZorinPlus
                      target: previewBlock; property: "x"
                      to: previewBox.width - previewBlock.width - ScalerService.s(12)
                      duration: 950; easing.type: Easing.InOutCubic
                    }

                    // 9. Zorin Soft Bounce (mượt + nảy nhẹ cuối, mô phỏng curve 'overshot')
                    PropertyAnimation {
                      id: animZorinBounce
                      target: previewBlock; property: "x"
                      to: previewBox.width - previewBlock.width - ScalerService.s(12)
                      duration: 700; easing.type: Easing.OutBack; easing.overshoot: 1.3
                    }

                    // 10. Zorin Depth Glide (trượt mượt + mờ nhẹ 'slidefade 40%')
                    ParallelAnimation {
                      id: animZorinDepth
                      PropertyAnimation { target: previewBlock; property: "x"; to: previewBox.width - previewBlock.width - ScalerService.s(12); duration: 750; easing.type: Easing.InOutCubic }
                      SequentialAnimation {
                        PropertyAnimation { target: previewBlock; property: "opacity"; to: 0.6; duration: 375 }
                        PropertyAnimation { target: previewBlock; property: "opacity"; to: 1.0; duration: 375 }
                      }
                    }

                    // 11. Cube 3D (Xoay 3D khối với chất mượt InOutCubic kết hợp overshot nhẹ)
                    ParallelAnimation {
                      id: animCube3d
                      PropertyAnimation { target: previewBlock; property: "x"; to: previewBox.width - previewBlock.width - ScalerService.s(12); duration: 700; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
                      SequentialAnimation {
                        PropertyAnimation { target: previewBlock; property: "rotation"; to: 180; duration: 350; easing.type: Easing.InOutCubic }
                        PropertyAnimation { target: previewBlock; property: "rotation"; to: 360; duration: 350; easing.type: Easing.InOutCubic }
                      }
                    }

                    // 12. Card Stack (Hiệu ứng xếp bài chồng mượt InOutCubic kết hợp overshot)
                    ParallelAnimation {
                      id: animCardStack
                      PropertyAnimation { target: previewBlock; property: "x"; to: previewBox.width - previewBlock.width - ScalerService.s(12); duration: 750; easing.type: Easing.OutBack; easing.overshoot: 1.4 }
                      SequentialAnimation {
                        PropertyAnimation { target: previewBlock; property: "scale"; to: 0.7; duration: 375; easing.type: Easing.InOutCubic }
                        PropertyAnimation { target: previewBlock; property: "scale"; to: 1.0; duration: 375; easing.type: Easing.OutBack; easing.overshoot: 1.4 }
                      }
                    }

                    // 13. Zoom Block (Phóng to thu nhỏ chiều sâu InOutCubic + overshot)
                    ParallelAnimation {
                      id: animZoomBlock
                      PropertyAnimation { target: previewBlock; property: "x"; to: previewBox.width - previewBlock.width - ScalerService.s(12); duration: 720; easing.type: Easing.OutBack; easing.overshoot: 1.5 }
                      SequentialAnimation {
                        PropertyAnimation { target: previewBlock; property: "scale"; to: 1.3; duration: 360; easing.type: Easing.InOutCubic }
                        PropertyAnimation { target: previewBlock; property: "scale"; to: 1.0; duration: 360; easing.type: Easing.OutBack; easing.overshoot: 1.5 }
                      }
                    }

                    function activePreviewAnimation() {
                      switch (effectCard.effectData.previewType) {
                        case "android": return animAndroid;
                        case "zorin": return animZorin;
                        case "jelly": return animJelly;
                        case "deck": return animDeck;
                        case "tunnel": return animTunnel;
                        case "cinematic": return animCinematic;
                        case "swift": return animSwift;
                        case "zorinPlus": return animZorinPlus;
                        case "zorinBounce": return animZorinBounce;
                        case "zorinDepth": return animZorinDepth;
                        case "cube3d": return animCube3d;
                        case "cardStack": return animCardStack;
                        case "zoomBlock": return animZoomBlock;
                        default: return animAndroid;
                      }
                    }

                    function stopAllPreviewAnimations() {
                      animAndroid.stop(); animZorin.stop(); animJelly.stop(); 
                      animDeck.stop(); animTunnel.stop(); animCinematic.stop(); animSwift.stop();
                      animZorinPlus.stop(); animZorinBounce.stop(); animZorinDepth.stop();
                      animCube3d.stop(); animCardStack.stop(); animZoomBlock.stop();
                    }
                  }

                  Text {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: ScalerService.s(6)
                    text: effectCard.effectData.glyph
                    color: theme.primary.dim_foreground
                    font.pixelSize: ScalerService.s(16)
                    opacity: 0.8
                  }

                  Rectangle {
                    visible: effectCard.isCurrent
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: ScalerService.s(6)
                    width: ScalerService.s(22)
                    height: ScalerService.s(22)
                    radius: ScalerService.s(11)
                    color: theme.normal.green
                    z: 5

                    Text {
                      text: "✓"
                      color: theme.primary.background
                      font.pixelSize: ScalerService.s(12)
                      font.bold: true
                      anchors.centerIn: parent
                    }
                  }
                }

                // 2. Info Card
                Text {
                  width: parent.width
                  text: effectCard.effectData.name
                  color: theme.primary.foreground
                  font.pixelSize: ScalerService.s(14)
                  font.bold: true
                  elide: Text.ElideRight
                }

                Text {
                  width: parent.width
                  height: ScalerService.s(55)
                  text: effectCard.effectData.desc
                  color: theme.primary.dim_foreground
                  font.pixelSize: ScalerService.s(11)
                  wrapMode: Text.WordWrap
                  maximumLineCount: 4
                  elide: Text.ElideRight
                }

                // 3. Button
                Rectangle {
                  width: parent.width
                  height: ScalerService.s(32)
                  radius: ScalerService.s(6)
                  color: effectCard.isCurrent ? theme.normal.green : theme.normal.blue

                  Text {
                    anchors.centerIn: parent
                    text: effectCard.isCurrent
                      ? (lang?.effects?.already_applied || "Đã áp dụng")
                      : (lang?.effects?.apply || "Áp dụng ngay")
                    color: theme.primary.background
                    font.pixelSize: ScalerService.s(12)
                    font.bold: true
                  }
                }
              }

              MouseArea {
                id: cardMouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                  previewBlock.stopAllPreviewAnimations();
                  previewBlock.x = ScalerService.s(12);
                  previewBlock.scale = 1.0;
                  previewBlock.rotation = 0.0;
                  previewBlock.opacity = 1.0;
                  previewBlock.anchors.verticalCenterOffset = 0; // Tránh lỗi trục Y với Deck
                  previewBlock.activePreviewAnimation().restart();
                }

                onExited: {
                  previewBlock.stopAllPreviewAnimations();
                  previewBlock.x = ScalerService.s(12);
                  previewBlock.scale = 1.0;
                  previewBlock.rotation = 0.0;
                  previewBlock.opacity = 1.0;
                  previewBlock.anchors.verticalCenterOffset = 0;
                }

                onClicked: {
                  effectsSettings.applyEffect(effectCard.effectData);
                }
              }
            }
          }
        }
      }

      Item { Layout.fillHeight: true }
    }
  }

  // Thông báo Notification 
  Rectangle {
    id: successNotification
    visible: false
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: ScalerService.s(30)
    width: ScalerService.s(280)
    height: ScalerService.s(45)
    radius: ScalerService.s(22)
    color: theme.normal.green
    z: 1001

    Row {
      anchors.centerIn: parent
      spacing: ScalerService.s(10)
      Text {
        text: "✓"
        color: theme.primary.background
        font.bold: true
        font.pixelSize: ScalerService.s(16)
      }
      Text {
        id: notificationText
        color: theme.primary.background
        text: ""
        font.bold: true
        font.pixelSize: ScalerService.s(14)
      }
    }

    Timer {
      id: notificationTimer
      interval: 3500
      onTriggered: successNotification.visible = false
    }
  }

  function showNotification(message) {
    notificationText.text = message;
    successNotification.visible = true;
    notificationTimer.start();
  }
}