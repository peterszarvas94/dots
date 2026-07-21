-- Custom keybindings (migrated from bindings.conf for Omarchy 4 / Hyprland Lua).

local function unbind(keys)
  hl.unbind(keys)
end

-- Unbind Omarchy defaults we override.
unbind("PRINT")
unbind("ALT + PRINT")
unbind("CTRL + SPACE")
unbind("SHIFT + PRINT")

unbind("SUPER + ALT + T")
unbind("SUPER + ALT + C")
unbind("SUPER + ALT + COMMA")
unbind("SUPER + ALT + DOWN")
unbind("SUPER + ALT + H")
unbind("SUPER + ALT + J")
unbind("SUPER + ALT + K")
unbind("SUPER + ALT + L")
unbind("SUPER + ALT + LEFT")
unbind("SUPER + ALT + P")
unbind("SUPER + ALT + RIGHT")
unbind("SUPER + ALT + S")
unbind("SUPER + ALT + UP")

unbind("SUPER + CTRL + COMMA")
unbind("SUPER + CTRL + PRINT")
unbind("SUPER + CTRL + E")

unbind("SUPER + SHIFT + B")
unbind("SUPER + SHIFT + P")
unbind("SUPER + SHIFT + ALT + COMMA")
unbind("SUPER + SHIFT + COMMA")
for code = 10, 18 do
  unbind("SUPER + SHIFT + code:" .. code)
end

unbind("SUPER + COMMA")
unbind("SUPER + DOWN")
unbind("SUPER + H")
unbind("SUPER + J")
unbind("SUPER + K")
unbind("SUPER + L")
unbind("SUPER + LEFT")
unbind("SUPER + PRINT")
unbind("SUPER + RIGHT")
unbind("SUPER + S")
unbind("SUPER + UP")
unbind("SUPER + Y")
for code = 10, 18 do
  unbind("SUPER + code:" .. code)
end

unbind("SUPER + SHIFT + T")

-- Focus (HJKL).
o.bind("SUPER + H", "Move focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Move focus down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Move focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Move focus right", hl.dsp.focus({ direction = "r" }))

-- Swap windows (HJKL).
o.bind("SUPER + SHIFT + H", "Swap window left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window right", hl.dsp.window.swap({ direction = "r" }))

-- Move window into group (HJKL).
o.bind("SUPER + ALT + H", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
o.bind("SUPER + ALT + J", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))
o.bind("SUPER + ALT + K", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
o.bind("SUPER + ALT + L", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))

-- Workspaces (number row keys).
for workspace = 1, 9 do
  o.bind("SUPER + " .. workspace, "Workspace " .. workspace, hl.dsp.focus({ workspace = tostring(workspace) }))
  o.bind(
    "SUPER + SHIFT + " .. workspace,
    "Move window to workspace " .. workspace,
    hl.dsp.window.move({ workspace = tostring(workspace) })
  )
end

-- Applications.
o.bind("SUPER + SHIFT + B", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + S", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + RETURN", "Terminal", { omarchy = "terminal" })
o.bind("SUPER + SHIFT + F", "Files", "uwsm app -- nautilus --new-window")
o.bind("SUPER + I", "Password Quick Access", "uwsm app -- 1password --quick-access")

-- Capture & picker.
o.bind("SUPER + SHIFT + P", "Screenshot", "omarchy-capture-screenshot")
o.bind("SUPER + ALT + P", "Screenrecording", "omarchy-menu screenrecord")
o.bind("SUPER + ALT + E", "Emoji picker", "omarchy-launch-walker -m symbols")
o.bind("SUPER + ALT + T", "Extract text (OCR)", "omarchy-capture-text-extraction")
o.bind("SUPER + ALT + C", "Color picker", "pkill hyprpicker || hyprpicker -a")

-- Notifications (N keys instead of comma).
o.bind("SUPER + N", "Dismiss last notification", "makoctl dismiss")
o.bind(
  "SUPER + CTRL + N",
  "Toggle silencing notifications",
  'makoctl mode -t do-not-disturb && makoctl mode | grep -q \'do-not-disturb\' && notify-send "Silenced notifications" || notify-send "Enabled notifications"'
)
o.bind("SUPER + ALT + N", "Invoke last notification", "makoctl invoke")
o.bind("SUPER + SHIFT + N", "Restore last notification", "makoctl restore")

-- Theme & tools.
o.bind("SUPER + SHIFT + T", "Cycle Rose Pine Themes", os.getenv("HOME") .. "/.local/share/dots/bin/theme")
o.bind("SUPER + D", "Toggle screen drawing overlay", "wayscriber --daemon-toggle")
o.bind("SUPER + SHIFT + S", "Speedtest", "omarchy-launch-tui /home/peti/.bun/bin/speedtui")

-- speedtui floating window (Super+Shift+S via omarchy-launch-tui)
-- 656x245 px = 82x15 ghostty cells (Berkeley Mono 9.5: 8px/col, 15px/row + 20px padding)
o.window("org.omarchy.speedtui", { float = true, center = true, size = { 656, 245 } })
