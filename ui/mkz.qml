import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

//  Mycroft.Delegate{
//     anchors.fill: parent
// 
// 
//    Image {
//        id: imageId
//         width: parent.width
//         height: parent.height
//         anchors.horizontalCenter: parent.horizontalCenter
//         anchors.verticalCenter: parent.verticalCenter
//         source: Qt.resolvedUrl("../images/mkz_homescreen.png")
//     }
// }

Mycroft.ScrollableDelegate{
    id: actionsList
    skillBackgroundSource: sessionData.background
    property var actionsModel: sessionData.actionsList

    Kirigami.CardsGridView {
        id: exampleListView
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: actionsModel.actions
        delegate: Kirigami.AbstractCard {
            id: rootCard
            implicitHeight: delegateItem.implicitHeight + Kirigami.Units.largeSpacing
            contentItem: Rectangle {
                implicitWidth: parent.implicitWidth
                implicitHeight: parent.implicitHeight
                radius: 20
                ColumnLayout {
                    id: delegateItem
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    spacing: Kirigami.Units.largeSpacing
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 10
                    }
                    Image {
                        id: placeImage
                        source: modelData.image
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 20
                        fillMode: Image.PreserveAspectCrop
                    }
//                     Kirigami.Separator {
//                         Layout.fillWidth: true
//                     }
                    Kirigami.Heading {
                        id: restaurantNameLabel
                        Layout.fillWidth: true
                        text: modelData.text
                        level: 2
                        wrapMode: Text.WordWrap
                    }
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 10
                    }
                }
            }
        }
    }
}

