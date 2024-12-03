return {
  { 'plasticboy/vim-markdown', ft = { 'markdown' } },
  { "rhysd/vim-go-impl",       ft = { 'go' } },
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    }
  }
}
