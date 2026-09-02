hl.config({
  general = {
    gaps_out = 3,
    gaps_in  = 3,
    col      = {
      active_border   = active_border,
      inactive_border = inactive_border,
    },
  },
  misc = {
    force_default_wallpaper = 0,
  },
  decoration = {
    rounding = 2,
  },
  ecosystem = {
    no_update_news  = true,
    no_donation_nag = true,
  },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- MONITORS

hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-2", mode = "2560x1440@60", position = "0x0", scale = 1 })

-- AUTOSTART

hl.on("hyprland.start", function()
  hl.exec_cmd(terminal)
end)

-- KEYBINDS

-- App launchers
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd(launcher))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("wofi-bookmarks"))
hl.bind(mod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("quick-access-kitty"))
hl.bind(mod .. " + S", hl.dsp.exec_cmd(app .. " steam"))
hl.bind(mod .. " + A", hl.dsp.exec_cmd(webapp .. "=https://chatgpt.com"))
hl.bind(mod .. " + W", hl.dsp.exec_cmd(webapp .. "=https://web.whatsapp.com/"))
hl.bind(mod .. " + K", hl.dsp.exec_cmd(webapp .. "=https://remap-keys.app/configure"))

-- Session
hl.bind(mod .. " + Q", hl.dsp.exec_cmd("hyprctl-conditional-quit"))

-- Clipboard
hl.bind(mod .. " + V", hl.dsp.exec_cmd("cliphist list | " .. app .. " wofi --dmenu | cliphist decode | wl-copy"))

-- Move window
hl.bind(window_mod .. " + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(window_mod .. " + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(window_mod .. " + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(window_mod .. " + J", hl.dsp.window.move({ direction = "down" }))

-- Resize window
hl.bind(window_mod .. " + Left", hl.dsp.window.resize({ x = -240, y = 0, relative = true }))
hl.bind(window_mod .. " + Right", hl.dsp.window.resize({ x = 180, y = 0, relative = true }))
hl.bind(window_mod .. " + Up", hl.dsp.window.resize({ x = 0, y = -240, relative = true }))
hl.bind(window_mod .. " + Down", hl.dsp.window.resize({ x = 0, y = 180, relative = true }))

-- Focus
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Layout / workspaces
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + G", hl.dsp.focus({ workspace = 10 }))
hl.bind(mod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" && notify-send -a 'Grim' 'Screenshot taken']]))

-- Special workspace
hl.bind(mod .. " + X", hl.dsp.workspace.toggle_special())
hl.bind(window_mod .. " + X", hl.dsp.window.move({ workspace = "special" }))

-- Workspace switch and move (1–9)
for i = 1, 9 do
  hl.bind(mod .. " + code:" .. (9 + i), hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + code:" .. (9 + i), hl.dsp.window.move({ workspace = i }))
end

-- Mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

-- Media: repeating + locked (bindle)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("media-control volume_up"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("media-control volume_down"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("media-control brightness_up"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("media-control brightness_down"), { repeating = true, locked = true })

-- Media: locked only (bindl)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("media-control volume_mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("media-control mic_mute"), { locked = true })
hl.bind("F8", hl.dsp.exec_cmd("media-control play_pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("media-control play_pause"), { locked = true })
hl.bind("F9", hl.dsp.exec_cmd("media-control next"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("media-control next"), { locked = true })
hl.bind("F7", hl.dsp.exec_cmd("media-control prev"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("media-control prev"), { locked = true })

-- WINDOW RULES

hl.window_rule({ match = { class = ".*" }, idle_inhibit = "fullscreen" })
hl.window_rule({ match = { float = true }, center = true })

hl.window_rule({ match = { class = "^(wofi)$" }, stay_focused = true })

hl.window_rule({ match = { title = "^(Volume Control|Friends List|Steam Settings|Extension.*Mozilla Firefox)$" }, float = true })

hl.window_rule({ match = { class = "^(org.kde.dolphin)$" }, float = true, size = "1200 800", workspace = "special" })

hl.window_rule({ match = { class = "^steam_app\\d+$" }, fullscreen = true })

hl.window_rule({ match = { title = "^(QuickAccessKitty)$" }, float = true, size = "1200 800", workspace = "special" })

hl.window_rule({ match = { class = "^(kitty)$" }, workspace = "1" })
hl.window_rule({ match = { class = "^(firefox)$" }, workspace = "2" })
hl.window_rule({ match = { class = "^(chrome-.+__-Default|Spotify|discord|1password)$" }, workspace = "3" })
hl.window_rule({ match = { title = "^(Remap)$" }, workspace = "3" })
hl.window_rule({ match = { class = "^(steam|org.prismlauncher.PrismLauncher|info.mumble.Mumble)$" }, workspace = "9" })
hl.window_rule({ match = { title = "^(Steam)$" }, workspace = "9" })
hl.window_rule({ match = { class = "^(steam_app_[0-9]+|dwarfort|Minecraft.*)$" }, workspace = "10" })
