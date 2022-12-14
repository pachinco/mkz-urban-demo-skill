import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

Mycroft.ScrollableDelegate{
// Mycroft.CardDelegate {
    id: actionFrame
    anchors.fill: parent
    leftPadding: 10
    rightPadding: 30
    topPadding: 20
    bottomPadding: 20
    skillBackgroundSource: Qt.resolvedUrl(sessionData.background)

    property var actionsModel: sessionData.actionsList

    Component {
        id: actionDelegate
        Item {
            width: view.cellWidth
            height: view. cellHeight
            Rectangle {
                color: "#f1c0c3"
                radius: 20
                width: parent.width-Kirigami.Units.gridUnit
                height: parent.height-Kirigami.Units.gridUnit
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 6
                    verticalOffset: 6
                }
                Item {
                    id: actionSpacer1
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: Kirigami.Units.gridUnit
                }
                Image {
                    id: actionIcon
                    anchors.left: actionSpacer1.right
                    anchors.verticalCenter: parent.verticalCenter
                    source: model.image
                    width: Kirigami.Units.gridUnit * 3
                    fillMode: Image.PreserveAspectFit
                }
                Item {
                    id: actionSpacer2
                    anchors.left: actionIcon.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: Kirigami.Units.gridUnit
                }
                Kirigami.Heading {
                    id: actionsLabel
                    anchors.left: actionSpacer2.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: model.text
                    color: "#202020"
                    font.pixelSize: Kirigami.Units.gridUnit
                }
            }
        }
    }

    GridView {
        id: view
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - Kirigami.Units.gridUnit * 2
        height: parent.height
        model: actionsModel
//         maximumColumns: 3
        delegate: actionDelegate
        cellWidth: width/4
        cellHeight: 100
//         spacing: Kirigami.Units.largeSpacing
    }
}
