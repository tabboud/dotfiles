return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSP/tools to stdpath
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Better UI for hover, code-actions, and diagnostics
      "glepnir/lspsaga.nvim",

      -- Show current code context in the winbar
      "SmiteshP/nvim-navic",
    },
    config = function()
      local lspsaga = require('lspsaga')
      local mason = require('mason')
      local mason_lspconfig = require('mason-lspconfig')
      local mason_tool_installer = require('mason-tool-installer')
      local icons = require("icons")

      -- LSP On-Attach autocmd
      vim.api.nvim_create_autocmd({ 'LspAttach' }, {
        callback = function(args)
          local bufnr = args.buf
          local client_id = args.data.client_id
          local client = vim.lsp.get_client_by_id(client_id)
          if not client then
            return
          end

          -- Configure keymaps
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { desc = desc, noremap = true, silent = true, buffer = bufnr, })
          end
          -- nvim-lspconfig keymaps
          map("gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "LSP: Workspace symbols")
          map("<c-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", "LSP: Go to definition")
          -- lsp-saga keymaps
          map("ga", "<cmd>Lspsaga code_action<CR>", "LSP: Code Action")
          map("g]", "<cmd>Lspsaga diagnostic_jump_next<CR>", "LSP: Diagnostics next")
          map("g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "LSP: Diagnostics prev")
          map("K", "<cmd>Lspsaga hover_doc<CR>", "LSP: Hover docs")
          -- default + snacks.input
          map("<leader>rn", function() vim.lsp.buf.rename(nil, { prompt = "Rename" }) end,
            "LSP: Rename word under cursor")

          -- prefix diagnostics with the name of the client
          local ns = vim.lsp.diagnostic.get_namespace(client_id)
          vim.diagnostic.config({
            virtual_text = {
              format = function(d)
                return string.format('%s: %s', client.name, d.message)
              end,
            },
          }, ns)

          -- turn on document highlight
          if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd("CursorHold", {
              buffer = bufnr,
              command = "lua vim.lsp.buf.document_highlight()",
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              buffer = bufnr,
              command = "lua vim.lsp.buf.clear_references()",
            })
          end

          -- turn on document formatting
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "lua vim.lsp.buf.format()",
            })
          end

          -- turn on breadcrumbs if document symbols are supported
          if client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, bufnr)
          end

          -- turn on inlay-hints with a keymap toggle
          if client.server_capabilities.inlayHintProvider then
            vim.keymap.set("n", "<leader>dh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ nil }))
            end, { buffer = bufnr, desc = "✨LSP toggle inlay hints" })
          end

          -- turn off semantic token support
          if client.server_capabilities.semanticTokensProvider then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })

      -- Diagnostic sign mappings
      local diagnostic_signs = {
        { name = "LspDiagnosticsSignError",       text = icons.lsp.error },
        { name = "LspDiagnosticsSignWarning",     text = icons.lsp.warning },
        { name = "LspDiagnosticsSignHint",        text = icons.lsp.hint },
        { name = "LspDiagnosticsSignInformation", text = icons.lsp.info },
        { name = "DiagnosticSignError",           text = icons.lsp.error },
        { name = "DiagnosticSignWarn",            text = icons.lsp.warning },
        { name = "DiagnosticSignHint",            text = icons.lsp.hint },
        { name = "DiagnosticSignInfo",            text = icons.lsp.info },
      }
      for _, sign in ipairs(diagnostic_signs) do
        vim.fn.sign_define(sign.name, {
          text = sign.text,
          texthl = sign.name,
          linehl = "",
          numhl = sign.name,
        })
      end

      -- nvim-navic: add in the winbar extension after loading
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

      -- LSP server settings
      local server_settings = {
        -- gopls settings: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
        gopls = {
          gopls = {
            usePlaceholders = true,
            gofumpt = false,
            staticcheck = false,
            analyses = {
              shadow = false,
              unusedparams = false,
              nilness = true,
              unusedwrite = true,
              useany = true,
            },
            codelenses = {
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = false,
              compositeLiteralFields = true,
              compositeLiteralTypes = false,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true
            },
          },
        },

        -- lua-language-server settings
        lua_ls = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            workspace = {
              checkThirdParty = false,
              maxPreload = 2000,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          },
        },
      }

      -- Setup mason so it can manage external tooling
      mason.setup({
        providers = {
          -- Use client providers instead of registry-api due to SSL issues using a VPN
          -- ref: https://github.com/williamboman/mason.nvim/issues/633
          "mason.providers.client",
          "mason.providers.registry-api" -- This is the default provider used as a fallback
        },
      })
      mason_tool_installer.setup({
        ensure_installed = {
          -- go
          "delve",
          "gofumpt",
          "goimports",
          "golangci-lint",
          "gopls",
          "impl",
          "staticcheck",

          -- lua
          'lua-language-server',
          'stylua',

          -- rust
          'rust-analyzer',

          -- vim
          'vim-language-server',
          'shellcheck',
        }
      })
      mason_lspconfig.setup({
        ensure_installed = {
          "gopls",
          "lua_ls",
          "yamlls",
        },
      })

      local get_cmp_capabilities = function(capabilities)
        -- nvim-cmp
        local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
        if has_cmp_nvim_lsp then
          -- apply with overrides
          vim.notify_once("cmp_nvim_lsp", vim.log.levels.INFO)
          return cmp_nvim_lsp.default_capabilities(capabilities)
        else
          -- blink.nvim
          local has_blink_cmp, blink_cmp = pcall(require, 'blink.cmp')
          if has_blink_cmp then
            vim.notify_once("blink_cmp", vim.log.levels.INFO)
            return blink_cmp.get_lsp_capabilities(capabilities)
          end
        end
        return capabilities
      end

      local get_capabilities = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
          properties = { "documentation", "detail", "additionalTextEdits" },
        }
        return get_cmp_capabilities(capabilities)
      end

      mason_lspconfig.setup_handlers {
        -- The first entry (without a key) will be the default handler and will
        -- be called for each installed server that doesn't have a dedicated handler.
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = get_capabilities(),
            settings = server_settings[server_name],
          }
        end,
      }

      -- setup lsp-saga
      lspsaga.setup()
    end,
  },
}
