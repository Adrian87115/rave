#include "player.h"

Player::Player(QObject *parent): QObject(parent), previousVolume(30){
    QSettings settings("AL", "Rave");
    int last_vol = settings.value("last_vol", 30).toInt();
    QUrl last_song = settings.value("last_song").toUrl();
    songs = new Songs();
    player = new QMediaPlayer(this);
    audioOutput = new QAudioOutput(this);
    player->setAudioOutput(audioOutput);
    setSource(last_song);
    if(last_vol == 0){
        setVolume(0);
        previousVolume = 30;
    }else{
        setVolume(last_vol);
    }
    playlists = new Playlists();
    connect(player, &QMediaPlayer::durationChanged, this, &Player::updateDuration);
    connect(player, &QMediaPlayer::positionChanged, this, &Player::updatePosition);
    connect(player, &QMediaPlayer::metaDataChanged, this, &Player::updateMetaData);
    connect(player, &QMediaPlayer::mediaStatusChanged, this, [this](QMediaPlayer::MediaStatus status) {
        if (status == QMediaPlayer::EndOfMedia) {
            if (m_current_playlist == "HomePlaylist") {
                playNextSongInHomePlaylist();
            } else {
                playNextSongInPlaylist();
            }
        }
    });
}

void Player::playPause(){
    if(player->playbackState() == QMediaPlayer::PlayingState){
        player->pause();
    }else{
        player->play();
    }
    saveLastSong(m_currentSongUrl);
}

void Player::setSource(const QUrl &source){
    if(m_currentSongUrl != source){
        m_currentSongUrl = source;
        player->setSource(source);
        emit currentSongUrlChanged(m_currentSongUrl);
        bool liked = isCurrentSongLiked();
        emit currentSongLikedChanged(liked);
    }
}

bool Player::isCurrentSongLiked() const{
    for(Song* song : songs->getLibrary()){
        if(song->getFileUrl() == m_currentSongUrl){
            return song->isLiked();
        }
    }
    return false;
}

void Player::setCurrentSongLiked(bool liked){
    for(Song* song : songs->getLibrary()){
        if(song->getFileUrl() == m_currentSongUrl){
            song->setLiked(liked);
            break;
        }
    }
}

void Player::saveLastSong(const QUrl &song){
    QSettings settings("AL", "Rave");
    settings.setValue("last_song", song);
}

qint64 Player::position() const{
    return player->position();
}

void Player::setPosition(qint64 position){
    player->setPosition(position);
}

qint64 Player::duration() const{
    return player->duration();
}

void Player::updateDuration(qint64 duration){
    emit durationChanged(duration);
}

void Player::updatePosition(qint64 position){
    emit positionChanged(position);
}

int Player::volume() const{
    return qRound(audioOutput->volume() * 100);
}

void Player::setVolume(int volume){
    qreal linearVolume = volume / 100.0;
    if(volume == 0){
        previousVolume = qRound(audioOutput->volume() * 100);
        audioOutput->setVolume(0.0);
    }else{
        audioOutput->setVolume(linearVolume);
    }
    QSettings settings("AL", "Rave");
    settings.setValue("last_vol", volume);
    emit volumeChanged(volume);
}

QString Player::title() const{
    return m_title;
}

QString Player::author() const{
    return m_author;
}

void Player::updateMetaData(){
    m_title = player->metaData().value(QMediaMetaData::Title).toString();
    m_author = player->metaData().value(QMediaMetaData::ContributingArtist).toString();
    emit titleChanged(m_title);
    emit authorChanged(m_author);
}

bool Player::isPlaying() const{
    return player->playbackState() == QMediaPlayer::PlayingState;
}


void Player::playAndPause(){
    if(player->playbackState() == QMediaPlayer::PlayingState){
        player->pause();
    }else{
        player->play();
    }
}

QUrl Player::currentSongUrl() const{
    return m_currentSongUrl;
}

QString Player::getCurrentPlaylist() const{
    return m_current_playlist;
}

void Player::setCurrentPlaylist(const QString &new_current_playlist){
    if(m_current_playlist == new_current_playlist){
        return;
    }
    m_current_playlist = new_current_playlist;
    emit currentPlaylistChanged();
}

void Player::playPlaylist(const QString &playlistName){
    setCurrentPlaylist(playlistName);
    m_currentSongIndex = 0;
    QStringList songs = playlists->getPlaylistContents(playlistName);
    if(!songs.isEmpty()){
        setSource(QUrl(songs.at(m_currentSongIndex)));
        playAndPause();
    }
}

int Player::getCurrentSongIndex() const{
    return m_currentSongIndex;
}

void Player::setHomePlaylistAndPlay(int songIndex){
    QList<QObject*> allSongs = songs->getSongList();
    m_current_playlist = "HomePlaylist";
    m_currentSongIndex = songIndex;
    if(songIndex >= 0 && songIndex < allSongs.size()){
        Song* selectedSong = qobject_cast<Song*>(allSongs.at(songIndex));
        if(selectedSong){
            setSource(selectedSong->getFileUrl());
            emit currentSongUrlChanged(selectedSong->getFileUrl());
        }
    }
}

void Player::playNextSongInPlaylist(){
    if(m_current_playlist == "HomePlaylist"){
        playNextSongInHomePlaylist();
    }else{
        QStringList songs = playlists->getPlaylistContents(m_current_playlist);
        if(songs.isEmpty()){
            return;
        }
        m_currentSongIndex = (m_currentSongIndex + 1) % songs.size();
        setSource(QUrl(songs.at(m_currentSongIndex)));
        playAndPause();
    }
}

void Player::playPreviousSongInPlaylist(){
    if(m_current_playlist == "HomePlaylist"){
        playPreviousSongInHomePlaylist();
    }else{
        QStringList songs = playlists->getPlaylistContents(m_current_playlist);
        if(songs.isEmpty()){
            return;
        }
        if(m_currentSongIndex - 1 < 0){
            m_currentSongIndex = songs.size() - 1;
        }else{
            m_currentSongIndex--;
        }
        setSource(QUrl(songs.at(m_currentSongIndex)));
        playAndPause();
    }
}

void Player::playNextSongInHomePlaylist(){
    QList<QObject*> allSongs = songs->getSongList();
    if(allSongs.isEmpty()){
        return;
    }
    m_currentSongIndex = (m_currentSongIndex + 1) % allSongs.size();
    Song* nextSong = qobject_cast<Song*>(allSongs.at(m_currentSongIndex));
    if(nextSong){
        setSource(nextSong->getFileUrl());
        playAndPause();
    }
}

void Player::playPreviousSongInHomePlaylist(){
    QList<QObject*> allSongs = songs->getSongList();
    if(allSongs.isEmpty()){
        return;
    }
    if(m_currentSongIndex - 1 < 0){
        m_currentSongIndex = allSongs.size() - 1;
    }else{
        m_currentSongIndex--;
    }
    Song* previousSong = qobject_cast<Song*>(allSongs.at(m_currentSongIndex));
    if(previousSong){
        setSource(previousSong->getFileUrl());
        playAndPause();
    }
}
