on run
	set info to ""
	tell application "System Events"
		set num to count (every process whose name is "PandoraBoy")
	end tell
	if num > 0 then
		tell application "PandoraBoy"
			activate
			set currentStation to name of current station
			set nextStation to name of next station
			set previousStation to name of previous station
			set who to artist of current track
			set what to name of current track
			set onwhat to album of current track
			set playerState to player state
			set info to "CurrentStation:" & currentStation & linefeed & "NextStation:" & nextStation & linefeed & "PreviousStation:" & previousStation & linefeed & "Artist:" & who & linefeed & "Name:" & what & linefeed & "Album:" & onwhat & linefeed & "PlayerState:" & playerState as string
		end tell
	end if
	return info
end run