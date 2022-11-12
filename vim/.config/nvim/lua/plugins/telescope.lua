local M = {}

-- entry_maker for lsp_references/lsp_implementations
-- This was copied from telescope.nvim and updates the displayer to no longer
-- display the preview in the results window. See comment inline below.
local gen_from_quickfix = function(opts)
  local utils = require("telescope.utils")
  local entry_display = require("telescope.pickers.entry_display")
  opts = opts or {}

  local displayer = entry_display.create {
    separator = "▏",
    items = {
      { width = 8 },
      { width = opts.bufnr_width },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    local filename = utils.transform_path(opts, entry.filename)

    local line_info = { table.concat({ entry.lnum, entry.col }, ":"), "TelescopeResultsLineNr" }

    if opts.trim_text then
      entry.text = entry.text:gsub("^%s*(.-)%s*$", "%1")
    end

    return displayer {
      line_info,
      -- TODO(TDA): The following line adds in the preview text in the 'Results' window.
      --            This function was pulled directly from nvim-telescope.
      -- entry.text:gsub(".* | ", ""),
      filename,
    }
  end

  return function(entry)
    local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)

    return {
      valid = true,
      value = entry,
      ordinal = (not opts.ignore_filename and filename or "") .. " " .. entry.text,
      display = make_display,
      bufnr = entry.bufnr,
      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      text = entry.text,
      start = entry.start,
      finish = entry.finish,
    }
  end
end

local options = function()
  local actions = require("telescope.actions")
  local action_layout = require("telescope.actions.layout")
  local themes = require('telescope.themes')
  local lga_actions = require("telescope-live-grep-args.actions")

  return {
    defaults = {
      layout_strategy = 'flex',
      file_ignore_patterns = {
        -- Adding this explicitly to the commands that should ignore it instead of being global
        -- "vendor",
        "^.git/",
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        -- Trim indentation at the beginning of presented line in result window
        "--trim"
      },
      mappings = {
        i = {
          -- map actions.which_key to <C-h> (default: <C-/>)
          -- actions.which_key shows the mappings for your picker,
          -- e.g. git_{create, delete, ...}_branch for the git_branches picker
          ["<C-h>"] = "which_key",

          -- Toggle preview window (global preview must be set to true)
          ["?"] = action_layout.toggle_preview,

          -- Allow using ctrl-{j,k} to move to next selection, similar to fzf
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous
        },
        n = {
          -- Allow using ctrl-{j,k} to move to next selection, similar to fzf
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous
        }
      }
    },
    pickers = {
      -- find_files with the ivy theme + preview
      find_files = themes.get_ivy {
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
        hidden = true,
      },
      buffers = {
        theme = "dropdown",
        ignore_current_buffer = true,
        sort_lastused = true,
      },
      lsp_references = themes.get_ivy {
        trim_text = false,
        entry_maker = gen_from_quickfix(),
      },
      lsp_implementations = themes.get_ivy {
        trim_text = false,
        entry_maker = gen_from_quickfix(),
      },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        mappings = {
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-l>g"] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
            ["<C-l>t"] = lga_actions.quote_prompt({ postfix = ' -t' }),
          }
        }
      }
    }
  }
end

local configure_keymaps = function()
  local builtin = require('telescope.builtin')
  local ignore_patterns = { file_ignore_patterns = { "%_test.go", "%_mocks.go" } }

  local nmap = function(lhs, rhs)
    vim.keymap.set("n", lhs, rhs, { noremap = false, silent = true })
  end

  nmap("<leader><Enter>", function() return builtin.buffers({ previewer = false }) end)
  nmap("<leader>p", function() return builtin.find_files() end)

  -- live_grep with dynamic args for rg
  nmap("<leader>rg", function() return builtin.live_grep() end)
  nmap("rg", function()
    return builtin.live_grep({
      prompt = " Live grep (rg) ",
      file_ignore_patterns = { "vendor" },
    })
  end)

  -- LSP commands through Telescope - These supercede the ones defined in lspconfig.lua
  -- Show symbols for the current document
  nmap("g0", function() return builtin.lsp_document_symbols() end)

  -- Find all implementations + ignore tests/mocks
  nmap("<leader>gi", function() return builtin.lsp_implementations() end)
  nmap("gi", function() return builtin.lsp_implementations(ignore_patterns) end)

  -- Find all references + ignore tests/mocks
  nmap("<leader>gr", function() return builtin.lsp_references() end)
  nmap("gr", function() return builtin.lsp_references(ignore_patterns) end)

  -- Edit dotfiles
  nmap("<leader>ed", function()
    local dotfilesPath = vim.env.DOTFILES
    if dotfilesPath == "" then
      print("[editDotfiles] $DOTFILES is not configured")
      return
    end
    return builtin.find_files({
      shorten_path = false,
      cwd = dotfilesPath,
      prompt = "~ dotfiles ~",
      hidden = true,
    })
  end)
end


function M.setup()
  local ok, telescope = pcall(require, 'telescope')
  if not ok then
    print("Telescope could not be required...skipping setup")
    return
  end
  telescope.setup(options())
  configure_keymaps()
end

return M
