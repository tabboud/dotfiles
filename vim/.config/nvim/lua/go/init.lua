local M = {}

local vim = vim
local fn = vim.fn
local api = vim.api

---ToggleTest toggles to/from a Go file and the corresponding test.
---@param vsplit boolean
function M.ToggleTest(vsplit)
  local alternate_file = ""

  local file = api.nvim_buf_get_name(0)
  if vim.endswith(file, "_test.go") then
    alternate_file = fn.split(file, "_test.go")[1] .. ".go"
  elseif vim.endswith(file, ".go") then
    alternate_file = fn.split(file, "\\.go")[1] .. "_test.go"
  else
    print("Not a Go file")
    return
  end

  if vsplit then
    vim.cmd("vsplit" .. alternate_file)
  else
    vim.cmd("edit" .. alternate_file)
  end
end

return M
