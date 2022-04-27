
require 'nvim-treesitter.configs'.setup({
    -- list of available parsers
    ensure_installed = { 'go' },

    highlight = {
        -- false disables the entire extension
        enable = false,
    },
})
