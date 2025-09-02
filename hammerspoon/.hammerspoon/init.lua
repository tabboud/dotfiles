local hotkey = require("hs.hotkey")
local applications = require("applications")
local notify = require("hs.notify")
local log = require("hs.logger").new('dotfiles')

---@class Config
---@field modKeys? table<string> Modifier keys
---@field keymaps? table<string, string> Key to application mappings
local config = {
  modKeys = { "cmd", "ctrl" },
  keymaps = {
    t = "WezTerm",
    c = "Visual Studio Code",
    i = "Google Chrome",
    s = "Slack",
    o = "Microsoft Outlook",
    g = "GoLand",
    q = "Quip",
    n = "Obsidian",
    ["0"] = "IntelliJ IDEA",
    ["1"] = "1Password",
  }
}

-- Load overrides from an external file
-- Example overrides.lua file:
--  return { keymaps = { n = "Notes" } }
local overridesPath = os.getenv("HOME") .. "/.local/dotfiles/hammerspoon/overrides.lua"
local ok, overrides = pcall(dofile, overridesPath)
if ok and type(overrides) == "table" then
  -- modKey overrides
  if overrides.modKeys ~= nil then
    log.wf("ModKeys override found: Original (%s) Override (%s)", config.modKeys, overrides.modKeys)
    config.modKeys = overrides.modKeys
  end

  -- keymap overrides
  for key, app in pairs(overrides.keymaps or {}) do
    log.wf("Application override: %s -> %s - Key: %s", config.keymaps[key], app, key)
    config.keymaps[key] = app
  end
else
  log.wf("No overrides found")
end

-- Setup Application Toggling
applications.bind(config.modKeys, config.keymaps)
-- Toggle chooser to enable/disable application keymaps
hotkey.bind(config.modKeys, "v", function() applications.showToggleChooser() end)

-- Load ControlEscape which maps capslock to ESC when tapped and ctrl when held
hs.loadSpoon('ControlEscape'):start()

-- Hammerspoon specific keybindings
hotkey.bind(config.modKeys, "R", function() hs.reload() end)
-- hotkey.bind(modKeys, "C", function() hs.toggleConsole() end)

notify.new({ title = 'Hammerspoon', informativeText = 'Ready to rock 🤘' }):send()
