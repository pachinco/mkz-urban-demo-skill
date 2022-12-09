import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import QtQuick3D 1.15
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

Mycroft.Delegate {
    id: cluster
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
    property bool routeSegmentNext: sessionData.routeSegmentNext
    property int controlIdx: sessionData.controlIdx

//     property string maptiler_key: "nGqcqqyYOrE4VtKI6ftl"
//     property string mapboxToken: "pk.eyJ1IjoicGFjaGluY28iLCJhIjoiY2w5b2RkN2plMGZnMTNvcDg3ZmF0YWdkMSJ9.vzH21tcuxbMkqCKOIbGwkw"
//     property string mapboxToken_mkz: "sk.eyJ1IjoicGFjaGluY28iLCJhIjoiY2w5b21lazFxMGgyMDQwbXprcHZlYzRuZiJ9.zEfn2HsyB0VyMXS93xAcow"
    View3D {
        id: view
        anchors.fill: parent

        environment: SceneEnvironment {
            clearColor: "skyblue"
            backgroundMode: SceneEnvironment.Color
        }

        PerspectiveCamera {
            position: Qt.vector3d(0, 200, 300)
            eulerRotation.x: -30
        }

        DirectionalLight {
            eulerRotation.x: -30
            eulerRotation.y: -70
        }

        Model {
            position: Qt.vector3d(0, -200, 0)
            source: "#Cylinder"
            scale: Qt.vector3d(2, 0.2, 1)
            materials: [ DefaultMaterial {
                    diffuseColor: "red"
                }
            ]
        }

        Model {
            position: Qt.vector3d(0, 150, 0)
            source: "#Sphere"

            materials: [ DefaultMaterial {
                    diffuseColor: "blue"
                }
            ]

            SequentialAnimation on y {
                loops: Animation.Infinite
                NumberAnimation {
                    duration: 3000
                    to: -150
                    from: 150
                    easing.type:Easing.InQuad
                }
                NumberAnimation {
                    duration: 3000
                    to: 150
                    from: -150
                    easing.type:Easing.OutQuad
                }
            }
        }
    }
}
