local map = vim.keymap.set

-- Setup leader mappings - normal (n) / visual (x) mode map a space to a noop
vim.g.mapleader = " "
map({ 'n', 'x' }, " ", "", { desc = "Set leader key" })
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
map("n", "<leader>tt", function() return require("go").ToggleTest(false) end, { desc = "Go: Toggle Go test" })
map("v", "*", "<Esc>/\\%V", { desc = "Visual search word under cursor (next)" })
map("v", "#", "<Esc>?\\%V", { desc = "Visual search word under cursor (prev)" })
map("v", "<leader>jq", ":!jq<cr>", { desc = "Format JSON" })
map("n", "<leader>[", "<<", { desc = "Shift left" })
map("n", "<leader>]", ">>", { desc = "Shift right" })
map("v", "<leader>[", "<gv", { desc = "Shift left" })
map("v", "<leader>]", ">gv", { desc = "Shift right" })
map("t", "<Esc>", "<c-\\><c-n>", { desc = "Terminal: exit terminal mode" })
map("n", "<leader>cr", function()
  vim.lsp.codelens.run()
end, { desc = "CodeLens: run" })

-- Highlight word without jumping
-- Convert into lua
-- M.nnoremap("*", "<cmd>let @/= '<' . expand('<cword>') . '>' <bar> set hls <cr>",
--   { desc = "Highlight word without jumping" })
vim.cmd [[ nnoremap <silent> * :let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr> ]]



-- Custom 'gh' commands
vim.api.nvim_create_user_command(
  "GH",
  function()
    if not vim.fn.executable('gh') then
      print("'gh' executable not found")
      return
    end

    vim.ui.select(
      {
        {
          name = "View Repo",
          callback = function()
            vim.fn.system("gh repo view --web")
          end,
        },
        {
          name = "View PR",
          callback = function()
            vim.ui.input(
              { prompt = "Enter PR #: " },
              function(input)
                if input == nil or input == "" then
                  return
                end
                vim.fn.system("gh pr view --web " .. input)
              end)
          end,
        },
        {
          name = "View the current buffer in a web browser",
          callback = function()
            local currentBufferFilepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
            -- if cmd.args ~= "" then
            --   currentBufferFilepath = currentBufferFilepath .. ":" .. cmd.args
            -- end
            vim.fn.system("gh browse " .. currentBufferFilepath)
          end,
        },
      },
      {
        prompt = "Select a GH command: ",
        format_item = function(cmd)
          return cmd.name
        end
      },
      function(choice)
        choice.callback()
      end
    )
  end,
  {}
)

---Window Movement Shortcuts
---Moves to the window in the direction shown or creates a new window
---@param key string
local winmove = function(key)
  local current_window_num = vim.api.nvim_win_get_number(0)
  -- Try moving to the desired window, if the window number is the same,
  -- then create a new split before moving into it
  vim.cmd('wincmd ' .. key)
  if current_window_num == vim.api.nvim_win_get_number(0) then
    if key == 'j' or key == 'k' then
      vim.cmd('wincmd s') -- new horizontal split
    else
      vim.cmd('wincmd v') -- new vertical split
    end
    -- switch to the new window
    vim.cmd('wincmd ' .. key)
  end
end

map("n", "<C-h>", function() winmove('h') end, { desc = "Copy or move to file (left)", silent = true })
map("n", "<C-j>", function() winmove('j') end, { desc = "Copy or move to file (down)", silent = true })
map("n", "<C-k>", function() winmove('k') end, { desc = "Copy or move to file (up)", silent = true })
map("n", "<C-l>", function() winmove('l') end, { desc = "Copy or move to file (right)", silent = true })
