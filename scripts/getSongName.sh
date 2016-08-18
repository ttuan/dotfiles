#!/bin/bash

apps="vlc totem rhythmbox banshee mplayer gnome-mplayer"

for app in $apps
do
  pat="([^\w-]$app)"
  if ps ux | grep -P $pat | grep -vq grep; then
    file=`lsof -F n -c "$app" | grep -i "^.*\.mp3$\|^.*\.mp4$" | sed 's/^n//g'`
    set -- "$file"
    IFS="/"; declare -a Array=($*)
    echo -n "${Array[-1]}"
  fi
done
