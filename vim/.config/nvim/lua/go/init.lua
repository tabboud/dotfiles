local M = {}

local vim = vim
local fn = vim.fn
local api = vim.api

-- ends_with returns true if str ends with ending.
local function ends_with(str, ending)
  return ending == "" or str:sub(- #ending) == ending
end

-- ToggleTest toggles to/from a Go file and the corresponding test.
function M.ToggleTest()
  local alternate_file = ""

  local file = api.nvim_buf_get_name(0)
  if ends_with(file, "_test.go") then
    alternate_file = fn.split(file, "_test.go")[1] .. ".go"
  elseif ends_with(file, ".go") then
    alternate_file = fn.split(file, "\\.go")[1] .. "_test.go"
  else
    print("Not a Go file")
    return
  end

  vim.cmd("edit" .. alternate_file)
end

return M
