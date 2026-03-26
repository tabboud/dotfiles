return {
  {
    "saghen/blink.cmp",
    enabled = false,
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
      signature = {
        enabled = true
      },
      keymap = {
        preset = "default",
        ["<C-e>"] = { "cancel" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-y>"] = {}, -- disable
      },
      -- cmdline = {
      --   keymap = {
      --     preset = 'enter',
      --     -- Use tab/s-tab to show the completion window and traverse up/down through it
      --     ['<Tab>'] = { 'show', 'select_next', 'fallback' },
      --     ['<S-Tab>'] = { 'select_prev', 'fallback' },
      --   }
      -- },
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
          -- Don't show completion menu automatically in cmdline mode (use the trigger <C-space> to show)
          auto_show = function(ctx) return ctx.mode ~= 'cmdline' end
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = true,
        },
      },


    },
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      require("blink.cmp").setup(opts)
    end,
  },
}
