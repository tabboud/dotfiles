-----------------
-- Languages
-----------------
return {
  -- Markdown syntax and previewer via glow
  { 'plasticboy/vim-markdown', ft = { 'markdown' } },
  { "rhysd/vim-go-impl",       ft = { 'go' } },
  {
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('render-markdown').setup({})
    end,
  },
}
