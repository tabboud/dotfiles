-- init.lua

-- ensure packer is installed and setup plugins
-- TODO: This should be moved after the core is applied
--      however we set the treesitter foldexpr here so it has to be before the core
require("config.plugins")

----------------------
-- Core
----------------------
local core = require("config.core")
core.apply_options()
core.apply_keymaps()
core.apply_autogroups()

-- Go specific functions
require("go/alternate")
