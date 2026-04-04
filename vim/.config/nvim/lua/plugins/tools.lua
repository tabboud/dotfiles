-- tools.lua
-- vim-surround and vim-rooter are pure vimscript plugins; no setup needed.

require("which-key").setup()

require("nvim-lastplace").setup({
  lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
  lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
  lastplace_open_folds = true
})

local config = require('session_manager.config')
require("session_manager").setup({
  autoload_mode = config.AutoloadMode.Disabled,
})
vim.keymap.set("n", '<leader>sl', '<cmd>SessionManager load_current_dir_session<CR>',
  { desc = "Load current dir session" })

require('grug-far').setup()
