// player.h
#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QSettings>
#include <QMediaMetaData>
#include "songs.h"
#include "playlists.h"

class Player: public QObject{
    Q_OBJECT
    Q_PROPERTY(qint64 position READ position NOTIFY positionChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(QString title READ title NOTIFY titleChanged)
    Q_PROPERTY(QString author READ author NOTIFY authorChanged)
    Q_PROPERTY(QUrl currentSongUrl READ currentSongUrl NOTIFY currentSongUrlChanged)
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY playbackStateChanged)
    Q_PROPERTY(bool currentSongLiked READ isCurrentSongLiked WRITE setCurrentSongLiked NOTIFY currentSongLikedChanged)
    Q_PROPERTY(QString currentPlaylist READ getCurrentPlaylist WRITE setCurrentPlaylist NOTIFY currentPlaylistChanged)
    Q_PROPERTY(int currentSongIndex READ getCurrentSongIndex NOTIFY currentSongIndexChanged)

    public:
        explicit Player(QObject *parent = nullptr);
        qint64 position() const;
        qint64 duration() const;
        Q_INVOKABLE int volume() const;
        Q_INVOKABLE void setVolume(int volume);
        QString title() const;
        QString author() const;
        Q_INVOKABLE void setSource(const QUrl &source);
        QUrl currentSongUrl() const;
        bool isCurrentSongLiked() const;
        void setCurrentSongLiked(bool liked);

        bool isPlaying() const;
        Q_INVOKABLE void playAndPause();

        void saveLastSong(const QUrl &song);

        QString getCurrentPlaylist() const;
        void setCurrentPlaylist(const QString &new_current_playlist);
        Q_INVOKABLE void playPlaylist(const QString &playlistName);
        Q_INVOKABLE void playNextSongInPlaylist();
        int getCurrentSongIndex() const;
        Q_INVOKABLE void setHomePlaylistAndPlay(int songIndex);
        Q_INVOKABLE void playNextSongInHomePlaylist();

        Q_INVOKABLE void playPreviousSongInPlaylist();
        Q_INVOKABLE void playPreviousSongInHomePlaylist();
    signals:
        void positionChanged(qint64 position);
        void durationChanged(qint64 duration);
        void volumeChanged(int volume);
        void titleChanged(const QString &title);
        void authorChanged(const QString &author);
        void playbackStateChanged();
        void currentSongUrlChanged(const QUrl &url);
        void currentSongLikedChanged(bool liked);


        void currentPlaylistChanged();
        void currentSongIndexChanged();

    public slots:
        void playPause();
        void setPosition(qint64 position);


    private:
        QMediaPlayer* player;
        QAudioOutput* audioOutput;
        int previousVolume;
        QUrl previousSong;
        QString m_title;
        QString m_author;
        QUrl m_currentSongUrl;
        Songs* songs;
        Playlists* playlists;
        QString m_current_playlist;
        int m_currentSongIndex;

    private slots:
        void updateDuration(qint64 duration);
        void updatePosition(qint64 position);
        void updateMetaData();
};

#endif // PLAYER_H
