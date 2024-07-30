if not vim.g.neovide then
  return
end

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

vim.keymap.set('n', '<D-s>', ':w<CR>')        -- Save
vim.keymap.set('v', '<D-c>', '"+y')           -- Copy
vim.keymap.set('n', '<D-v>', '"+P')           -- Paste normal mode
vim.keymap.set('v', '<D-v>', '"+P')           -- Paste visual mode
vim.keymap.set('c', '<D-v>', '<C-R>+')        -- Paste command mode
vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli')   -- Paste insert mode

vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.25)
end)
vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1 / 1.25)
end)
