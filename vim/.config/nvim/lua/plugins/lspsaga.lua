local M = {}

-- TODO(tabboud):  Enable symbols in the winbar

local map = function(mode, l, r, opts)
  opts = opts or {}
  opts.buffer = bufnr
  vim.keymap.set(mode, l, r, opts)
end

local setup_keymaps = function()
  local opts = { noremap = true, silent = true }
  map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
  map("n", "ga", "<cmd>Lspsaga code_action<CR>", opts)
  map("n", "g]", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
  map("n", "g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
  map("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
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
