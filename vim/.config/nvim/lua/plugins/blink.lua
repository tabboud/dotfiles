return {
  {
    "saghen/blink.cmp",
    version = "*",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.default",
    },
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
      },
    },
    event = "InsertEnter",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      signature = { enabled = true },
      keymap = {
        preset = "default",
        ["<C-e>"] = { "select_and_accept" },
      },
      snippets = {
        preset = 'luasnip'
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        -- compat = {},
        -- cmdline = {},
      },

      -- FROM LAZYVIM

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        trigger = {
          show_on_insert_on_trigger_character = false,
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      },


    },
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      require("blink.cmp").setup(opts)
    end,
  },
}
