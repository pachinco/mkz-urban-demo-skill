import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

Mycroft.Delegate{
    id: homescreen
    skillBackgroundSource: Qt.resolvedUrl(sessionData.background)

    Image {
        id: placeImage
        source: "../images/Lincoln-UPower.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height*0.5
        fillMode: Image.PreserveAspectFit
    }
}
