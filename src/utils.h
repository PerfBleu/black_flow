#ifndef UTILS_H
#define UTILS_H

#include <QString>
#include <QObject>

class Utils: public QObject {
    Q_OBJECT
public:
    explicit Utils(QObject *parent = nullptr);
    Q_INVOKABLE static QString getSystemProxyInfo();
    // Q_INVOKABLE static QString getFileName(const QString &filePath);
    // Q_INVOKABLE static QString getFileExtension(const QString &filePath);
    // Q_INVOKABLE static QString getFileNameWithoutExtension(const QString &filePath);
signals:
public slots:
};

QString getSystemProxyInfo();

#endif // UTILS_H 