return {
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
      require('neo-tree').setup({
        source_selector = {
          winbar = true,
          sources = {
            { source = "filesystem" },
            { source = "git_status" },
          },
        },
        -- hide stats columns when using "width = 'fit_content'
        default_component_configs = {
          file_size = { enabled = false },
          type = { enabled = false },
          last_modified = { enabled = false },
          created = { enabled = false },
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = true,
            never_show = {
              '.DS_Store',
            },
          },
        },
        window = {
          -- width = 'fit_content',
          width = 50,
          -- max_width = 50,
          mappings = {
            ['S'] = function(state)
              local node = state.tree:get_node()
              local path = vim.fn.fnamemodify(node.path, ":.")
              require('telescope.builtin').live_grep({
                search_dirs = { path },
              })
            end,
            ['Y'] = function(state)
              -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
              -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
              local node = state.tree:get_node()
              local filepath = node:get_id()
              local modify = vim.fn.fnamemodify

              local results = {
                filepath,               -- absolute path to file (e.g. /Users/user/project/cmd/main.go)
                modify(filepath, ':.'), -- path relative to CWD, usually the root of a git repo (e.g. cmd/main.go)
              }

              -- absolute path to clipboard
              local i = vim.fn.inputlist({
                'Select a path to copy:',
                string.format('1. Absolute path: "%s"', results[1]),
                string.format('2. Project root:  "%s"', results[2]),
              })

              if i > 0 then
                local result = results[i]
                if not result then return print('Invalid choice: ' .. i) end
                -- store value into system clipboard register
                vim.fn.setreg('+', result)
              end
            end
          }
        },
      })
    end
  }
}
