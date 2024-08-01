local map = vim.keymap.set

-- Setup leader mappings - normal (n) / visual (x) mode map a space to a noop
vim.g.mapleader = " "
map({ 'n', 'x' }, " ", "", { desc = "Set leader key" })
map("n", "<C-h>", "<Plug>WinMoveLeft", { desc = "Copy or move to file (left)" })
map("n", "<C-j>", "<Plug>WinMoveDown", { desc = "Copy or move to file (down)" })
map("n", "<C-k>", "<Plug>WinMoveUp", { desc = "Copy or move to file (up)" })
map("n", "<C-l>", "<Plug>WinMoveRight", { desc = "Copy or move to file (right)" })
map("n", "Q", "", { desc = "Disable Ex mode" })
map("n", "Y", "y$", { desc = "Yank until EOL" })
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
map("n", "[[", ':call search("^func", "b")<cr>', { desc = "Jump to prev func" })
map("n", "<leader>v", "<cmd>set paste!<cr>", { desc = "Toggle paste mode" })
map("n", "<leader>a", "<cmd>%y+<cr>", { desc = "Copy the entire buffer" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "Qa", "", { desc = "Quit all" })
map("n", "<leader>l", "<cmd>set list!<cr>", { desc = "Toggle 'listchars'" })
map("n", "<leader>n", "<cmd>set nowrap!<cr>", { desc = "Toggle line wrapping" })
map("n", "<leader>tt", function() return require("go").ToggleTest() end, { desc = "Go: Toggle Go test" })

map("v", "*", "<Esc>/\\%V", { desc = "Visual search word under cursor (next)" })
map("v", "#", "<Esc>?\\%V", { desc = "Visual search word under cursor (prev)" })
map("v", "<leader>jq", ":!jq<cr>", { desc = "Format JSON" })
map("n", "<leader>[", "<<", { desc = "Shift left" })
map("n", "<leader>]", ">>", { desc = "Shift right" })
map("v", "<leader>[", "<gv", { desc = "Shift left" })
map("v", "<leader>]", ">gv", { desc = "Shift right" })

-- Highlight word without jumping
-- Convert into lua
-- M.nnoremap("*", "<cmd>let @/= '<' . expand('<cword>') . '>' <bar> set hls <cr>",
--   { desc = "Highlight word without jumping" })
vim.cmd [[ nnoremap <silent> * :let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr> ]]

map("t", "<Esc>", "<c-\\><c-n>", { desc = "Terminal: exit terminal mode" })


-- Custom 'gh' commands
vim.api.nvim_create_user_command(
  "GHRepoView",
  function()
    if not vim.fn.executable('gh') then
      print("'gh' executable not found")
      return
    end
    vim.fn.system("gh repo view --web")
  end,
  { desc = "Open repo in web browser via 'gh'" }
)
vim.api.nvim_create_user_command(
  "GHPRView",
  function(cmd)
    if not vim.fn.executable('gh') then
      print("'gh' executable not found")
      return
    end
    if cmd.args == "" then
      print("'PR number must be provided'")
      return
    end
    vim.fn.system("gh pr view --web " .. cmd.args)
  end,
  {
    desc = "Open a PR in a web browser via 'gh'",
    nargs = "?",
  }
)
vim.api.nvim_create_user_command(
  "GHBrowse",
  function(cmd)
    if not vim.fn.executable('gh') then
      print("'gh' executable not found")
      return
    end
    local currentBufferFilepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
    if cmd.args ~= "" then
      currentBufferFilepath = currentBufferFilepath .. ":" .. cmd.args
    end
    vim.fn.system("gh browse " .. currentBufferFilepath)
  end,
  {
    desc = "Open the current file in a web browser via 'gh'",
    nargs = "?",
  }
)

local commands = {
  {
    name = "View Repo",
    callback = function()
      if not vim.fn.executable('gh') then
        print("'gh' executable not found")
        return
      end
      vim.fn.system("gh repo view --web")
    end,
    opts = { nargs = "?" }
  },
}
local function command_select()
  local opts = {
    prompt = "Select a GH command: ",
    format_item = function(cmd)
      return cmd.name
    end
  }
  local on_choice = function(cmd)
    if cmd ~= nil then
      cmd.callback()
    end
  end

  vim.ui.select(commands, opts, on_choice)
end

vim.api.nvim_create_user_command("GH", command_select, {})
