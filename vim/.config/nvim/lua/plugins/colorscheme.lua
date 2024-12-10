return {
  {
    "briones-gabriel/darcula-solid.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    enabled = false,
  },
  {
    'projekt0n/github-nvim-theme',
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      require('github-theme').setup({
        options = {
          transparent = true,
        }
      })
    end
  },
  {
    'mcchrish/zenbones.nvim',
    enabled = false,
    dependencies = { 'rktjmp/lush.nvim' }
  },
  {
    "tabboud/darcula-dark.nvim",
    enabled = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  }
}
