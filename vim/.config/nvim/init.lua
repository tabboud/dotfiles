-- init.lua

-- core
require("globals")
require("keymaps")
require("autocmds")

-- Go specific settings
require("go")

-- Setup the package manager before trying to install plugins on first load.
if require("first_load")() then
  return
end
require("plugins")

-- TODO: Options should not depend on plugins and should be in the core above
require("options")
