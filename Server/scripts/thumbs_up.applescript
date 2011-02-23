on run
	tell application "System Events"
		set num to count (every process whose name is "PandoraBoy")
	end tell
	if num > 0 then
		tell application "PandoraBoy"
			activate
			thumbs up
		end tell
	end if
end run