return {
  -- used by gitsigns
  git = {
    GitSignsAdd = '│',
    GitSignsChange = '│',
    GitSignsDelete = '_',
    GitSignsTopDelete = '‾',
    GitSignsChangedDelete = '~',
  },
  -- used by nvim-cmp
  kind = {
    Text = "   (Text) ",
    Method = "   (Method)",
    Function = "   (Function)",
    Constructor = "   (Constructor)",
    Field = " ﴲ  (Field)",
    Variable = "[] (Variable)",
    Class = "   (Class)",
    Interface = " ﰮ  (Interface)",
    Module = "   (Module)",
    Property = " 襁 (Property)",
    Unit = "   (Unit)",
    Value = "   (Value)",
    Enum = " 練 (Enum)",
    Keyword = "   (Keyword)",
    Snippet = "   (Snippet)",
    Color = "   (Color)",
    File = "   (File)",
    Reference = "   (Reference)",
    Folder = "   (Folder)",
    EnumMember = "   (EnumMember)",
    Constant = "   (Constant)",
    Struct = "   (Struct)",
    Event = "   (Event)",
    Operator = "   (Operator)",
    TypeParameter = "   (TypeParameter)",
  },
  -- used by lspconfig
  lsp = {
    error = " ",
    warn = " ",
    hint = " ",
    info = " ",
  },
  nvimtree = {
    diagnostics = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
    renderer = {
      corner = "└ ",
      edge = "│ ",
      none = "  ",
    },
    glyphs = {
      default = "",
      symlink = "",
      GitUnstaged = "",
      GitStaged = "S",
      GitUnmerged = "",
      GitRenamed = "➜",
      GitDeleted = "",
      GitUntracked = "U",
      GitIgnored = "◌",
      FolderDefault = "",
      FolderOpen = "",
      FolderEmpty = "",
      FolderEmptyOpen = "",
      FolderSymlink = "",
    }
  }
}
