
require 'nvim-treesitter.configs'.setup({
    -- list of available parsers
    ensure_installed = { 'go', 'json', 'yaml', 'vim' },

    highlight = {
        -- false disables the entire extension
        enable = true,
    },
})
