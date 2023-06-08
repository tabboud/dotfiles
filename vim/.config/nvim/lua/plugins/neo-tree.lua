require('neo-tree').setup({
  filesystem = {
    follow_current_file = true,
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
    width = 40,
  },
})
