-- Hammerspoon Configs

-- Modules
require("hs.application")
require("hs.logger")
require("hs.screen")
require("hs.window")
require("hs.alert")

-- ctrlTap module
-- require("ctrltap")

local keys = require "keys"
require "triggers"

-- Logging
local log = hs.logger.new("My Config", "info")

-- Add Fast Application Switching
keys.deactivateKeys()
keys.activateKeys()

-- Reload config
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function() hs.reload() end)

-- Show date time and battery
hs.hotkey.bind({"cmd", "ctrl"}, "D", function()
  local seconds = 3
  local message = os.date("%I:%M%p") .. "\n" .. os.date("%a %b %d") .. "\nBattery: " ..
     hs.battery.percentage() .. "%"
  hs.alert.show(message, seconds)
end)

-- Install / Use Spoons
-- hs.loadSpoon("SpoonInstall")
-- spoon.SpoonInstall:andUse("WindowHalfsAndThirds",
--                {
--                  config = {
--                    use_frame_correctness = true
--                  },
--                  hotkeys = 'default',
--                }
-- )


-- Load ControlEscape which maps capslock to ESC when tapped and ctrl when held
hs.loadSpoon('ControlEscape'):start()

hs.notify.new({title='Hammerspoon', informativeText='Ready to rock 🤘'}):send()
