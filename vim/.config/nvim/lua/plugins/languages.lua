return {
  { 'plasticboy/vim-markdown', ft = { 'markdown' } },
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
