-- pack.lua
-- All plugin definitions using vim.pack (Neovim 0.12 built-in plugin manager).

-- Disable built-in plugins we don't use
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tohtml = 1
vim.g.loaded_tutor = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1

-- PackChanged hooks MUST be registered before vim.pack.add() so they fire on first install too
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end

    if name == 'blink.cmp' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('blink.cmp') end
      vim.cmd('BlinkCmp build')
    end
  end
})

vim.pack.add({
  -- Colorscheme
  'https://github.com/projekt0n/github-nvim-theme',

  -- LSP
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/glepnir/lspsaga.nvim',
  'https://github.com/SmiteshP/nvim-navic',

  -- Completion
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('*') },

  -- Snippets
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = 'v2.*' },
  'https://github.com/rafamadriz/friendly-snippets',

  -- Treesitter (track main branch explicitly)
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  -- UI
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/akinsho/bufferline.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',

  -- File explorer (stay on stable v3.x branch)
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = 'v3.x' },
  'https://github.com/MunifTanjim/nui.nvim',

  -- Snacks (picker, notifier, dashboard, input, indent)
  'https://github.com/folke/snacks.nvim',

  -- Diagnostics
  'https://github.com/folke/trouble.nvim',

  -- Git
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',

  -- Tools
  'https://github.com/tpope/vim-surround',
  'https://github.com/airblade/vim-rooter',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/ethanholz/nvim-lastplace',
  'https://github.com/Shatur/neovim-session-manager',
  'https://github.com/MagicDuck/grug-far.nvim',

  -- Shared dependencies
  'https://github.com/nvim-lua/plenary.nvim',

  -- Mini
  { src = 'https://github.com/echasnovski/mini.nvim', version = 'stable' },

  -- Languages
  'https://github.com/preservim/vim-markdown',
  'https://github.com/OXY2DEV/markview.nvim',
})

-- Note: nvim-dap, neotest, and Go adapters are NOT listed here.
-- They are lazy-loaded via FileType go autocmd in plugins/testing.lua.
-- The lockfile ensures they are installed at startup even though loading is deferred.
