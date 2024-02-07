-- Pull in the wezterm API
local wezterm = require 'wezterm'
local action = wezterm.action

local color_schemes = {
  Light = "One Light (Gogh)",
  Dark = "Tomorrow Night Eighties",
}

local function getCurrentTheme()
  local file = assert(io.open(os.getenv("HOME") .. "/.theme", "r"), 'Failed to open "$HOME/.theme"')
  local content = file:read("*a")
  file:close()
  return content
end

local function setDesiredTheme(theme)
  local file = assert(io.open(os.getenv("HOME") .. "/.theme", "w+"), 'Failed to open "$HOME/.theme"')
  file:write(theme)
  file:close()
end

-- toggle the current theme to/from dark and light.
local function toggleColorscheme(window, pane)
  wezterm.log_info('WindowID:', window:window_id(), 'PaneID:', pane:pane_id())
  local overrides = window:get_config_overrides() or {}
  local currentTheme = getCurrentTheme()

  if currentTheme == "dark" then
    setDesiredTheme("light")
    overrides.color_scheme = color_schemes.Light
  else
    setDesiredTheme("dark")
    overrides.color_scheme = color_schemes.Dark
  end

  wezterm.log_info(string.format("Current: %s Desired: %s", currentTheme, overrides.color_scheme))
  window:set_config_overrides(overrides)
end

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.initial_cols = 200
config.initial_rows = 30
config.font = wezterm.font {
  family = 'JetBrainsMono Nerd Font',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
}
config.color_scheme = getCurrentTheme() == "light" and color_schemes.Light or color_schemes.Dark
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.95
-- config.macos_window_background_blur = 50 -- blur background windows (useful when opacity is low)
config.audible_bell = "Disabled"
config.window_decorations = "RESIZE"
config.integrated_title_button_style = "MacOsNative"
config.integrated_title_buttons = { 'Close' }
config.keys = {
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow",  mods = "OPT",  action = wezterm.action { SendString = "\x1bb" } },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT",  action = wezterm.action { SendString = "\x1bf" } },
  -- Toggle FullScreen mode
  { key = 'Enter',      mods = 'CMD',  action = wezterm.action.ToggleFullScreen },
  -- Toggle colorscheme for light/dark mode
  { key = "t",          mods = "ALT",  action = wezterm.action_callback(toggleColorscheme) },
  -- Show debug overlay for logs
  { key = "Escape",     mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
  -- Open URL via quick select mode
  {
    key = "Enter",
    mods = "ALT",
    action = action.QuickSelectArgs {
      label = 'open url',
      patterns = { 'https?://\\S+' },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.open_with(url)
      end),
    },
  },
}
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(action.CopyTo("ClipboardAndPrimarySelection"), pane)
        window:perform_action(action.ClearSelection, pane)
      else
        window:perform_action(action({ PasteFrom = "Clipboard" }), pane)
      end
    end),
  },
}

return config
