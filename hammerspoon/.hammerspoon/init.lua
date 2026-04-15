local hotkey = require("hs.hotkey")
local applications = require("applications")
local notify = require("hs.notify")
local log = require("hs.logger").new('dotfiles')

---@class Config
---@field modKeys? table<string> Modifier keys
---@field apps? table<string, string> Map of key to app name (e.g. t = "terminal")
local config = {
  modKeys = { "cmd", "ctrl" },
  apps = {
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

-- Load overrides from a local overrides.lua file (gitignored)
---@type boolean, Config
local ok, overrides = pcall(require, "overrides")
if not ok then
  log.wf("No overrides found")
else
  -- modKey overrides
  if overrides.modKeys ~= nil then
    log.wf("ModKeys override found: Original (%s) Override (%s)", config.modKeys, overrides.modKeys)
    config.modKeys = overrides.modKeys
  end

  -- keymap overrides
  for key, app in pairs(overrides.apps or {}) do
    log.wf("App override: %s -> %s - Key: %s", config.apps[key], app, key)
    config.apps[key] = app
  end
end

-- Setup Application Toggling
applications.bind(config.modKeys, config.apps)

-- Toggle chooser to enable/disable application keymaps
hotkey.bind(config.modKeys, "v", function() applications.showToggleChooser() end)

-- Load ControlEscape which maps capslock to ESC when tapped and ctrl when held
hs.loadSpoon('ControlEscape'):start()

-- reload config with "config.modKeys + shift"
local reloadModKeys = {}
for _, v in ipairs(config.modKeys) do
  table.insert(reloadModKeys, v)
end
table.insert(reloadModKeys, "shift")

hotkey.bind(reloadModKeys, "R", function() hs.reload() end)
-- hotkey.bind(modKeys, "C", function() hs.toggleConsole() end)

notify.new({ title = 'Hammerspoon', informativeText = 'Ready to rock 🤘' }):send()
