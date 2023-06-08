return {
  -- used by gitsigns
  git = {
    GitSignsAdd = '│',
    GitSignsChange = '│',
    GitSignsDelete = '_',
    GitSignsTopDelete = '‾',
    GitSignsChangedDelete = '~',

    -- from nvim-tree defaults
    unstaged = "✗",
    staged = "✓",
    unmerged = "",
    renamed = "➜",
    untracked = "★",
    deleted = "",
    ignored = "◌",
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
  lualine = {
    Folder = " ",
    Lsp = " ",
    Position = "",
    ComponentSeparator = "|",
    Search = "",
  },
  -- used by lspconfig
  lsp = {
    error = " ",
    warn = " ",
    hint = " ",
    info = " ",
  },
  dap = {
    error = "",
    rejected = "-",
    stop = ">",
  },
  neotest = {
    expanded = "╮",
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },

    -- expanded = "",
    -- child_prefix = "",
    -- child_indent = "",
    -- final_child_prefix = "",
    -- non_collapsible = "",
    -- collapsed = "",

    failed = "",
    passed = "",
    skipped = "◌",
    unknown = "",
    running = "",
  }
}
