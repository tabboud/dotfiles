return {
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      local icons = require("icons").lualine

      -- projectName returns the name of the containing directory (or project).
      local project_name = function()
        local project = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        return string.format("%s %s", icons.Folder, project)
      end

      -- returns the currently attached LSP server or 'none' if no server is attached.
      local get_attached_lsp = function()
        for _, client in ipairs(vim.lsp.get_clients()) do
          if client.attached_buffers[vim.api.nvim_get_current_buf()] then
            return string.format("%s LSP: %s ", icons.Lsp, client.name)
          end
        end
        -- no clients attached
        return string.format("%s LSP: none ", icons.Lsp)
      end

      require('lualine').setup {
        options = {
          theme = IsLightMode() and "onelight" or "jellybeans",
          component_separators = { left = icons.ComponentSeparator, right = icons.ComponentSeparator },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {
              "neo-tree"
            },
          },
        },
        sections = {
          lualine_a = { project_name },
          lualine_b = { "filename" },
          lualine_c = {
            "searchcount",
            -- show macro recording (for struct definition, see :h lualine - lualine-General-component-options)
            {
              function()
                return 'Recording @' .. vim.fn.reg_recording()
              end,
              cond = function()
                return vim.fn.reg_recording() ~= ''
              end,
              color = { fg = 'red' },
            },
          },
          lualine_x = { get_attached_lsp, "diagnostics" },
          lualine_y = {},
          lualine_z = { "branch" },
        },
        inactive_sections = {
          lualine_a = { { "filename", file_status = false } },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {},
      }
    end
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("bufferline").setup {
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          offsets = {
            {
              -- Don't show buffers above neotree
              filetype = "neo-tree",
              text = "",
              text_align = "left",
              separator = true,
            }
          },
        }
      }
      vim.keymap.set("n", "gn", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer: Go to next" })
      vim.keymap.set("n", "gp", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer: Go to prev" })
    end,
  },
  {
    "folke/todo-comments.nvim",
    enabled = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local icons = require('icons')
      require('todo-comments').setup({
        keywords = {
          TDA = { icon = icons.lsp.hint, color = "hint" },
        },
        highlight = {
          -- default pattern
          -- pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
          -- pattern to highlight "TODO(author)"
          pattern = [[(KEYWORDS)\s*(\([^\)]*\))?]],
        },
        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--hidden",       -- search hidden files
            "--glob=!vendor", -- ignore the vendor directory
          },
          pattern = [[\b(KEYWORDS)\s*(\([^\)]*\))?:]],
          -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
        },
      })
    end,
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    },
  },
}
