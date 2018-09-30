import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

Item {
    id: item1
    width: 400
    height: 200
    property alias passwordEdit: passwordEdit
    property alias usernameEdit: usernameEdit
    property alias urlEdit: urlEdit

    GridLayout {
        id: gridLayout
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 5
        anchors.topMargin: 5
        rows: 3
        columns: 2
        anchors.fill: parent

        Label {
            id: label1
            text: qsTr("Username")
            font.pixelSize: 12
        }

        TextField {
            id: usernameEdit
            text: qsTr("")
            placeholderText: "Username"
            Layout.fillWidth: true
            font.pixelSize: 12
        }

        Label {
            id: label
            text: qsTr("Password")
        }

        TextField {
            id: passwordEdit
            text: qsTr("")
            placeholderText: "Password"
            Layout.fillWidth: true
        }

        Label {
            id: label2
            text: qsTr("URL")
            font.pixelSize: 12
        }

        TextField {
            id: urlEdit
            text: qsTr("")
            placeholderText: "URL"
            Layout.fillWidth: true
            font.pixelSize: 12
        }

        Item {
            id: item2
            Layout.fillHeight: true
        }
    }
}
