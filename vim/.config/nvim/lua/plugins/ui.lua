-- ui.lua
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

-- Lualine
local icons = require("icons").lualine

local project_name = function()
  local project = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  return string.format("%s %s", icons.Folder, project)
end

local get_attached_lsp = function()
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.attached_buffers[vim.api.nvim_get_current_buf()] then
      return string.format("%s LSP: %s ", icons.Lsp, client.name)
    end
  end
  return string.format("%s LSP: none ", icons.Lsp)
end

local custom_jellybeans = require 'lualine.themes.jellybeans'
custom_jellybeans.inactive.c.bg = colors.inactivegray

require('lualine').setup {
  options = {
    theme = custom_jellybeans,
    component_separators = { left = icons.ComponentSeparator, right = icons.ComponentSeparator },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { "neo-tree" },
    },
  },
  sections = {
    lualine_a = { project_name },
    lualine_b = { "filename" },
    lualine_c = {
      "searchcount",
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

-- Bufferline
require("bufferline").setup {
  options = {
    diagnostics = "nvim_lsp",
    separator_style = "slant",
    offsets = {
      {
        filetype = "neo-tree",
        text = "",
        text_align = "left",
        separator = true,
      }
    },
    groups = {
      items = {
        require('bufferline.groups').builtin.ungrouped,
        {
          name = "Vendor",
          auto_close = true,
          highlight = {
            underline = false,
            italic = true,
            bold = false,
            fg = colors.green,
            sp = "green",
          },
          matcher = function(buf)
            if buf.path == nil then
              return false
            end
            local luaDataDir = vim.fn.stdpath("data")
            return buf.path:match('/vendor/') or buf.path:match(luaDataDir)
          end
        }
      },
    },
  }
}

vim.keymap.set("n", "gn", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer: Go to next" })
vim.keymap.set("n", "gp", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer: Go to prev" })
