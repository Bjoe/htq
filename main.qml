import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 1.4
import Qt.labs.settings 1.0
import "ui"

ApplicationWindow {
    id: window

    visible: true
    width: 640
    height: 480
    title: qsTr("Hunter tool")

    Settings {
        category: "WindowSettings"
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
    }

    Home {
        id: home
    }

    onClosing: home.closeApplication();
}
