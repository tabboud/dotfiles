local M = {}

---ToggleTest toggles to/from a Go file and the corresponding test.
---@param vsplit boolean
function M.ToggleTest(vsplit)
  local file = vim.api.nvim_buf_get_name(0)
  local alternate_file
  if vim.endswith(file, "_test.go") then
    alternate_file = file:gsub("_test%.go$", ".go")
  elseif vim.endswith(file, ".go") then
    alternate_file = file:gsub("%.go$", "_test.go")
  else
    vim.notify("Not a Go file", vim.log.levels.WARN)
    return
  end

  if vsplit then
    vim.cmd.vsplit(alternate_file)
  else
    vim.cmd.edit(alternate_file)
  end
end

return M
