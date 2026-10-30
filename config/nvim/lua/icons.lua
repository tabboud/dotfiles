return {
  -- used by gitsigns
  git = {
    GitAdd = "▍",
    GitChange = "▍",
    GitDelete = '_',
    GitTopDelete = '‾',
    GitChangeDelete = '~',
  },
  lualine = {
    Folder = " ",
    Lsp = " ",
    ComponentSeparator = "|",
  },
  -- used by lsp diagnostics
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
    failed = "",
    passed = "",
    skipped = "◌",
    unknown = "",
    running = "",
  }
}
