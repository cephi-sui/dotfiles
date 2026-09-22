import Quickshell
import Quickshell.Wayland
import QtQuick

Scope {
    PanelWindow {
        id: bar

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 40
        color: "transparent"
        //backingWindowVisible: false
        //visible: false
        WlrLayershell.namespace: "test"
        exclusionMode: ExclusionMode.Ignore


        PanelWindow {
            id: rect

            //anchors.left: parent.left
            //anchors.right: parent.right
            //anchors.verticalCenter: parent.verticalCenter
            anchors {
                left: true
                right: true
                top: true
                //verticalCenter: parent.verticalCenter
            }

            margins {
                top: 10
                bottom: 10
            }

            implicitHeight: 20

            color: "#ccffffff"
        }

        Text {
            SystemClock {
                id: clock
                precision: SystemClock.Minutes
            }

            anchors.centerIn: this.parent

            font.family: "Short Stack"
            font.pointSize: 10

            text: Qt.formatDateTime(clock.date, "⸻ yyyy/MM/dd hh:mm ⸻")
        }
    }

    /*
    WlrLayershell {
        Text {
            SystemClock {
                id: clock2
                precision: SystemClock.Minutes
            }

            anchors {
                //centerIn: this.parent
                top: this.parent.top
                left: this.parent.left
                right: this.parent.right
            }

            font.family: "Roboto"
            font.pointSize: 10

            text: Qt.formatDateTime(clock.date, "⸻ yyyy/MM/dd hh:mm ⸻")
        }
    }
    */

    /*
    PanelWindow {
        id: leftThing

        anchors {
            top: true
            left: true
            bottom: true
        }

        //anchors.top: bar.bottom
        color: "transparent"

        implicitWidth: 30

        exclusionMode: ExclusionMode.Ignore
    }
    */
}
