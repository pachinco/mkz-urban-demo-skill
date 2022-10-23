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

    property bool uiHome: (sessionData.uiIdx===-1) ? true:false
    property bool uiConfig: (sessionData.uiIdx===0) ? true:false
    property bool uiMap: (sessionData.uiIdx===1) ? true:false
    property bool uiCar: (sessionData.uiIdx===2) ? true:false
    property bool uiMusic: (sessionData.uiIdx===3) ? true:false
    property bool uiContact: (sessionData.uiIdx===4) ? true:false

    Item {
        id: bgHome
        anchors.fill: parent
//         visible: uiHome
        state: (uiHome) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: mkzImage
                    x: parent.width*0.2
                    y: parent.height*0.2
                    height: parent.height*0.6
                    width: parent.width*0.6
                    opacity: 1
                }
                PropertyChanges {
                    target: mkzBackground
                    opacity: 1
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: mkzImage
                    x: parent.width*0.6
                    y: parent.height*0.3
                    width: parent.width*0.2
                    height: parent.height*0.2
                    opacity: 0
                }
                PropertyChanges {
                    target: mkzBackground
                    opacity: 0
                }
            }
        ]
        transitions: [
            Transition {
                from: "INACTIVE"
                to: "ACTIVE"
                SequentialAnimation {
                    PropertyAction {
                        target: bgHome
                        property: "visible"
                        value: true
                    }
                    NumberAnimation { target: mkzBackground; properties: "opacity"; duration: 500 }
                    NumberAnimation { target: mkzImage; properties: "opacity,x,y,width,height"; duration: 500 }
                }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                SequentialAnimation {
                    NumberAnimation { target: mkzBackground; properties: "opacity"; duration: 500 }
                    NumberAnimation { target: mkzImage; properties: "opacity,x,y,width,height"; duration: 500 }
                    PropertyAction {
                        target: bgHome
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
        Image {
            id: mkzBackground
            source: "../images/mkz_background_stage_day.png"
            anchors.fill: parent
            fillMode: Image.Image.PreserveAspectCrop
        }
        Image {
            id: mkzImage
            source: "../images/Lincoln-UPower.png"
            fillMode: Image.PreserveAspectFit
        }
    }

    Item {
        id: mapFrame
        anchors.fill: parent
//         visible: uiMap
        state: (uiMap) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: mapView
                    height: parent.height
                    width: parent.width
                    opacity: 1
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: mapView
                    height: parent.height*2
                    width: parent.width*2
                    opacity: 0
                }
            }
        ]
        transitions: [
            Transition {
                from: "INACTIVE"
                to: "ACTIVE"
                SequentialAnimation {
                    PropertyAction {
                        target: mapFrame
                        property: "visible"
                        value: true
                    }
                    NumberAnimation { target: mapView; properties: "opacity,width,height"; duration: 500 }
                }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                SequentialAnimation {
                    NumberAnimation { target: mapView; properties: "opacity"; duration: 500 }
                    PropertyAction {
                        target: mapFrame
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
        Plugin {
            id: mapPlugin
            name: "osm"
        }
        
        Map {
            id: mapView
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
//             height: parent.height
//             width: parent.width
            plugin: mapPlugin
            center: QtPositioning.coordinate(37.3963974,-122.035018) // UPower Sunnyvale
            zoomLevel: 20
            tilt: 60
        }
    }

    Item {
        id: topFrame
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: frameTop.height
        z: 10
        Image {
            id: frameTop
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
            opacity: 0.6
        }
//         Behavior on y { PropertyAnimation { from: -500; easing.type: Easing.InOutQuad; duration: 500 } }
    }

    Item {
        id: bottomFrame
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: frameBottom.height
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
        Component {
            id: menuDelegate
            Item {
                id: menuItem
                signal clicked
                width: menuIcons.cellWidth
                height: menuIcons.cellHeight
                anchors.bottom: parent.bottom
                Image {
                    id: menuIcon
                    z: 20
                    width: menuIcons.cellWidth*1.2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: menuItem.horizontalCenter
                    source: Qt.resolvedUrl(model.image)
                    fillMode: Image.PreserveAspectFit
                    opacity: (sessionData.uiIdx===model.idx) ? 1 : 0.2
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: menuItem.clicked()
                }
                onClicked: {
//                     console.log("menu clicked "+model.ui)
                    sessionData.uiIdx=(sessionData.uiIdx===model.idx) ? -1 : model.idx
                }
            }
        }
        GridView {
            id: menuIcons
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: frameBottom.width*0.303
            height: frameBottom.height*0.66
            model: sessionData.uiButtons
            currentIndex: sessionData.uiIdx
            delegate: menuDelegate
            cellWidth: width/5
            cellHeight: height
            highlightFollowsCurrentItem: true
//             highlight: Rectangle {
//                 id: menuMarker
//                 color: "#80800000"
//             }
//             Rectangle {
//                 anchors.fill: parent
//                 color: "#50505050"
//             }
        }
        Image {
            id: menuHighlight
            z: 25
            source: Qt.resolvedUrl("../images/SelectedMenuButtonGlow.png")
            anchors.verticalCenter: menuIcons.verticalCenter
            x: frameBottom.width*0.5+(sessionData.uiIdx-2)*(menuIcons.width*0.2)-width*0.5
            visible: sessionData.uiIdx>-1 ? true:false
            width: menuIcons.cellWidth*2.5
            height: menuIcons.height*1.55
            Behavior on x { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 500 } }
        }
//         Behavior on y { PropertyAnimation { from: 1000; easing.type: Easing.InOutQuad; duration: 500 } }
    }

    Item {
        id: carFrame
        anchors.fill: parent
//         visible: uiCar
        state: (uiCar) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: actionsView
                    height: parent.height*0.75
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: actionsView
                    height: 0
                }
            }
        ]
        transitions: [
            Transition {
                from: "INACTIVE"
                to: "ACTIVE"
                SequentialAnimation {
                    PropertyAction {
                        target: carFrame
                        property: "visible"
                        value: true
                    }
                    NumberAnimation { target: actionsView; property: "height"; duration: 500 }
                }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                SequentialAnimation {
                    NumberAnimation { target: actionsView; property: "height"; duration: 500 }
                    PropertyAction {
                        target: carFrame
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
        Component {
            id: actionDelegate
            Item {
                z: 1
                width: actionsView.cellWidth
                height: actionsView.cellHeight
                anchors.bottom: parent.bottom
                visible: false
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
                        source: Qt.resolvedUrl(model.image)
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
                        color: "#c0000000"
                        font.pointSize: Kirigami.Units.gridUnit*2
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
                id: dispTrans1
                SequentialAnimation {
                    PauseAnimation { duration: dispTrans1.ViewTransition.index * 200 }
                    PropertyAction { property: "visible"; value: true }
                    NumberAnimation { property: "height"; from: 0; to: parent.height*0.75; duration: 500 }
                }
            }
            populate: Transition {
                id: dispTrans2
                SequentialAnimation {
                    PauseAnimation { duration: dispTrans2.ViewTransition.index * 200 }
                    PropertyAction { property: "visible"; value: true }
                    NumberAnimation { property: "height"; from: 0; to: parent.height*0.75; duration: 500 }
                }
            }
        }
    }
}
