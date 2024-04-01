-- init.lua

-- If supported, compile lua to bytecode (e.g. cache modules).
if vim.loader and vim.fn.has "nvim-0.9" == 1 then vim.loader.enable() end

-- core
require("globals")
require("keymaps")
require("autocmds")

-- Plugin loading / config
require("lazy")

-- Options that include plugin settings
require("options")
