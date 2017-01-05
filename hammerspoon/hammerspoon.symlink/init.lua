-- Hammerspoon Configs

-- Modules
require("hs.application")
require("hs.logger")
require("hs.screen")
require("hs.window")


local log = hs.logger.new("My Config")

hs.window.animationDuration = 0


-- Functions
local function openIterm()
  application.launchOrFocus('iTerm')
end

local function setupWorkLayout()
  -- get my main Dell27 screen
  local monitor = hs.screen.allScreens()[2]:name()
  local iterm = hs.application.find("iterm")
  local emacs = hs.application.find("emacs")
  local messages = hs.application.find("messages")
  local citrix = hs.application.find("citrix viewer")

  -- check if the applications are running, and start if not


  local windowLayout = {
    {citrix, nil, monitor, hs.layout.right70, nil, nil},
    -- put on bottom left
    {iterm, nil, monitor, nil, nil, nil},
    {messages, nil, monitor, hs.layout.left30, nil, nil},
    -- put on top left
    {emacs, nil, monitor, hs.layout.left30, nil, nil},
  }
  log.d("setting up workspace")
  hs.layout.apply(windowLayout)
  log.d("Done")
end


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", setupWorkLayout)


-- Hello World
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", openIterm)
-- End
