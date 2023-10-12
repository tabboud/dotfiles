-- Application key mappings
-- This file sets up the various hotkeys to use to
-- quickly switch between applications.
M = {}

local alert = require("hs.alert")
local application = require("hs.application")
local hotkey = require("hs.hotkey")

local modKeys = { "cmd", "ctrl" }
local keymaps = {
  -- { app = "iTerm",                           key = "t" },
  { app = "WezTerm",                         key = "t" },
  -- { app = "kitty", key = "t" },
  -- { app = "Alacritty", key = "t" },
  { app = "Google Chrome",                   key = "i" },
  { app = "Slack",                           key = "s" },
  { app = "Microsoft Outlook",               key = "o" },
  { app = "GoLand",                          key = "g" },
  { app = "IntelliJ IDEA Community Edition", key = "0" },
  { app = "Quip",                            key = "q" },
  { app = "1Password",                       key = "1" },
}
local boundKeys = {}

-- Returns a string that contains all currently mapped keys for use in an alert.
local getAlertMapping = function()
  local allKeys = ""
  for _, keymap in ipairs(keymaps) do
    local mod_keys = ""
    for _, v in ipairs(modKeys) do
      mod_keys = mod_keys .. v .. "+"
    end
    allKeys = allKeys .. string.format("%s:    %s", mod_keys .. keymap.key, keymap.app) .. "\n"
  end
  return allKeys
end

local toggleApp = function(app, enable)
  if enable then
    boundKeys[app] = boundKeys[app]:enable()
  else
    boundKeys[app] = boundKeys[app]:disable()
  end
end

local enableWorkMode = true

-- Setup the applications to bind to based on the configured key mappings.
M.setup = function()
  for _, keymap in ipairs(keymaps) do
    local key = hotkey.bind(modKeys, keymap.key, function()
      application.launchOrFocus(keymap.app)
    end)
    boundKeys[keymap.app] = key
  end

  --- toggle mappings for work
  hotkey.bind({ "cmd", "ctrl" }, "W", function()
    toggleApp("Microsoft Outlook", enableWorkMode)
    toggleApp("Slack", enableWorkMode)

    local notifyText = ""
    if enableWorkMode then
      enableWorkMode = false
      notifyText = "✅ Enabled"
    else
      enableWorkMode = true
      notifyText = "⛔ Disabled"
    end
    hs.notify.new({ title = 'Work Mode', informativeText = notifyText }):send()
  end)

  -- List the current application key mappings in an alert window
  hotkey.bind({ "cmd", "ctrl" }, "N", function()
    alert.show(getAlertMapping())
  end)
end

return M
