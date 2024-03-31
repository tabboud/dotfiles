-- lazy.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({
  spec = {
    -- { import = "plugins.colorscheme" },
    -- { import = "plugins.completion" },
    -- { import = "plugins.languages" },
    -- { import = "plugins.git" },
    -- { import = "plugins.neo-tree" },
    { import = "plugins" },
  },
  -- install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = false, -- whether to automatically check for plugin updates
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
