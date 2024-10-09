tell application "iTerm2"
    repeat with aWindow in windows
        set currentTransparency to transparency of current session of aWindow
        if currentTransparency is equal to 0 then
            set transparency of current session of aWindow to 0.55 -- Set to 55% transparent
        else
            set transparency of current session of aWindow to 0 -- Set to fully opaque
        end if
    end repeat
end tell
