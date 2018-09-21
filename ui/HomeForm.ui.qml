import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1

Page {
    id: page
    width: 600
    height: 400
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

    ComboBox {
        id: projectComboBox
        displayText: "Project"
        anchors.right: clearButton.left
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
    }

    Button {
        id: clearButton
        x: 382
        text: qsTr("Clear")
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
    }

    ComboBox {
        id: branchComboBox
        displayText: "Branch"
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.top: projectComboBox.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.topMargin: 5
    }

    GridLayout {
        id: gridLayout
        columns: 3
        anchors.top: branchComboBox.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 5

        Frame {
            id: frame

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
                //   Layout.preferredHeight: 40
                anchors.fill: parent
                opacity: 0.0
                value: 0.5
                /*                padding: 2

                background: Rectangle {
//                          implicitWidth: 200
//                          implicitHeight: 6
                          opacity: 0.0
                      }

                contentItem: Item {
                          implicitWidth: 200
                          implicitHeight: 4

                          Rectangle {
                              width: control.visualPosition * parent.width
                              height: parent.height
                              radius: 2
                              color: "#17a81a"
                          }
                }*/
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
