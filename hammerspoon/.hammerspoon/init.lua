-- Hammerspoon Configs

-- Modules
local alert = require("hs.alert")
local applicationKeys = require("application-keys")

-- Shortcut to reload config
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function() hs.reload() end)

-- Show date, time, and battery life
hs.hotkey.bind({"cmd", "ctrl"}, "D", function()
  local seconds = 3
  local message = os.date("%I:%M%p") .. "\n" .. os.date("%a %b %d") .. "\nBattery: " ..
     hs.battery.percentage() .. "%"
  alert.show(message, seconds)
end)

-- Load ControlEscape which maps capslock to ESC when tapped and ctrl when held
hs.loadSpoon('ControlEscape'):start()

-- Fast Application Switching
applicationKeys.deactivate()
applicationKeys.activate()


-- List the current application key mappings in an alert window
hs.hotkey.bind({"cmd", "ctrl"}, "N", function()
  local seconds = 5
  local allApplicationKeys = applicationKeys.getAlertMapping()
  alert.show(allApplicationKeys, seconds)
end)

hs.notify.new({title='Hammerspoon', informativeText='Ready to rock 🤘'}):send()
