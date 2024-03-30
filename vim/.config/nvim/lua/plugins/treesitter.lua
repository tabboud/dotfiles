-----------------
-- Treesitter
-----------------
return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'nvim-treesitter.configs'.setup({
        -- list of available parsers
        ensure_installed = {
          'go',
          'json',
          'lua',
          'markdown',
          'markdown_inline',
          'rust',
          'vim',
          'yaml',
        },

        highlight = {
          -- false disables the entire extension
          enable = true,
        },
      })
    end
  },
}
