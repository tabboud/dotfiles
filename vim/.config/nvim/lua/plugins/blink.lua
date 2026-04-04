-- blink.lua
---@module 'blink.cmp'
---@type blink.cmp.Config
require("blink.cmp").setup({
  signature = {
    enabled = true,
  },
  keymap = {
    preset = "default",
    ["<C-e>"] = { "cancel" },
    ["<CR>"] = { "accept", "fallback" },
    ["<C-y>"] = {}, -- disable
  },
  snippets = {
    preset = 'luasnip',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
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
      -- Don't show completion menu automatically in cmdline mode
      auto_show = function(ctx) return ctx.mode ~= 'cmdline' end,
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    ghost_text = {
      enabled = true,
    },
  },
})
