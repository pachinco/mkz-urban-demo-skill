import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft
import QtPositioning 5.12
import QtLocation 5.12
import Qt.labs.folderlistmodel 2.1
import QtMultimedia 5.0

Mycroft.Delegate {
    id: homescreen
//     skillBackgroundSource: Qt.resolvedUrl("../images/mkz_background_stage_day.png")
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

    property var carSpeed: 25
    property bool traffic: true
    property bool night: false
    property bool navigating: true
    property bool mapOn: false

//     property string maptiler_key: "nGqcqqyYOrE4VtKI6ftl"
//     property string mapboxToken: "pk.eyJ1IjoicGFjaGluY28iLCJhIjoiY2w5b2RkN2plMGZnMTNvcDg3ZmF0YWdkMSJ9.vzH21tcuxbMkqCKOIbGwkw"
//     property string mapboxToken_mkz: "sk.eyJ1IjoicGFjaGluY28iLCJhIjoiY2w5b21lazFxMGgyMDQwbXprcHZlYzRuZiJ9.zEfn2HsyB0VyMXS93xAcow"

    Image {
        id: uiStage
        anchors.fill: parent
        source: (night) ? "../images/mkz_background_night.png" : "../images/mkz_background_stage_day.png"
        fillMode: Image.Image.PreserveAspectCrop
        z: -10
        state: "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: uiStage
                    opacity: 1
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: uiStage
                    opacity: 0
                }
            }
        ]
        transitions: [
            Transition {
                from: "INACTIVE"
                to: "ACTIVE"
                NumberAnimation { target: uiStage; properties: "opacity"; duration: 3000 }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                NumberAnimation { target: uiStage; properties: "opacity"; duration: 500 }
            }
        ]
        Component.onCompleted: {
            uiStage.state = "ACTIVE"
        }
    }

    Item {
        id: bgHome
        anchors.fill: parent
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
                    target: uiStage
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
            }
        ]
        transitions: [
            Transition {
                from: "INACTIVE"
                to: "ACTIVE"
                SequentialAnimation {
                    PropertyAction {
                        target: homescreen
                        property: "mapOn"
                        value: false
                    }
                    PropertyAction {
                        target: bgHome
                        property: "visible"
                        value: true
                    }
                    ParallelAnimation {
                        NumberAnimation { target: uiStage; properties: "opacity"; duration: 500 }
                        NumberAnimation { target: mkzImage; properties: "opacity,x,y,width,height"; easing.type: Easing.OutQuad; duration: 500 }
                    }
                }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation { target: mkzImage; properties: "opacity,x,y,width,height"; easing.type: Easing.InQuad; duration: 500 }
                    }
                    PropertyAction {
                        target: bgHome
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
        Image {
            id: mkzImage
            source: "../images/Lincoln-UPower.png"
            fillMode: Image.PreserveAspectFit
            mipmap: true
            z: -8
            ColorOverlay {
                anchors.fill: mkzImage
                source: mkzImage
                color: (night) ? "#40000000" : "#00000000"
            }
        }
    }

    Item {
        id: mapFrame
        anchors.fill: parent
        z: -5
        state: ((sessionData.uiIdx===1) || mapOn) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: map
                    opacity: 1
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: map
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
                        target: homescreen
                        property: "mapOn"
                        value: true
                    }
                    PropertyAction {
                        target: mapFrame
                        property: "visible"
                        value: true
                    }
                    NumberAnimation { target: map; properties: "opacity"; duration: 500 }
                }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                SequentialAnimation {
                    NumberAnimation { target: map; properties: "opacity"; duration: 500 }
                    PropertyAction {
                        target: mapFrame
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
        Map {
            id: map
            anchors.fill: parent
            states: [
                State {
                    name: ""
                    PropertyChanges { target: map; tilt: 0; bearing: 0; zoomLevel: map.zoomLevel }
                },
                State {
                    name: "navigating"
                    PropertyChanges { target: map; tilt: 60; zoomLevel: 17 }
                }
            ]

            transitions: [
                Transition {
                    to: "*"
                    RotationAnimation { target: map; property: "bearing"; duration: 100; direction: RotationAnimation.Shortest }
                    NumberAnimation { target: map; property: "zoomLevel"; duration: 100 }
                    NumberAnimation { target: map; property: "tilt"; duration: 100 }
                }
            ]

            state: navigating ? "navigating" : ""

            plugin: Plugin {
                name: "mapboxgl"
                PluginParameter {
                    name: "mapboxgl.access_token"
                    value: "pk.eyJ1IjoicGFjaGluY28iLCJhIjoiY2w5b2RkN2plMGZnMTNvcDg3ZmF0YWdkMSJ9.vzH21tcuxbMkqCKOIbGwkw"
                }
                PluginParameter {
                    name: "mapboxgl.mapping.additional_style_urls"
                    value: "mapbox://styles/mapbox/navigation-guidance-day-v2,mapbox://styles/mapbox/navigation-guidance-night-v2,mapbox://styles/mapbox/navigation-preview-day-v2,mapbox://styles/mapbox/navigation-preview-night-v2,mapbox://styles/pachinco/cl9olfi4i000514nzmcj6b8os"
                }
                PluginParameter {
                    name: "mapboxgl.mapping.items.insert_before"
                    value: "road-label-small"
                }
            }
            center: QtPositioning.coordinate(37.3963974,-122.034) // UPower Sunnyvale
//             zoomLevel: 3
//             tilt: 60

            activeMapType: {
                var style;
                if (navigating) {
                    style = night ? supportedMapTypes[1] : supportedMapTypes[0];
                } else {
                    style = night ? supportedMapTypes[3] : supportedMapTypes[2];
                }
                return style;
            }

            MapParameter {
                type: "layer"
                property var name: "3d-buildings"
                property var source: "composite"
                property var sourceLayer: "building"
                property var layerType: "fill-extrusion"
                property var minzoom: 15.0
            }
            MapParameter {
                type: "filter"
                property var layer: "3d-buildings"
                property var filter: [ "==", "extrude", "true" ]
            }
            MapParameter {
                type: "paint"
                property var layer: "3d-buildings"
                property var fillExtrusionColor: "#00617f"
                property var fillExtrusionOpacity: 0.5
                property var fillExtrusionHeight: { return { type: "identity", property: "height" } }
                property var fillExtrusionBase: { return { type: "identity", property: "min_height" } }
            }

//             Component.onCompleted: {
//                 for (let i=0; i<map.supportedMapTypes.length; i++) {
//                     for (let x in map.supportedMapTypes[i]) {
//                         console.log('maptypes['+i+'].'+x+": "+map.supportedMapTypes[i][x])
//                         if (x === "metadata") {
//                             for (let y in map.supportedMapTypes[i][x]) {
//                                 console.log('maptypes['+i+'].'+x+"."+y+": "+map.supportedMapTypes[i][x][y])
//                             }
//                         }
//                     }
//                 }
//             }

            Location {
                id: previousLocation
                coordinate: QtPositioning.coordinate(0, 0)
            }

//             RotationAnimation on bearing {
//                 id: bearingAnimation
//                 duration: 250
//                 alwaysRunToEnd: false
//                 direction: RotationAnimation.Shortest
//             }
//             onCenterChanged: {
//                 if (previousLocation.coordinate == center) return
// 
//                 bearingAnimation.to = previousLocation.coordinate.azimuthTo(center)
//                 bearingAnimation.start()
//                 
//                 previousLocation.coordinate = center
//             }

            function updateRoute() {
                routeQuery.clearWaypoints();
//                 console.log("start: "+startMarker.coordinate+" / end: "+endMarker.coordinate);
                routeQuery.addWaypoint(startMarker.coordinate);
//                 routeQuery.addWaypoint(carMarker.coordinate);
                routeQuery.addWaypoint(endMarker.coordinate);
            }
            
            MapQuickItem {
                id: carMarker
                sourceItem: Image {
                    id: dotMarker
                    source: "../images/car-marker.png"
                    height: 50
                    fillMode: Image.PreserveAspectFit
                    opacity: 1.0
                }
                coordinate: QtPositioning.coordinate(37.3964,-122.034)
                anchorPoint.x: dotMarker.width/2
                anchorPoint.y: dotMarker.height/2
                zoomLevel: 17
                MouseArea  {
                    drag.target: parent
                    anchors.fill: parent
                }

                onCoordinateChanged: {
                    map.updateRoute();
                }
            }
            MapQuickItem {
                id: startMarker
                sourceItem: Image {
                    id: greenMarker
                    source: "../images/Map_marker_blue.png"
                    height: 50
                    fillMode: Image.PreserveAspectFit
                    opacity: 1.0
                }
                coordinate: QtPositioning.coordinate(37.3964,-122.034)
                anchorPoint.x: greenMarker.width/2
                anchorPoint.y: greenMarker.height
                MouseArea  {
                    drag.target: parent
                    anchors.fill: parent
                }
                onCoordinateChanged: {
                    map.updateRoute();
                }
            }
            MapQuickItem {
                id: endMarker

                sourceItem: Image {
                    id: redMarker
                    source: "../images/Map_marker_pink.png"
                    height: 50
                    fillMode: Image.PreserveAspectFit
                    opacity: 1.0
                }
                coordinate : QtPositioning.coordinate(37.4,-122.03)
                anchorPoint.x: redMarker.width / 2
                anchorPoint.y: redMarker.height
                MouseArea  {
                    drag.target: parent
                    anchors.fill: parent
                }
                onCoordinateChanged: {
                    map.updateRoute();
                }
            }
            MapItemView {
                model: routeModel

                delegate: MapRoute {
                    route: routeData
                    line.color: "#f92469"
                    line.width: 15
                    opacity: (index == 0) ? 1.0 : 0.3
                }
            }
        }
    }
    RouteModel {
        id: routeModel

        autoUpdate: true
        query: routeQuery

        plugin: Plugin {
            name: "mapbox"

            PluginParameter {
                name: "mapbox.access_token"
                value: "pk.eyJ1IjoicXRzZGsiLCJhIjoiY2l5azV5MHh5MDAwdTMybzBybjUzZnhxYSJ9.9rfbeqPjX2BusLRDXHCOBA"
            }
        }

        Component.onCompleted: {
            if (map) {
                map.updateRoute();
            }
        }
    }

    RouteQuery {
        id: routeQuery
    }

    Item {
        id: topFrame
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: frameTop.height
        z: 10
        state: (sessionData.uiIdx>-2) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: frameTop
                    y: 0
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: frameTop
                    y: -frameTop.height
                }
            }
        ]
        transitions: [
            Transition {
                from: "INACTIVE"
                to: "ACTIVE"
                NumberAnimation { target: frameTop; properties: "y"; duration: 500 }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                NumberAnimation { target: frameTop; properties: "y"; duration: 500 }
            }
        ]
        Image {
            id: frameTop
            y: 0
            anchors.left: parent.left
            anchors.right: parent.right
            source: (night) ? "../images/mkz_frame_top_night.png" : "../images/mkz_frame_top_day.png"
            fillMode: Image.PreserveAspectFit
            Item {
                id: lSpacer1
                anchors.left: frameTop.left
                anchors.bottom: frameTop.verticalCenter
                width: 20
            }
            Text {
                id: lTime
                anchors.left: lSpacer1.right
                anchors.bottom: frameTop.verticalCenter
                color: (night) ? "#a9cac9" : "#000000"
                font.pixelSize: 28
                font.capitalization: Font.SmallCaps
                font.bold: true
                text: sessionData.datetime.substring(0,5)
                opacity: (night) ? 1 : 0.6
            }
            Text {
                id: lAmpm
                anchors.left: lTime.right
                anchors.bottom: frameTop.verticalCenter
                color: (night) ? "#a9cac9" : "#000000"
                font.pixelSize: 28
                font.capitalization: Font.SmallCaps
                font.bold: false
                font.weight: Font.Thin
                text: sessionData.datetime.substring(5,7)
                opacity: (night) ? 1 : 0.6
            }
            Item {
                id: lSpacer2
                anchors.left: lAmpm.right
                anchors.bottom: frameTop.verticalCenter
                width: 20
            }
            Text {
                id: lDay
                anchors.left: lSpacer2.right
                anchors.bottom: frameTop.verticalCenter
                color: (night) ? "#a9cac9" : "#000000"
                font.pixelSize: 28
                font.capitalization: Font.SmallCaps
                font.bold: true
                text: sessionData.datetime.substring(8,11)
                opacity: (night) ? 1 : 0.6
            }
            Item {
                id: lSpacer3
                anchors.left: lDay.right
                anchors.bottom: frameTop.verticalCenter
                width: 10
            }
            Text {
                id: lDate
                anchors.left: lSpacer3.right
                anchors.bottom: frameTop.verticalCenter
                color: (night) ? "#a9cac9" : "#000000"
                font.pixelSize: 28
                font.capitalization: Font.SmallCaps
                font.bold: false
                font.weight: Font.Thin
                text: sessionData.datetime.substring(12)
                opacity: (night) ? 1 : 0.6
            }

            Item {
                id: rSpacer1
                anchors.right: frameTop.right
                anchors.bottom: frameTop.verticalCenter
                width: 10
            }
            Image {
                id: dayNightIcon
                signal clicked
                anchors.right: rSpacer1.left
                y: 12
//                 anchors.bottom: frameTop.verticalCenter
                source: (night) ? "../images/moon-night.svg" : "../images/sun-solid.svg"
                height: 28
                opacity: (night) ? 1 : 0.6
//                 color: (night) ? "#a9cac9" : "#000000"
                mipmap: true
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: dayNightIcon.clicked()
                }
                onClicked: {
                    night = (night) ? false : true
                }
            }

            Item {
                id: musicTopview
                anchors.horizontalCenter: frameTop.horizontalCenter
                anchors.top: frameTop.top
                width: topFrame.width*0.4
                height: topFrame.height
                z: 15
                visible: (player.source!="")
                Item {
                    id: musicTopProgress
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: Kirigami.Units.gridUnit*1.5
    //                 anchors.leftMargin: Kirigami.Units.gridUnit
    //                 anchors.rightMargin: Kirigami.Units.gridUnit
                    width: parent.width*0.6
                    height: 10
                    Rectangle {
                        anchors.fill: parent
                        color: "#40000000"
                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.width*player.position/player.duration
                            color: "#de6e2a"
                        }
                    }
                }
                Text {
                    id: musicTopCurrent
                    anchors.right: musicTopProgress.left
                    anchors.verticalCenter: musicTopProgress.verticalCenter
                    anchors.rightMargin: 5
                    text: playLogic.msToTime(player.position)
    //                                 font.family: appFont.name
                    color: (night) ? "#e8fffc" : "#c0000000"
                    font.pointSize: 14
                }
                Text {
                    id: musicTopTotal
                    anchors.left: musicTopProgress.right
                    anchors.verticalCenter: musicTopProgress.verticalCenter
                    anchors.leftMargin: 5
                    text: "-"+playLogic.msToTime(player.duration-player.position)
    //                                 font.family: appFont.name
                    color: (night) ? "#e8fffc" : "#c0000000"
                    font.pointSize: 14
                }
                Text {
                    id: musicTopTitle
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: musicTopProgress.bottom
                    text: player.metaData.title ? player.metaData.title : ""
                    color: (night) ? "#e8fffc" : "#c0000000"
    //                                         font.family: appFont.name
                    font.capitalization: Font.SmallCaps
                    font.weight: Font.Thin
                    font.pointSize: 20
                    font.bold: false
    //                         style: Text.Raised
    //                         styleColor: "#80000000"
                    wrapMode: Text.Wrap
                }
            }
        }
    }

    Item {
        id: bottomFrame
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: frameBottom.height
        z: 20
        state: (sessionData.uiIdx>-2) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: frameBottom
                    y: bottomFrame.height-frameBottom.height
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: frameBottom
                    y: bottomFrame.height
                }
            }
        ]
        transitions: [
            Transition {
                from: "INACTIVE"
                to: "ACTIVE"
                NumberAnimation { target: frameBottom; properties: "y"; duration: 500 }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                NumberAnimation { target: frameBottom; properties: "y"; duration: 500 }
            }
        ]
        Image {
            id: frameBottom
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
                        mipmap: true
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
                        if (sessionData.uiIdx===model.idx) {
                            sessionData.uiIdx = (mapOn && (model.idx!=1)) ? 1 : -1;
                        } else {
                            sessionData.uiIdx = model.idx
                        }
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
                Behavior on x { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 250 } }
            }
        }
    }

    Item {
        id: carFrame
        anchors.fill: parent
        state: (uiCar) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: actionsView
                    height: parent.height*0.75
                }
                PropertyChanges {
                    target: carBackshade
                    opacity: 0.5
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: actionsView
                    height: 0
                }
                PropertyChanges {
                    target: carBackshade
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
                        target: carFrame
                        property: "visible"
                        value: true
                    }
                    ParallelAnimation {
                        NumberAnimation { target: actionsView; properties: "height"; duration: 500 }
                        NumberAnimation { target: carBackshade; properties: "opacity"; duration: 500 }
                    }
                }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation { target: actionsView; properties: "height"; duration: 500 }
                        NumberAnimation { target: carBackshade; properties: "opacity"; duration: 500 }
                    }
                    PropertyAction {
                        target: carFrame
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
        Rectangle {
            id: carBackshade
            anchors.fill: parent
            z: -1
            color: "#000000"
        }
        Component {
            id: actionDelegate
            Item {
                z: 1
                width: actionsView.cellWidth
                height: actionsView.cellHeight
                anchors.bottom: parent.bottom
                visible: false
                Rectangle {
                    id: actionsButton
                    color: (night) ? "#ff1e373a" : "#f0f0f0f0"
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
                        mipmap: true
                        source: Qt.resolvedUrl(model.image)
                        height: Kirigami.Units.gridUnit * 5
                        fillMode: Image.PreserveAspectFit
                        ColorOverlay {
                            anchors.fill: actionIcon
                            source: actionIcon
                            color: (night) ? "#401e373a" : "#00000000"
                        }
                    }
                    Item {
                        id: actionSpacer2
                        anchors.top: actionIcon.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: Kirigami.Units.gridUnit
                    }
                    Text {
                        id: actionsLabel
                        anchors.top: actionSpacer2.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: model.text
                        color: (night) ? "#e8fffc" : "#c0000000"
                        font.pointSize: Kirigami.Units.gridUnit*2
                    }
                    MouseArea {
                        id: actionsMouse
                        anchors.fill: parent
                        onClicked: actionsButton.clicked()
                    }
                    onClicked: {
                        console.log("actions clicked "+model.text)
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
//             height: 0
            model: sessionData.actionsList
            delegate: actionDelegate
            cellWidth: width/3
            cellHeight: height
            add: Transition {
                id: actionsTrans1
                SequentialAnimation {
                    PauseAnimation { duration: actionsTrans1.ViewTransition.index * 200 }
                    PropertyAction { property: "visible"; value: true }
                    NumberAnimation { property: "height"; from: 0; to: parent.height*0.75; duration: 500 }
                }
            }
            populate: Transition {
                id: actionsTrans2
                SequentialAnimation {
                    PauseAnimation { duration: actionsTrans2.ViewTransition.index * 200 }
                    PropertyAction { property: "visible"; value: true }
                    NumberAnimation { property: "height"; from: 0; to: parent.height*0.75; duration: 500 }
                }
            }
        }
    }
    
    Item {
        id: statusFrame
        anchors.fill: parent
        state: (uiConfig) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: statusView
                    height: parent.height*0.75
                }
                PropertyChanges {
                    target: statusBackshade
                    opacity: 0.5
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: statusView
                    height: 0
                }
                PropertyChanges {
                    target: statusBackshade
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
                        target: statusView
                        property: "visible"
                        value: true
                    }
                    ParallelAnimation {
                        NumberAnimation { target: statusView; property: "height"; duration: 500 }
                        NumberAnimation { target: statusBackshade; properties: "opacity"; duration: 500 }
                    }
                }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation { target: statusView; property: "height"; duration: 500 }
                        NumberAnimation { target: statusBackshade; properties: "opacity"; duration: 500 }
                    }
                    PropertyAction {
                        target: statusView
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
        Rectangle {
            id: statusBackshade
            anchors.fill: parent
            z: -1
            color: "#000000"
        }
        Component {
            id: statusDelegate
            Item {
                z: 1
                width: statusView.cellWidth
                height: statusView.cellHeight
                Rectangle {
                    id: statusButton
                    color: (night) ? "#ff1e373a" : "#f0f0f0f0"
                    signal clicked
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width-Kirigami.Units.gridUnit*4
                    height: parent.height
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
                        id: statusSpacer1
                        anchors.left: statusButton.left
                        anchors.verticalCenter: statusButton.verticalCenter
                        width: Kirigami.Units.gridUnit
                    }
                    Text {
                        id: statusLabel
                        anchors.left: statusSpacer1.right
                        anchors.verticalCenter: statusButton.verticalCenter
                        text: model.text
                        color: (model.text.substring(model.text.length-1)==="✓") ? ((night) ? "#e8fffc" : "#c0000000") : "#c0f00000"
                        font.bold: (model.text.substring(model.text.length-1)==="✓") ? false : true
                        font.pointSize: Kirigami.Units.gridUnit
                    }
                    MouseArea {
                        id: statusMouse
                        anchors.fill: parent
                        onClicked: statusButton.clicked()
                    }
                    onClicked: {
                        console.log("status clicked "+model.text)
                    }
                }
            }
        }
        GridView {
            id: statusView
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: parent.width*0.5
//             height: parent.height*0.75
            model: sessionData.statusList
            delegate: statusDelegate
            cellWidth: width
            cellHeight: height/8
        }
    }

    MediaPlayer {
        id: player
    }

    Item {
        id: playLogic

        property int index: -1
        property MediaPlayer mediaPlayer: player
        property FolderListModel items: FolderListModel {
            folder: Qt.resolvedUrl("../music")
            nameFilters: ["*.mp3"]
        }

        function init(){
            if(mediaPlayer.playbackState===1){
                mediaPlayer.pause();
            }else if(mediaPlayer.playbackState===2){
                mediaPlayer.play();
            }else{
                setIndex(0);
            }
        }

        function setIndex(i)
        {
            index = i;

            if (index < 0 || index >= items.count)
            {
                index = -1;
                mediaPlayer.source = "";
            }
            else{
                mediaPlayer.source = items.get(index,"filePath");
                mediaPlayer.play();
            }
        }

        function next(){
            setIndex(index + 1);
        }

        function previous(){
            setIndex(index - 1);
        }

        function msToTime(duration) {
            var seconds = parseInt((duration/1000)%60);
            var minutes = parseInt((duration/(1000*60))%60);

            minutes = (minutes < 10) ? "0" + minutes : minutes;
            seconds = (seconds < 10) ? "0" + seconds : seconds;

            return minutes + ":" + seconds;
        }
    }

    Item {
        id: musicFrame
        anchors.fill: parent
        z: 15
        state: (uiMusic) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: musicTopview
                    opacity: 0
                }
                PropertyChanges {
                    target: musicView
                    opacity: 1
                }
                PropertyChanges {
                    target: musicView
                    height: parent.height*0.9
                }
                PropertyChanges {
                    target: musicBackshade
                    opacity: 0.5
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: musicTopview
                    opacity: 1
                }
                PropertyChanges {
                    target: musicView
                    opacity: 0
                }
                PropertyChanges {
                    target: musicView
                    height: 0
                }
                PropertyChanges {
                    target: musicBackshade
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
                        target: musicFrame
                        property: "visible"
                        value: true
                    }
                    ParallelAnimation {
                        NumberAnimation { target: musicView; properties: "opacity, height"; duration: 500 }
                        NumberAnimation { target: musicTopview; properties: "opacity"; duration: 500 }
                        NumberAnimation { target: musicBackshade; properties: "opacity"; duration: 500 }
                    }
                }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation { target: musicView; properties: "opacity, height"; duration: 500 }
                        NumberAnimation { target: musicTopview; properties: "opacity"; duration: 500 }
                        NumberAnimation { target: musicBackshade; properties: "opacity"; duration: 500 }
                    }
                    PropertyAction {
                        target: musicFrame
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
        Rectangle {
            id: musicBackshade
            anchors.fill: parent
            z: -1
            color: "#000000"
        }

        Connections {
            target: playLogic.mediaPlayer

            onPaused: {
                playPause.source = "../images/play.png";
            }

            onPlaying: {
                playPause.source = "../images/pause.png";
            }

            onStopped: {
                playPause.source = "../images/play.png";
                if (playLogic.mediaPlayer.status == MediaPlayer.EndOfMedia)
                    playLogic.next();
            }

            onError: {
                console.log(error+" error string is "+errorString);
            }

            onMediaObjectChanged: {
                if (playLogic.mediaPlayer.mediaObject)
                    playLogic.mediaPlayer.mediaObject.notifyInterval = 50;
            }
        }

//         FontLoader {
//             id: appFont
//             name: "OpenSans-Regular"
//             source: "fonts/OpenSans-Regular.ttf"
//         }

        Rectangle {
            id: musicView
            color: (night) ? "#ff1e373a" : "#f0f0f0f0"
            width: parent.width*0.4
//             height: parent.height*0.75
            anchors.horizontalCenter: parent.horizontalCenter
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
            Item { // Artist picture + title/album
                id: artistWrapper
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Kirigami.Units.gridUnit
                height: topLeftWrapper.height

                Rectangle { // Artist picture
                    id: topLeftWrapper
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    height: 150
                    width: 150
//                     radius: 7

                    BorderImage {
                        id: coverBorder
                        source: "../images/cover_overlay.png"
                        anchors.fill: parent
                        anchors.margins: 4
                        border { left: 10; top: 10; right: 10; bottom: 10 }
                        horizontalTileMode: BorderImage.Stretch
                        verticalTileMode: BorderImage.Stretch

                        Image {
                            id: coverPic
                            source: player.metaData.coverArtUrlLarge ? player.metaData.coverArtUrlLarge : "../images/cover.png"
                            anchors.fill: coverBorder
                            anchors.margins: 2
                        }
                    }
                }
                Item { // title/album stack
                    id: titleAlbum
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: topLeftWrapper.right
                    anchors.right: parent.right
                    anchors.leftMargin: Kirigami.Units.gridUnit

                    Text {
                        id: trackAlbum
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        text: player.metaData.albumTitle ? player.metaData.albumTitle : ""
                        color: (night) ? "#e8fffc" : "#c0000000"
//                                         font.family: appFont.name
                        font.capitalization: Font.SmallCaps
                        font.pointSize: 20
                        font.bold: false
                        font.weight: Font.Thin
//                         style: Text.Raised
//                         styleColor: "#80000000"
                        wrapMode: Text.Wrap
                    }
                    Text {
                        id: trackTitle
                        anchors.left: parent.left
                        anchors.bottom: trackAlbum.top
                        anchors.right: parent.right
                        text: player.metaData.title ? player.metaData.title : ""
                        color: (night) ? "#e8fffc" : "#c0000000"
//                                         font.family: appFont.name
                        font.capitalization: Font.SmallCaps
                        font.pointSize: 20
                        font.bold: true
//                         style: Text.Raised
//                         styleColor: "#80000000"
                        wrapMode: Text.Wrap
                    }
                    Text {
                        id: trackArtist
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.right: parent.right
                        text: player.metaData.albumArtist ? player.metaData.albumArtist : ""
                        color: (night) ? "#e8fffc" : "#c0000000"
//                                         font.family: appFont.name
                        font.pointSize: 24
                        font.bold: false
                        font.capitalization: Font.SmallCaps
                        font.weight: Font.Thin
//                         style: Text.Raised
//                         styleColor: "#80000000"
                        wrapMode: Text.Wrap
                    }
                }
            }
            Item {
                id: musicProgress
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: artistWrapper.bottom
                anchors.topMargin: Kirigami.Units.gridUnit*2
                anchors.leftMargin: Kirigami.Units.gridUnit
                anchors.rightMargin: Kirigami.Units.gridUnit
                height: 8
                Rectangle {
                    anchors.fill: parent
                    color: "#40000000"
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width*player.position/player.duration
                        color: "#de6e2a"
                    }
                }
            }

            Item { // music time
                id: timeWrap
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: musicProgress.bottom
//                 anchors.topMargin: musicProgress.height
//                 anchors.margins: Kirigami.Units.gridUnit
                anchors.leftMargin: Kirigami.Units.gridUnit
                anchors.rightMargin: Kirigami.Units.gridUnit
                height: currentTime.height

                Text {
                    id: currentTime
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 1
                    text: playLogic.msToTime(player.position)
//                                 font.family: appFont.name
                    color: (night) ? "#e8fffc" : "#c0000000"
                    font.pointSize: 14
                }

                Text {
                    id: totalTime
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 1
                    text: "-"+playLogic.msToTime(player.duration-player.position)
//                                 font.family: appFont.name
                    color: (night) ? "#e8fffc" : "#c0000000"
                    font.pointSize: 14
                }
            }

            Item { // music controls
                id: buttonWrapper
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: timeWrap.bottom
                anchors.topMargin: Kirigami.Units.gridUnit*2
                anchors.leftMargin: parent.width*0.2
                anchors.rightMargin: parent.width*0.2
                height: ppTrack.height

                Image {
                    id: prevTrack
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../images/rewind.png"
//                     ColorOverlay {
//                         anchors.fill: prevTrack
//                         source: prevTrack
//                         color: (night) ? "#401e373a" : "#40000000"
//                     }
                    state: "none"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: playLogic.previous()
                        onPressed: prevTrack.state = "pressed"
                        onReleased: prevTrack.state = "none"
                    }
                    states: State {
                        name: "pressed"
                        when: mouseArea.pressed
                        PropertyChanges { target: prevTrack; scale: 0.8 }
                    }
                    transitions: Transition {
                        NumberAnimation { properties: "scale"; duration: 100; easing.type: Easing.InOutQuad }
                    }
                }

                Rectangle {
                    id: ppTrack
                    width: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image {
                        id: playPause
                        source: "../images/play.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
//                         ColorOverlay {
//                             anchors.fill: playPause
//                             source: playPause
//                             color: (night) ? "#401e373a" : "#40000000"
//                         }
                        state: "none"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: playLogic.init();
                            onPressed: playPause.state = "pressed"
                            onReleased: playPause.state = "none"
                        }
                        states: State {
                            name: "pressed"
                            when: mouseArea.pressed
                            PropertyChanges { target: playPause; scale: 0.8 }
                        }
                        transitions: Transition {
                            NumberAnimation { properties: "scale"; duration: 100; easing.type: Easing.InOutQuad }
                        }
                    }
                }

                Image {
                    id: nextTrack
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../images/forward.png"
//                     ColorOverlay {
//                         anchors.fill: nextTrack
//                         source: nextTrack
//                         color: (night) ? "#401e373a" : "#40000000"
//                     }
                    state: "none"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: playLogic.next()
                        onPressed: nextTrack.state = "pressed"
                        onReleased: nextTrack.state = "none"
                    }
                    states: State {
                        name: "pressed"
                        when: mouseArea.pressed
                        PropertyChanges { target: nextTrack; scale: 0.8 }
                    }
                    transitions: Transition {
                        NumberAnimation { properties: "scale"; duration: 100; easing.type: Easing.InOutQuad }
                    }
                }
            }
        }

    }
}
