import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
// import QtQuick3D 1.15
// import QtQuick 2.2 as QQ2
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
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
    Entity {
        id: sceneRoot
        anchors.fill: parent

        Camera {
            id: camera
            projectionType: CameraLens.PerspectiveProjection
            fieldOfView: 45
            aspectRatio: 16/9
            nearPlane : 0.1
            farPlane : 1000.0
            position: Qt.vector3d( 0.0, 0.0, -40.0 )
            upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
            viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
        }

        OrbitCameraController {
            camera: camera
        }

        components: [
            RenderSettings {
                activeFrameGraph: ForwardRenderer {
                    clearColor: Qt.rgba(0, 0.5, 1, 1)
                    camera: camera
//                     showDebugOverlay: true
                }
            },
            // Event Source will be set by the Qt3DQuickWindow
            InputSettings { }
        ]

        PhongMaterial {
            id: material
        }

        TorusMesh {
            id: torusMesh
            radius: 5
            minorRadius: 1
            rings: 100
            slices: 20
        }


        Transform {
            id: torusTransform
            scale3D: Qt.vector3d(1.5, 1, 0.5)
            rotation: fromAxisAndAngle(Qt.vector3d(1, 0, 0), 45)
        }

        Entity {
            id: torusEntity
            components: [ torusMesh, material, torusTransform ]
        }

        SphereMesh {
            id: sphereMesh
            radius: 3
        }

        Transform {
            id: sphereTransform
            property real userAngle: 0.0
            matrix: {
                var m = Qt.matrix4x4();
                m.rotate(userAngle, Qt.vector3d(0, 1, 0));
                m.translate(Qt.vector3d(20, 0, 0));
                return m;
            }
        }

        NumberAnimation {
            target: sphereTransform
            property: "userAngle"
            duration: 10000
            from: 0
            to: 360

            loops: Animation.Infinite
            running: true
        }

        Entity {
            id: sphereEntity
            components: [ sphereMesh, material, sphereTransform ]
        }
    }
}
