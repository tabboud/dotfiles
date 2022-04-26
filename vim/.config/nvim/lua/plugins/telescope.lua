local action_layout = require("telescope.actions.layout")
require('telescope').setup{
  defaults = {
    -- Disable preview for ALL windows
    -- preview = false,

    -- ignore vendor directories in ALL windows
    file_ignore_patterns = {
        "vendor",
    },
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,

    -- Trim indentation at the beginning of presented line in result window
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim" -- add this value
    },

    -- Custom mappings
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key"

        -- Toggle preview window (global preview must be set to true)
        -- ["<C-l>"] = action_layout.toggle_preview
      },
      n = {
        -- Toggle preview window
        -- ["<C-l>"] = action_layout.toggle_preview
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    find_files = {
        theme = "dropdown",
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
    },
    buffers = {
        theme = "dropdown",
        ignore_current_buffer = true,
        sort_lastused = true,
    }
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}
