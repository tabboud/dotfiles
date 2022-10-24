local M = {}

-- TODO(tabboud):  Enable symbols in the winbar

local setup_keymaps = function()
  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap("n", "<Leader>rn", "<cmd>Lspsaga rename<CR>", opts)
  vim.api.nvim_set_keymap("n", "ga", "<cmd>Lspsaga code_action<CR>", opts)
  vim.api.nvim_set_keymap("n", "g]", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
  vim.api.nvim_set_keymap("n", "g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
  vim.api.nvim_set_keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
end

function M.setup()
  local ok, lspsaga = pcall(require, 'lspsaga')
  if not ok then
    print("lspsaga could not be required, skipping setup")
    return
  end
  lspsaga.init_lsp_saga()
  setup_keymaps()
end

return M
