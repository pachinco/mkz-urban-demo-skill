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

//     property coordinate carPos: QtPositioning.coordinate(0,0)
    property real carSpeed: sessionData.carSpeed
    property var carPosition: sessionData.carPosition
    property bool carDriving: sessionData.carDriving
    property bool modeAutonomous: sessionData.modeAutonomous
    property bool modeRoute: sessionData.modeRoute
    property bool modeMarker: sessionData.modeMarker
    property bool modeFollow: sessionData.modeFollow
    property bool modeNorth: sessionData.modeNorth
    property bool mode3D: sessionData.mode3D
    property bool modeTraffic: sessionData.modeTraffic
    property bool modeNight: sessionData.modeNight
    property bool carAnimate: true
    property real carAnimateTime: 1
    property real carAnimateSpeed: 1
    property bool mapOn: false
    property real carBearing: 0
    property int routeSegment: sessionData.routeSegment
    property int routePath: sessionData.routePath

//     property string maptiler_key: "nGqcqqyYOrE4VtKI6ftl"
//     property string mapboxToken: "pk.eyJ1IjoicGFjaGluY28iLCJhIjoiY2w5b2RkN2plMGZnMTNvcDg3ZmF0YWdkMSJ9.vzH21tcuxbMkqCKOIbGwkw"
//     property string mapboxToken_mkz: "sk.eyJ1IjoicGFjaGluY28iLCJhIjoiY2w5b21lazFxMGgyMDQwbXprcHZlYzRuZiJ9.zEfn2HsyB0VyMXS93xAcow"

    onModeAutonomousChanged: {
        sessionData.modeAutonomous = modeAutonomous;
    }
    onModeRouteChanged: {
        sessionData.modeRoute = modeRoute;
    }
    onModeMarkerChanged: {
        sessionData.modeMarker = modeMarker;
    }
    onModeFollowChanged: {
        sessionData.modeFollow = modeFollow;
    }
    onModeNorthChanged: {
        sessionData.modeNorth = modeNorth;
    }
    onMode3DChanged: {
        sessionData.mode3D = mode3D;
    }
    onModeTrafficChanged: {
        sessionData.modeTraffic = modeTraffic;
    }
    onModeNightChanged: {
        sessionData.modeFollow = modeNight;
    }
    onCarPositionChanged: {
        console.log("onCarPositionChanged: Lat="+carPosition.lat+" Lon="+carPosition.lon);
        carLocation.coordinate = QtPositioning.coordinate(carPosition.lat, carPosition.lon);
    }
    onRouteSegmentChanged: {
        sessionData.routeSegment = routeSegment;
        routeList.currentIndex = routeSegment;
        routeList.positionViewAtIndex(routeSegment, ListView.Beginning)
//         sessionGetManeuver(0, routeSegment);
//         triggerGuiEvent("mkz-urban-demo-skill.route_update", {"string": routeAdaptDriver(routeModel.get(0).segments[routeSegment].maneuver.instructionText)});
//         console.log("RouteModel onStatusChanged: "+routeAdaptDriver(routeModel.get(0).segments[routeSegment].maneuver.instructionText));
    }
    
    Image {
        id: uiStage
        anchors.fill: parent
        source: (modeNight) ? "../images/mkz_background_night.png" : "../images/mkz_background_stage_day.png"
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
                color: (modeNight) ? "#40000000" : "#00000000"
            }
        }
    }

    function carAnimateNextStep() {
        if (routeModel.status != RouteModel.Ready) return
        console.log("segment #"+routeSegment+"/",routeModel.get(0).segments.length);
        console.log("path #"+routePath+"/",routeModel.get(0).segments[routeSegment].path.length);
        if (routePath<routeModel.get(0).segments[routeSegment].path.length-1) {
            routePath = routePath+1;
        } else if (routeSegment<routeModel.get(0).segments.length-1) {
            routePath = 1;
            routeSegment = routeSegment+1;
        } else
            return
        var distance = routeModel.get(0).segments[routeSegment].distance;
        var time = routeModel.get(0).segments[routeSegment].travelTime;
        console.log("route "+routeSegment+"/"+routePath+" coordinate: "+routeModel.get(0).segments[routeSegment].path[routePath].latitude+","+routeModel.get(0).segments[routeSegment].path[routePath].longitude);
        carAnimateSpeed = distance/time;
//         console.log("carAnimateSpeed: ",carAnimateSpeed);
        carLocation.coordinate = routeModel.get(0).segments[routeSegment].path[routePath];
    }
    onCarAnimateChanged: {
        if (carAnimate)
            carAnimateNextStep(false);
    }


    Item {
        id: mapMap
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
                        target: mapMap
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
                        target: mapMap
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
        Map {
            id: map
            anchors.fill: parent

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
            center: modeFollow ? carLocation.coordinate : map.center
            bearing: modeNorth ? 0 : carBearing
            tilt: mode3D ? 60 : 0
            zoomLevel: 17
            
            Behavior on tilt {
                NumberAnimation { duration: 500 }
            }
            Behavior on bearing {
//                 enabled: (carAnimate) ? false : true
                RotationAnimation {
                    duration: 500
                    alwaysRunToEnd: false
                    direction: RotationAnimation.Shortest
                }
            }
            Behavior on center {
//                 enabled: (carAnimate) ? false : true
                CoordinateAnimation {
                    duration: 500
                    alwaysRunToEnd: false
                    easing.type: Easing.Linear
                }
            }
            onCenterChanged: {
                if (modeFollow && !carAnimate)
                    center = carLocation.coordinate
            }
//             center: QtPositioning.coordinate(37.3963974,-122.034) // UPower Sunnyvale
//             zoomLevel: 3
//             tilt: 60

            activeMapType: {
                var style;
                if (modeRoute) {
                    style = modeNight ? supportedMapTypes[1] : supportedMapTypes[0];
                } else {
                    style = modeNight ? supportedMapTypes[3] : supportedMapTypes[2];
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
            MouseArea {
                anchors.fill: parent

                onWheel: {
                    modeFollow = false
                    wheel.accepted = false
                }
            }

            gesture.onPanStarted: {
                modeFollow = false
            }

            gesture.onPinchStarted: {
                modeFollow = false
            }
            
            Location {
                id: oldLocation
                coordinate: QtPositioning.coordinate(0, 0)
            }
            Location {
                id: carLocation
                coordinate: QtPositioning.coordinate(37.3964,-122.034)
                onCoordinateChanged: {
//                     if (carMarkerAnimator.running) return
                    if (oldLocation.coordinate != carLocation.coordinate) {
                        carBearing = oldLocation.coordinate.azimuthTo(carLocation.coordinate);
                        var distance = oldLocation.coordinate.distanceTo(carLocation.coordinate);
                        carAnimateTime = distance*1000/carAnimateSpeed;
                        console.log("carAnimateTime: ",carAnimateTime);
                        oldLocation.coordinate = carLocation.coordinate;
                        carMarkerAnimator.start();
//                         if (carAnimate && modeFollow) map.center = carLocation.coordinate;
//                         if (carAnimate && !modeNorth) map.bearing = carBearing;
                    }
                }
//                 Behavior on coordinate {
//                     enabled: carAnimate
//                 }
            }
            CoordinateAnimation {
                id: carMarkerAnimator
                duration: (carAnimateTime>1) ? carAnimateTime : 1
                alwaysRunToEnd: true
                easing.type: Easing.Linear
                onRunningChanged: {
                    if (!carMarkerAnimator.running) {
                                console.log("carMarkerAnimator finished.");
                        carAnimateNextStep(false)
                    }
                }
            }

            function routeReset() {
                routeQuery.clearWaypoints();
                routeModel.reset();
            }

            function routeUpdate() {
                routeQuery.clearWaypoints();
                if (modeRoute) {
                    if (!carMarker.coordinate.isValid)
                        carMarker.coordinate = QtPositioning.coordinate(carPosition.lat, carPosition.lon);
                    console.log("routeUpdate start: "+carMarker.coordinate.latitude+","+carMarker.coordinate.longitude)
                    console.log("routeUpdate end: "+endMarker.coordinate.latitude+","+endMarker.coordinate.longitude)
//                 routeQuery.addWaypoint(startMarker.coordinate);
                    routeQuery.addWaypoint(carMarker.coordinate);
                    routeQuery.addWaypoint(endMarker.coordinate);
//                 console.log("routeModel.onCompleted: "+(routeReady?"ready":"not ready"));
                    routeList.currentIndex = 0;
                } else {
                    routeModel.reset();
                }
            }

//             RotationAnimation on bearing {
//                 id: bearingAnimation
//                 duration: 500
//                 alwaysRunToEnd: false
//                 direction: RotationAnimation.Shortest
//             }
//             CoordinateAnimation {
//                 id: carAnimation
//                 duration: 1000
//                 target: carLocation
//                 property: "coordinate"
//                 alwaysRunToEnd: false
//                 easing.type: Easing.Linear
//             }
//             onCenterChanged: {
//                 if (prevLocation.coordinate == center) return
// 
//                 if (modeFollow) {
//                     carAnimation.from = prevLocation.coordinate;
//                     carAnimation.to = carLocation.coordinate;
//                     carAnimation.start();
//                 }
//                 if (!modeNorth) {
//                     bearingAnimation.to = prevLocation.coordinate.azimuthTo(center);
//                     bearingAnimation.start();
//                 }
//                 
//                 prevLocation.coordinate = center;
//             }
            
            MapQuickItem {
                id: carMarker
                sourceItem: Image {
                    id: dotMarker
                    source: "../images/car-marker.png"
                    height: 50
                    fillMode: Image.PreserveAspectFit
                    opacity: 1.0
                }
                coordinate: carLocation.coordinate
                anchorPoint.x: dotMarker.width/2
                anchorPoint.y: dotMarker.height/2
                zoomLevel: 17
                MouseArea  {
                    drag.target: parent
                    anchors.fill: parent
                }

//                 onCoordinateChanged: {
//                     map.routeUpdate();
//                 }
            }
//             MapQuickItem {
//                 id: startMarker
//                 sourceItem: Image {
//                     id: greenMarker
//                     source: "../images/Map_marker_blue.png"
//                     height: 50
//                     fillMode: Image.PreserveAspectFit
//                     opacity: 1.0
//                 }
//                 coordinate: QtPositioning.coordinate(37.3964,-122.034)
//                 anchorPoint.x: greenMarker.width/2
//                 anchorPoint.y: greenMarker.height
//                 visible: modeRoute
//                 MouseArea  {
//                     drag.target: parent
//                     anchors.fill: parent
//                 }
//                 onCoordinateChanged: {
//                     map.routeUpdate();
//                 }
//             }
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
                visible: modeMarker
                MouseArea  {
                    drag.target: parent
                    anchors.fill: parent
                }
                onCoordinateChanged: {
                    if (modeRoute) map.routeUpdate();
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
    Item {
        id: mapFrame
        state: (uiMap) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: mapFrame
                    width: Kirigami.Units.gridUnit*8
                }
                PropertyChanges {
                    target: mapFrame
                    opacity: 1
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: mapFrame
                    width: 0
                }
                PropertyChanges {
                    target: mapFrame
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
                    NumberAnimation { target: routeView; properties: "width,opacity"; duration: 500 }
                }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                SequentialAnimation {
                    NumberAnimation { target: routeView; properties: "width,opacity"; duration: 500 }
                    PropertyAction {
                        target: mapFrame
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
        anchors.right: parent.right
//         anchors.rightMargin: Kirigami.Units.gridUnit*2
        anchors.top: topFrame.bottom
//         anchors.topMargin: Kirigami.Units.gridUnit*2
        anchors.bottom: bottomFrame.top
//         anchors.bottomMargin: Kirigami.Units.gridUnit*2
//         width: parent.width*0.25
        z: 15
        Column {
            id: mapControls
            anchors.fill: parent
            anchors.margins: Kirigami.Units.gridUnit*1.5
            spacing: Kirigami.Units.gridUnit*1.5
//             layer.enabled: true
//             layer.effect: DropShadow {
//                 transparentBorder: true
//                 verticalOffset: -6
//                 horizontalOffset: 6
//                 radius: 10
//                 samples: 21
//                 color: "#80000000"
//             }
            Image {
                id: iconRoute
                signal clicked
                anchors.horizontalCenter: parent.horizontalCenter
                source: (modeRoute) ? "../images/mode-route.png" : "../images/mode-browse.png"
                height: 30
                width: 30
                mipmap: true
                fillMode: Image.PreserveAspectFit
                opacity: 1
                MouseArea {
                    anchors.fill: parent
                    onClicked: iconRoute.clicked()
                }
                onClicked: {
                    modeRoute = (modeRoute) ? false : true;
                    if (modeRoute) {
                        modeMarker = true;
                        if (map) map.routeUpdate();
                    } else {
                        if (map) map.routeReset();
                    }
                }
                ColorOverlay {
                    anchors.fill: iconRoute
                    source: iconRoute
                    color: (modeNight) ? "#a9cac9" : "#ffffff"
                }
            }
            Image {
                id: iconMarker
                signal clicked
                anchors.horizontalCenter: parent.horizontalCenter
                source: (modeMarker) ? "../images/map-location.png" : "../images/map-solid.png"
                height: 30
                width: 30
                mipmap: true
                fillMode: Image.PreserveAspectFit
                opacity: 1
                MouseArea {
                    anchors.fill: parent
                    onClicked: iconMarker.clicked()
                }
                onClicked: {
                    modeMarker = (modeRoute) ? true : ((modeMarker) ? false : true);
                }
                ColorOverlay {
                    anchors.fill: iconMarker
                    source: iconMarker
                    color: (modeNight) ? "#a9cac9" : "#ffffff"
                }
            }
            Image {
                id: iconFollow
                signal clicked
                anchors.horizontalCenter: parent.horizontalCenter
                source: (modeFollow) ? "../images/mode-location.png" : "../images/mode-follow.png"
                height: 30
                width: 30
                mipmap: true
                fillMode: Image.PreserveAspectFit
                opacity: 1
                MouseArea {
                    anchors.fill: parent
                    onClicked: iconFollow.clicked()
                }
                onClicked: {
                    modeFollow = (modeFollow) ? false : true
                }
                ColorOverlay {
                    anchors.fill: iconFollow
                    source: iconFollow
                    color: (modeNight) ? "#a9cac9" : "#ffffff"
                }
            }
            Image {
                id: icon3D
                signal clicked
                anchors.horizontalCenter: parent.horizontalCenter
                source: (mode3D) ? "../images/mode-3D.png" : "../images/mode-2D.png"
                height: 30
                width: 30
                mipmap: true
                fillMode: Image.PreserveAspectFit
                opacity: 1
                MouseArea {
                    anchors.fill: parent
                    onClicked: icon3D.clicked()
                }
                onClicked: {
                    mode3D = (mode3D) ? false : true
                }
                ColorOverlay {
                    anchors.fill: icon3D
                    source: icon3D
                    color: (modeNight) ? "#a9cac9" : "#ffffff"
                }
            }
            Image {
                id: iconNorth
                signal clicked
                anchors.horizontalCenter: parent.horizontalCenter
                source: (modeNorth) ? "../images/mode-compass.png" : "../images/mode-direction.png"
                height: 30
                width: 30
                mipmap: true
                fillMode: Image.PreserveAspectFit
                opacity: 1
                MouseArea {
                    anchors.fill: parent
                    onClicked: iconNorth.clicked()
                }
                onClicked: {
                    modeNorth = (modeNorth) ? false : true
                }
                ColorOverlay {
                    anchors.fill: iconNorth
                    source: iconNorth
                    color: (modeNight) ? "#a9cac9" : "#ffffff"
                }
            }
            Image {
                id: iconAnimate
                signal clicked
                anchors.horizontalCenter: parent.horizontalCenter
                source: (carAnimate) ? "../images/music-play.png" : "../images/music-stop.png"
                height: 30
                width: 30
                mipmap: true
                fillMode: Image.PreserveAspectFit
                opacity: 1
                MouseArea {
                    anchors.fill: parent
                    onClicked: iconAnimate.clicked()
                }
                onClicked: {
                    carAnimate = (carAnimate) ? false : true
                }
                ColorOverlay {
                    anchors.fill: iconAnimate
                    source: iconAnimate
                    color: (modeNight) ? "#a9cac9" : "#ffffff"
                }
            }
        }
    }

    Item {
        id: mapRoute
        state: (uiMap && (routeModel.status == RouteModel.Ready)) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: routeView
                    height: parent.height
                }
            },
            State {
                name: "INACTIVE"
                PropertyChanges {
                    target: routeView
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
                        target: mapRoute
                        property: "visible"
                        value: true
                    }
                    NumberAnimation { target: routeView; properties: "height"; duration: 500 }
                }
            },
            Transition {
                from: "ACTIVE"
                to: "INACTIVE"
                SequentialAnimation {
                    NumberAnimation { target: routeView; properties: "height"; duration: 500 }
                    PropertyAction {
                        target: mapRoute
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
        anchors.leftMargin: Kirigami.Units.gridUnit*2
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: parent.width*0.25
        height: parent.height*0.9
        z: 15
        Rectangle {
            id: routeView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                verticalOffset: -6
                horizontalOffset: 6
                radius: 10
                samples: 21
                color: "#80000000"
            }
            ListView {
                id: routeList
                anchors.fill: parent
                model: routeModel.status == RouteModel.Ready ? routeModel.get(0).segments : null
                visible: model ? true : false
                snapMode: ListView.SnapToItem
                headerPositioning: ListView.OverlayHeader
                clip: true
                header: Rectangle {
                    width: parent.width
                    height: Kirigami.Units.gridUnit*7
                    color: (modeNight) ? "#275660" : "#ffffff"
                    z: 16
//                     opacity: 0.8
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        verticalOffset: -4
                        radius: 10
                        samples: 21
                        color: "#80000000"
                    }
                    Text {
                        id: routeTravelTime
                        anchors.left: parent.left
                        anchors.leftMargin: Kirigami.Units.gridUnit
                        anchors.top: parent.top
                        anchors.topMargin: Kirigami.Units.gridUnit*0.5
                        color: (modeNight) ? "#ef7b30" : "#47696f"
                        text: routeTime>3600 ? Math.floor(routeTime/3600)+" hr  "+Math.floor((routeTime%3600)/60)+" min" : Math.round(routeTime/60)+" min"
                        font.pointSize: Kirigami.Units.gridUnit*2
                        font.bold: true
                    }
                    Text {
                        id: routeDist
                        anchors.left: parent.left
                        anchors.leftMargin: Kirigami.Units.gridUnit
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: Kirigami.Units.gridUnit*0.5
                        color: (modeNight) ? "white" : "black"
                        text: routeDistance>1000 ? Math.floor(routeDistance/1000)+" km" : Math.round(routeDistance)+" m"
                        font.pointSize: Kirigami.Units.gridUnit
                        font.bold: true
                    }
                }
                delegate: Rectangle {
                    id: routeListdelegate
                    width: parent.width
                    height: Kirigami.Units.gridUnit*6
                    color: (modeNight) ? ((index%2===0) ? "#73a8a6" : "#5f9295") : ((index%2===0) ? "#dadada" : "#b2a196")
//                     opacity: 0.8
                    property bool hasManeuver: modelData.maneuver && modelData.maneuver.valid
                    visible: hasManeuver
                    signal clicked
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        verticalOffset: -4
                        radius: 10
                        samples: 21
                        color: "#80000000"
                    }
                    Image {
                        id: maneuverDir
                        anchors.right: parent.right
                        anchors.rightMargin: Kirigami.Units.gridUnit
                        anchors.top: parent.top
                        anchors.topMargin: Kirigami.Units.gridUnit*0.5
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: Kirigami.Units.gridUnit*0.5
//                         height: maneuverDist.height
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
//                         color: (modeNight) ? "#a9cac9" : "#000000"
                        source: {
                            switch (modelData.maneuver.direction) {
                                case RouteManeuver.NoDirection:
                                    return "";
                                case RouteManeuver.DirectionForward:
                                    return "../images/Dir-Straight.png";
                                case RouteManeuver.DirectionBearRight:
                                    return "../images/Dir-Bear-right.png";
                                case RouteManeuver.DirectionLightRight:
                                    return "../images/Dir-LightTurn-right.png";
                                case RouteManeuver.DirectionRight:
                                    return "../images/Dir-Turn-right.png";
                                case RouteManeuver.DirectionHardRight:
                                    return "../images/Dir-SharpTurn-right.png";
                                case RouteManeuver.DirectionUTurnRight:
                                    return "../images/Dir-Uturn-right.png";
                                case RouteManeuver.DirectionUTurnLeft:
                                    return "../images/Dir-Uturn-left.png";
                                case RouteManeuver.DirectionHardLeft:
                                    return "../images/Dir-SharpTurn-left.png";
                                case RouteManeuver.DirectionLeft:
                                    return "../images/Dir-Turn-left.png";
                                case RouteManeuver.DirectionLightLeft:
                                    return "../images/Dir-LightTurn-left.png";
                                case RouteManeuver.DirectionBearLeft:
                                    return "../images/Dir-Bear-left.png";
                                default:
                                    return null;
                            }
                        }
                    }
                    Text {
                        id: maneuverInstr
                        anchors.left: parent.left
                        anchors.leftMargin: Kirigami.Units.gridUnit
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: Kirigami.Units.gridUnit*0.7
                        anchors.top: maneuverDist.bottom
                        anchors.topMargin: Kirigami.Units.gridUnit*0.2
                        anchors.right: maneuverDir.left
                        anchors.rightMargin: Kirigami.Units.gridUnit*0.5
                        text: hasManeuver ? routeAdaptDriver(modelData.maneuver.instructionText) : ""
//                         color: (modeNight) ? "#a9cac9" : "#000000"
                        font.pointSize: Kirigami.Units.gridUnit*0.5
                        font.weight: Font.Thin
                        wrapMode: Text.Wrap
                    }
                    Text {
                        id: maneuverDist
                        anchors.left: parent.left
                        anchors.leftMargin: Kirigami.Units.gridUnit
                        anchors.top: parent.top
                        anchors.topMargin: Kirigami.Units.gridUnit*0.3
//                         color: (modeNight) ? "#a9cac9" : "#000000"
//                         text: hasManeuver ? Math.floor(modelData.maneuver.distanceToNextInstruction)+"m" : ""
                        text: (hasManeuver && index>0) ? (routeModel.get(0).segments[index-1].maneuver.distanceToNextInstruction>1000 ? Math.round(routeModel.get(0).segments[index-1].maneuver.distanceToNextInstruction/100)/10+" km" : Math.round(routeModel.get(0).segments[index-1].maneuver.distanceToNextInstruction)+" m") : ""
                        font.pointSize: Kirigami.Units.gridUnit*1.8
                        font.bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("segment instruction: "+routeModel.get(0).segments[index].maneuver.instructionText);
                            routeList.positionViewAtIndex(index+1, ListView.Beginning)
                        }
                    }
                }
                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                    NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
                }
                displaced: Transition {
                    NumberAnimation { properties: "y"; duration: 500; easing.type: Easing.OutBounce }
                }
                move: Transition {
                    NumberAnimation { properties: "y"; duration: 500; easing.type: Easing.OutBounce }
                }
            }
        }
    }

    property int routeTime: routeModel.status == RouteModel.Ready ? routeModel.get(0).travelTime : 0
    property real routeDistance: routeModel.status == RouteModel.Ready ? routeModel.get(0).distance : 0

    function routeAdaptDriver(inst) {
        if (modeAutonomous) {
            if (inst.slice(0,4)==="Your") {
                return inst.replace("Your", "Our");
            } else if (inst.slice(0,3)==="You") {
                return inst.replace("You", "We");
            } else
                return "We'll "+inst.substring(0,1).toLowerCase()+inst.slice(1);
        } else
            return inst;
    }

//     function sessionGetManeuver(route, man) {
//         sessionData.routeNum = route;
//         sessionData.routeSegment = man;
//         sessionData.routeSegments = routeModel.get(route).segments.length;
//         sessionData.routeTotalTime = routeModel.get(route).travelTime;
//         sessionData.routeTotalDistance = routeModel.get(route).distance;
//         sessionData.routeDistance = routeModel.get(route).segments[man].distance;
//         sessionData.routePositionLat = routeModel.get(route).segments[man].maneuver.position.latitude;
//         sessionData.routePositionLon = routeModel.get(route).segments[man].maneuver.position.longitude;
//         sessionData.routeTime = routeModel.get(route).segments[man].travelTime;
//         sessionData.routeDirection = routeModel.get(route).segments[man].maneuver.direction;
//         sessionData.routeInstruction = routeAdaptDriver(routeModel.get(route).segments[man].maneuver.instructionText);
//         sessionData.routeDistanceToNext = routeModel.get(route).segments[man].maneuver.distanceToNextInstruction;
//         sessionData.routeTimeToNext = routeModel.get(route).segments[man].maneuver.timeToNextInstruction;
//         var routePath = "[{'lat':"+routeModel.get(route).segments[man].path[0].latitude+",'lon':"+routeModel.get(route).segments[man].path[0].longitude+"}";
//         for (let i = 1; i < routeModel.get(route).segments[man].path.length; i++) {
//             routePath = routePath+",{'lat':"+routeModel.get(route).segments[man].path[i].latitude+",'lon':"+routeModel.get(route).segments[man].path[i].longitude+"}";
//             console.log("maneuver path #"+i+": Lat="+routeModel.get(route).segments[man].path[i].latitude+" Lon="+routeModel.get(route).segments[man].path[i].longitude);
//         }
//         sessionData.routePath = routePath+"]";
//         console.log("route path: "+routePath+"]");
//         if (man+1<routeModel.get(route).segments.length) {
//             man=man+1;
//             sessionData.routeNext = true;
//             sessionData.routeNextSegment = man;
//             sessionData.routeNextDistance = routeModel.get(route).segments[man].distance;
//             sessionData.routeNextPositionLat = routeModel.get(route).segments[man].maneuver.position.latitude;
//             sessionData.routeNextPositionLon = routeModel.get(route).segments[man].maneuver.position.longitude;
//             sessionData.routeNextTime = routeModel.get(route).segments[man].travelTime;
//             sessionData.routeNextDirection = routeModel.get(route).segments[man].maneuver.direction;
//             sessionData.routeNextInstruction = routeAdaptDriver(routeModel.get(route).segments[man].maneuver.instructionText);
//         } else {
//             sessionData.routeNext = false;
//         }
//     }

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
            console.log("RouteModel onCompleted");
            if (modeRoute)
                map.routeUpdate();
        }
        onStatusChanged: {
            if (routeModel.status === RouteModel.Ready) {
                routeSegment = 0;
                routePath = 0;
                routeList.currentIndex = 0;
                carAnimateNextStep(true);
//                 sessionGetManeuver(0, 0);
//                 triggerGuiEvent("mkz-urban-demo-skill.route_update", {"string": routeAdaptDriver(routeModel.get(0).segments[0].maneuver.instructionText)});
//                 console.log("RouteModel onStatusChanged: "+routeAdaptDriver(routeModel.get(0).segments[0].maneuver.instructionText));
//             } else {
//                 console.log("RouteModel onStatusChanged: not ready");
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
            source: (modeNight) ? "../images/mkz_frame_top_night.png" : "../images/mkz_frame_top_day.png"
            fillMode: Image.PreserveAspectFit
            Text {
                id: lTime
                anchors.left: parent.left
                anchors.leftMargin: Kirigami.Units.gridUnit*1.5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height*0.35
                color: (modeNight) ? "#a9cac9" : "#000000"
                font.pixelSize: 28
                font.capitalization: Font.SmallCaps
                font.bold: true
                text: sessionData.datetime.substring(0,5)
                opacity: (modeNight) ? 1 : 0.6
            }
            Text {
                id: lAmpm
                anchors.left: lTime.right
                anchors.leftMargin: 2
                anchors.bottom: lTime.bottom
                color: (modeNight) ? "#a9cac9" : "#000000"
                font.pixelSize: 28
                font.capitalization: Font.SmallCaps
                font.bold: false
                font.weight: Font.Thin
                text: sessionData.datetime.substring(5,7)
                opacity: (modeNight) ? 1 : 0.6
            }
            Text {
                id: lDay
                anchors.left: lAmpm.right
                anchors.bottom: lTime.bottom
                anchors.leftMargin: Kirigami.Units.gridUnit*1.5
                color: (modeNight) ? "#a9cac9" : "#000000"
                font.pixelSize: 28
                font.capitalization: Font.SmallCaps
                font.bold: true
                text: sessionData.datetime.substring(8,11)
                opacity: (modeNight) ? 1 : 0.6
            }
            Text {
                id: lDate
                anchors.left: lDay.right
                anchors.bottom: lTime.bottom
                anchors.leftMargin: Kirigami.Units.gridUnit*0.8
                color: (modeNight) ? "#a9cac9" : "#000000"
                font.pixelSize: 28
                font.capitalization: Font.SmallCaps
                font.bold: false
                font.weight: Font.Thin
                text: sessionData.datetime.substring(12)
                opacity: (modeNight) ? 1 : 0.6
            }

            Image {
                id: dayNightIcon
                signal clicked
                anchors.right: parent.right
                anchors.rightMargin: Kirigami.Units.gridUnit*1.5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height*0.4
                source: (modeNight) ? "../images/moon-solid.png" : "../images/sun-solid.png"
                height: 30
                width: 30
                opacity: 0.7
                mipmap: true
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: dayNightIcon.clicked()
                }
                onClicked: {
                    modeNight = (modeNight) ? false : true
                }
                ColorOverlay {
                    anchors.fill: dayNightIcon
                    source: dayNightIcon
                    color: (modeNight) ? "#a9cac9" : "#000000"
                }
            }
            Image {
                id: autonomousIcon
                signal clicked
                anchors.right: dayNightIcon.left
                anchors.rightMargin: Kirigami.Units.gridUnit
                anchors.verticalCenter: dayNightIcon.verticalCenter
                source: (modeAutonomous) ? "../images/mode-autonomous.png" : "../images/mode-manual.png"
                height: 30
                width: 30
                mipmap: true
                fillMode: Image.PreserveAspectFit
                opacity: 0.7
                MouseArea {
                    anchors.fill: parent
                    onClicked: autonomousIcon.clicked()
                }
                onClicked: {
                    modeAutonomous = (modeAutonomous) ? false : true
                }
                ColorOverlay {
                    anchors.fill: autonomousIcon
                    source: autonomousIcon
                    color: (modeNight) ? "#a9cac9" : "#000000"
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
                    color: (modeNight) ? "#e8fffc" : "#c0000000"
                    font.pointSize: 14
                }
                Text {
                    id: musicTopTotal
                    anchors.left: musicTopProgress.right
                    anchors.verticalCenter: musicTopProgress.verticalCenter
                    anchors.leftMargin: 5
                    text: "-"+playLogic.msToTime(player.duration-player.position)
    //                                 font.family: appFont.name
                    color: (modeNight) ? "#e8fffc" : "#c0000000"
                    font.pointSize: 14
                }
                Text {
                    id: musicTopTitle
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: musicTopProgress.bottom
                    text: player.metaData.title ? player.metaData.title : ""
                    color: (modeNight) ? "#e8fffc" : "#c0000000"
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
                    color: (modeNight) ? "#ff1e373a" : "#f0f0f0f0"
                    signal clicked
                    width: parent.width-Kirigami.Units.gridUnit*2
                    height: parent.height-Kirigami.Units.gridUnit
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.bottom: parent.bottom
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 6
                        verticalOffset: -6
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
                            color: (modeNight) ? "#401e373a" : "#00000000"
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
                        color: (modeNight) ? "#e8fffc" : "#c0000000"
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
        z: 15
        state: (uiConfig) ? "ACTIVE" : "INACTIVE"
        states: [
            State {
                name: "ACTIVE"
                PropertyChanges {
                    target: statusView
                    height: parent.height*0.9
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
        Rectangle {
            id: statusView
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: Kirigami.Units.gridUnit*2
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: Kirigami.Units.gridUnit*2
//             width: parent.width*0.5
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 6
                verticalOffset: -6
                color: "#80000000"
                radius: 10
                samples: 21
            }
            ListView {
                id: statusListView
                anchors.fill: parent
//                 anchors.left: parent.left
//                 anchors.bottom: parent.bottom
//                 width: parent.width*0.5
    //             height: parent.height*0.75
    //             cellWidth: width
    //             cellHeight: height/8
                model: sessionData.statusList
                delegate: Item {
//                     z: 1
//                     width: statusView.cellWidth
//                     height: statusView.cellHeight
                    width: statusListView.width
                    height: Kirigami.Units.gridUnit*3
                    Rectangle {
                        id: statusButton
    //                     color: (modeNight) ? "#ff1e373a" : "#f0f0f0f0"
                        color: (modeNight) ? ((index%2===0) ? "#73a8a6" : "#5f9295") : ((index%2===0) ? "#dadada" : "#bababa")
                        signal clicked
                        anchors.fill: parent
//                         anchors.verticalCenter: parent.verticalCenter
//                         anchors.left: parent.left
//                         width: parent.width
//                         height: parent.height
                        Text {
                            id: statusLabel
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: Kirigami.Units.gridUnit
                            anchors.verticalCenter: parent.verticalCenter
//                             height: parent.height
                            text: model.text
                            color: (model.text.substring(model.text.length-1)==="✓") ? ((modeNight) ? "#e8fffc" : "#c0000000") : "#ef7b30"
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
            color: (modeNight) ? "#ff1e373a" : "#f0f0f0f0"
            width: parent.width*0.4
//             height: parent.height*0.75
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 6
                verticalOffset: -6
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
                        color: (modeNight) ? "#e8fffc" : "#c0000000"
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
                        color: (modeNight) ? "#e8fffc" : "#c0000000"
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
                        color: (modeNight) ? "#e8fffc" : "#c0000000"
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
                    color: (modeNight) ? "#e8fffc" : "#c0000000"
                    font.pointSize: 14
                }

                Text {
                    id: totalTime
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 1
                    text: "-"+playLogic.msToTime(player.duration-player.position)
//                                 font.family: appFont.name
                    color: (modeNight) ? "#e8fffc" : "#c0000000"
                    font.pointSize: 14
                }
            }

            Item { // music controls
                id: buttonWrapper
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: timeWrap.bottom
                anchors.topMargin: Kirigami.Units.gridUnit*3
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
//                         color: (modeNight) ? "#401e373a" : "#40000000"
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
//                             color: (modeNight) ? "#401e373a" : "#40000000"
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
//                         color: (modeNight) ? "#401e373a" : "#40000000"
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
