local nvimtree = require('nvim-tree')

nvimtree.setup({
  -- This is deprecated
  -- auto_close = true,
  update_focused_file = {
    enable      = true,
    update_cwd  = false,
    ignore_list = {}
  },
  git = {
    enable = true,
    -- Don't hide .gitignore files. These will show up with this symbol ◌
    ignore = false,
    timeout = 400,
  },
  filters = {
      dotfiles = false,
      -- Filter out the vendor directory.
      -- Toggle this with the toggle_custom command ('U')
      custom = {'vendor'},
  },
}
)
