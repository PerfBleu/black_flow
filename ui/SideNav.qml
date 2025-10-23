import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Window

Rectangle {
    width: 240
    height: parent ? parent.height : 600
    color: "#F9EDF0"  // 淡树莓色背景
    
    // 从主应用获取树莓色主题
    property var raspberryPalette: parent && parent.parent ? parent.parent.raspberryPalette : {
        "primary": "#D81B60", "accent": "#C2185B", "primaryLight": "#F48FB1"
    }
    
    Material.accent: raspberryPalette.accent
    signal itemSelected(int index)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4


        // 导航菜单列表
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            model: ListModel {
                ListElement { name: "视频下载 (yt-dlp)"; icon: "download" }
                ListElement { name: "mkvmerge"; icon: "merge" }
            }

            delegate: ItemDelegate {
                width: parent.width
                text: name
                icon.source: "assets/" + model.icon + ".svg"
                // icon.source: "assets/bolt.png"
                // highlighted: ListView.isCurrentItem
                Material.foreground: highlighted ? Material.accentColor : Material.foreground
                onClicked: {
                    ListView.view.currentIndex = index
                    itemSelected(index)
                }
                icon.color: highlighted ? Material.accentColor : Material.foreground

                // 轻微点击波纹特效
                // ripple: true
            }

            // 当前选中项的高亮条动画
            highlight: Rectangle {
                color: Qt.rgba(Material.accentColor.r, Material.accentColor.g, Material.accentColor.b, 0.15)
                radius: 8
            }

            focus: true
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 200
        }

        // 底部登出按钮
        // Button {
        //     Layout.fillWidth: true
        //     text: "退出登录"
        //     icon.name: "logout"
        //     Material.foreground: Material.Red
        //     flat: true
        // }
    }
}
