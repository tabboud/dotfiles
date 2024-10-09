return {
  { 'plasticboy/vim-markdown', ft = { 'markdown' } },
  { "rhysd/vim-go-impl",       ft = { 'go' } },
  {
    'MeanderingProgrammer/markdown.nvim',
    enabled = true,
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = 'markdown',
    config = function()
      require('render-markdown').setup({})
    end,
  },
}
