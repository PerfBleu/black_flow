#include "utils.h"
#include <QNetworkProxy>

Utils::Utils(QObject *parent)
    : QObject(parent) {
}

QString getSystemProxyInfo() {
    std::map<QNetworkProxy::ProxyType, QString> proxyProtocol{
        {QNetworkProxy::NoProxy, ""},
        {QNetworkProxy::DefaultProxy, ""},
        {QNetworkProxy::Socks5Proxy, "socks://"},
        {QNetworkProxy::HttpProxy, "http://"},
        {QNetworkProxy::HttpCachingProxy, "http://"},
        {QNetworkProxy::FtpCachingProxy, "ftp://"}
    };
    QNetworkProxyQuery npq(QUrl("http://www.google.com"));
    QList<QNetworkProxy> listOfProxies = QNetworkProxyFactory::systemProxyForQuery(npq);
    QNetworkProxy proxy = listOfProxies.first();
    QString result = proxyProtocol.at(proxy.type()) + proxy.hostName() + ":" + QString::number(proxy.port());
    // for (const QNetworkProxy &proxy : listOfProxies) {
    //     result += proxyProtocol.at(proxy.type()) + proxy.hostName() + ":" + QString::number(proxy.port()) + "\n";
    // }
    if (result == ":0") { return ""; }
    return result;
}

QString Utils::getSystemProxyInfo() {
    return ::getSystemProxyInfo();
}