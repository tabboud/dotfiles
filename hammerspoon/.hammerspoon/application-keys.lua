-- Application key mappings
-- This file sets up the various hotkeys to use to
-- quickly switch between applications.
M = {}

local application = require("hs.application")
local hotkey = require("hs.hotkey")
local log = require("hs.logger").new("Application Keys", "info")

local shortcutKey = { "cmd", "ctrl" }

local keymaps = {
  -- { app = "iTerm", keymap = "t" },
  { app = "Alacritty", keymap = "t" },
  -- { app = "kitty", keymap = "t" },
  { app = "Google Chrome", keymap = "i" },
  { app = "Slack", keymap = "s" },
  { app = "Microsoft Outlook", keymap = "o" },
  { app = "GoLand", keymap = "g" },
  { app = "IntelliJ IDEA Community Edition", keymap = "0" },
  { app = "Quip", keymap = "q" },
}

local bind_key_for = function(app_name, func)
  local keys = Keys[app_name]
  local normalKeys = keys[1]
  shortcuts["normal"][app_name] = hotkey.new(normalKeys[1], normalKeys[2], func)
end

-- Setup the applications to bind to based on the configured key mapping/trigger.
for _, keymap in ipairs(keymaps) do
  local launchOrFocus = function()
    application.launchOrFocus(keymap.app)
  end
end


M.deactivate = function()
  for _, keys in pairs(shortcuts) do
    for _, k in pairs(keys) do
      k:disable()
    end
  end
end

M.activate = function()
  local keys = shortcuts["normal"]
  for _, k in pairs(keys) do
    log.i(k)
    k:enable()
  end
end

-- Returns a string that contains all currently mapped keys
-- for use in an alert.
M.getAlertMapping = function()
  local allKeys = ""

  -- TODO(): sort the table for consistent output
  for appName, mappings in pairs(Keys.triggers) do
    local normalKeys = mappings[1]
    local appKey = normalKeys[2]
    local modKeys = ""

    for _, v in pairs(normalKeys[1]) do
      modKeys = modKeys .. v .. "+"
    end

    allKeys = allKeys .. string.format("%-32s:\t%s", appName, modKeys .. appKey) .. "\n"
  end
  return allKeys
end

return M
