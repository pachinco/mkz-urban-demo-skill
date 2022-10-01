import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

 Mycroft.ScrollableDelegate{
    skillBackgroundSource: sessionData.exampleImage
    ColumnLayout {
        anchors.fill: parent

        Image {
            id: imageId
            leftPadding: 0
            rightPadding: 0
            topPadding: 0
            bottomPadding: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: Qt.resolvedUrl("../images/mkz_homescreen.png")
        }
    }
}
