local alert = require "hs.alert"
local hotkey = require "hs.hotkey"

shortcutKey = {"cmd", "ctrl"}
local shortcuts = {
  ["normal"] = {},
}

Keys = {
  ["specialTriggers"] = {
  },
  ["triggers"] = {
    ["iTerm"] = {{shortcutKey, "t"}},
    -- ["Alacritty"] = {{shortcutKey, "t"}},
    ["Firefox"] = {{shortcutKey, "i"}},
    ["Google Chrome"] = {{shortcutKey, "c"}},
    ["Slack"] = {{shortcutKey, "s"}},
    ["Messages"] = {{shortcutKey, "m"}},
    ["Microsoft Outlook"] = {{shortcutKey, "o"}},
    ["GoLand"] = {{shortcutKey, "g"}},
    ["Quip"] = {{shortcutKey, "q"}},
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
