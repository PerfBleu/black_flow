#ifndef YTDLP_H
#define YTDLP_H

#include <QObject>

class YTDLP : public QObject {
    Q_OBJECT
public:
    explicit YTDLP(QObject *parent = nullptr);
    static QString ytdlp_command;
    Q_INVOKABLE void download(QString url, QString vquality, QString format,
        QString proxy, QString savepath,
        bool thumbnail, bool subtitle
    );
signals:
    void progressUpdated(int progress);
    void downloadLog(const QString &log);
    void downloadFinished();
public slots:
};

#endif // YTDLP_H