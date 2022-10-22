import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft
import QtPositioning 5.12
import QtLocation 5.12

Mycroft.Delegate {
    id: homescreen
    skillBackgroundSource: Qt.resolvedUrl("../images/mkz_background_stage_day.png")
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    anchors.fill: parent

    property bool uiHome: (sessionData.ui==="none") ? true:false
    property bool uiMap: (sessionData.ui==="map") ? true:false
    property bool uiCar: (sessionData.ui==="car") ? true:false
    property bool uiMusic: (sessionData.ui==="music") ? true:false
    property bool uiConfig: (sessionData.ui==="config") ? true:false
    property bool uiContact: (sessionData.ui==="contact") ? true:false
    property var buttons: sessionData.uiButtons

    Item {
        id: bgHome
        visible: uiHome
        anchors.fill: parent
        Image {
            source: "../images/mkz_background_stage_day.png"
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Image {
            id: mkzImage
            source: "../images/Lincoln-UPower.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height*0.6
            fillMode: Image.PreserveAspectFit
            SequentialAnimation {
                id: mkzAnimation
                running: true
                loops: Animation.Infinite
                PropertyAction {
                    property: "visible"
                    value: false
                }
                PauseAnimation {
                    duration: 1000
                }
                PropertyAction {
                    property: "visible"
                    value: true
                }
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 1000 }
//                 NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 1000 }
            }
        }
    }

    Item {
        id: mapView
        visible: uiMap
        anchors.fill: parent
        Plugin {
            id: mapPlugin
            name: "osm"
        }
        
        Map {
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(37.3963974,-122.035018) // UPower Sunnyvale
            zoomLevel: 20
            tilt: 60
        }
    }

    Item {
        id: topFrame
        anchors.fill: parent
        z: 10
        Image {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            source: Qt.resolvedUrl("../images/mkz_frame_top_day.png")
            fillMode: Image.PreserveAspectFit
        }
        Text {
            id: dtime
            x: 20
            y: 20
            z: 20
            font.pixelSize: 30
            text: sessionData.datetime
            opacity: 0.8
        }
    }

    Item {
        id: bottomFrame
        anchors.fill: parent
        z: 10
        Image {
            id: frameBottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            source: Qt.resolvedUrl("../images/mkz_frame_bottom_day.png")
            fillMode: Image.PreserveAspectFit
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                verticalOffset: -6
                radius: 10
                samples: 21
                color: "#80000000"
            }
        }
        Image {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            source: Qt.resolvedUrl("../images/LightningIcon.png")
        }
        Component {
            id: menuDelegate
            Item {
                z: 20
                Image {
                    id: menuIcon
                    anchors.bottom: parent.bottom
                    source: Qt.resolvedUrl(model.image)
    //                 fillMode: Image.PreserveAspectFit
                }
                Rectangle {
                    anchors.fill: parent
                    color: "green"
                }
            }
        }
        GridView {
            id: menuIcons
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: frameBottom.width*0.3
            height: frameBottom.height*0.8
            model: buttons
            delegate: menuDelegate
            cellWidth: parent.width/5
            cellHeight: parent.height
            Rectangle {
                anchors.fill: parent
                color: "#50505050"
            }
        }
    }

    Item {
        id: configFrame
        visible: uiConfig
        anchors.fill: parent
        Component {
            id: actionDelegate
            Item {
                z: 1
                width: actionsView.cellWidth
                height: actionsView.cellHeight
                anchors.bottom: parent.bottom
                visible: false
    //             opacity: 0
                Rectangle {
                    id: button
                    color: "#f0f0f0f0"
                    signal clicked
                    width: parent.width-Kirigami.Units.gridUnit*2
                    height: parent.height-Kirigami.Units.gridUnit
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.bottom: parent.bottom
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
                        height: Kirigami.Units.gridUnit * 3
                    }
                    Image {
                        id: actionIcon
                        anchors.top: actionSpacer1.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: model.image
                        height: Kirigami.Units.gridUnit * 5
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
                        font.pixelSize: Kirigami.Units.gridUnit*2
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
            id: actionsView
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: parent.width*0.7
            height: parent.height*0.75
            model: sessionData.actionsList
            delegate: actionDelegate
            cellWidth: width/3
            cellHeight: height
            add: Transition {
                id: dispTrans
                SequentialAnimation {
                    PauseAnimation { duration: dispTrans.ViewTransition.index * 200 }
                    PropertyAction { property: "visible"; value: true }
                    NumberAnimation { property: "height"; from: 0; to: parent.height*0.75; duration: 500 }
                }
            }
        }
    }

    Component.onCompleted: {
        mkzAnimation.running = true
    }
}
