local keymaps = {
  nmap = {
    { "Q", "" }, -- disable Ex mode
    { "<leader>v", ":set paste!<cr>" }, -- toggle paste mode
    { "<leader>a", ":%y+<cr>" }, -- copy the entire buffer
    { "<leader>w", ":w<cr>" }, -- write file
    { "<leader>q", ":q<cr>" }, -- quit
    { "<leader>l", ":set list!<cr>" }, -- toggle listchars
    { "<leader>n", ":set nowrap!<cr>" }, -- toggle wrapping
    { "<leader>[", "<<" }, -- indent left
    { "<leader>]", ">>" }, -- indent right
    { "gn", ":bn<cr>" }, -- faster buffer switching
    { "gp", ":bp<cr>" }, -- faster buffer switching
    { "gd", ":bd<cr>" }, -- faster buffer switching

    -- TODO: Add more convenience plugin/gitconfig
    { "<leader>ev", ":e! $MYVIMRC<cr>" }, -- edit vimrc

    -- copy file to a split
    { "<C-h>", "<Plug>WinMoveLeft" },
    { "<C-j>", "<Plug>WinMoveDown" },
    { "<C-k>", "<Plug>WinMoveUp" },
    { "<C-l>", "<Plug>WinMoveRight" },
  },
  nnoremap = {
    { "Y", "y$" }, -- yank until EOL
    { "n", "nzzzv" }, -- Center screen on search
    { "N", "Nzzzv" },
    { "<CR>", ":noh<cr><cr>" }, -- clear all highlighting
    { "<C-e>", "3<C-e>" }, -- scroll viewport faster down
    { "<C-y>", "3<C-y>" }, -- scroll viewport faster up

    -- Jump to next/prev function
    { "]]", ':call search("^func")<cr>' },
    { "[[", ':call search("^func", "b")<cr>' },

    -- Move up/down per line including wrapped chars
    { "j", "gj" },
    { "k", "gk" },
    { "^", "g^" },
    { "$", "g$" },

    { "tt", ":tab split<cr>" }, -- open current buffer in a new tab (mimics full screen mode)
  },
  vmap = {
    { "*", "<Esc>/\\%V" }, -- Visual search /
    { "#", "<Esc>?\\%V" }, -- Visual search ?
    { "<leader>[", "<gv" }, -- Shift left
    { "<leader>]", ">gv" }, -- Shift right
  }
}

-- set a key mapping for a given mode and options.
-- keymaps should be a list of tables that map the key to command
local function map_keys(mode, opts, mappings)
  for _, keymap in ipairs(mappings) do
    vim.keymap.set(mode, keymap[1], keymap[2], opts)
  end
end

-- Setup leader mappings - normal (n) / visual (x) mode map a space to a noop
vim.g.mapleader = " "
vim.keymap.set("n", " ", "", { noremap = true })
vim.keymap.set("x", " ", "", { noremap = true })

-- TODO: Make new methods to do nmap nnoremap so we can split up core from plugins
-- TODO: Move all nmap to nnoremap
map_keys("n", { noremap = false, silent = true }, keymaps.nmap)
map_keys("n", { noremap = true, silent = true }, keymaps.nnoremap)
map_keys("x", { noremap = false, silent = true }, keymaps.vmap)
