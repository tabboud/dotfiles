local nvimtree = require('nvim-tree')
local icons = require("icons")

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
      hint = icons.nvimtree.diagnostics.hint,
      info = icons.nvimtree.diagnostics.info,
      warning = icons.nvimtree.diagnostics.warning,
      error = icons.nvimtree.diagnostics.error,
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
        corner = icons.nvimtree.renderer.corner,
        edge = icons.nvimtree.renderer.edge,
        none = icons.nvimtree.renderer.none,
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
        default = icons.nvimtree.glyphs.default,
        symlink = icons.nvimtree.glyphs.symlink,
        git = {
          unstaged = icons.nvimtree.glyphs.GitUnstaged,
          staged = icons.nvimtree.glyphs.GitStaged,
          unmerged = icons.nvimtree.glyphs.GitUnmerged,
          renamed = icons.nvimtree.glyphs.GitRenamed,
          deleted = icons.nvimtree.glyphs.GitDeleted,
          untracked = icons.nvimtree.glyphs.GitUntracked,
          ignored = icons.nvimtree.glyphs.GitIgnored,
        },
        folder = {
          default = icons.nvimtree.glyphs.FolderDefault,
          open = icons.nvimtree.glyphs.FolderOpen,
          empty = icons.nvimtree.glyphs.FolderEmpty,
          empty_open = icons.nvimtree.glyphs.FolderEmptyOpen,
          symlink = icons.nvimtree.glyphs.FolderSymlink,
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
local keymaps = require('keymaps')
keymaps.nnoremap("<leader>k", ":NvimTreeToggle<cr>", { desc = "NvimTree: Toggle file tree" })
keymaps.nnoremap("<leader>f", ":NvimTreeFindFile<cr>", { desc = "NvimTree: Find file" })
