import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

// Mycroft.Delegate{
//     anchors.fill: parent
// 
//     Image {
//         id: imageId
//         width: parent.width+20
//         height: parent.height+20
//         anchors.horizontalCenter: parent.horizontalCenter
//         anchors.verticalCenter: parent.verticalCenter
//         source: Qt.resolvedUrl("../images/mkz_background2.png")
//     }
// 
//     Rectangle {
//         id: settingsBox
//         width: parent.width/4
//         height: parent.height
//         anchors.top: parent.verticalCenter-100
//         x: parent.width*0.075
//         color: "#ff00ff"
//         opacity: 0.5
//         layer.enabled: true
//         radius: 20
// 
//         YAnimator {
//             target: settingsBox;
//             from: 800;
//             to: 100;
//             duration: 8000
//             running: true
//             easing {
//                 type: Easing.OutElastic
//                 amplitude: 0.5
//                 period: 0.5
//             }
//         }
//         Image {
//             width: settingsBox.width-20
//             opacity: 1.0
//             source: Qt.resolvedUrl("../images/settings-icon-10.png")
//             fillMode: Image.PreserveAspectCrop
//         }
//     }
// 
//     Rectangle {
//         id: drivingBox
//         width: parent.width/4
//         height: parent.height
//         anchors.top: parent.verticalCenter-100
//         x: parent.width*0.375
//         color: "#00ffff"
//         opacity: 0.5
//         layer.enabled: true
//         radius: 20
// 
//         YAnimator {
//             target: drivingBox;
//             from: 1000;
//             to: 100;
//             duration: 10000
//             running: true
//         }
//     }
//     Image {
//         width: drivingBox.width-20
//         anchors.top: drivingBox.top
//         anchors.horizontalCenter: drivingBox.horizontalCenter
//         opacity: 1.0
//         source: Qt.resolvedUrl("../images/settings-icon-10.png")
//         fillMode: Image.PreserveAspectCrop
//     }
// 
//     Rectangle {
//         id: statusBox
//         width: parent.width/4
//         height: parent.height
//         anchors.top: parent.verticalCenter-100
//         x: parent.width*0.675
//         color: "#ffff00"
//         opacity: 0.5
//         layer.enabled: true
//         radius: 20
// 
//         YAnimator {
//             target: statusBox;
//             from: 1200;
//             to: 100;
//             duration: 12000
//             running: true
//         }
//     }
//     Image {
//         width: statusBox.width-20
//         anchors.top: statusBox.top
//         anchors.horizontalCenter: statusBox.horizontalCenter
//         opacity: 1.0
//         source: Qt.resolvedUrl("../images/settings-icon-10.png")
//         fillMode: Image.PreserveAspectCrop
//     }
// }

Mycroft.ScrollableDelegate{
    id: actionsList
    skillBackgroundSource: Qt.resolvedUrl(sessionData.background)
    property var actionsModel: sessionData.actionsList

    Kirigami.CardsGridView {
        id: exampleListView
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: actionsModel.actions
        maximumColumns: 3
//         delegate: Kirigami.AbstractCard {
        delegate: Mycroft.CardDelegate {
            id: rootCard
            implicitHeight: delegateItem.implicitHeight + Kirigami.Units.largeSpacing
            leftPadding: 10
            rightPadding: 10
//             topPadding: 10
//             bottomPadding: 10
            contentItem: Item {
                implicitWidth: parent.implicitWidth
                implicitHeight: parent.implicitHeight
                ColumnLayout {
                    id: delegateItem
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    spacing: Kirigami.Units.largeSpacing
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                    }
                    Image {
                        id: placeImage
                        source: modelData.image
//                         Layout.fillWidth: true
//                         Layout.preferredHeight: Kirigami.Units.gridUnit * 11
//                         Layout.preferredWidth: Kirigami.Units.gridUnit * 8
//                         Layout.height: Kirigami.Units.gridUnit * 11
                        Layout.width: Kirigami.Units.gridUnit * 8
                        fillMode: Image.PreserveAspectCrop
                    }
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 1
                    }
                    Kirigami.Heading {
                        id: actionsLabel
                        Layout.fillWidth: true
                        text: modelData.text
                        level: 2
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: parent.width * 0.20
                    }
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 7
                    }
                }
            }
        }
    }
}

