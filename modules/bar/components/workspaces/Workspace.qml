pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia.Config
import qs.components
import qs.services

StyledRect {
    id: root

    required property int index
    required property int activeWsId
    required property var occupied
    required property int groupOffset
    required property ShellScreen screen

    readonly property bool isWorkspace: true // Flag for finding workspace children

    readonly property int ws: groupOffset + index + 1
    readonly property bool isOccupied: occupied[ws] ?? false
    readonly property bool isActive: activeWsId === ws

    implicitWidth: Tokens.sizes.bar.innerWidth - Tokens.padding.small
    implicitHeight: Tokens.sizes.bar.innerWidth - Tokens.padding.small
    radius: Tokens.rounding.full
    color: isActive ? Colours.palette.m3primary : isOccupied ? Colours.layer(Colours.palette.m3surfaceContainerHigh, 2) : "transparent"

    StyledText {
        anchors.centerIn: parent

        animate: true
        text: {
            const w = Hypr.workspaces.values.find(w => w.id === root.ws);
            const wsName = !w || w.name == root.ws ? root.ws : w.name[0];
            let displayName = wsName.toString();
            if (Config.bar.workspaces.capitalisation.toLowerCase() === "upper") {
                displayName = displayName.toUpperCase();
            } else if (Config.bar.workspaces.capitalisation.toLowerCase() === "lower") {
                displayName = displayName.toLowerCase();
            }
            const label = Config.bar.workspaces.label || displayName;
            const occupiedLabel = Config.bar.workspaces.occupiedLabel || label;
            const activeLabel = Config.bar.workspaces.activeLabel || (root.isOccupied ? occupiedLabel : label);
            return root.isActive ? activeLabel : root.isOccupied ? occupiedLabel : label;
        }
        color: root.isActive ? Colours.palette.m3onPrimary : root.isOccupied ? Colours.palette.m3onSurface : Colours.layer(Colours.palette.m3outlineVariant, 2)
        font.family: Tokens.font.workspaces
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.isActive)
                return;
            Hypr.dispatch(Hypr.usingLua ? `hl.dsp.focus({ workspace = ${root.ws} })` : `workspace ${root.ws}`);
        }
    }
}
