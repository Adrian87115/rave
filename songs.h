#ifndef SONGS_H
#define SONGS_H

#include <QObject>
#include <QMediaPlayer>
#include <QDir>
#include <QFileInfoList>
#include <QAbstractListModel>
#include <QSettings>
#include <vector>

class Song: public QObject{
    Q_OBJECT
    Q_PROPERTY(QString name READ getName NOTIFY nameChanged)
    Q_PROPERTY(QString artist READ getArtist NOTIFY artistChanged)
    Q_PROPERTY(QUrl fileUrl READ getFileUrl NOTIFY fileUrlChanged)
    Q_PROPERTY(bool liked READ isLiked WRITE setLiked NOTIFY likedChanged)

    public:
        explicit Song(QObject *parent = nullptr);

        QString getName() const;
        void setName(const QString &name);

        QString getArtist() const;
        void setArtist(const QString &artist);

        QUrl getFileUrl() const;
        void setFileUrl(const QUrl &fileUrl);

        bool isLiked() const;
        void setLiked(bool liked);

        friend class Songs;

    signals:
        void nameChanged();
        void artistChanged();
        void fileUrlChanged();
        void likedChanged();
        void playClicked(QUrl fileUrl);

    private:
        QString m_name;
        QString m_artist;
        QUrl m_fileUrl;
        bool m_liked = false;
};

class Songs: public QObject{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> songList READ getSongList NOTIFY songListChanged)

    public:
        Songs();
        std::vector<Song*> getLibrary();
        Q_INVOKABLE QList<QObject*> getSongList() const;
        Q_INVOKABLE void loadSongsFromDirectory(QString directoryPath);
        Q_INVOKABLE void saveLikedFromQML();
        Q_INVOKABLE int getSongCount() const;

        Q_INVOKABLE QString getSongTitleByUrl(const QUrl &songUrl) const;
        Q_INVOKABLE QString getSongAuthorByUrl(const QUrl &songUrl) const;
        friend class Player;

    signals:
        void songListChanged();

    public slots:
        void saveLiked();


    private slots:
        void onMediaLoaded(QMediaPlayer::MediaStatus status);

    private:
        void loadLiked();
        void addSong(QString filePath);
        std::vector<Song*> library;
        QList<QObject*> songList;
        QMediaPlayer player_temp;
        std::vector<QUrl> pendingUrls;
        QSettings settings;
};

#endif // SONGS_H
