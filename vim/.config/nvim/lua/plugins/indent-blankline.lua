local M = {}

local options = {
  enabled = true,
  buftype_exclude = { "terminal", "nofile" },
  filetype_exclude = {
    "help",
    "startify",
    "dashboard",
    "packer",
    "neogitstatus",
    "NvimTree",
    "Trouble",
    "text",
  },
  char = "▏",
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  use_treesitter = true,
  show_current_context = true,
}

function M.setup()
  local ok, indent_blanklines = pcall(require, 'indent_blankline')
  if not ok then
    print("indent_blanlines could not be required, skipping setup")
    return
  end
  indent_blanklines.setup(options)
end

return M
