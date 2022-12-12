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
