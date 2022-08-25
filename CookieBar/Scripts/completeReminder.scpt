on run argv
    tell application "Reminders"
        set completed of (reminders whose name is (item 1 of argv)) to true
    end tell
end run
