-- Pull in the wezterm API
local wezterm = require 'wezterm'
local action = wezterm.action

local colorSchemes = {
  Light = "One Light (Gogh)",
  Dark = "Tomorrow Night Eighties",
}

local function getCurrentTheme()
  local file = assert(io.open(os.getenv("HOME") .. "/.theme", "r"), "Failed to open theme for reading")
  local content = assert(file:read("*a"), "Failed to read theme file")
  assert(file:close(), "Failed to close theme file")
  return content
end

-- toggle the current theme to/from dark and light.
local function toggleColorscheme(window, _)
  local overrides = window:get_config_overrides() or {}
  local currentTheme = getCurrentTheme()
  local desiredTheme = ""

  if currentTheme == "dark" then
    desiredTheme = "light"
    overrides.color_scheme = colorSchemes.Light
  else
    desiredTheme = "dark"
    overrides.color_scheme = colorSchemes.Dark
  end

  -- Update theme + reload window
  local f = assert(io.open(os.getenv("HOME") .. "/.theme", "w+"), "Failed to open theme for writing")
  assert(f:write(desiredTheme), "Failed to update theme")
  assert(f:close(), "Failed to close theme file")
  window:set_config_overrides(overrides)
end


local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.color_scheme = getCurrentTheme() == "dark" and colorSchemes.Dark or colorSchemes.Light
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
