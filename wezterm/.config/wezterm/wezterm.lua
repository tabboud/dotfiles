-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.color_scheme = 'Tomorrow Night Eighties'
-- config.color_scheme = 'Tomorrow'

config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.87
-- config.macos_window_background_blur = 50 -- blur background windows (useful when opacity is low)

config.audible_bell = "Disabled"

config.keys = {
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow",  mods = "OPT", action = wezterm.action { SendString = "\x1bb" } },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT", action = wezterm.action { SendString = "\x1bf" } },
  -- Toggle FullScreen mode
  { key = 'Enter',      mods = 'CMD', action = wezterm.action.ToggleFullScreen },
}

config.window_decorations = "RESIZE"
config.integrated_title_button_style = "MacOsNative"
config.integrated_title_buttons = { 'Close' }
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
      end
    end),
  },
}

return config
