-- Application key mappings
-- This file sets up the various hotkeys to use to
-- quickly switch between applications.
--
local application = require("hs.application")
local hotkey = require("hs.hotkey")
local log = require("hs.logger").new("Application Keys", "info")

shortcutKey = { "cmd", "ctrl" }
local shortcuts = {
  ["normal"] = {},
}

Keys = {
  ["specialTriggers"] = {},
  ["triggers"] = {
    -- ["iTerm"] = {{shortcutKey, "t"}},
    ["Alacritty"] = { { shortcutKey, "t" } },
    -- ["kitty"] = { { shortcutKey, "t" } },
    ["Google Chrome"] = { { shortcutKey, "i" } },
    ["Slack"] = { { shortcutKey, "s" } },
    ["Messages"] = { { shortcutKey, "m" } },
    ["Microsoft Outlook"] = { { shortcutKey, "o" } },
    ["GoLand"] = { { shortcutKey, "g" } },
    ["IntelliJ IDEA Community Edition"] = { { shortcutKey, "0" } },
    ["Visual Studio Code"] = { { shortcutKey, "c" } },
    ["Quip"] = { { shortcutKey, "q" } },
  },
}

function Keys.keyFor(name)
  local keys = Keys.triggers[name]
  if not keys then
    keys = Keys.specialTriggers[name]
  end

  return keys
end

function Keys.bindKeyFor(appName, fn)
  keys = Keys.keyFor(appName)
  normalKeys = keys[1]
  shortcuts["normal"][appName] = hotkey.new(normalKeys[1], normalKeys[2], fn)
end

function Keys.deactivate()
  for _, keys in pairs(shortcuts) do
    for __, k in pairs(keys) do
      k:disable()
    end
  end
end

function Keys.activate()
  keys = shortcuts["normal"]
  for _, k in pairs(keys) do
    log.i(k)
    k:enable()
  end
end

-- Setup the applications to bind to based on the configured key mapping/trigger.
for applicationName, _ in pairs(Keys.triggers) do
  Keys.bindKeyFor(applicationName, function()
    application.launchOrFocus(applicationName)
  end)
end

-- Returns a string that contains all currently mapped keys
-- for use in an alert.
function Keys.getAlertMapping(name)
  local allKeys = ""

  -- TODO(): sort the table for consistent output
  for appName, mappings in pairs(Keys.triggers) do
    normalKeys = mappings[1]
    appKey = normalKeys[2]
    local modKeys = ""
    for k, v in pairs(normalKeys[1]) do
      modKeys = modKeys .. v .. "+"
    end

    allKeys = allKeys .. string.format("%-32s: %s", appName, modKeys .. appKey) .. "\n"
  end
  return allKeys
end

return Keys
