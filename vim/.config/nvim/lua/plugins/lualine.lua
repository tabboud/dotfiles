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

-- TODO: show lsp status with a progress loader or %
local lsp_status_with_progress = function ()
end

-- Show the current search count
local search_count = function ()
  if vim.v.hlsearch == 0 then
    return ''
  end

  local result = vim.fn.searchcount { maxcount = 999, timeout = 500 }
  local denominator = math.min(result.total, result.maxcount)
  return string.format('%s [%d/%d]', icons.Search, result.current, denominator)
end

require('lualine').setup {
  options = {
    theme = "jellybeans",
    component_separators = { left = icons.ComponentSeparator, right = icons.ComponentSeparator},
    section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = { "branch" },
    lualine_b = {  "diff" },
    lualine_c = { search_count },
    lualine_x = { "lsp_progress", lsp_status, "diagnostics" },
    lualine_y = {},
    lualine_z = {  project_name },
  },
  inactive_sections = {
    lualine_a = { "filename" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}
