-- init.lua

-- ensure packer is installed and setup plugins
-- TODO: This should be moved after the core is applied
--      however we set the treesitter foldexpr here so it has to be before the core
require("plugins")

-- Core
require("options")
require("keymaps")
require("autocmds")

-- Go specific settings
require("go")
