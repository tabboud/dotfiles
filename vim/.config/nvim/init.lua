-- init.lua

-- core
require("globals")
require("keymaps")
require("autocmds")
require("options")

-- Go specific settings
require("go")

-- Setup the package manager before trying to install plugins on first load.
if require("first_load")() then
  return
end
require("plugins")
