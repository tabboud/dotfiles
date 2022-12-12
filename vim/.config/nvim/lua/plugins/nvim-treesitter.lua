require 'nvim-treesitter.configs'.setup({
  -- list of available parsers
  ensure_installed = {
    'go',
    'help',
    'json',
    'lua',
    'vim',
    'yaml',
  },

  highlight = {
    -- false disables the entire extension
    enable = true,
  },
})
