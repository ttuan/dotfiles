-- Helper function to check if the domain is already open
on checkForOpenTab(targetDomain)
    tell application "Google Chrome"
        repeat with w in windows
            set tabIndex to 0
            repeat with t in tabs of w
                set tabIndex to tabIndex + 1
                if URL of t contains targetDomain then
                    -- Switch to the window containing the tab
                    set index of w to 1
                    -- Switch to the correct tab
                    set active tab index of w to tabIndex
                    return true
                end if
            end repeat
        end repeat
    end tell
    return false
end checkForOpenTab

-- Main function to check for open tab and open new tab if needed
on run {targetDomain}
    tell application "Google Chrome"
        activate

        -- Check if the target domain is already open in any tab
        if not (my checkForOpenTab(targetDomain)) then
            -- Open a new tab
            tell window 1
                make new tab with properties {URL:"https://" & targetDomain}
                set active tab index to (count of tabs)
            end tell
        end if
    end tell
end run
