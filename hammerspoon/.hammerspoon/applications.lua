-- Application key mappings
-- This file sets up the various hotkeys to use to
-- quickly switch between applications.
local M = {}

local alert = require("hs.alert")
local application = require("hs.application")
local hotkey = require("hs.hotkey")
local chooser = require("hs.chooser")

---@class AppBinding
---@field name string
---@field hotkey function
---@field enabled boolean

---@type AppBinding[]
local bindings = {}

-- Toggle application keybindings with a UI
local function getAppChooserForBindings()
  local completionFn = function(result)
    if result and result.bindingsIdx then
      local binding = bindings[result.bindingsIdx]
      if binding.enabled then
        -- prefer the binding.enabled field to allow for showing an alert when a keymap is disabled
        -- binding.hotkey:disable()
        binding.enabled = false
        alert.show("Disabled " .. binding.name)
      else
        -- binding.hotkey:enable()
        binding.enabled = true
        alert.show("Enabled " .. binding.name)
      end
    end
  end

  local function getChoices()
    local choices = {}

    for i, binding in ipairs(bindings) do
      local symbol = "✅"
      local status = "Enabled"
      if not binding.enabled then
        symbol = "⛔"
        status = "Disabled"
      end
      table.insert(choices,
        {
          text = binding.name,
          subText = string.format("%s %s", symbol, status),
          bindingsIdx = i,
        })
    end
    return choices
  end

  return chooser.new(completionFn):choices(getChoices)
end

--- Bind an application to a keymap.
--- Wraps a hammerspoon hotkey that shows an alert if the keymap is disabled.
---
---@param mods table<string>
---@param name string
---@param key string
---@return AppBinding
local function bindApp(mods, name, key)
  local hk = hotkey.bind(mods, key, function()
    for _, binding in ipairs(bindings) do
      if binding.name == name and not binding.enabled then
        alert.show(string.format("%s is disabled", binding.name))
        return
      end
    end
    application.launchOrFocus(name)
  end
  )

  return {
    name = name,
    hotkey = hk,
    enabled = true,
  }
end

local appChooser = nil

-- Bind application keys
---@param mods table<string>
---@param apps table<string, string>
function M.bind(mods, apps)
  for key, app in pairs(apps) do
    table.insert(bindings, bindApp(mods, app, key))
  end
  appChooser = getAppChooserForBindings()
end

function M.showToggleChooser()
  if appChooser then
    -- refresh before showing to ensure symbols update
    appChooser:refreshChoicesCallback()
    appChooser:show()
  end
end

return M
