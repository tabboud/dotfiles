local M = {}

-- desc returns the the description for a keymapping.
-- If one exists, it will prefix "Dots: " before it for easier lookup.
-- If one does not exist "Dots: not specified" will be returned.
local desc = function(opts)
  opts = opts or { desc = "" }
  if opts.desc == "" then
    return "Dots: not specified"
  end
  return "Dots: " .. opts.desc
end

function M.nnoremap(lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = true
  opts.silent = true
  opts.desc = desc(opts)
  vim.keymap.set({ 'n' }, lhs, rhs, opts)
end

function M.vnoremap(lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = true
  opts.silent = true
  opts.desc = desc(opts)
  vim.keymap.set({ 'v' }, lhs, rhs, opts)
end

function M.nmap(lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = false
  opts.silent = true
  opts.desc = desc(opts)
  vim.keymap.set({ 'n' }, lhs, rhs, opts)
end

-- Setup leader mappings - normal (n) / visual (x) mode map a space to a noop
-- using noremap to prevent a recursive mapping overwriting this.
vim.g.mapleader = " "
vim.keymap.set("n", " ", "", { noremap = true })
vim.keymap.set("x", " ", "", { noremap = true })

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
M.nnoremap("bn", "<cmd>bn<cr>", { desc = "Go to buffer (next)" })
M.nnoremap("bp", "<cmd>bp<cr>", { desc = "Go to buffer (prev)" })
M.nnoremap("<CR>", "<cmd>noh<cr><cr>", { desc = "Clear all highlighting" })
M.nnoremap("<C-e>", "3<C-e>", { desc = "Scroll down viewport" })
M.nnoremap("<C-y>", "3<C-y>", { desc = "Scroll up viewport" })
M.nnoremap("]]", '<cmd>call search("^func")<cr>', { desc = "Jump to next func" })
M.nnoremap("[[", ':call search("^func", "b")<cr>', { desc = "Jump to prev func" })
M.nnoremap("<leader>v", "<cmd>set paste!<cr>", { desc = "Toggle paste mode" })
M.nnoremap("<leader>a", "<cmd>%y+<cr>", { desc = "Copy the entire buffer" })
M.nnoremap("<leader>w", "<cmd>w<cr>", { desc = "Write file" })
M.nnoremap("<leader>q", "<cmd>q<cr>", { desc = "Quit" })
M.nnoremap("<leader>l", "<cmd>set list!<cr>", { desc = "Toggle 'listchars'" })
M.nnoremap("<leader>n", "<cmd>set nowrap!<cr>", { desc = "Toggle line wrapping" })
M.nnoremap("<leader>[", "<<", { desc = "Shift left" })
M.nnoremap("<leader>]", ">>", { desc = "Shift right" })
M.nnoremap("<leader>tt", function()
  return require("go").ToggleTest()
end, { desc = "Go: Toggle Go test" })

M.vnoremap("*", "<Esc>/\\%V", { desc = "Visual search word under cursor (next)" })
M.vnoremap("#", "<Esc>?\\%V", { desc = "Visual search word under cursor (prev)" })
M.vnoremap("<leader>[", "<gv", { desc = "Shift left" })
M.vnoremap("<leader>]", ">gv", { desc = "Shift right" })

return M
