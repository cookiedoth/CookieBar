tell application "Reminders"
    set activeReminders to name of (reminders of list "Reminders" whose completed is false)
end tell
tell application "System Events" to tell process "Reminders" to set visible to false
return activeReminders
