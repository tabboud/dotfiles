-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.font = wezterm.font 'JetBrainsMono Nerd Font'

-- For example, changing the color scheme:
config.color_scheme = 'Tomorrow Night Eighties'
-- config.color_scheme = 'Tomorrow'

config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.97
config.audible_bell = "Disabled"

-- Make option+{left,right} go backwark/forward words on OSX
config.keys = {
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow",  mods = "OPT", action = wezterm.action { SendString = "\x1bb" } },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT", action = wezterm.action { SendString = "\x1bf" } },
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

-- and finally, return the configuration to wezterm
return config
