on run
	tell application "System Events"
		set num to count (every process whose name is "PandoraBoy")
	end tell
	if num > 0 then
		tell application "PandoraBoy"
			activate
			set current station to previous station
		end tell
	end if
end run