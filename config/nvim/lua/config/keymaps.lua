local map = vim.keymap.set

-- Setup leader mappings - normal (n) / visual (x) mode map a space to a noop
vim.g.mapleader = " "
map({ 'n', 'x' }, " ", "", { desc = "Set leader key" })
map("n", "Q", "", { desc = "Disable Ex mode" })
map("n", "n", "nzzzv", { desc = "Center screen on search (next)" })
map("n", "N", "Nzzzv", { desc = "Center screen on search (prev)" })
map("n", "j", "gj", { desc = "Move down" })
map("n", "k", "gk", { desc = "Move up" })
map("n", "^", "g^", { desc = "Move to start" })
map("n", "$", "g$", { desc = "Move to end" })
map("n", "tt", "<cmd>tab split<cr>", { desc = "Open current buffer in a new tab (full-screen mode)" })
map("n", "<Esc>", "<Esc><cmd>noh<cr>", { desc = "Clear all highlighting" })
map("n", "<C-e>", "3<C-e>", { desc = "Scroll down viewport" })
map("n", "<C-y>", "3<C-y>", { desc = "Scroll up viewport" })
map("n", "<C-w><", "10<C-w>>", { desc = "Shift window left" })
map("n", "<C-w>>", "10<C-w><", { desc = "Shift window right" })
map("n", "]]", '<cmd>call search("^func")<cr>', { desc = "Jump to next func" })
map("n", "[[", '<cmd>call search("^func", "b")<cr>', { desc = "Jump to prev func" })
map("n", "<leader>a", "<cmd>%y+<cr>", { desc = "Copy the entire buffer" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "*", "<cmd>let @/ = '\\<' .. expand('<cword>') .. '\\>' | set hlsearch<cr>",
  { desc = "Highlight word under cursor without jumping" })
map("v", "*", "<Esc>/\\%V", { desc = "Visual search word under cursor (next)" })
map("v", "#", "<Esc>?\\%V", { desc = "Visual search word under cursor (prev)" })
map("v", "<leader>jq", ":!jq<cr>", { desc = "Format JSON" })
map("n", "<leader>[", "<<", { desc = "Shift left" })
map("n", "<leader>]", ">>", { desc = "Shift right" })
map("v", "<leader>[", "<gv", { desc = "Shift left" })
map("v", "<leader>]", ">gv", { desc = "Shift right" })
map("t", "<Esc>", "<c-\\><c-n>", { desc = "Terminal: exit terminal mode" })
map("n", "<leader>gh", "<cmd>GH<cr>", { desc = "GH commands" })

---Moves to the window in the direction of key, creating a split if there is none.
---@param key string
local winmove = function(key)
  local current_window_num = vim.api.nvim_win_get_number(0)
  vim.cmd('wincmd ' .. key)
  if current_window_num == vim.api.nvim_win_get_number(0) then
    if key == 'j' or key == 'k' then
      vim.cmd('wincmd s') -- new horizontal split
    else
      vim.cmd('wincmd v') -- new vertical split
    end
    vim.cmd('wincmd ' .. key)
  end
end

map("n", "<C-h>", function() winmove('h') end, { desc = "Move to or create window (left)", silent = true })
map("n", "<C-j>", function() winmove('j') end, { desc = "Move to or create window (down)", silent = true })
map("n", "<C-k>", function() winmove('k') end, { desc = "Move to or create window (up)", silent = true })
map("n", "<C-l>", function() winmove('l') end, { desc = "Move to or create window (right)", silent = true })
