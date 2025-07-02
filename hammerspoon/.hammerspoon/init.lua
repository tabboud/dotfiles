local hotkey = require("hs.hotkey")
-- local applicationKeys = require("application-keys")
local applications = require("applications")
local notify = require("hs.notify")

local modKeys = { "cmd", "ctrl" }

-- Hammerspoon specific keybindings
hotkey.bind(modKeys, "R", function() hs.reload() end)
-- hotkey.bind(modKeys, "C", function() hs.toggleConsole() end)

local applicationKeymaps = {
  t = "WezTerm",
  c = "Visual Studio Code",
  i = "Google Chrome",
  s = "Slack",
  o = "Microsoft Outlook",
  g = "GoLand",
  q = "Quip",
  n = "Obsidian",
  ["0"] = "IntelliJ IDEA",
  ["1"] = "1Password",
}

-- Setup Application Toggling
applications.bind(modKeys, applicationKeymaps)
hotkey.bind(modKeys, "v", function() applications.showToggleChooser() end)

-- Load ControlEscape which maps capslock to ESC when tapped and ctrl when held
hs.loadSpoon('ControlEscape'):start()

notify.new({ title = 'Hammerspoon', informativeText = 'Ready to rock 🤘' }):send()
