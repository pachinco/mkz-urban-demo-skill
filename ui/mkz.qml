import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft
import QtPositioning 5.12
import QtLocation 5.12

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
    
    property var carSpeed: 35
    property var traffic: true
    property var night: true
    property var navigating: true

//     property string maptiler_key: "nGqcqqyYOrE4VtKI6ftl"
//     property string mapboxToken: "pk.eyJ1IjoicGFjaGluY28iLCJhIjoiY2w5b2RkN2plMGZnMTNvcDg3ZmF0YWdkMSJ9.vzH21tcuxbMkqCKOIbGwkw"
//     property string mapboxToken_mkz: "sk.eyJ1IjoicGFjaGluY28iLCJhIjoiY2w5b21lazFxMGgyMDQwbXprcHZlYzRuZiJ9.zEfn2HsyB0VyMXS93xAcow"

    Image {
        id: uiStage
        anchors.fill: parent
        source: "../images/mkz_background_stage_day.png"
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
            z: 1
        }
    }

    Item {
        id: mapFrame
        anchors.fill: parent
        visible: true
        state: (uiMap) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: map
                    height: parent.height
                    width: parent.width
                    opacity: 1
                }
                PropertyChanges {
                    target: uiStage
                    opacity: 0
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: map
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
                    ParallelAnimation {
                        NumberAnimation { target: uiStage; properties: "opacity"; duration: 500 }
                        NumberAnimation { target: map; properties: "opacity,width,height"; duration: 500 }
                    }
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
        // OSM
//         Plugin {
//             id: mapPlugin
//             name: "osm"
//             PluginParameter {
//                 name: "osm.mapping.highdpi_tiles"
//                 value: "true"
//             }
//             PluginParameter {
//                 name: "osm.mapping.providersrepository.disabled"
//                 value: "true"
//             }
//             PluginParameter
//             {
//                 name: "osm.mapping.custom.host"
//                 value: "https://api.maptiler.com/maps/winter/%z/%x/%y.png?key=nGqcqqyYOrE4VtKI6ftl"
//                 value: "https://stamen-tiles.a.ssl.fastly.net/watercolor/"
//                 value: "https://stamen-tiles.a.ssl.fastly.net/toner/"
//             }
//         }
        // mapbox
//         Plugin {
//             id: mapPlugin
//             name: "mapbox"
//             PluginParameter {
//                 name: "mapbox.access_token";
//                 value: mapboxToken_mkz
//             }
//             PluginParameter {
//                 name: "mapbox.mapping.highdpi_tiles"
//                 value: "true"
//             }
//             PluginParameter {
//                 name: "mapbox.api_base_url"
//                 value: "https://api.mapbox.com/styles/v1"
//             }
//             PluginParameter {
//                 name: "mapbox.mapping.api_base_url"
//                 value: "https://api.mapbox.com/styles/v1"
//             }
//             PluginParameter {
//                 name: "mapbox.mapping.additional_map_ids"
//                 name: "mapbox.mapping.map_id"
//                 value: "pachinco/cl9olfi4i000514nzmcj6b8os/tiles"
//            }
//         }
        // mapboxgl
//         Plugin

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
                    PropertyChanges { target: map; tilt: 60; zoomLevel: 20 }
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
//                 PluginParameter {
//                     name: "antialias"
//                     value: "true"
//                 }
    //             PluginParameter {
    //                 name: "mapboxgl.api_base_url"
    //                 value: "https://api.mapbox.com"
    //             }
//                 PluginParameter {
//                     name: "mapboxgl.mapping.use_fbo"
//                     value: "false"
//                 }
                PluginParameter {
                    name: "mapboxgl.mapping.additional_style_urls"
//                     value: "mapbox://styles/pachinco/cl9olfi4i000514nzmcj6b8os"
                    value: "mapbox://styles/mapbox/navigation-guidance-day-v2,mapbox://styles/mapbox/navigation-guidance-night-v2,mapbox://styles/mapbox/navigation-preview-day-v2,mapbox://styles/mapbox/navigation-preview-night-v2"
//                     value: "mapbox://styles/mapbox/light-v10"
//                     value: "mapbox://styles/examples/cj68bstx01a3r2rndlud0pwpv"
    //                 value: "https://api.maptiler.com/styles/streets/style.json?key=nGqcqqyYOrE4VtKI6ftl"
                }
                PluginParameter {
                    name: "mapboxgl.mapping.items.insert_before"
                    value: "road-label-small"
                }
            }
            center: QtPositioning.coordinate(37.3963974,-122.035018) // UPower Sunnyvale
//             center: QtPositioning.coordinate(37.777,-122.419) // SF Van Ness Ave
            zoomLevel: 20
            tilt: 60
