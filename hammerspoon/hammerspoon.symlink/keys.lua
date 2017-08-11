local alert = require "hs.alert"
local hotkey = require "hs.hotkey"

hyper = {"cmd", "alt", "ctrl", "shift"}
shortcutKey = {"alt"}
local shortcuts = {
  ["normal"] = {},
}

Keys = {
  ["specialTriggers"] = {
  },
  ["triggers"] = {
    ["iTerm"] = {{shortcutKey, "1"}, {hyper, "S"}},
    ["Google Chrome"] = {{shortcutKey, "2"}, {hyper, "F"}},
    ["Slack"] = {{shortcutKey, "3"}, {hyper, "B"}},
    ["Microsoft Outlook"] = {{shortcutKey, "4"}, {hyper, "O"}},
    -- ["Dash"] = {{{"cmd", "shift"}, "E"}, {hyper, "E"}},
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
  ergodoxKeys = keys[2]
  shortcuts["normal"][appName] = hotkey.new(normalKeys[1], normalKeys[2], fn)
end

function Keys.deactivateKeys()
  for _, keys in pairs(shortcuts) do
    for __, k in pairs(keys) do
      k:disable()
    end
  end
end

function Keys.activateKeys()
  keys = shortcuts["normal"]
  for _, k in pairs(keys) do
    k:enable()
  end
end

return Keys
