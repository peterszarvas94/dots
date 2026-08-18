-- Disable Omarchy's workspace layout toggle.
hl.unbind("SUPER + L")

-- Notification shortcuts that replace Omarchy's comma bindings.
o.bind("SUPER + N", "Dismiss last notification", "omarchy-shell notifications dismissOne")
o.bind("SUPER + ALT + N", "Invoke last notification", "omarchy-shell notifications invokeLast")
o.bind("SUPER + SHIFT + ALT + N", "Open notification history", "omarchy-shell notifications showHistory")

-- Healthy Pomodoro: focus, movement, posture, and screen-rest prompts.
o.bind("SUPER + CTRL + ALT + P", "Healthy Pomodoro", "omarchy-shell shell toggle peti.pomodoro")
