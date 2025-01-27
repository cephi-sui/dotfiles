#! /bin/sh
# The first argument is the action (next, prev).
# The second argument is the maximum number of workspaces on the monitor.
activeMonitorID=$(hyprctl -j monitors | jq -r '.[] | select(.focused == true) | .id')
activeWorkspaceID=$(hyprctl -j activeworkspace | jq -r '.id')

case $1 in
    next)
        # The comparison and redundant dispatch call are to handle scrolling too fast,
        # causing hyprland to skip over the last workspace and continue past the max.
        if [ $activeWorkspaceID -ge $(($activeMonitorID*$2+$2)) ];
            # then hyprctl dispatch workspace "$activeMonitorID"1;
            then hyprctl dispatch workspace $(($activeMonitorID*$2+$2));
            else hyprctl dispatch workspace r+1;
        fi
    ;;
    prev)
        if [ $activeWorkspaceID -le "$activeMonitorID"1 ];
            # then hyprctl dispatch workspace $(($activeMonitorID*$2+$2));
            then hyprctl dispatch workspace "$activeMonitorID"1;
            else hyprctl dispatch workspace r-1;
        fi
    ;;
esac
