import QtQuick 2.15
import QtQuick.Controls 2.15

Item{
    id: player_s
    width: parent.width
    height: parent.height
    property bool played: player.isPlaying
    property bool sound: true
    property int previousVolume: 30

    Rectangle{
        id: container
        anchors.fill: parent
        width: parent.width
        height: parent.height
        color: "#444444"


        MoreButton {
            id: more1
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 10
        }

        Image{
            id: home
            width: 45
            height: 45
            anchors.verticalCenter: more1.verticalCenter
            anchors.left: more1.right
            anchors.margins: 10
            fillMode: Image.PreserveAspectFit
            source: "qrc:/resources/images/home_dark.png"

            MouseArea{
                id: homeButton
                anchors.fill: parent
                onPressed: home.opacity = 0.7
                onReleased: home.opacity = 1.0
                onCanceled: home.opacity = 1.0
                onClicked:{
                    stackView.push(homeComponent);
                }
            }
        }

        Image{
            id: volume
            width: 45
            height: 45
            anchors.horizontalCenter: more1.horizontalCenter
            anchors.top: more1.bottom
            anchors.margins: 10
            fillMode: Image.PreserveAspectFit
            source: player.volume === 0 ? "qrc:/resources/images/mute_dark.png" : "qrc:/resources/images/vol_dark.png"

            MouseArea{
                    id: volumeButton
                    anchors.fill: parent
                    onClicked:{
                        if(player.volume === 0){
                            volume.source = "qrc:/resources/images/vol_dark.png";
                            player.setVolume(previousVolume);
                            sliderVol.value = previousVolume;
                        }else{
                            previousVolume = sliderVol.value;
                            volume.source = "qrc:/resources/images/mute_dark.png";
                            player.setVolume(0);
                            sliderVol.value = 0;
                        }
                        sound = !sound;
                    }
                    onPressed: volume.opacity = 0.7
                    onReleased: volume.opacity = 1.0
                    onCanceled: volume.opacity = 1.0
            }
        }

        Slider{
            id: sliderVol
            orientation: Qt.Vertical
            anchors.top: volume.bottom
            anchors.horizontalCenter: volume.horizontalCenter
            anchors.margins: 20
            from: 0
            to: 100
            value: player.volume
            stepSize: 1
            width: 20
            height: parent.height * 0.4

            background: Rectangle{
                width: 5
                height: parent.height
                x: sliderVol.leftPadding + sliderVol.availableWidth / 2 - width / 2
                y: sliderVol.topPadding
                color: "#F0F0F0"
            }

            handle: Rectangle{
                width: 20
                height: 20
                radius: 10
                color: sliderVol.pressed ? "#66BB6A" : "#1DB954"
                border.width: 3
                border.color: "#66BB6A"
                x: sliderVol.leftPadding + sliderVol.availableWidth / 2 - width / 2
                y: sliderVol.topPadding + sliderVol.visualPosition * (sliderVol.availableHeight - height)
                scale: sliderVol.pressed ? 1.2 : 1
            }

            onValueChanged:{
                    player.setVolume(value);
                    if(value === 0){
                        volume.source = "qrc:/resources/images/mute_dark.png";
                        sound = false;
                    }else{
                        volume.source = "qrc:/resources/images/vol_dark.png";
                        sound = true;
                        previousVolume = value;
                    }
                }
        }

        Text{
            id: volumeText
            width: contentWidth
            height: contentHeight
            color: "#F0F0F0"
            font.pixelSize: 12
            anchors.top: sliderVol.bottom
            anchors.horizontalCenter: sliderVol.horizontalCenter
            text: player.volume.toString()
        }

        Image{
            id: heart
            width: 45
            height: 45
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10
            fillMode: Image.PreserveAspectFit
            property bool liked: player.currentSongLiked
            source: liked ? "qrc:/resources/images/heart_pink_fill.png" : "qrc:/resources/images/heart_black_empty.png"

            MouseArea{
                id: heartButton
                anchors.fill: parent
                onClicked:{
                    liked = !liked
                    player.currentSongLiked = liked
                    if(liked){
                        heart.source = "qrc:/resources/images/heart_pink_fill.png"
                    }else{
                        heart.source = "qrc:/resources/images/heart_black_empty.png"
                    }
                }
                onPressed: heart.opacity = 0.7
                onReleased: heart.opacity = 1.0
                onCanceled: heart.opacity = 1.0
            }
        }

        Image{
            id: play
            width: 35
            height: 35
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 30
            fillMode: Image.PreserveAspectFit
            source: played ? "qrc:/resources/images/pause_dark.png" : "qrc:/resources/images/play_dark.png"

            MouseArea{
                id: playButton
                anchors.fill: parent
                onClicked:{
                    played = !played;
                    play.source = played ? "qrc:/resources/images/pause_dark.png" : "qrc:/resources/images/play_dark.png";
                    // console.log(player.currentSongUrl)
                    if(homeComponent.list_view){
                        console.log("found")}else{
                        console.log("not")
                    }

                    // for (var i = 0; i < homeComponent.song_count; ++i) {

                    //     var item = homeComponent.list_view.contentItem.children[i]
                    //     if(item){
                    //         console.log("true")
                    //     }

                    //     if (item && item.objectName === player.currentSongUrl) {
                    //         console.log("found")
                    //         item.playPauseImg.source = player.isPlaying ? "qrc:/resources/images/pause_dark2.png" : "qrc:/resources/images/play_dark2.png";
                    //         break;
                    //     }

                    player.playPause()
                }
                onPressed: play.opacity = 0.7
                onReleased: play.opacity = 1.0
                onCanceled: play.opacity = 1.0
            }
        }

        Image{//playing previos doesnt work, also play button state is desynchronised when playing next, it hsould always go to play, when next or prev presse
            id: prev
            width: 35
            height: 35
            anchors.right: play.left
            anchors.bottom: parent.bottom
            anchors.margins: 30
            fillMode: Image.PreserveAspectFit
            source: "qrc:/resources/images/next_prev_dark.png"
            transform: Rotation{
                origin.x: prev.width / 2
                origin.y: prev.height / 2
                angle: 180
            }

            MouseArea{
                id: prevButton
                anchors.fill: parent
                onPressed: prev.opacity = 0.7
                onReleased: prev.opacity = 1.0
                onCanceled: prev.opacity = 1.0
                onClicked:{
                    player.playPreviousSongInPlaylist();
                    play.source = "qrc:/resources/images/pause_dark.png"
                }
            }
        }

        Image{
            id: next
            width: 35
            height: 35
            anchors.left: play.right
            anchors.bottom: parent.bottom
            anchors.margins: 30
            fillMode: Image.PreserveAspectFit
            source: "qrc:/resources/images/next_prev_dark.png"

            MouseArea{
                id: nextButton
                anchors.fill: parent
                onPressed: next.opacity = 0.7
                onReleased: next.opacity = 1.0
                onCanceled: next.opacity = 1.0
                onClicked:{
                    player.playNextSongInPlaylist();
                    play.source = "qrc:/resources/images/pause_dark.png"
                }
            }
        }

        Slider{
            id: slider
            anchors.bottom: play.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 20
            from: 0
            to: player.duration
            value: player.position
            stepSize: 1000
            width: parent.width * 0.8
            height: 20

            background: Rectangle{
                height: 5
                width: parent.width
                x: slider.leftPadding
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                color: "#F0F0F0"
            }

            handle: Rectangle{
                width: 20
                height: 20
                radius: 10
                color: slider.pressed ? "#66BB6A" : "#1DB954"
                border.width: 3
                border.color: "#66BB6A"
                x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                scale: slider.pressed ? 1.2 : 1
            }

            onValueChanged:{
                if (slider.pressed){
                    player.setPosition(value);
                }
            }
        }

        Text{
            id: currTime
            width: contentWidth
            height: contentHeight
            color: "#F0F0F0"
            font.pixelSize: 15
            anchors{
                verticalCenter: slider.verticalCenter
                right: slider.left
                rightMargin: 10
            }
            text:{
                var mins = Math.floor(player.position / 60000);
                var secs = Math.floor((player.position % 60000) / 1000);
                return mins + ':' + (secs < 10 ? '0' : '') + secs;
            }
        }

        Text{
            id: totalTime
            width: contentWidth
            height: contentHeight
            color: "#F0F0F0"
            font.pixelSize: 15
            anchors{
                verticalCenter: slider.verticalCenter
                left: slider.right
                leftMargin: 10
            }
            text:{
                var mins = Math.floor(player.duration / 60000);
                var secs = Math.floor((player.duration % 60000) / 1000);
                return mins + ':' + (secs < 10 ? '0' : '') + secs;
            }
        }

        Text{
            id: songName
            width: 100
            height: 20
            color: "#F0F0F0"
            font.pixelSize: 12
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 20
            text: player.title
        }

        Text{
            id: songAuthors
            width: 100
            height: 20
            color: "#F0F0F0"
            font.pixelSize: 12
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 20
            text: player.author
        }
    }
}


// when screens changed, play button goes back to initial
// too long texts have to scroll automatically, also in home
