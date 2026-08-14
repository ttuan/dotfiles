-- Resize the frontmost window to a Messenger chat-frame size
-- and dock it at the bottom-right of the screen.
-- Tweak the three values below to taste.

set winWidth to 520
set winHeight to 800
set edgeMargin to 12

-- Get the usable desktop size (excludes the menu bar).
tell application "Finder"
	set screenBounds to bounds of window of desktop
	set screenWidth to item 3 of screenBounds
	set screenHeight to item 4 of screenBounds
end tell

-- Bottom-right anchor.
set posX to screenWidth - winWidth - edgeMargin
set posY to screenHeight - winHeight - edgeMargin

tell application "System Events"
	set frontApp to first application process whose frontmost is true
	try
		set frontWin to front window of frontApp
		-- Size first, then position, so the anchor stays correct.
		set size of frontWin to {winWidth, winHeight}
		set position of frontWin to {posX, posY}
	end try
end tell
