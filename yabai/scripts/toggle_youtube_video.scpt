#!/usr/bin/osascript

tell application "Google Chrome"
    tell active tab of front window
        execute javascript "
            (function() {
                var video = document.querySelector('video');
                if (video) {
                    if (video.paused) {
                        video.play();
                    } else {
                        video.pause();
                    }
                    console.log(video.paused ? 'Video paused' : 'Video playing');
                } else {
                    console.log('No video element found on the page');
                }
            })();
        "
    end tell
end tell
