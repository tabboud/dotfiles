-- plugins.lua
-- All plugin definitions and references to configuration.

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({
  -----------------
  -- Theme / Tools
  -----------------
  { 'tpope/vim-surround' },   -- Add surroundings (quotes, parenthesis, etc)
  { 'Raimondi/delimitMate' }, -- Match parenthesis and quotes
  {
    'ntpeters/vim-better-whitespace',
    config = function()
      -- ignore trailing whitespace for dashboard-nvim
      vim.g.better_whitespace_filetypes_blacklist = { 'dashboard' }
    end
  },
  { 'airblade/vim-rooter' }, -- Auto cd to root of git repo
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-lua/lsp-status.nvim' },
    config = function()
      require("plugins.lualine")
    end
  },
  {
    'akinsho/bufferline.nvim',
    version = "v3.*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("bufferline").setup {
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "padded_slant",
        }
      }
      local keymaps = require("keymaps")
      keymaps.nnoremap("gn", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer: Go to next" })
      keymaps.nnoremap("gp", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer: Go to prev" })
    end,
    custom_keys = {
      -- { "gn", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
      -- { "gp", "<cmd>Neotree reveal<cr>", desc = "NeoTree" },
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    keys = {
      { "<leader>k", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
      { "<leader>f", "<cmd>Neotree reveal<cr>", desc = "NeoTree" },
    },
    config = function()
      require("plugins.neo-tree")
    end
  },
  {
    enabled = true,
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("plugins.indent-blankline").setup()
    end,
  },
  {
    'qpkorr/vim-bufkill', -- Bring sanity to closing buffers
    config = function()
      require('keymaps').nnoremap("<c-c>", "<cmd>BD<cr>", { desc = "Buffer: Delete" })
    end
  },
  {
    'tpope/vim-commentary', -- Toggle comments like sublime
    config = function()
      require('keymaps').noremap({ 'n', 'v' }, '<leader>/', '<cmd>Commentary<cr>', { desc = "Toggle comment" })
    end
  },
  {
    "NvChad/nvterm",
    config = function()
      require("nvterm").setup()
      require('keymaps').nnoremap('<leader><space>', function()
        return require("nvterm.terminal").toggle "horizontal"
      end, { desc = "Toggle terminal" })
    end,
  },
  -- TODO: Group keys with tool prefix
  -- TODO: Conditionally add keymaps based on current buffer (ex: Go tests and toggle tests only for Go files)
  {
    enabled = true,
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("plugins.todo-comments")
    end,
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "stevearc/aerial.nvim",
    config = function()
      require('aerial').setup()
    end
  },
  {
    'Bekaboo/deadcolumn.nvim'
  },
  -- save my last cursor position
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true
      })
    end,
  },
  {
    "Shatur/neovim-session-manager",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local config = require('session_manager.config')
      require("session_manager").setup({
        autoload_mode = config.AutoloadMode.Disabled,
      })
    end,
  },
  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    enabled = false,
    opts = function()
      local opts = {
        theme = "doom",
        config = {
          week_header = {
            enable = true,
            concat = "something else",
          },
          center = {
            { action = "Telescope find_files", desc = " Find file", icon = " ", key = "f" },
            { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
            { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
            { action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
            { action = "e $MYVIMRC", desc = " Config", icon = " ", key = "c" },
            -- { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
            {
              action = 'lua require("session_manager").load_session()',
              desc = " Restore Session",
              icon = " ",
              key = "s"
            },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = "qa", desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end
      return opts
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
  },

  ----------------
  -- DAP / Testing
  ----------------
  {
    'mfussenegger/nvim-dap',
    ft = { 'go' },
    config = function()
      require("plugins.dap").setup()
    end,
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
    },
  },
  {
    "nvim-neotest/neotest",
    ft = { 'go' },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Go test adapter
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("plugins.neotest")
    end
  },

  -----------------
  -- Git
  -----------------
  {
    'tpope/vim-fugitive',
    config = function()
      require('keymaps').nnoremap("<leader>gb", "<cmd>Git blame<cr>", { desc = "Git: blame" })
    end
  },
  {
    'TimUntersberger/neogit',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local neogit = require('neogit')
      neogit.setup()
      require('keymaps').nnoremap("<leader>gg", function() neogit.open({ kind = "split_above" }) end,
        { desc = "Git: Show status pane" })
    end,
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- only load this plugin on the following commands
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffViewLog' },
    config = function()
      require("diffview").setup({
        -- See ':h diffview-config-enhanced_diff_hl'
        enhanced_diff_hl = true,

        -- See ':h diffview-config-hooks'
        hooks = {
          diff_buf_read = function(_)
            -- Change local options in diff buffers
            -- vim.opt_local.wrap = false
            vim.opt_local.list = false
            vim.opt_local.colorcolumn = { 80 }
          end,

          diff_buf_win_enter = function(_, _, ctx)
            -- Highlight 'DiffChange' as 'DiffDelete' on the left, and 'DiffAdd' on the right.
            if ctx.layout_name:match("^diff2") then
              if ctx.symbol == "a" then
                vim.opt_local.winhl = table.concat({
                  "DiffAdd:DiffviewDiffAddAsDelete",
                  "DiffDelete:DiffviewDiffDelete",
                  "DiffChange:DiffAddAsDelete",
                  "DiffText:DiffDeleteText",
                }, ",")
              elseif ctx.symbol == "b" then
                vim.opt_local.winhl = table.concat({
                  "DiffDelete:DiffviewDiffDelete",
                  "DiffChange:DiffAdd",
                  "DiffText:DiffAddText",
                }, ",")
              end
            end
          end,
          view_opened = function(view)
            print(
              ("A new %s was opened on tab page %d!")
              :format(view.class:name(), view.tabpage)
            )
          end,

          -- TDA: An attempt to use hooks to set the colorscheme for diffview only.
          -- It's a bit buggy, but does work.
          view_enter = function()
            -- vim.cmd.colorscheme('github_light')
          end,
          view_leave = function()
            -- vim.cmd.colorscheme('darcula-solid')
          end,
        }
      })
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require("plugins.gitsigns")
    end
  },

  -----------------
  -- Languages
  -----------------
  -- Markdown syntax and previewer via glow
  { 'plasticboy/vim-markdown',            ft = { 'markdown' } },
  { "ellisonleao/glow.nvim",              config = true,                        cmd = "Glow" },
  { "rhysd/vim-go-impl",                  ft = { 'go' } },

  -----------------
  -- Color Schemes
  -----------------
  { "briones-gabriel/darcula-solid.nvim", dependencies = { "rktjmp/lush.nvim" } },
  { 'mcchrish/zenbones.nvim',             dependencies = { 'rktjmp/lush.nvim' } },
  { 'projekt0n/github-nvim-theme' },

  -----------------
  -- Treesitter
  -----------------
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'nvim-treesitter.configs'.setup({
        -- list of available parsers
        ensure_installed = {
          'go',
          'json',
          'lua',
          'markdown',
          'markdown_inline',
          'rust',
          'vim',
          'yaml',
        },

        highlight = {
          -- false disables the entire extension
          enable = true,
        },
      })
    end
  },

  -----------------
  -- LSP
  -----------------
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require("plugins.lsp")
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
      "mrded/nvim-lsp-notify"
    },
  },
  -- Provides a small window to show diagnostics, telescope results, etc.
  {
    "folke/trouble.nvim",
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require("trouble").setup {}
    end
  },
  {
    'mrded/nvim-lsp-notify',
    dependencies = { 'rcarriga/nvim-notify' },
    config = function()
      require('lsp-notify').setup({
        -- TODO: Re-enable after fixing nvim-notify startup errors -> https://github.com/mrded/nvim-lsp-notify/issues/11
        -- notify = require('notify'),
      })
    end
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.opt.termguicolors = true
      require("notify").setup({
        background_colour = "#000000",
      })
    end
  },

  ----------------
  -- Completion
  ----------------
  {
    'hrsh7th/nvim-cmp',
    config = function()
      require("plugins/cmp")
    end,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },
  {
    'L3MON4D3/LuaSnip',
    version = 'v1.*',
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },

  -----------------
  -- Telescope
  -----------------
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Allow neovim core to fill the telescope picker (e.g. lua vim.lsp.buf.code_action())
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      require("plugins.telescope").setup()
    end
  },
})
