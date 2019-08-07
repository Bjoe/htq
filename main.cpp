#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "sha1sum.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setApplicationName("htq");
    app.setOrganizationName("hunter");
    app.setOrganizationDomain("hunter.sh");

    qmlRegisterType<util::Sha1Sum>("util", 1, 0, "Sha1Sum");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
