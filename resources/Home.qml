import QtQuick 2.15
import QtQuick.Controls 2.15

Item{
    id: home_s
    width: parent.width
    height: parent.height
    property bool open_tab: false

    Rectangle{
        id: container
        anchors.fill: parent
        width: parent.width
        height: parent.height
        color: "#444444"


        Image{
            id: more1
            width: 50
            height: 50
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 10
            fillMode: Image.PreserveAspectFit
            source: "qrc:/resources/images/more_dark.png"

            MouseArea{
                id: moreButton1
                anchors.fill: parent
                onClicked:{
                    open_tab = !open_tab
                    more1.source = open_tab ? "qrc:/resources/images/more_dark2.png" : "qrc:/resources/images/more_dark.png"
                }
                onPressed: more1.opacity = 0.7
                onReleased: more1.opacity = 1.0
                onCanceled: more1.opacity = 1.0
            }
        }

        Image{
            id: goToPlayer
            width: 50
            height: 50
            anchors{
                verticalCenter: more1.verticalCenter
                left: more1.right
                margins: 5
            }
            fillMode: Image.PreserveAspectFit
            source: "qrc:/resources/images/sound_dark.png"

            MouseArea {
                id: goToPlayerButton
                anchors.fill: parent
                onPressed: goToPlayer.opacity = 0.7
                onReleased: goToPlayer.opacity = 1.0
                onCanceled: goToPlayer.opacity = 1.0
                onClicked:{
                    stackView.push(playerComponent)
                }
            }
        }

        ListView{
            id: songListView
            anchors.top: goToPlayer.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            spacing: 1
            width: parent.width * 0.95

            height: parent.height - goToPlayer.height - more1.height
            clip: true
            model: songs.songList

            delegate: Rectangle{
                id: songP
                height: 45
                width: songListView.width
                color: "#555555"
                property bool liked: false
                property bool played: false
                property string songTitle: model.name
                property string songAuthor: model.artist

                Text{
                    id: titleText
                    font.pixelSize: 15
                    color: "#F0F0F0"
                    anchors{
                        left: parent.left
                        margins: 10
                    }
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    width: 300
                    text: songTitle
                }

                Text{
                    id: authorText
                    font.pixelSize: 15
                    color: "#F0F0F0"
                    anchors{
                        left: titleText.right
                        leftMargin: 10
                    }
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    width: 300
                    text: songAuthor
                }

                Image{
                    id: heartImg
                    height: parent.height - 3
                    width: parent.height - 3
                    anchors{
                        verticalCenter: parent.verticalCenter
                        right: playPauseImg.left
                        rightMargin: 15
                    }
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/resources/images/heart_black_empty.png"

                    MouseArea{
                        id: heartButton
                        anchors.fill: parent
                        onClicked:{
                            liked = !liked
                            heartImg.source = liked ? "qrc:/resources/images/heart_pink_fill.png" : "qrc:/resources/images/heart_black_empty.png"
                        }
                        onPressed: heartImg.opacity = 0.7
                        onReleased: heartImg.opacity = 1.0
                        onCanceled: heartImg.opacity = 1.0
                    }
                }

                Image {
                    id: playPauseImg
                    height: parent.height - 3
                    width: parent.height - 3
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: moreImg.left
                    }
                    fillMode: Image.PreserveAspectFit
                    source: (player.currentSongUrl === model.fileUrl) ? (player.isPlaying ? "qrc:/resources/images/pause_dark2.png" : "qrc:/resources/images/play_dark2.png") : "qrc:/resources/images/play_dark2.png"

                    MouseArea {
                        id: playButton
                        anchors.fill: parent
                        onClicked: {
                            if (player.currentSongUrl === model.fileUrl) {
                                player.playPause()
                            } else {
                                player.setSource(model.fileUrl)
                                player.playPause()
                            }
                            played = !played
                            playPauseImg.source = played ? "qrc:/resources/images/pause_dark2.png" : "qrc:/resources/images/play_dark2.png"
                        }
                        onPressed: playPauseImg.opacity = 0.7
                        onReleased: playPauseImg.opacity = 1.0
                        onCanceled: playPauseImg.opacity = 1.0
                    }
                }

                Image{
                    id: moreImg
                    height: parent.height - 3
                    width: parent.height - 3
                    anchors{
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                    }
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/resources/images/more_settings_dark.png"
                    transform: Rotation {
                        origin.x: moreImg.width / 2
                        origin.y: moreImg.height / 2
                        angle: 90
                    }

                    MouseArea{
                        id: moreImgButton
                        anchors.fill: parent
                        onPressed: moreImg.opacity = 0.7
                        onReleased: moreImg.opacity = 1.0
                        onCanceled: moreImg.opacity = 1.0
                    }
                }
            }
        }
    }
}
