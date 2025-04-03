-- Example: 70% of screen size
set scale to 0.6

tell application "Finder"
	set screenBounds to bounds of window of desktop
	set screenWidth to item 3 of screenBounds
	set screenHeight to item 4 of screenBounds
end tell

set winWidth to screenWidth * scale
set winHeight to screenHeight * scale
set posX to (screenWidth - winWidth) / 2
set posY to (screenHeight - winHeight) / 2

tell application "System Events"
	set frontApp to name of first application process whose frontmost is true
end tell

tell application frontApp
	try
		set bounds of front window to {posX, posY, posX + winWidth, posY + winHeight}
	end try
end tell
