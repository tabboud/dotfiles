local cmp = require('cmp')
local icons = require("icons")
local luasnip = require("luasnip")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  completion = {
    keyword_length = 1,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = {
    ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
    ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ["<CR>"] = cmp.mapping.confirm { select = false },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if luasnip.expand_or_jumpable() then
          print("1")
          luasnip.expand_or_jump()
        else
          print("2")
          cmp.select_next_item()
        end
      elseif luasnip.expandable() then
        print("3")
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        print("4")
        luasnip.expand_or_jump()
      elseif has_words_before() then
        print("5")
        cmp.complete()
      else
        print("6")
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  -- mapping = {
  --   ["<C-d>"] = cmp.mapping.scroll_docs(-4),
  --   ["<C-f>"] = cmp.mapping.scroll_docs(4),
  --   ["<C-Space>"] = cmp.mapping.complete(),
  --   ['<C-y>'] = cmp.config.disable,
  --   ['<C-e>'] = cmp.mapping {
  --     i = cmp.mapping.abort(),
  --     c = cmp.mapping.close(),
  --   },
  --   ['<C-k>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
  --   ['<C-j>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
  --   ["<CR>"] = cmp.mapping.confirm {
  --     behavior = cmp.ConfirmBehavior.Replace,
  --     select = false,
  --   },
  --   ["<Tab>"] = cmp.mapping(function(fallback)
  --     if cmp.visible() then
  --       cmp.select_next_item()
  --     elseif luasnip.expandable() then
  --       luasnip.expand()
  --     elseif luasnip.expand_or_jumpable() then
  --       luasnip.expand_or_jump()
  --     elseif has_words_before() then
  --       cmp.complete()
  --     else
  --       fallback()
  --     end
  --   end, {
  --     "i",
  --     "s",
  --   }),
  --   ["<S-Tab>"] = cmp.mapping(function(fallback)
  --     if cmp.visible() then
  --       cmp.select_prev_item()
  --     elseif luasnip.jumpable(-1) then
  --       luasnip.jump(-1)
  --     else
  --       fallback()
  --     end
  --   end, {
  --     "i",
  --     "s",
  --   })
  -- },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  }),

  formatting = {
    format = function(entry, item)
      item.kind = icons.kind[item.kind]
      item.menu = ({
        nvim_lsp = "[LSP]",
        vsnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
        crates = "[Crates]",
        latex_symbols = "[LaTex]",
      })[entry.source.name]
      return item
    end,
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
