return {
  'tpope/vim-surround',  -- Add surroundings (quotes, parenthesis, etc)
  'airblade/vim-rooter', -- Auto cd to root of git repo
  'kevinhwang91/nvim-bqf',
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end
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

      vim.keymap.set("n", '<leader>sl', '<cmd>SessionManager load_current_dir_session<CR>',
        { desc = "Load current dir session" })
    end,
  },
  {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      require('mini.files').setup()
      require('mini.pairs').setup({
        modes = { insert = true, command = true, terminal = false },
        -- skip autopair when next character is one of these
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        -- skip autopair when the cursor is inside these treesitter nodes
        skip_ts = { "string" },
        -- skip autopair when next character is closing pair
        -- and there are more closing pairs than opening pairs
        skip_unbalanced = true,
        -- better deal with markdown code blocks
        markdown = true,
      })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({
        winopts = {
          split = "belowright new"
        },
      })
    end
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      terminal = { enabled = true },
      bufdelete = { enabled = true },
      statuscolumn = { enabled = false },
      indent = {},
      notifier = {},
      input = {
        enabled = true,
        win = {
          keys = {
            -- ESC drops back to normal mode instead of cancel by default
            i_esc = { "<esc>", "stopinsert", mode = "i" },
          },
        }
      },
      picker = { enabled = true },
    },
    keys = {
      { "<c-/>",           function() Snacks.terminal() end,                          desc = "Toggle Terminal" },
      { "<c-_>",           function() Snacks.terminal() end,                          desc = "which_key_ignore" },
      { "<c-c>",           function() Snacks.bufdelete.delete() end,                  desc = "delete buffer" },
      { "<leader>nh",      function() Snacks.notifier.show_history() end,             desc = "Show notification history" },

      -- Picker keymaps
      { "<leader><Enter>", function() Snacks.picker.buffers({ current = false }) end, desc = "Buffers" },
      -- { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
      -- { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
      -- { "<leader><space>", function() Snacks.picker.files() end,                                   desc = "Find Files" },
      -- find
      -- { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      -- { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      -- { "<leader>p",       function() Snacks.picker.files() end,          desc = "Find Files" },
      { "<leader>p",       function() Snacks.picker.git_files() end,                  desc = "Find Git Files" },
      -- { "<leader>pr",      function() Snacks.picker.recent() end,         desc = "Recent" },
      -- git
      -- { "<leader>gc",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
      -- { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      -- Grep
      -- { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      -- { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
      -- { "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
      -- { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      -- { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
      -- { "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
      -- { "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
      -- { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
      -- { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>h",       function() Snacks.picker.help() end,                       desc = "Help Pages" },
      -- { "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
      -- { "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
      -- { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
      -- { "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
      -- { "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
      -- { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
      { "<leader>sR",      function() Snacks.picker.resume() end,                     desc = "Resume" },
      -- { "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
      -- { "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
      -- { "<leader>qp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
      -- LSP
      -- { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
      { "gr",              function() Snacks.picker.lsp_references() end,             nowait = true,                     desc = "References" },
      { "gi",              function() Snacks.picker.lsp_implementations() end,        desc = "Goto Implementation" },
      -- { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
      -- { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
    }
  }
}
