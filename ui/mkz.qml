import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

Mycroft.Delegate {
//    skillBackgroundSource: sessionData.exampleImage
    ColumnLayout {
        anchors.fill: parent

        Image {
            id: imageId
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
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
                Layout.preferredHeight: Kirigami.Units.gridUnit * 10
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#000000"
                text: "U Power Autonomous Driving System"            
            }
        }
    }
}

Mycroft.ScrollableDelegate{
    id: root
    skillBackgroundSource: sessionData.background
    property var sampleModel: sessionData.sampleBlob

    Kirigami.CardsListView {
        id: exampleListView
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: sampleModel.lorem
        delegate: Kirigami.AbstractCard {
            id: rootCard
            implicitHeight: delegateItem.implicitHeight + Kirigami.Units.largeSpacing
            contentItem: Item {
                implicitWidth: parent.implicitWidth
                implicitHeight: parent.implicitHeight
                ColumnLayout {
                    id: delegateItem
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    spacing: Kirigami.Units.largeSpacing
                    Kirigami.Heading {
                        id: restaurantNameLabel
                        Layout.fillWidth: true
                        text: modelData.text
                        level: 2
                        wrapMode: Text.WordWrap
                    }
                    Kirigami.Separator {
                        Layout.fillWidth: true
                    }
                    Image {
                        id: placeImage
                        source: modelData.image
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                        fillMode: Image.PreserveAspectCrop
                    }
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 1
                    }
                }
            }
        }
    }
}
