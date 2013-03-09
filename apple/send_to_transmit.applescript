-- Sends a file to Transmit (uses the DockSend feature)
-- Credit: https://github.com/tmallen/transmit-vim
on run argv
    set filepath to item 1 of argv
	set filename to POSIX file filepath
	ignoring application responses
		tell application "Transmit"
			open filename
		end tell
	end ignoring
end run 

