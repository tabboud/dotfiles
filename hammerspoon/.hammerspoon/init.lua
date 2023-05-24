-- Hammerspoon Configs

-- Modules
local hotkey = require("hs.hotkey")
-- local alert = require("hs.alert")
-- local application = require("hs.application")
local applicationKeys = require("application-keys")
local notify = require("hs.notify")

-- Load ControlEscape which maps capslock to ESC when tapped and ctrl when held
hs.loadSpoon('ControlEscape'):start()

-- Fast Application Switching
applicationKeys.setup()

-- Shortcut to reload config
hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function() hs.reload() end)

-- Automatically toggle alacritty
-- hotkey.bind({ "ctrl" }, "space", function()
-- local alacritty = application.find('alacritty')
-- if alacritty:isFrontmost() then
--   alacritty:hide()
-- else
--   application.launchOrFocus("/Applications/Alacritty.app")
-- end
-- end)
-- hotkey.bind({ "ctrl" }, "space", function()
--   local alacritty = application.find('alacritty')
--   if alacritty ~= nil and alacritty:isFrontmost() then
--     alacritty:hide()
--   else
--     application.launchOrFocus("/Applications/Alacritty.app")
--     alacritty = application.find('alacritty')
--     alacritty.setFrontmost(alacritty)
--     alacritty.activate(alacritty)
--   end
-- end
-- )

notify.new({ title = 'Hammerspoon', informativeText = 'Ready to rock 🤘' }):send()
