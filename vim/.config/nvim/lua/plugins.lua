local packer = require("packer")
-- packer.init{
--   max_jobs = 3,
-- }
packer.startup(function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  -- vsnips
  use { "rafamadriz/friendly-snippets" }
  use { "hrsh7th/vim-vsnip", after = "nvim-cmp" }
  use { "hrsh7th/vim-vsnip-integ" }

  -- nvim-cmp
  use {
    "hrsh7th/nvim-cmp",
    --after = "nvim-lspconfig",
    config = function() require("plugins/cmp") end,
  }
  use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
  use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
  use { "hrsh7th/cmp-vsnip", after = "nvim-cmp" }

  -- lsp-config
  use {
    "neovim/nvim-lspconfig",
    after = {"cmp-nvim-lsp"},
    config = function() require("plugins/lspconfig") end,
  }

end)
