local hotkey = require("hs.hotkey")
-- local applicationKeys = require("application-keys")
local applications = require("applications")
local notify = require("hs.notify")

local modKeys = { "cmd", "ctrl" }

-- Hammerspoon specific keybindings
hotkey.bind(modKeys, "R", function() hs.reload() end)
-- hotkey.bind(modKeys, "C", function() hs.toggleConsole() end)

-- Setup Application Toggling
applications.bind(modKeys, {
  -- { "Alacritty",                       "t" },
  -- { "iTerm",                           "t" },
  -- { "kitty",                           "t" },
  { "WezTerm",                         "t" },
  { "Visual Studio Code",              "c" },
  { "Google Chrome",                   "i" },
  { "Slack",                           "s" },
  { "Microsoft Outlook",               "o" },
  { "GoLand",                          "g" },
  { "IntelliJ IDEA Community Edition", "0" },
  { "Quip",                            "q" },
  { "1Password",                       "1" },
  { "Obsidian",                        "n" },
})
hotkey.bind(modKeys, "v", function() applications.showToggleChooser() end)

-- Load ControlEscape which maps capslock to ESC when tapped and ctrl when held
hs.loadSpoon('ControlEscape'):start()

notify.new({ title = 'Hammerspoon', informativeText = 'Ready to rock 🤘' }):send()
