import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.4 as Kirigami
import Mycroft 1.0 as Mycroft

// Mycroft.ScrollableDelegate {
Mycroft.Delegate {
    id: actionFrame
    anchors.fill: parent
    leftPadding: Kirigami.Units.gridUnit * 2.5
    rightPadding: Kirigami.Units.gridUnit * 4
    topPadding: Kirigami.Units.gridUnit * 2.5
//     bottomPadding: Kirigami.Units.gridUnit * 2.5
    skillBackgroundSource: Qt.resolvedUrl(sessionData.background)
//     skillBackgroundSource: Qt.resolvedUrl("../images/mkz_background_center_day.png")
//     skillBackgroundColorOverlay: "#40800080"
//     x: 0
//     y: 0
//     width: parent.width
//     height: parent.height

    property var actionsModel: sessionData.actionsList

    Image {
        id: background
        x: 0
        y: 0
        z: 10
        width: parent.width
        height: parent.height
        anchors.fill: parent
        source: Qt.resolvedUrl("../images/mkz_center_bottom_day.png")
    }

    Component {
        id: actionDelegate
        Item {
            width: view.cellWidth/2
            height: view.cellHeight
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle {
                id: button
                color: "#f1c0c3"
                radius: 20
                signal clicked
                width: parent.width-Kirigami.Units.gridUnit
                height: parent.height-Kirigami.Units.gridUnit
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 6
                    verticalOffset: 6
                    color: "#aa000000"
//                     opacity: 0.2
                }
                Item {
                    id: actionSpacer1
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: Kirigami.Units.gridUnit * 4
                }
                Image {
                    id: actionIcon
                    anchors.left: actionSpacer1.right
                    anchors.verticalCenter: parent.verticalCenter
                    source: model.image
                    width: Kirigami.Units.gridUnit * 4
                    fillMode: Image.PreserveAspectFit
                }
                Item {
                    id: actionSpacer2
                    anchors.left: actionIcon.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: Kirigami.Units.gridUnit
                }
                Kirigami.Heading {
                    id: actionsLabel
                    anchors.left: actionSpacer2.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: model.text
                    color: "#202020"
                    font.pixelSize: Kirigami.Units.gridUnit*3
                }
                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    onClicked: button.clicked()
                }
                onClicked: {
                    console.log("button clicked "+model.text)
                }
            }
        }
    }

    GridView {
        id: view
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.fill: parent
//         width: parent.width-Kirigami.Units.gridUnit*2
//         height: parent.height
        model: actionsModel
        delegate: actionDelegate
        cellWidth: width
//         cellHeight: height/2.6
        cellHeight: Kirigami.Units.gridUnit * 6
        add: Transition {
            id: dispTrans1
            SequentialAnimation {
                PauseAnimation {
                    duration: dispTrans1.ViewTransition.index * 1000
                }
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 1000 }
                NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 1000 }
//                 PathAnimation {
//                     duration: 1000
//                     path: Path {
//                         startX: 0; startY: 1000
//                         PathLine { x: 0; y: dispTrans1.ViewTransition.index * (Kirigami.Units.gridUnit * 6) }
//                     }
//                 }
            }
        }
//         populate: Transition {
//             id: dispTrans2
//             SequentialAnimation {
//                 PauseAnimation {
//                     duration: dispTrans2.ViewTransition.index * 100
//                 }
//                 NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
//                 NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
//             }
//         }

//         displaced: Transition {
//             NumberAnimation { properties: "x,y"; duration: 4000; easing.type: Easing.OutBounce }
//         }
    }
}

