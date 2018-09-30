import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1

Page {
    id: page
    width: 600
    height: 450
    property alias ownerMouseArea: ownerMouseArea
    property alias projectMouseArea: projectMouseArea
    property alias urlMouseArea: urlMouseArea
    property alias ownerComboBox: ownerComboBox
    property alias typeComboBox: typeComboBox
    property alias urlComboBox: urlComboBox
    property alias clearButton: clearButton
    property alias progressBar: progressBar
    property alias copyUrlbutton: copyUrlbutton
    property alias copyShabutton: copyShabutton
    property alias copyIdbutton: copyIdbutton
    property alias sha1sumOutput: sha1sumOutput
    property alias urlOutput: urlOutput
    property alias commitMessageOutput: commitMessageOutput
    property alias commitIdOutput: commitIdOutput
    property alias branchComboBox: branchComboBox
    property alias projectComboBox: projectComboBox

    title: qsTr("Home")

    GridLayout {
        id: gridLayout
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 5
        anchors.topMargin: 5
        anchors.fill: parent
        columns: 3

        ComboBox {
            id: typeComboBox
            displayText: "Git type"
            textRole: ""
            Layout.fillWidth: true
            Layout.columnSpan: 3
        }

        ComboBox {
            id: urlComboBox
            textRole: "text"
            enabled: false
            Layout.columnSpan: 3
            Layout.fillWidth: true
            editable: false
            displayText: "Git url"

            MouseArea {
                id: urlMouseArea
                anchors.fill: parent
            }
        }

        ComboBox {
            id: ownerComboBox
            textRole: "text"
            enabled: false
            Layout.columnSpan: 3
            Layout.fillWidth: true
            editable: false
            displayText: "Owner"

            MouseArea {
                id: ownerMouseArea
                anchors.fill: parent
            }
        }

        ComboBox {
            id: projectComboBox
            textRole: "text"
            enabled: false
            Layout.columnSpan: 3
            Layout.fillWidth: true
            editable: false
            displayText: "Project"

            MouseArea {
                id: projectMouseArea
                anchors.fill: parent
            }
        }

        ComboBox {
            id: branchComboBox
            textRole: "text"
            enabled: false
            Layout.columnSpan: 2
            Layout.fillWidth: true
            editable: false
            displayText: "Branch"
        }

        Button {
            id: clearButton
            text: qsTr("Clear")
        }

        Frame {
            id: frame
            Layout.fillWidth: false

            Label {
                id: label
                text: qsTr("Commit id")
            }
        }

        TextField {
            id: commitIdOutput
            Layout.fillWidth: true
            placeholderText: qsTr("Commit id")
        }

        Button {
            id: copyIdbutton
            text: qsTr("Copy")
        }

        Frame {
            id: frame2

            Label {
                id: label1
                text: qsTr("Commit message")
            }
        }

        TextField {
            id: commitMessageOutput
            Layout.fillWidth: true
            placeholderText: qsTr("Commit message")
        }

        Item {
            id: placeholder
            width: 100
            height: 40
            Layout.preferredHeight: 40
            Layout.preferredWidth: 100
        }

        Frame {
            id: frame4

            Label {
                id: label2
                text: qsTr("Url")
            }
        }

        TextField {
            id: urlOutput
            Layout.fillWidth: true
            placeholderText: qsTr("Url")
        }

        Button {
            id: copyUrlbutton
            text: qsTr("Copy")
        }

        Frame {
            id: frame6

            Label {
                id: label3
                text: qsTr("SHA1 sum")
            }
        }

        Item {
            Layout.preferredHeight: 40
            Layout.fillWidth: true
            TextField {
                id: sha1sumOutput
                anchors.fill: parent

                placeholderText: qsTr("SHA1 sum")
            }
            ProgressBar {
                id: progressBar
                anchors.fill: parent
                opacity: 0.0
                value: 0.5
            }
        }

        Button {
            id: copyShabutton
            text: qsTr("Copy")
        }

        Item {
            id: placeholder2
            width: 100
            height: 40
            Layout.columnSpan: 3
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}


/*##^## Designer {
    D{i:29;anchors_height:100;anchors_width:100}
}
 ##^##*/
