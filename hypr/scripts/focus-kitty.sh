#!/bin/sh
function get_kitty() {
    # hyprctl clients -j | jq -r '.[] | select(.class == "kitty") | .address'
    hyprctl clients -j | jq '.[] | select(.class == "kitty")'
}

active_workspace="$(hyprctl activeworkspace -j | jq -r '.id')"
kitty="$(get_kitty)"
kitty_address="$(echo $kitty | jq -r '.address' )"
kitty_workspace=$(echo $kitty | jq -r '.workspace.id' )

if [ "$kitty_address" == "" ];
then
    kitty &
else
    kitty="$(get_kitty)"
    kitty_address="$(echo $kitty | jq -r '.address' )"
fi

if (($active_workspace == $kitty_workspace))
then
    hyprctl dispatch movetoworkspacesilent "name:terminal,address:$kitty_address"
else
    hyprctl dispatch movetoworkspace "$active_workspace,address:$kitty_address"
    hyprctl dispatch focuswindow "address:$kitty_address"
    hyprctl dispatch resizeactive "exact 80% 80%"
    hyprctl dispatch centerwindow
fi
