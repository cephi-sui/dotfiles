#! /bin/sh
# This script is a bounded relative workspace switch, going from workspace 1 to
#   the maximum workspace # specified by the second argument.

# The first argument is the action (up, down).
# The second argument is the maximum number of workspaces on the monitor.

activeMonitorID=$(hyprctl -j monitors | jq -r '.[] | select(.focused == true) | .id')
activeWorkspaceID=$(hyprctl -j activeworkspace | jq -r '.id')

if [ $1 = "--help" -o $1 = "-h" ];
    then echo "Usage: switch_workspace.sh <up|down> <# of workspaces per monitor>"; exit 0
fi

if [ $# -lt 2 ];
    then echo "Expected 2 arguments!"; exit 1
fi

if [ -z "$2" ];
    then echo "Argument 2 invalid!"; exit 1
fi

case $1 in
    up)
        # The comparison and redundant dispatch call are to handle scrolling too fast,
        # causing hyprland to skip over the last workspace and continue past the max.
        if [ $activeWorkspaceID -ge $(($activeMonitorID*$2+$2)) ];
            # then hyprctl dispatch workspace "$activeMonitorID"1;
            then hyprctl dispatch workspace $(($activeMonitorID*$2+$2));
            else hyprctl dispatch workspace r+1;
        fi
    ;;
    down)
        if [ $activeWorkspaceID -le "$activeMonitorID"1 ];
            # then hyprctl dispatch workspace $(($activeMonitorID*$2+$2));
            then hyprctl dispatch workspace "$activeMonitorID"1;
            else hyprctl dispatch workspace r-1;
        fi
    ;;
    *)
        echo "Argument 1 invalid!"; exit 1
    ;;
esac
