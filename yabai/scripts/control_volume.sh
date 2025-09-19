#!/bin/bash
# ~/.config/yabai/scripts/control_volume.sh

direction="$1"
step=10

osascript <<EOF
set stepSize to $step
set vol to output volume of (get volume settings)
set isMuted to output muted of (get volume settings)

if "$direction" is "up" then
    set newVol to vol + stepSize
    if newVol > 100 then set newVol to 100
    set volume output volume newVol
else if "$direction" is "down" then
    set newVol to vol - stepSize
    if newVol < 0 then set newVol to 0
    set volume output volume newVol
else if "$direction" is "mute" then
    set volume with output muted
else if "$direction" is "unmute" then
    set volume without output muted
else if "$direction" is "toggle" then
    if isMuted is true then
        set volume without output muted
    else
        set volume with output muted
    end if
end if
EOF
