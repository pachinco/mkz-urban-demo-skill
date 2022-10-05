import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

Mycroft.ScrollableDelegate{
    id: actionsList
    skillBackgroundSource: Qt.resolvedUrl(sessionData.background)
    property var actionsModel: sessionData.actionsList

    Kirigami.CardsGridView {
        id: actionsListView
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: actionsModel.actions
        maximumColumns: 3
        delegate: Mycroft.CardDelegate {
            id: rootCard
            implicitWidth: delegateItem.implicitWidth + Kirigami.Units.largeSpacing
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 8
                verticalOffset: 8
            }
            contentItem: Rectangle {
                color: "#f1c0c3"
                radius: 20
                RowLayout {
                    id: delegateItem
                    anchors.fill: parent
                    spacing: Kirigami.Units.largeSpacing
                    Image {
                        id: placeImage
                        source: modelData.image
                        Layout.fillHeight: true
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                        fillMode: Image.PreserveAspectFit
                    }
                    Kirigami.Heading {
                        id: actionsLabel
                        Layout.fillHeight: true
                        text: modelData.text
                        level: 2
                        color: "#202020"
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Kirigami.Units.gridUnit
                    }
                }
            }
        }
    }
}
