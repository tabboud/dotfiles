return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    event = { "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
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
          'vimdoc',
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
