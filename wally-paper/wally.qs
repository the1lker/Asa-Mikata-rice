import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ShellRoot {

    property var wallpapers: []

    Process {
        id: wallpaperList

        command: [
            "python",
            "/home/theilker/.config/wally-paper/wally.py",
            "list"
        ]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    wallpapers = JSON.parse(text)
                } catch (e) {
                    console.log("JSON error:", e)
                }
            }
        }
    }

    function setWallpaper(path) {
        wallpaperProcess.command = [
            "python",
            "/home/theilker/.config/wally-paper/wally.py",
            "set",
            path
        ]

        wallpaperProcess.running = true
    }

    Process {
        id: wallpaperProcess
        running: false
    }

    PanelWindow {
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        color: "#00000000"

        Rectangle {
            anchors.fill: parent

            color: "#000000"
            opacity: 0.55

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
            }
        }

        Rectangle {
            id: main

            width: 850
            height: 600

            anchors.centerIn: parent

            color: "#050505"

            radius: 18

            border.width: 1
            border.color: "#222222"

            MouseArea {
                anchors.fill: parent
                onClicked: mouse.accepted = true
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24

                spacing: 18

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "󰸉  Wallpapers"

                        color: "#ffffff"

                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 20
                        font.bold: true

                        Layout.fillWidth: true
                    }

                    Text {
                        text: "×"

                        color: "#777777"

                        font.pixelSize: 26

                        MouseArea {
                            anchors.fill: parent

                            onClicked: Qt.quit()
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 44

                    radius: 10

                    color: "#0d0d0d"

                    border.width: 1
                    border.color: "#1c1c1c"

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.verticalCenter: parent.verticalCenter

                        text: "󰍉  Search wallpapers..."

                        color: "#666666"

                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                    }
                }

                GridView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    cellWidth: 195
                    cellHeight: 150

                    clip: true

                    model: wallpapers

                    delegate: Rectangle {

                        width: 185
                        height: 140

                        radius: 12

                        color: "#0d0d0d"

                        border.width: 1
                        border.color: "#1c1c1c"

                        Image {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right

                            anchors.margins: 6

                            height: 105

                            source: "file://" + modelData.path

                            fillMode: Image.PreserveAspectCrop

                            asynchronous: true
                            cache: true
                            smooth: true
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom

                            anchors.margins: 9

                            text: modelData.name

                            color: "#cccccc"

                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11

                            elide: Text.ElideRight
                        }

                        MouseArea {
                            anchors.fill: parent

                            hoverEnabled: true

                            onEntered: parent.border.color = "#444444"
                            onExited: parent.border.color = "#1c1c1c"

                            onClicked: {
                                setWallpaper(modelData.path)
                            }
                        }
                    }
                }

                Text {
                    text: wallpapers.length + " wallpapers"

                    color: "#555555"

                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                }
            }
        }
    }
}
