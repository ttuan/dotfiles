set scaleStep to 1.05 -- Tăng 5%

-- Get screen size
tell application "Finder"
	set screenBounds to bounds of window of desktop
	set screenWidth to item 3 of screenBounds
	set screenHeight to item 4 of screenBounds
end tell

-- Use System Events to get frontmost app and window
tell application "System Events"
	set frontApp to first application process whose frontmost is true
	try
		set currentBounds to position of front window of frontApp
		set winSize to size of front window of frontApp

		set {x1, y1} to currentBounds
		set {w, h} to winSize

		set newWidth to w * scaleStep
		set newHeight to h * scaleStep

		set posX to (screenWidth - newWidth) / 2
		set posY to (screenHeight - newHeight) / 2

		set position of front window of frontApp to {posX, posY}
		set size of front window of frontApp to {newWidth, newHeight}
	end try
end tell
