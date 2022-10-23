local M = {}

local options = {

}

function M.setup()
  local ok, navic = pcall(require, "nvim-navic")
  if not ok then
    print("nvim-navic not installed, skipping setup")
    return
  end

  navic.setup(options)
end
return M
