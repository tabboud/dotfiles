local M = {}

-- desc returns the the description for a keymapping.
-- If one exists, it will use the provided description.
-- If one does not exist "Dots: not specified" will be returned.
local desc = function(opts)
  opts = opts or { desc = "" }
  if opts.desc == nil or opts.desc == "" then
    return "Dots: not specified"
  end
  return opts.desc
end

-- map is used to configure various :map keymappings.
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = false
  opts.silent = true
  opts.desc = desc(opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- noremap is used to configure various :noremap keymappings.
function M.noremap(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = true
  opts.silent = true
  opts.desc = desc(opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- nnoremap sets a normal mode noremap keymap
function M.nnoremap(lhs, rhs, opts)
  M.noremap({ 'n' }, lhs, rhs, opts)
end

-- vnoremap sets a visual mode noremap keymap
function M.vnoremap(lhs, rhs, opts)
  M.noremap({ 'v' }, lhs, rhs, opts)
end

-- nmap sets a normal mode map keymap
function M.nmap(lhs, rhs, opts)
  M.map({ 'n' }, lhs, rhs, opts)
end

-- Setup leader mappings - normal (n) / visual (x) mode map a space to a noop
-- using noremap to prevent a recursive mapping overwriting this.
vim.g.mapleader = " "
M.noremap({ 'n', 'x' }, " ", "", { desc = "Set leader key" })

M.nmap("<C-h>", "<Plug>WinMoveLeft", { desc = "Copy or move to file (left)" })
M.nmap("<C-j>", "<Plug>WinMoveDown", { desc = "Copy or move to file (down)" })
M.nmap("<C-k>", "<Plug>WinMoveUp", { desc = "Copy or move to file (up)" })
M.nmap("<C-l>", "<Plug>WinMoveRight", { desc = "Copy or move to file (right)" })

M.nnoremap("Q", "", { desc = "Disable Ex mode" })
M.nnoremap("Y", "y$", { desc = "Yank until EOL" })
M.nnoremap("n", "nzzzv", { desc = "Center screen on search (next)" })
M.nnoremap("N", "Nzzzv", { desc = "Center screen on search (prev)" })
M.nnoremap("j", "gj", { desc = "Move down" })
M.nnoremap("k", "gk", { desc = "Move up" })
M.nnoremap("^", "g^", { desc = "Move to start" })
M.nnoremap("$", "g$", { desc = "Move to end" })
M.nnoremap("tt", "<cmd>tab split<cr>", { desc = "Open current buffer in a new tab (full-screen mode)" })
M.nnoremap("<Esc>", "<Esc><cmd>noh<cr>", { desc = "Clear all highlighting" })
M.nnoremap("<C-e>", "3<C-e>", { desc = "Scroll down viewport" })
M.nnoremap("<C-y>", "3<C-y>", { desc = "Scroll up viewport" })
M.nnoremap("<C-w><", "10<C-w>>", { desc = "Shift window left" })
M.nnoremap("<C-w>>", "10<C-w><", { desc = "Shift window right" })
M.nnoremap("]]", '<cmd>call search("^func")<cr>', { desc = "Jump to next func" })
M.nnoremap("[[", ':call search("^func", "b")<cr>', { desc = "Jump to prev func" })
M.nnoremap("gn", "<cmd>bn<cr>", { desc = "Buffer: Go to next" })
M.nnoremap("gp", "<cmd>bp<cr>", { desc = "Buffer: Go to prev" })
M.nnoremap("<leader>v", "<cmd>set paste!<cr>", { desc = "Toggle paste mode" })
M.nnoremap("<leader>a", "<cmd>%y+<cr>", { desc = "Copy the entire buffer" })
M.nnoremap("<leader>w", "<cmd>w<cr>", { desc = "Write file" })
M.nnoremap("<leader>q", "<cmd>q<cr>", { desc = "Quit" })
M.nnoremap("<leader>l", "<cmd>set list!<cr>", { desc = "Toggle 'listchars'" })
M.nnoremap("<leader>n", "<cmd>set nowrap!<cr>", { desc = "Toggle line wrapping" })
M.nnoremap("<leader>[", "<<", { desc = "Shift left" })
M.nnoremap("<leader>]", ">>", { desc = "Shift right" })
M.nnoremap("<leader>tt", function() return require("go").ToggleTest() end, { desc = "Go: Toggle Go test" })

M.vnoremap("*", "<Esc>/\\%V", { desc = "Visual search word under cursor (next)" })
M.vnoremap("#", "<Esc>?\\%V", { desc = "Visual search word under cursor (prev)" })
M.vnoremap("<leader>[", "<gv", { desc = "Shift left" })
M.vnoremap("<leader>]", ">gv", { desc = "Shift right" })
M.vnoremap("<leader>jq", ":!jq<cr>", { desc = "Format JSON" })

-- Highlight word without jumping
-- Convert into lua
-- M.nnoremap("*", "<cmd>let @/= '<' . expand('<cword>') . '>' <bar> set hls <cr>",
--   { desc = "Highlight word without jumping" })
vim.cmd [[ nnoremap <silent> * :let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr> ]]

M.noremap({ "t" }, "<Esc>", "<c-\\><c-n>", { desc = "Terminal: exit terminal mode" })
return M
