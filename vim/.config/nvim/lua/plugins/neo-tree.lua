require('neo-tree').setup({
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
      ['Y'] = function(state)
        -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
        -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
        local node = state.tree:get_node()
        local filepath = node:get_id()
        local filename = node.name
        local modify = vim.fn.fnamemodify

        local results = {
          filepath,
          modify(filepath, ':.'),
          modify(filepath, ':~'),
          filename,
          modify(filename, ':r'),
          modify(filename, ':e'),
        }

        -- absolute path to clipboard
        local i = vim.fn.inputlist({
          'Choose to copy to clipboard:',
          '1. Absolute path: ' .. results[1],
          '2. Path relative to CWD: ' .. results[2],
          '3. Path relative to HOME: ' .. results[3],
          '4. Filename: ' .. results[4],
          '5. Filename without extension: ' .. results[5],
          '6. Extension of the filename: ' .. results[6],
        })

        if i > 0 then
          local result = results[i]
          if not result then return print('Invalid choice: ' .. i) end
          vim.fn.setreg('"', result)
        end
      end
    }
  },
})
