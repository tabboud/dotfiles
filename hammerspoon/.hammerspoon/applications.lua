-- Application key mappings
-- This file sets up the various hotkeys to use to
-- quickly switch between applications.
local M = {}

local alert = require("hs.alert")
local application = require("hs.application")
local hotkey = require("hs.hotkey")
local chooser = require("hs.chooser")

local bindings = {}

-- Toggle application keybindings with a UI
local function getAppChooserForBindings()
  local completionFn = function(result)
    if result and result.bindingsIdx then
      local binding = bindings[result.bindingsIdx]
      if binding.enabled then
        binding.hotkey:disable()
        binding.enabled = false
        alert.show("Disabled " .. binding.name)
      else
        binding.hotkey:enable()
        binding.enabled = true
        alert.show("Enabled " .. binding.name)
      end
    end
  end

  local function getChoices()
    local choices = {}
    for i, binding in ipairs(bindings) do
      -- TODO: Use hs.chooser:refreshChoicesCallback() to refresh symbols
      local symbol = "✅"
      if not binding.enabled then
        symbol = "⛔"
      end
      table.insert(choices,
        {
          ["text"] = binding.name,
          ["subText"] = string.format("%s Toggle %s keybinding", symbol, binding.name),
          ["bindingsIdx"] = i,
        })
    end
    return choices
  end

  return chooser.new(completionFn):choices(getChoices)
end

local function bindApp(mods, name, key)
  return {
    name = name,
    hotkey = hotkey.bind(mods, key, function() application.launchOrFocus(name) end),
    enabled = true,
  }
end

local appChooser = nil

-- Bind application keys
---@param mods table
---@param apps table
function M.bind(mods, apps)
  for _, app in ipairs(apps) do
    local name = app[1]
    local key = app[2]
    table.insert(bindings, bindApp(mods, name, key))
  end
  appChooser = getAppChooserForBindings()
end

function M.showToggleChooser()
  if appChooser then
    appChooser:show()
  end
end

return M
