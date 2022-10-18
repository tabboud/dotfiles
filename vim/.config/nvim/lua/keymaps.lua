-- Lua tables that map the vim mode to a list of Lua tables
-- that map the desired key to the desired command.
local keymaps = {}

-- normal mode mappings
keymaps["nmap"] = {
    { "Q", "" },                            -- disable Ex mode
    { "<leader>v", ":set paste!<cr>" },     -- toggle paste mode
    { "<leader>a", ":%y+<cr>" },            -- copy the entire buffer
    { "<leader>w", ":w<cr>" },              -- write file
    { "<leader>q", ":q<cr>" },              -- quit
    { "<leader>l", ":set list!<cr>" },      -- toggle listchars
    { "<leader>n", ":set nowrap!<cr>" },    -- toggle wrapping
    { "<leader>[", "<<" },                  -- indent left
    { "<leader>]", ">>" },                  -- indent right
    { "gn", ":bn<cr>" },                    -- faster buffer switching
    { "gp", ":bp<cr>" },                    -- faster buffer switching
    { "gd", ":bd<cr>" },                    -- faster buffer switching

    -- TODO: Add more convenience plugin/gitconfig
    { "<leader>ev", ":e! $MYVIMRC<cr>" },   -- edit vimrc

    -- copy file to a split
    { "<C-h>", "<Plug>WinMoveLeft" },
    { "<C-j>", "<Plug>WinMoveDown" },
    { "<C-k>", "<Plug>WinMoveUp" },
    { "<C-l>", "<Plug>WinMoveRight" },
}

-- normal mode mappings with noremap
keymaps["nnoremap"] = {
    { "Y", "y$" },          -- yank until EOL
    { "n", "nzzzv" },       -- Center screen on search
    { "N", "Nzzzv" },
    { "<CR>", ":noh<cr><cr>" },     -- clear all highlighting
    { "<C-e>", "3<C-e>" },         -- scroll viewport faster down
    { "<C-y>", "3<C-y>" },         -- scroll viewport faster up
    -- { "//", "" },         -- scroll viewport faster up

    -- Jump to next/prev function
    { "]]", ':call search("^func")<cr>' },
    { "[[", ':call search("^func", "b")<cr>' },

    -- Move up/down per line including wrapped chars
    { "j", "gj" },
    { "k", "gk" },
    { "^", "g^" },
    { "$", "g$" },

    { "tt", ":tab split<cr>" },     -- open current buffer in a new tab (mimics full screen mode)
}

-- visual mode mappings
keymaps["vmap"] = {
    { "*", "<Esc>/\\%V" }, -- Visual search /
    { "#", "<Esc>?\\%V" }, -- Visual search ?
}

return keymaps
