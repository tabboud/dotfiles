-- init.lua

-- If supported, compile lua to bytecode (e.g. cache modules).
if vim.loader and vim.fn.has "nvim-0.9" == 1 then vim.loader.enable() end

-- core
require("config.globals")
require("keymaps")
require("config.autocmds")

-- Plugin loading / config
require("config.lazy")

-- Options that include plugin settings
require("config.options")
