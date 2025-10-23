#include "ytdlp.h"
#include <QDebug>
#include <QString>
#include <QProcess>

QString YTDLP::ytdlp_command = QStringLiteral("yt-dlp");

YTDLP::YTDLP(QObject *parent)
    : QObject(parent) {
}

void YTDLP::download(QString url, QString vquality, QString format,
    QString proxy, QString savepath, bool thumbnail, bool subtitle) {
    QString args;
    if (vquality == "") {
        args = "bestaudio";
    } else {
        args = (vquality == "最佳质量" ? "bestvideo" : "bestvideo[height" + vquality + "]") + "+" + "bestaudio";
    }
    QString command = ytdlp_command + " -f " + args + " -P \"" + savepath + "\" " +
                        (format == "默认" ? "" : "--merge-output-format " + format + " ") +
                        (proxy == "" ? "" : "--proxy " + proxy + " ") 
                        + (subtitle ? "--write-sub " : "")
                        + (thumbnail ? "--write-all-thumbnails " : "")
                        + url;
    qDebug() << "Executing command: " << command;
    QProcess* process = new QProcess(this);
    emit downloadLog("Download started for URL: " + url);
    connect(process, &QProcess::readyReadStandardOutput, [this, process]() {
        QByteArray output = process->readAllStandardOutput();
        emit downloadLog(QString::fromUtf8(output));
    });
    connect(process, &QProcess::finished, [=](int exitCode, QProcess::ExitStatus exitStatus) {
        if (exitStatus == QProcess::NormalExit && exitCode == 0) {
            emit downloadLog("Download completed successfully.");
            emit downloadFinished();
        } else {
            emit downloadLog("Download failed with exit code: " + QString::number(exitCode));
            emit downloadFinished();
        }
        process->deleteLater();
    });
    process->startCommand(command);
    return;
}