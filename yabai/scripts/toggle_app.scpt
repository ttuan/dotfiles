on run argv
    set appName to item 1 of argv
    if application appName is running then
        tell application appName
            activate
        end tell
    else
        tell application appName
            launch
            activate
        end tell
    end if
end run
