#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "src/utils.h"
#include "src/ytdlp.h"

int main(int argc, char *argv[])
{
    qputenv("QT_QUICK_CONTROLS_MATERIAL_VARIANT", QByteArray( "Dense" ));
    
    QGuiApplication app(argc, argv);
    qmlRegisterType<Utils>("blackflow", 1, 0, "Utils");
    qmlRegisterType<YTDLP>("blackflow", 1, 0, "YTDLP");
    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("blackflow", "Main");

    return app.exec();
}
