local nvimtree = require('nvim-tree')

nvimtree.setup({
  git = {
    enable = false,
    -- Don't hide .gitignore files. These will show up with this symbol ◌
    ignore = false,
  },
  filters = {
    dotfiles = false,
    -- Filter out the vendor directory.
    -- Toggle this with the toggle_custom command ('U')
    custom = { 'vendor' },
  },
  diagnostics = {
    enable = true,
  },
  disable_netrw = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
    icons = {
      webdev_colors = false,
    },
    highlight_opened_files = "name",
    root_folder_modifier = ":t",
  },
}
)

-- configure key mappings
local keymaps = require('keymaps')
keymaps.nnoremap("<leader>k", ":NvimTreeToggle<cr>", { desc = "NvimTree: Toggle file tree" })
keymaps.nnoremap("<leader>f", ":NvimTreeFindFile<cr>", { desc = "NvimTree: Find file" })
