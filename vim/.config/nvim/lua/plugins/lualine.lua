local icons = require("icons").lualine

-- projectName returns the name of the containing directory (or project).
local project_name = function()
 -- local folderIcon = require("icons").nvimtree.glyphs.FolderOpen
 local project = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
 return string.format("%s %s", icons.Folder, project)
end

local file_progress = function()
  local cur = vim.fn.line "."
  local total = vim.fn.line "$"
  local progress = math.modf((cur/total) * 100) .. tostring "%%"
  progress = (cur == 1 and "Top") or progress
  progress = (cur == total and "Bot") or progress

  return string.format("%s %s", icons.Position, progress)
end

local lsp_status = function ()
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.attached_buffers[vim.api.nvim_get_current_buf()] then
      if vim.o.columns > 100 then
        return string.format(" %s LSP: %s", icons.Lsp, client.name)
      end
        return string.format(" %s LSP", icons.Lsp)
    end
  end

  return string.format(" %s LSP: none", icons.Lsp)
end

require('lualine').setup {
  options = {
    theme = "jellybeans",
    component_separators = { left = icons.ComponentSeparator, right = icons.ComponentSeparator},
    section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = { project_name },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {},
    lualine_x = { lsp_status },
    lualine_y = { "searchCount" },
    lualine_z = { file_progress },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}
