local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local builtin = require("telescope.builtin")

local utils = require("telescope.utils")
local Path = require "plenary.path"
local entry_display = require "telescope.pickers.entry_display"

local themes = require('telescope.themes')

-- entry_maker for lsp_references/lsp_implementations
-- This was copied from telescope.nvim and updates the displayer to no longer
-- display the preview in the results window. See comment inline below.
function gen_from_quickfix(opts)
  opts = opts or {}

  local displayer = entry_display.create {
    separator = "▏",
    items = {
      { width = 8 },
      { width = 0.45 },
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

require('telescope').setup{
  defaults = {
    -- Disable preview for ALL windows
    -- preview = false,

    -- wrap results since they are trimmed (defaults to false)
    wrap_results = false,
    -- Show filename in preview window (defaults to false)
    dynamic_preview_title = true,
    -- How file paths are displayed
    -- path_display = { "truncate" },

    -- Always use vertical layout to display results (defaults to 'horizontal')
    -- layout_strategy = 'vertical',

    -- ignore vendor directories in ALL windows
    file_ignore_patterns = {
        "vendor",
        "^.git/",
    },
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,

    -- Trim indentation at the beginning of presented line in result window
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim"
    },

    -- Custom mappings
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
        -- Toggle preview window
        -- ["<C-l>"] = action_layout.toggle_preview

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
    lsp_references = {
        trim_text = false,
        entry_maker = gen_from_quickfix(),
    },
    lsp_implementations = {
        trim_text = false,
        entry_maker = gen_from_quickfix(),
    },
    -- TODO(tabboud): consolidate the telescope logic in init.vim and here
  },
  extensions = {}
}

local previewers = require("telescope.previewers")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")

local godel_check_compiles = function(opts)
    opts = opts or {}
    pickers.new {
        prompt_title = "Godel Prompt",
        results_title = "[./godelw check compiles]",
        -- Run an external command and show the results in the finder window
        finder = finders.new_oneshot_job({"./godelw", "check", "compiles"}),
        sorter = sorters.get_fuzzy_file(),
  -- previewer = previewers.new_buffer_previewer {
  --   define_preview = function(self, entry, status)
  --      -- Execute another command using the highlighted entry
  --     return require('telescope.previewers.utils').job_maker(
  --         {"terraform", "state", "list", entry.value},
  --         self.state.bufnr,
  --         {
  --           callback = function(bufnr, content)
  --             if content ~= nil then
  --               require('telescope.previewers.utils').regex_highlighter(bufnr, 'apollo')
  --             end
  --           end,
  --         })
  --   end
  -- },
    }:find()
end
