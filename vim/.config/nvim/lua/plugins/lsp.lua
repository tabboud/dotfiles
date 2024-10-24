return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require("pluginconfig.lsp")
    end,
    dependencies = {
      -- Automatically install LSPs/tools to stdpath
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Better UI for hover, code-actions, and diagnostics
      "glepnir/lspsaga.nvim",

      -- Show current code context in the winbar
      "SmiteshP/nvim-navic",

      -- Get LSP loading status in the status bar
      "nvim-lua/lsp-status.nvim",
      "mrded/nvim-lsp-notify"
    },
  },
  {
    'mrded/nvim-lsp-notify',
    enabled = false,
    dependencies = { 'rcarriga/nvim-notify' },
    config = function()
      require('lsp-notify').setup({
        notify = require('notify'),
      })
    end
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.opt.termguicolors = true
      require("notify").setup({
        background_colour = "#000000",
      })
    end
  },

  ----------------
  -- Completion
  ----------------
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    config = function()
      local luasnip = require("luasnip")
      local cmp = require('cmp')
      local types = require('cmp.types')
      local icons = require("icons")


      vim.o.completeopt = "menuone,noselect"

      -- Load snippets from luasnip
      require("luasnip.loaders.from_vscode").lazy_load()

      -- local feedkey = function(key, mode)
      --   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      -- end

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      cmp.setup({
        -- Disable LSP preselection results to prevent the cursor jumping around in the completion window.
        -- ref: https://github.com/hrsh7th/nvim-cmp/issues/1809
        preselect = cmp.PreselectMode.None,
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          -- use c-{j,k} to scroll through completions
          -- SelectBehavior.Insert "inserts" the completed option where the cursor is.
          -- SelectBehavior.Select will just "select/highlight" the completed option in the completion menu
          -- Just insert the text don't replace, see https://github.com/hrsh7th/nvim-cmp/issues/664
          ['<C-j>'] = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
          ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
          ['<CR>'] = cmp.mapping.confirm({
            -- TODO: Fix the insert behavior when there is an LSP completion item. Using ConfirmBehavior.Insert
            -- works correctly for non-LSP completions, but LSP causes the next word to be deleted.
            -- See https://github.com/hrsh7th/nvim-cmp/issues/664 for ConfirmBehavior explanation
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              -- TODO: Find a better way to enable this behavior
              -- Allow using tab to jump to next field when the cmp window is visible
              -- Helpful for jumping to the next function arg template
              -- if luasnip.jumpable(1) then
              -- luasnip.jump(1)
              -- else
              cmp.select_next_item()
              -- end
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        -- sorting = {
        --   comparators = {
        --     cmp.config.compare.offset,
        --     cmp.config.compare.exact,
        --     cmp.config.compare.score,
        --     cmp.config.compare.recently_used,
        --     -- require("cmp-under-comparator").under,
        --     cmp.config.compare.kind,
        --   },
        -- },
        cmdline = {
          enable = true,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer',                 keyword_length = 5 },
          { name = 'nvim_lsp_signature_help' },
        },
        formatting = {
          format = function(entry, item)
            item.kind = icons.kind[item.kind]
            item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
            })[entry.source.name]
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline({ '/', '?' }, {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     { name = 'buffer' }
      --   }
      -- })

      -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline(':', {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources(
      --     { { name = 'path' } },
      --     { { name = 'cmdline' } }
      --   )
      -- })
    end,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'saadparwaiz1/cmp_luasnip',
      {
        'L3MON4D3/LuaSnip',
        version = 'v1.*',
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
      },
    },
  },
}
