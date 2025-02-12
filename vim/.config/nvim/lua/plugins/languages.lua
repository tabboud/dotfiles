return {
  { 'plasticboy/vim-markdown', ft = { 'markdown' } },
  { "rhysd/vim-go-impl",       ft = { 'go' } },
  {
    "OXY2DEV/markview.nvim",
    enabled = false,
    lazy = false, -- Recommended
    ft = { 'markdown' },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    }
  }
}
