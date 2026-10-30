#!/usr/bin/osascript

-- Usage: osascript seek_youtube_video.scpt <seconds>   (negative = rewind)
on run argv
    set offsetSeconds to "5"
    if (count of argv) > 0 then set offsetSeconds to item 1 of argv

    tell application "Google Chrome"
        tell active tab of front window
            execute javascript "
                (function() {
                    var video = document.querySelector('video');
                    if (video) {
                        var target = video.currentTime + (" & offsetSeconds & ");
                        video.currentTime = Math.max(0, Math.min(target, video.duration || target));
                        console.log('Seeked to ' + video.currentTime);
                    } else {
                        console.log('No video element found on the page');
                    }
                })();
            "
        end tell
    end tell
end run
