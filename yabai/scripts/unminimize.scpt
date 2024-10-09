# https://talk.automators.fm/t/unminimize-windows-of-the-current-application/12360/5
tell application id ("com.apple.systemevents")  ¬
  to tell (process 1 where it is frontmost) ¬
  to tell (windows whose attribute named "AXMinimized"'s value is true) ¬
  to if (it exists) then set the value of its attribute named "AXMinimized" of item 1 to false
