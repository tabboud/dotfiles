return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require("pluginconfig.lsp")
    end,
    dependencies = {
      -- Automatically install LSPs/tools to stdpath
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Better UI for hover, code-actions, and diagnostics
      "glepnir/lspsaga.nvim",

      -- Show current code context in the winbar
      "SmiteshP/nvim-navic",

      -- Get LSP loading status in the status bar
      "nvim-lua/lsp-status.nvim",
    },
  },
}
