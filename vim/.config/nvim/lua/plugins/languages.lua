-----------------
-- Languages
-----------------
return {
  -- Markdown syntax and previewer via glow
  { 'plasticboy/vim-markdown', ft = { 'markdown' } },
  { "rhysd/vim-go-impl",       ft = { 'go' } },
  {
    'MeanderingProgrammer/markdown.nvim',
    enabled = false,
    main = 'render-markdown',
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('render-markdown').setup({})
    end,
  },
}
