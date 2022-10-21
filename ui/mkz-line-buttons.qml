import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.12
import QtQml.Models 2.12
import org.kde.kirigami 2.4 as Kirigami
import Mycroft 1.0 as Mycroft

// Mycroft.ScrollableDelegate {
Mycroft.Delegate {
    id: actionFrame
    anchors.fill: parent
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
//     leftPadding: Kirigami.Units.gridUnit * 2.5
//     rightPadding: Kirigami.Units.gridUnit * 4
//     topPadding: Kirigami.Units.gridUnit * 2.5
//     bottomPadding: Kirigami.Units.gridUnit * 2.5
    skillBackgroundSource: Qt.resolvedUrl(sessionData.background)
//     skillBackgroundSource: Qt.resolvedUrl("../images/mkz_background_stage_day.png")
//     skillBackgroundColorOverlay: "#40800080"

    property var actionsModel: sessionData.actionsList
    property var datetime: sessionData.datetime

//     Image {
//         id: background
//         z: -10
//         source: "../images/mkz_background_stage_day.png"
//         anchors.top: parent.top
//         anchors.bottom: parent.bottom
//         anchors.left: parent.left
//         anchors.right: parent.right
//         opacity: 0.75
//     }

    Image {
        id: foreground
        z: 10
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
//         opacity: 0.9
        source: Qt.resolvedUrl("../images/MKZ-background-frame-day.png")
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            verticalOffset: -6
            radius: 10
            samples: 21
            color: "#80000000"
        }
    }

    Text {
        id: dtime
//         anchors.left: parent.left
//         anchors.top: parent.top
        x: 20
        y: 20
        z: 20
        font.pixelSize: 30
//         text: datetime
        text: "5:23pm    Thu Oct 20    90°F"
        opacity: 0.8
    }

    Component {
        id: actionDelegate
        Item {
            width: view.cellWidth
            height: view.cellHeight
            z: 1
            anchors.top: parent.verticalCenter
            visible: false
            Rectangle {
                id: button
                color: "#f0f0f0f0"
                signal clicked
                width: parent.width-Kirigami.Units.gridUnit*2
                height: parent.height-Kirigami.Units.gridUnit
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 6
                    verticalOffset: 6
                    color: "#80000000"
                    radius: 10
                    samples: 21
                }
                Item {
                    id: actionSpacer1
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: Kirigami.Units.gridUnit * 4
                }
                Image {
                    id: actionIcon
                    anchors.top: actionSpacer1.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: model.image
                    height: Kirigami.Units.gridUnit * 4
                    fillMode: Image.PreserveAspectFit
                }
                Item {
                    id: actionSpacer2
                    anchors.top: actionIcon.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: Kirigami.Units.gridUnit
                }
                Kirigami.Heading {
                    id: actionsLabel
                    anchors.top: actionSpacer2.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
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
        anchors.bottom: parent.bottom
        width: parent.width*0.7
        height: parent.height*0.8
        model: actionsModel
        delegate: actionDelegate
        cellWidth: width/3
        cellHeight: height
        populate: Transition {
            id: dispTrans2
            SequentialAnimation {
                PauseAnimation {
                    duration: dispTrans2.ViewTransition.index * 1000
                }
                PropertyAction {
                    property: "visible"
                    value: true
                }
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 1000 }
//                 NumberAnimation { property: "y"; from: 1000; duration: 1000 }
            }
        }
    }
}

