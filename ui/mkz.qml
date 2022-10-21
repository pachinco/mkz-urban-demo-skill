import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

// Mycroft.Delegate {
Item {
    id: homescreen
//     skillBackgroundSource: Qt.resolvedUrl("../images/mkz_background_stage_day.png")
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    Image {
        id: background
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
//         PropertyAnimation {
//             id: animation;
//             target: mkzImage;
//             property: "height";
//             to: 4000;
//             duration: 5000
//         }
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
}
