#!/bin/bash

TERM_HANDLE=`xdotool getwindowfocus`;
xdotool search --onlyvisible --class "firefox" windowfocus && xdotool key Ctrl+r;
xdotool windowactivate $TERM_HANDLE;

# Move this file to /usr/local/bin and chmod a+x this file
