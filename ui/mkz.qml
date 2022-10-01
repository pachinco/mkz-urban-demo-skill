import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

Mycroft.Delegate {
    skillBackgroundSource: sessionData.exampleImage
    ColumnLayout {
        anchors.fill: parent
        parent.padding: 0 0 0 0;
        parent.border-spacing: 0px 0px;
        parent.margin: 0px;

        Image {
            id: imageId
            Layout.fillWidth: true
            Layout.fillHeight: true
            source: Qt.resolvedUrl("../images/mkz_homescreen.png")
        }
        Rectangle {
            width: parent.width/2
            height: parent.height/2
            radius: 20
            color: "#00ffff"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Label {
                id: labelId
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 4
                color: "#000000"
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."            
            }
        }
    }
}
