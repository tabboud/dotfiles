local colors = {
  black        = '#282828',
  white        = '#ebdbb2',
  red          = '#fb4934',
  green        = '#b8bb26',
  blue         = '#83a598',
  yellow       = '#fe8019',
  gray         = '#a89984',
  darkgray     = '#3c3836',
  lightgray    = '#504945',
  inactivegray = '#7c6f64',
}
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
      local custom_jellybeans = require 'lualine.themes.jellybeans'
      -- Change the background of lualine_c section for normal mode
      custom_jellybeans.inactive.c.bg = colors.inactivegray
      require('lualine').setup {
        options = {
          theme = custom_jellybeans,
          -- TODO(tabboud): Make the status-line / window separators clearer when split horizontal
          -- theme = IsLightMode() and "onelight" or "jellybeans",
          -- theme = {
          --   inactive = {
          --     a = { bg = colors.red, fg = colors.gray, gui = 'bold' },
          --     b = { bg = colors.red, fg = colors.gray },
          --     c = { bg = colors.red, fg = colors.gray }
          --   },
          -- },
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

          -- FIXME: Highlight the files in "internal/generated" and "vendor" differently so it's clear what is a dependency
          --
          -- V1 - highlight the bufferline icon for vendor files with a different color
          -- get_element_icon = function(element)
          --   local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
          --   -- highlight vendor code with a red logo
          --   print(element.path)
          --   if vim.startswith(element.path, "vendor") then
          --     return icon, "DevIconRedHat"
          --   end
          --   return icon, hl
          -- end
          --
          -- V2: Use groups for vendor files to make it clear
          -- This is not bad, but needs to be right aligned since it's hard to see
          -- Could also try grouping to the right. See :h bufferline-ordering-groups
          --
          -- Maybe we need a default group for everything else and then set the
          -- priority to make it come at the end
          groups = {
            items = {
              require('bufferline.groups').builtin.ungrouped, -- the ungrouped buffers will be in the middle of the grouped ones
              {
                name = "Vendor",
                auto_close = true,
                highlight = {
                  underline = true,
                  italic = true,
                  bold = false,
                  fg = colors.green,
                  -- bg = colors.inactivegray,
                  sp = "green",
                },
                matcher = function(buf)
                  if buf.path == nil then
                    return false
                  end
                  return buf.path:match('/vendor/')
                end
              }
            },
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
