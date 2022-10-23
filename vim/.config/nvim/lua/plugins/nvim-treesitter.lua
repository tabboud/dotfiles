require 'nvim-treesitter.configs'.setup({
  -- list of available parsers
  ensure_installed = { 'go', 'json', 'yaml' },

  highlight = {
    -- false disables the entire extension
    enable = true,
    disable = { 'vim' },
  },
})
