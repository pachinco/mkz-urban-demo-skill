import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

Mycroft.Delegate{
    anchors.fill: parent

    Image {
        id: imageId
        width: parent.width+20
        height: parent.height+20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: Qt.resolvedUrl("../images/mkz_background2.png")
    }

    Rectangle {
        id: settingsBox
        width: parent.width/4
        height: parent.height
        anchors.top: parent.verticalCenter-100
        anchors.horizontalCenter: parent.horizontalCenter/3
        color: "#cccccc"
        radius: 20

        YAnimator {
            target: settingsBox;
            from: 800;
            to: 100;
            duration: 8000
            running: true
        }
       
        Image {
            width: parent.width-20
//             height: parent.height
//             anchor.verticalCenter: parent.verticalCenter
//             anchor.horizontalCenter: parent.horizontalCenter
            source: Qt.resolvedUrl("../images/settings-icon-10.png")
            fillMode: Image.PreserveAspectCrop
        }
    }

    Rectangle {
        id: drivingBox
        width: parent.width/4
        height: parent.height
        anchors.top: parent.verticalCenter-100
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#cccccc"
        radius: 20

        YAnimator {
            target: drivingBox;
            from: 1000;
            to: 100;
            duration: 8000
            running: true
        }
       
        Image {
            width: parent.width-20
//             height: parent.height
//             anchor.verticalCenter: parent.verticalCenter
//             anchor.horizontalCenter: parent.horizontalCenter
            source: Qt.resolvedUrl("../images/settings-icon-10.png")
            fillMode: Image.PreserveAspectCrop
        }
    }
}

// Mycroft.ScrollableDelegate{
//     id: actionsList
//     skillBackgroundSource: Qt.resolvedUrl(sessionData.background)
//     property var actionsModel: sessionData.actionsList
// 
//     Kirigami.CardsGridView {
//         id: exampleListView
//         Layout.fillWidth: true
//         Layout.fillHeight: true
//         model: actionsModel.actions
//         delegate: Kirigami.AbstractCard {
//             id: rootCard
//             implicitHeight: delegateItem.implicitHeight + Kirigami.Units.largeSpacing
//             contentItem: Rectangle {
//                 implicitWidth: parent.implicitWidth
//                 implicitHeight: parent.implicitHeight
//                 radius: 20
//                 color: "#777777"
//                 ColumnLayout {
//                     id: delegateItem
//                     anchors.left: parent.left
//                     anchors.right: parent.right
//                     anchors.top: parent.top
//                     anchors.bottom: parent.bottom
//                     spacing: Kirigami.Units.largeSpacing
//                     Item {
//                         Layout.fillWidth: true
//                         Layout.preferredHeight: Kirigami.Units.gridUnit * 4
//                     }
//                     Image {
//                         id: placeImage
//                         source: modelData.image
//                         Layout.fillWidth: true
//                         Layout.preferredHeight: Kirigami.Units.gridUnit * 14
//                         fillMode: Image.PreserveAspectCrop
//                     }
//                     Kirigami.Heading {
//                         id: restaurantNameLabel
//                         Layout.fillWidth: true
//                         text: modelData.text
//                         level: 2
//                         wrapMode: Text.WordWrap
//                     }
//                     Item {
//                         Layout.fillWidth: true
//                         Layout.preferredHeight: Kirigami.Units.gridUnit * 4
//                     }
//                 }
//             }
//         }
//     }
// }

