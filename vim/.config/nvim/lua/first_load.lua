local download_packer = function()
  if vim.fn.input "Download Packer? (y for yes)" ~= "y" then
    return
  end

  local directory = string.format("%s/site/pack/packer/start", vim.fn.stdpath("data"))
  vim.fn.mkdir(directory, "p")

  print "Downloading packer.nvim..."
  local out = vim.fn.system(
    string.format("git clone %s %s", "https://github.com/wbthomason/packer.nvim", directory .. "/packer.nvim")
  )
  print(out)
  vim.cmd [[packadd packer.nvim]]
  print("You'll need to restart now, then run :PackerSync and :MasonToolsInstall to update all plugins/tools")
  require('plugins')
  vim.cmd [[PackerSync]]
  -- vim.cmd [[qa]]
end

return function()
  if not pcall(require, "packer") then
    download_packer()
    return true
  end
  return false
end
