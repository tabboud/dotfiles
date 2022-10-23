local nvimtree = require('nvim-tree')

nvimtree.setup({
  git = {
    enable = false,
    -- Don't hide .gitignore files. These will show up with this symbol ◌
    ignore = false,
    timeout = 400,
  },
  filters = {
    dotfiles = false,
    -- Filter out the vendor directory.
    -- Toggle this with the toggle_custom command ('U')
    custom = { 'vendor' },
  },

  -- From luavim
  diagnostics = {
    enable = true,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  disable_netrw = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  renderer = {
    indent_markers = {
      enable = true,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = false,
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          deleted = "",
          untracked = "U",
          ignored = "◌",
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
      },
    },
    highlight_git = false,
    highlight_opened_files = "name",
    root_folder_modifier = ":t",
  },
}
)

-- configure key mappings
vim.keymap.set("n", "<leader>k", ":NvimTreeToggle<cr>", { noremap = false, silent = true })
vim.keymap.set("n", "<leader>f", ":NvimTreeFindFile<cr>", { noremap = false, silent = true })

