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

    property var datetime: sessionData.datetime

    Image {
        id: background
        source: "../images/mkz_background_stage_day.png"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

//     Image {
//         id: mkzImage
//         source: "../images/Lincoln-UPower.png"
//         anchors.horizontalCenter: parent.horizontalCenter
//         anchors.verticalCenter: parent.verticalCenter
//         height: parent.height*0.6
//         fillMode: Image.PreserveAspectFit
//         SequentialAnimation {
//             id: mkzAnimation
//             running: true
//             loops: Animation.Infinite
//             PropertyAction {
//                 property: "visible"
//                 value: false
//             }
//             PauseAnimation {
//                 duration: 1000
//             }
//             PropertyAction {
//                 property: "visible"
//                 value: true
//             }
//             NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 1000 }
//             NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 1000 }
//         }
//     }

    Plugin {
        id: mapPlugin
        name: "osm"
    }
    
    Map {
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(37.3963974,-122.035018) // UPower Sunnyvale
        zoomLevel: 20
        tilt: 45
    }

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
        x: 20
        y: 20
        z: 20
        font.pixelSize: 30
//         text: datetime
        text: "5:23pm    Thu Oct 20    90°F"
        opacity: 0.8
    }

    Component.onCompleted: {
        mkzAnimation.running = true
    }
}
