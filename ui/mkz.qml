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

    property string hostingKey: "nGqcqqyYOrE4VtKI6ftl"
    property string mapboxToken: "pk.eyJ1IjoicGFjaGluY28iLCJhIjoiY2w5b2RkN2plMGZnMTNvcDg3ZmF0YWdkMSJ9.vzH21tcuxbMkqCKOIbGwkw"

    property real marker_base_height: 60
 
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
                PropertyChanges {
                    target: uiStage
                    opacity: 0
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
                    ParallelAnimation {
                        NumberAnimation { target: uiStage; properties: "opacity"; duration: 500 }
                        NumberAnimation { target: mapView; properties: "opacity,width,height"; duration: 500 }
                    }
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
        // OSM
        Plugin {
            id: mapPlugin
            name: "osm"
        }
        
        ListModel {
            id:dataModel
            ListElement { lat: 54.196; lon: 16.234; name: 'test1'; }
            ListElement { lat: 54.209; lon: 16.192; name: 'test2'; }
            ListElement { lat: 54.229; lon: 16.215; name: 'test3'; }
        }
        Map {
            id: mapView
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            plugin: mapPlugin
            center: QtPositioning.coordinate(37.3963974,-122.035018) // UPower Sunnyvale
//             activeMapType: supportedMapTypes[supportedMapTypes.length – 1]
            zoomLevel: 20
            tilt: 60
            z: 1
            MapItemView {
                id: mapItemView
                model: dataModel
                delegate: Component {
                    Marker {
                        id: m
                        visible: true
                        coordinate: QtPositioning.coordinate(model.lat, model.lon)
//                         z: 90–model.lat
                        marker_height: marker_base_height
                        marker_mouse.propagateComposedEvents: true
                        marker_mouse.onPressed: {
                            console.log(model.name)
                        }
                    }
                }
            }
            MapQuickItem {
                id: pos_marker
                anchorPoint.x: marker_base_height / 6
                anchorPoint.y: marker_base_height / 6
                z: 91
                sourceItem: Image {
                    height: marker_base_height / 2.5
                    width: marker_base_height / 2.5
                    fillMode: Image.PreserveAspectFit
                    source: 'qrc:/qml/img/pos.svg'
                    sourceSize.height: height
                    sourceSize.width: width
                }
            }
        }
        PositionSource {
            id: pos_src
            updateInterval: 1000
            active: true
            onPositionChanged: {
                pos_marker.coordinate=position.coordinate
            }
        }
        // mapboxgl
//         Plugin {
//             id: mapPlugin
//             name: "mapboxgl"
//             PluginParameter {
//                 name: "mapboxgl.access_token";
//                 value: "pk.eyJ1IjoicGFjaGluY28iLCJhIjoiY2w5b2RkN2plMGZnMTNvcDg3ZmF0YWdkMSJ9.vzH21tcuxbMkqCKOIbGwkw"
//             }
//             PluginParameter {
//                 name: "mapboxgl.mapping.additional_style_urls"
//                 value: "https://api.maptiler.com/maps/winter/tiles.json?key=nGqcqqyYOrE4VtKI6ftl#16.8/37.39568/-122.03325"
//                 value: "https://api.maptiler.com/styles/streets/style.json?key=nGqcqqyYOrE4VtKI6ftl"
//             }
//         }
// 
//         Map {
//             id: mapView
//             anchors.fill: parent
//             plugin: mapPlugin
//             center: QtPositioning.coordinate(37.3963974,-122.035018) // UPower Sunnyvale
//             zoomLevel: 20
//         }

        // mapboxgl
//         Map {
//             id: mapView
//             plugin: Plugin {
//                 name: "mapboxgl"
//                 PluginParameter {
//                     name: "mapboxgl.access_token";
//                     value: "pk.eyJ1IjoicGFjaGluY28iLCJhIjoiY2w5b2RkN2plMGZnMTNvcDg3ZmF0YWdkMSJ9.vzH21tcuxbMkqCKOIbGwkw"
//                 }
//             }
// 
//             center: QtPositioning.coordinate(37.3963974,-122.035018) // UPower Sunnyvale
//             zoomLevel: 12
// 
//             MapParameter {
//                 type: "source"
// 
//                 property var name: "routeSource"
//                 property var sourceType: "geojson"
//                 property var data: '{ "type": "FeatureCollection", "features": \
//                     [{ "type": "Feature", "properties": {}, "geometry": { \
//                     "type": "LineString", "coordinates": [[ 24.934938848018646, \
//                     60.16830257086771 ], [ 24.943315386772156, 60.16227776476442 ]]}}]}'
//             }
// 
//             MapParameter {
//                 type: "layer"
// 
//                 property var name: "route"
//                 property var layerType: "line"
//                 property var source: "routeSource"
// 
//                 property var before: "road-label-small"
//             }
// 
//             MapParameter {
//                 type: "paint"
// 
//                 property var layer: "route"
//                 property var lineColor: "blue"
//                 property var lineWidth: 8.0
//             }
// 
//             MapParameter {
//                 type: "layout"
// 
//                 property var layer: "route"
//                 property var lineJoin: "round"
//                 property var lineCap: "round"
//             }
//         }
//     }

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
