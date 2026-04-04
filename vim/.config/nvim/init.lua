-- init.lua

-- Enable Lua bytecode caching for faster startup
vim.loader.enable()

-- core
require("config.globals")
require("config.keymaps")
require("config.autocmds")

-- Load all plugins via vim.pack
require("config.pack")

-- Configure each plugin group (order matters: colorscheme first)
require("plugins.colorscheme")
require("plugins.lsp")
require("plugins.snacks")
require("plugins.ui")
require("plugins.nvim-treesitter")
require("plugins.neo-tree")
require("plugins.trouble")
require("plugins.git")
require("plugins.testing")
require("plugins.tools")
require("plugins.mini")
require("plugins.languages")

-- Options (colorscheme must be loaded before this)
require("config.options")

require("virtual-text")
