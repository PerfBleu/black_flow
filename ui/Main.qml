import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs
import "."
import blackflow

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: qsTr("Hello World")
    
    // 设置树莓色主题
    Material.theme: Material.Light
    Material.accent: "#C2185B"  // 树莓色/深粉色
    Material.primary: "#D81B60" // 树莓色/粉红色
    Material.background: "#FFF8F9" // 非常淡的粉色背景
    
    property var raspberryPalette: {
        "primary": "#D81B60",    // 树莓主色
        "primaryDark": "#AD1457", // 深树莓色
        "primaryLight": "#F48FB1", // 浅树莓色
        "accent": "#C2185B",      // 强调色
        "secondary": "#6A1B9A",   // 紫色辅助色
        "success": "#2E7D32",     // 成功绿色
        "warning": "#FF8F00",     // 警告橙色
        "error": "#D32F2F",       // 错误红色
        "textPrimary": "#212121", // 主文本色
        "textSecondary": "#757575" // 次文本色
    }

    Utils{
        id: utils
    }

    MessageDialog {
        id: msgBox
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0
        SideNav {
            Layout.fillHeight: true
            Layout.preferredWidth: width
            onItemSelected: function(index) {
                console.log("dense:", materialSettings.dense)
            }
        }

        StackView {
            id: stack
            Layout.fillHeight: true
            Layout.fillWidth: true
            initialItem: ytdlpPage
        }
    }
    Component {
        id: ytdlpPage
        Page {
            id: ytdlpPagePage
            YTDLP{
                id: ytdlp
                onDownloadLog: function(log) {
                    console.log("下载日志:", log);
                    statusLabel.text += log;
                }
                onDownloadFinished: function() {
                    ytdlpPagePage.enabled = true;
                    statusLabel.text += qsTr("下载完成!");
                    progressBar.visible = false;
                }
            }
            FolderDialog {
                id: folderDialog
                title: qsTr("选择保存位置")
                onAccepted: ()=>{
                    if (folderDialog.currentFolder.toString().startsWith("file://")) {
                        editSavePath.text = folderDialog.currentFolder.toString().split("://")[1];
                    }
                }
            }
            Dialog {
                id: diagYtdlp
                modal: true
                anchors.centerIn: Overlay.overlay
                title: qsTr("选择详细设置")
                standardButtons: Dialog.Ok | Dialog.Cancel
                onAccepted: {
                    const trimmedUrl = editUrl.text.trim();
                    var selectedQuality = qualityCombo.currentText;
                    var selectedFormat = comboFormat.currentText;
                    if (radioAudioOnly.checked) {
                        selectedQuality = "";
                        selectedFormat = "";
                    }
                    var proxy;
                    if (radioNoProxy.checked) {
                        proxy = "";
                    } else if (radioSystemProxy.checked) {
                        proxy = utils.getSystemProxyInfo();
                    } else {
                        proxy = editCustomProxy.text.trim();
                    }
                    ytdlp.download(trimmedUrl, selectedQuality, selectedFormat,
                        proxy, editSavePath.text.trim(), 
                        checkThumb.checked, checkSub.checked
                    );
                    ytdlpPagePage.enabled = false;
                    progressBar.visible = true;
                    progressBar.indeterminate = true;
                    // ytdlpPage.enabled = false;
                }
                ColumnLayout{
                    RowLayout {
                        spacing: 8
                        width: parent.width
                        RadioButton {
                            id: radioVideoAudio
                            text: qsTr("下载视频+音频")
                            checked: true
                        }
                        RadioButton {
                            id: radioAudioOnly
                            text: qsTr("仅下载音频")
                        }
                    }
                    RowLayout {
                        spacing: 8
                        width: parent.width
                        Label { text: qsTr("视频质量") }
                        ComboBox {
                            id: qualityCombo
                            Layout.fillWidth: true
                            model: ["最佳质量", "<=2160p","<=1440p", "<=1080p", "<=720p", "<=480p"]
                            currentIndex: 0
                        }
                        RowLayout {
                            spacing: 8
                            Label { text: "" ; Layout.fillWidth: true }
                        }
                        Label { text: qsTr("存储格式") }
                        ComboBox {
                            id: comboFormat
                            Layout.fillWidth: true
                            model: ["默认", "mp4", "webm", "mkv"]
                            currentIndex: 0
                        }
                    }

                    RowLayout {
                        spacing: 8
                        width: parent.width
                        CheckBox {
                            id: checkSub
                            text: qsTr("下载字幕")
                            checked: true
                            Layout.columnSpan: 2
                        }

                        CheckBox {
                            id: checkThumb
                            text: qsTr("下载缩略图")
                            checked: false
                            Layout.columnSpan: 2
                        }

                    }
                }
            }
            padding: 16
            
            // 使用来自主应用的树莓色调
            property var colors: parent.parent.parent.raspberryPalette
            
            background: Rectangle {
                color: Material.background
                
                // 添加微妙的渐变背景
                Rectangle {
                    anchors.fill: parent
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#FFF8F9" }
                        GradientStop { position: 1.0; color: "#F9EDF0" }
                    }
                }
            }
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 16
                
                Label {
                    text: qsTr("下载信息")
                    font.pixelSize: 22
                    font.weight: Font.Medium
                    color: colors.primary
                    Layout.fillWidth: true
                }
                
                // 第一行：视频链接
                ColumnLayout {
                    spacing: 4
                    Layout.fillWidth: true
                    TextField {
                        id: editUrl
                        Layout.fillWidth: true
                        placeholderText: qsTr("请输入或粘贴视频URL")
                        selectByMouse: true
                        
                        // 右侧粘贴按钮
                        rightPadding: buttonPaste.width + 8
                        
                        Button {
                            id: buttonPaste
                            icon.name: "content_paste"
                            icon.source: "assets/paste.svg" 
                            // icon.color: colors.primary
                            highlighted: true
                            Material.accent: colors.primaryLight
                            //flat: true
                            anchors {
                                right: parent.right
                                rightMargin: 4
                                verticalCenter: parent.verticalCenter
                            }
                            
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("从剪贴板粘贴")
                            
                            onClicked: {
                                editUrl.clear()
                                editUrl.paste()
                                console.log("粘贴URL:", editUrl.text)
                            }
                        }
                    }
                }
                
                // 第二行：保存位置
                ColumnLayout {
                    spacing: 4
                    Layout.fillWidth: true
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        
                        TextField {
                            id: editSavePath
                            Layout.fillWidth: true
                            placeholderText: qsTr("选择视频保存位置")
                            text: "~/Downloads"
                            selectByMouse: true
                        }
                    
                        Button {
                            text: qsTr("浏览...")
                            icon.name: "folder_open"
                            // icon.source: "qrc:/ui/assets/bolt.png" // 暂用bolt图标代替文件夹图标
                            Material.accent: colors.secondary
                            highlighted: true
                            // icon.color: colors.secondary
                            
                            onClicked: {
                                folderDialog.open()
                            }
                        }
                    }

                }
                Label {
                    text: qsTr("代理设置")
                    font.pixelSize: 22
                    font.weight: Font.Medium
                    color: colors.primary
                    Layout.fillWidth: true
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    RowLayout {
                        spacing: 8
                        width: parent.width
                        RadioButton {
                            id: radioNoProxy
                            text: qsTr("不使用代理")
                        }
                        RadioButton {
                            id: radioSystemProxy
                            text: qsTr("使用系统代理")
                            checked: true
                            onClicked: function() {
                                var proxyInfo = utils.getSystemProxyInfo();
                                editCustomProxy.text = proxyInfo;
                                console.log("系统代理信息:", proxyInfo);
                            }
                        }
                        RadioButton {
                            id: radioCustomProxy
                            text: qsTr("自定义代理")
                        }
                    }
                    TextField {
                        id: editCustomProxy
                        Layout.fillWidth: true
                        placeholderText: qsTr("代理地址")
                        text: ""
                        selectByMouse: true
                        readOnly: true
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    
                    Button {
                        id: buttonDownload
                        text: qsTr("下载")
                        icon.name: "download"
                        icon.source: "assets/download.svg" // 暂用bolt图标代替下载图标
                        highlighted: true
                        Material.accent: raspberryPalette.primary                
                        onClicked: {
                            if (!editUrl.text) {
                                errorLabel.text = qsTr("请输入视频URL")
                                msgBox.title = qsTr("错误")
                                msgBox.text = qsTr("请输入视频URL")
                                msgBox.open()
                                return
                            }
                            diagYtdlp.open()
                        }
                    }
                    
                    Button {
                        id: buttonDownloadSrt
                        text: qsTr("下载字幕")
                        icon.name: "download"
                        icon.source: "assets/download.svg" 
                        highlighted: true
                        Material.accent: raspberryPalette.primary      
                                  
                        onClicked: {
                            diagYtdlp.open()
                            console.log("开始下载:", editUrl.text)
                            console.log("保存位置:", editSavePath.text)
                            console.log("视频质量:", qualityCombo.currentText)
                            console.log("格式:", comboFormat.currentText)
                            
                            // 这里应该调用yt-dlp命令
                            progressBar.indeterminate = true
                            errorLabel.text = ""
                            
                            // 模拟下载进度
                            downloadTimer.start()
                        }
                    }

                    Button {
                        id: buttonDownloadThumb
                        text: qsTr("下载封面")
                        icon.name: "download"
                        icon.source: "assets/download.svg" 
                        highlighted: true
                        Material.accent: raspberryPalette.primary                
                        onClicked: {
                            diagYtdlp.open()
                            if (!editUrl.text) {
                                errorLabel.text = qsTr("请输入视频URL")
                                return
                            }
                            
                            console.log("开始下载:", editUrl.text)
                            console.log("保存位置:", editSavePath.text)
                            console.log("视频质量:", qualityCombo.currentText)
                            console.log("格式:", comboFormat.currentText)
                            
                            // 这里应该调用yt-dlp命令
                            progressBar.indeterminate = true
                            errorLabel.text = ""
                            
                            // 模拟下载进度
                            downloadTimer.start()
                        }
                    }

                    Button {
                        text: qsTr("取消")
                        enabled: progressBar.visible
                        Material.foreground: colors.warning
                        
                        onClicked: {
                            console.log("取消下载")
                            downloadTimer.stop()
                            progressBar.value = 0
                            progressBar.indeterminate = false
                            progressBar.visible = false
                            statusLabel.text = qsTr("已取消")
                        }
                    }
                }
                
                ProgressBar {
                    id: progressBar
                    Layout.fillWidth: true
                    from: 0
                    to: 0
                    value: 0
                    visible: false
                    
                    // 使用树莓色调
                    contentItem: Rectangle {
                        width: progressBar.visualPosition * parent.width
                        height: parent.height
                        color: colors.primary
                        radius: 2
                    }
                    
                    background: Rectangle {
                        implicitWidth: 200
                        implicitHeight: 6
                        color: "#E6E6E6"
                        radius: 2
                    }
                    
                    Timer {
                        id: downloadTimer
                        interval: 500
                        repeat: true
                        
                        onTriggered: {
                            progressBar.visible = true
                            progressBar.indeterminate = false
                            
                            if (progressBar.value < 100) {
                                progressBar.value += 5
                                statusLabel.text = qsTr("下载中... %1%").arg(Math.round(progressBar.value))
                            } else {
                                downloadTimer.stop()
                                statusLabel.text = qsTr("下载完成!")
                            }
                        }
                    }
                }
                
                // Label {
                //     id: statusLabel
                //     Layout.fillWidth: true
                //     wrapMode: Text.WordWrap
                //     color: colors.textSecondary
                // }
                ScrollView {
                    id: statusScroll
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150
                    clip: true
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    contentWidth: availableWidth

                    Text {
                        id: statusLabel
                        width: statusScroll.availableWidth
                        wrapMode: Text.WordWrap
                        color: colors.textSecondary
                    }
                }
                Label {
                    id: errorLabel
                    Layout.fillWidth: true
                    color: colors.error
                    wrapMode: Text.WordWrap
                }
                
                Item {
                    // 弹性空间
                    Layout.fillHeight: true
                }
            }
        }
    }
}
