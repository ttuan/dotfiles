set scaleStep to 1.05 -- Tăng 5%

-- Get screen size
tell application "Finder"
	set screenBounds to bounds of window of desktop
	set screenWidth to item 3 of screenBounds
	set screenHeight to item 4 of screenBounds
end tell

-- Get frontmost app
tell application "System Events"
	set frontApp to name of first application process whose frontmost is true
end tell

-- Get current window size and position
tell application frontApp
	try
		set currentBounds to bounds of front window
		set {x1, y1, x2, y2} to currentBounds

		set winWidth to (x2 - x1) * scaleStep
		set winHeight to (y2 - y1) * scaleStep

		set posX to (screenWidth - winWidth) / 2
		set posY to (screenHeight - winHeight) / 2

		set bounds of front window to {posX, posY, posX + winWidth, posY + winHeight}
	end try
end tell
