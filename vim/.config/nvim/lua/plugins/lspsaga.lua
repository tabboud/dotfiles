local M = {}

-- TODO(tabboud):  Enable symbols in the winbar

local setup_keymaps = function()
  local keymaps = require('keymaps')
  keymaps.nnoremap("<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "LSP: Rename word under cursor" })
  keymaps.nnoremap("ga", "<cmd>Lspsaga code_action<CR>", { desc = "LSP: Code Action" })
  keymaps.nnoremap("g]", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "LSP: Diagnostics next" })
  keymaps.nnoremap("g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "LSP: Diagnostics prev" })
  keymaps.nnoremap("K", "<cmd>Lspsaga hover_doc<CR>", { desc = "LSP: Hover docs" })
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
