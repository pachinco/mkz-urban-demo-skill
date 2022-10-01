import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

// Mycroft.ScrollableDelegate{
// Mycroft.Delegate {
//     skillBackgroundSource: sessionData.exampleImage
//     ColumnLayout {
//         anchors.fill: parent

//         Image {
//             id: imageId
//             Layout.fillWidth: true
//             Layout.fillHeight: true
//             anchors.horizontalCenter: parent.horizontalCenter
//             anchors.verticalCenter: parent.verticalCenter
//             source: Qt.resolvedUrl("../images/mkz_homescreen.png")
//         }

Kirigami.ScrollablePage {
    title: i18n("Address book (prototype)")

    Kirigami.CardsGridView {
        id: view

        model: ListModel {
            id: mainModel
        }

        delegate: card
    }

    Component.onCompleted: {
        mainModel.append({"firstname": "Pablo", "lastname": "Doe", "cellphone": "6300000002", "email" : "jane-doe@example.com", "photo": "qrc:/konqi.jpg"});
        mainModel.append({"firstname": "Paul", "lastname": "Adams", "cellphone": "6300000003", "email" : "paul-adams@example.com", "photo": "qrc:/katie.jpg"});
        mainModel.append({"firstname": "John", "lastname": "Doe", "cellphone": "6300000001", "email" : "john-doe@example.com", "photo": "qrc:/konqi.jpg"});
        mainModel.append({"firstname": "Ken", "lastname": "Brown", "cellphone": "6300000004", "email" : "ken-brown@example.com", "photo": "qrc:/konqi.jpg"});
        mainModel.append({"firstname": "Al", "lastname": "Anderson", "cellphone": "6300000005", "email" : "al-anderson@example.com", "photo": "qrc:/katie.jpg"});
        mainModel.append({"firstname": "Kate", "lastname": "Adams", "cellphone": "6300000005", "email" : "kate-adams@example.com", "photo": "qrc:/konqi.jpg"});
    }

    Component {
        id: card

        Kirigami.Card {

            height: view.cellHeight - Kirigami.Units.largeSpacing

            banner {
                title: model.firstname + " " + model.lastname
                titleIcon: "im-user"
            }

            contentItem: Column {
                id: content

                spacing: Kirigami.Units.smallSpacing

                Controls.Label {
                    wrapMode: Text.WordWrap
                    text: "Mobile: " + model.cellphone
                }

                Controls.Label {
                    wrapMode: Text.WordWrap
                    text: "Email: " + model.email
                }
            }

            actions: [
                Kirigami.Action {
                    text: "Call"
                    icon.name: "call-start"

                    onTriggered: { showPassiveNotification("Calling " + model.firstname + " " + model.lastname + " ...") }
                }
            ]
        }
    }
}
//        Kirigami.ScrollablePage {
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//             Rectangle {
//                 width: parent.width*2
//                 height: parent.height/2
//                 radius: 20
//                 color: "#00ffff"
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 anchors.verticalCenter: parent.verticalCenter
//                 Label {
//                     id: labelId
//                     Layout.fillWidth: true
//                     Layout.preferredHeight: Kirigami.Units.gridUnit * 10
//                     anchors.horizontalCenter: parent.horizontalCenter
//                     color: "#000000"
//                     text: "U Power Autonomous Driving System"            
//                 }
//             }
//         }
//         Kirigami.CardsListView {
//             id: exampleListView
//             Layout.fillWidth: true
//             Layout.fillHeight: true
//             model: ListModel {
//                 id: mainModel
//             }
//             delegate: Kirigami.AbstractCard {
//                 id: rootCard
//                 implicitHeight: delegateItem.implicitHeight + Kirigami.Units.largeSpacing
//                 contentItem: Item {
//                     implicitWidth: parent.implicitWidth
//                     implicitHeight: parent.implicitHeight
//                     ColumnLayout {
//                         id: delegateItem
//                         anchors.left: parent.left
//                         anchors.right: parent.right
//                         anchors.top: parent.top
//                         spacing: Kirigami.Units.largeSpacing
//                         Kirigami.Heading {
//                             id: restaurantNameLabel
//                             Layout.fillWidth: true
//                             text: "Heading"
//                             level: 2
//                             wrapMode: Text.WordWrap
//                         }
//                         Kirigami.Separator {
//                             Layout.fillWidth: true
//                         }
//                         Image {
//                             id: placeImage
//                             source: Qt.resolvedUrl("../images/mkz_homescreen.png")
//                             Layout.fillWidth: true
//                             Layout.preferredHeight: Kirigami.Units.gridUnit * 3
//                             fillMode: Image.PreserveAspectCrop
//                         }
//                         Item {
//                             Layout.fillWidth: true
//                             Layout.preferredHeight: Kirigami.Units.gridUnit * 1
//                         }
//                     }
//                 }
//             }
//         }
//     }
// }

// Mycroft.ScrollableDelegate{
//     id: root
//     skillBackgroundSource: sessionData.background
//     property var sampleModel: sessionData.sampleBlob
// 
//     Kirigami.CardsListView {
//         id: exampleListView
//         Layout.fillWidth: true
//         Layout.fillHeight: true
//         model: sampleModel.lorem
//         delegate: Kirigami.AbstractCard {
//             id: rootCard
//             implicitHeight: delegateItem.implicitHeight + Kirigami.Units.largeSpacing
//             contentItem: Item {
//                 implicitWidth: parent.implicitWidth
//                 implicitHeight: parent.implicitHeight
//                 ColumnLayout {
//                     id: delegateItem
//                     anchors.left: parent.left
//                     anchors.right: parent.right
//                     anchors.top: parent.top
//                     spacing: Kirigami.Units.largeSpacing
//                     Kirigami.Heading {
//                         id: restaurantNameLabel
//                         Layout.fillWidth: true
//                         text: modelData.text
//                         level: 2
//                         wrapMode: Text.WordWrap
//                     }
//                     Kirigami.Separator {
//                         Layout.fillWidth: true
//                     }
//                     Image {
//                         id: placeImage
//                         source: modelData.image
//                         Layout.fillWidth: true
//                         Layout.preferredHeight: Kirigami.Units.gridUnit * 3
//                         fillMode: Image.PreserveAspectCrop
//                     }
//                     Item {
//                         Layout.fillWidth: true
//                         Layout.preferredHeight: Kirigami.Units.gridUnit * 1
//                     }
//                 }
//             }
//         }
//     }
// }