//             activeMapType: supportedMapTypes[supportedMapTypes.length-1]
//             activeMapType: supportedMapTypes[0]
//             activeMapType: supportedMapTypes[10]
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

            Component.onCompleted: {
//                 console.log("Map loaded. "+mapView.supportedMapTypes.length)
//                 addMarker(QtPositioning.coordinate(37.3963974,-122.035018))
                for (let i=0; i<map.supportedMapTypes.length; i++) {
                    for (let x in map.supportedMapTypes[i]) {
                        console.log('maptypes['+i+'].'+x+": "+map.supportedMapTypes[i][x])
                        if (x === "metadata") {
                            for (let y in map.supportedMapTypes[i][x]) {
                                console.log('maptypes['+i+'].'+x+"."+y+": "+map.supportedMapTypes[i][x][y])
                            }
                        }
                    }
                }
            }

//             center: map.center

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
                routeQuery.addWaypoint(startMarker.coordinate);
                routeQuery.addWaypoint(endMarker.coordinate);
            }
            
            MapQuickItem {
                id: startMarker
                sourceItem: Image {
                    id: greenMarker
                    source: Qt.resolvedUrl("../images/Map_pin_green.png")
                    height: 50
                    fillMode: Image.PreserveAspectFit
                    opacity: 1.0
                }
                coordinate: QtPositioning.coordinate(37.3963974,-122.035018)
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
                    source: Qt.resolvedUrl("../images/Map_pin_red.png")
                    height: 50
                    fillMode: Image.PreserveAspectFit
                    opacity: 1.0
                }

                coordinate : QtPositioning.coordinate(37.4,-122.04)
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
//                     line.color: "#e9c396"
                    line.color: "#da3373"
                    line.width: 20
                    opacity: (index == 0) ? 1.0 : 0.3
                }
            }
//             MapCircle {
//                 id: mapCircle
//                 center: QtPositioning.coordinate(37.3963974,-122.035018)
//                 radius: 200000
//                 border.width: 5
//                 z: 7
// 
//                 MouseArea {
//                     anchors.fill: parent
//                     drag.target: parent
//                 }
//             }
        }
    }
    RouteModel {
        id: routeModel

        autoUpdate: true
        query: routeQuery

        plugin: Plugin {
            name: "mapbox"

            // Development access token, do not use in production.
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
//             anchors.top: parent.top
            y: 0
            anchors.left: parent.left
            anchors.right: parent.right
            source: Qt.resolvedUrl("../images/mkz_frame_top_day.png")
            fillMode: Image.PreserveAspectFit
            Text {
                id: dtime
                x: 20
                y: 20
                z: 20
                font.pixelSize: 30
                text: sessionData.datetime
                opacity: 0.6
            }
        }
    }

    Item {
        id: bottomFrame
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: frameBottom.height
        z: 10
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
                Behavior on x { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 250 } }
            }
        }
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
                PropertyChanges {
                    target: uiStage
                    opacity: 0.5
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
                    ParallelAnimation {
                        NumberAnimation { target: uiStage; properties: "opacity"; duration: 500 }
                        NumberAnimation { target: actionsView; property: "height"; duration: 500 }
                    }
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
                    id: actionsButton
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
        id: configFrame
        anchors.fill: parent
        state: (uiConfig) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: configView
                    height: parent.height*0.75
                }
                PropertyChanges {
                    target: uiStage
                    opacity: 0.5
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: configView
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
                        target: configView
                        property: "visible"
                        value: true
                    }
                    ParallelAnimation {
                        NumberAnimation { target: uiStage; properties: "opacity"; duration: 500 }
                        NumberAnimation { target: configView; property: "height"; duration: 500 }
                    }
                }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                SequentialAnimation {
                    NumberAnimation { target: configView; property: "height"; duration: 500 }
                    PropertyAction {
                        target: configView
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
        Component {
            id: configDelegate
            Item {
                z: 1
                width: configView.cellWidth
                height: configView.cellHeight
                Rectangle {
                    id: configButton
                    color: "#f0f0f0f0"
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
                        id: configSpacer1
                        anchors.left: configButton.left
                        anchors.verticalCenter: configButton.verticalCenter
                        width: Kirigami.Units.gridUnit
                    }
                    Kirigami.Heading {
                        id: configLabel
                        anchors.left: configSpacer1.right
                        anchors.verticalCenter: configButton.verticalCenter
                        text: model.text
                        color: (model.text.substring(model.text.length-1)==="✓") ? "#c0000000" : "#c0f00000"
                        font.pointSize: Kirigami.Units.gridUnit
                    }
                    MouseArea {
                        id: configMouse
                        anchors.fill: parent
                        onClicked: configButton.clicked()
                    }
                    onClicked: {
                        console.log("config clicked "+model.text)
                    }
                }
            }
        }
        GridView {
            id: configView
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: parent.width*0.5
            height: parent.height*0.75
            model: sessionData.configList
            delegate: configDelegate
            cellWidth: width
            cellHeight: height/8
        }
    }
}
