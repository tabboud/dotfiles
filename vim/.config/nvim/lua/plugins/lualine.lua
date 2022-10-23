-- projectName returns the name of the containing directory (or project).
local function projectName()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
end

require('lualine').setup {
  options = {
    theme = "jellybeans"
  },
  sections = {
    lualine_a = { projectName },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {},
    lualine_x = { "searchCount" },
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}
