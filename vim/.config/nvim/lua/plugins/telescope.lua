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

-- creates filename first in the results output
-- See: https://github.com/nvim-telescope/telescope.nvim/issues/2014
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "TelescopeResults",
--   callback = function(ctx)
--     vim.api.nvim_buf_call(ctx.buf, function()
--       vim.fn.matchadd("TelescopeParent", "\t\t.*$")
--       vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
--     end)
--   end,
-- })

-- local function filenameFirst(_, path)
--   local tail = vim.fs.basename(path)
--   local parent = vim.fs.dirname(path)
--   if parent == "." then return tail end
--   return string.format("%s\t\t%s", tail, parent)
-- end

return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Allow neovim core to fill the telescope picker (e.g. lua vim.lsp.buf.code_action())
      'nvim-telescope/telescope-ui-select.nvim',
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      local themes = require('telescope.themes')
      local trouble = require("trouble.sources.telescope")

      -- Load live_grep_args extension
      require("telescope").load_extension("live_grep_args")
      local lga_actions = require("telescope-live-grep-args.actions")

      telescope.setup({
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
            "--trim",
            "--hidden"
          },
          mappings = {
            i = {
              ["<c-s>"] = trouble.open,

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
              ["<c-s>"] = trouble.open,
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
            -- path_display = filenameFirst,
          },
          buffers = {
            theme = "dropdown",
            ignore_current_buffer = true,
            -- sort_lastused = true,
            sort_mru = true,
          },
          lsp_references = themes.get_ivy {
            trim_text = false,
            entry_maker = gen_from_quickfix(),
          },
          lsp_implementations = themes.get_ivy {
            trim_text = false,
            entry_maker = gen_from_quickfix(),

            -- see for below: https://github.com/nvim-telescope/telescope.nvim/issues/2606#issuecomment-1641220136
            -- disable_coordinates = true,
            -- path_display = { 'truncate' },
          },
        },
        extensions = {
          -- requires the 'nvim-telescope/telescope-ui-select.nvim' plugin
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({})
          },
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {         -- extend mappings
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          }
        }
      })

      -- Load extensions (must come after the setup function)
      require("telescope").load_extension("ui-select")

      -- Configure keymaps
      local builtin = require('telescope.builtin')
      local ignore_patterns = { file_ignore_patterns = { "%_test.go", "%_mocks.go" } }
      local nnoremap = require('keymaps').nnoremap

      nnoremap("<leader><Enter>", "<cmd>lua require('telescope.builtin').buffers({previewer=false})<CR>",
        -- builtin.buffers({ previewer = false }),
        { desc = "Telescope: List open buffers" })
      nnoremap("<leader>p", function()
        require('telescope.builtin').find_files({
          prompt_title = "My Find Files",
          file_ignore_patterns = {
            "^vendor/",
            "^.git/",
            "^changelog/"
          }
        })
      end, { desc = "Telescope: Find files" })

      -- live_grep with dynamic args for rg
      nnoremap("<leader>rg", builtin.live_grep)
      nnoremap("rg", function()
        require('telescope.builtin').live_grep(themes.get_ivy({
          prompt_title = " Live grep (rg) ",
          -- file_ignore_patterns = { "vendor", "^.git/" },
          file_ignore_patterns = { "vendor", "^.git/", "%_test.go", "%_mocks.go" },
        }))
      end, { desc = "Telescope: Live grep (rg)" })

      -- Add keymap for searching in dirs with glob
      -- Telescope live_grep search_dirs=cmd/helm glob_pattern=*_test.go
      -- nnoremap("rg", function()
      --   return builtin.live_grep(themes.get_ivy({
      --     prompt_title = " Live grep (rg) ",
      --     file_ignore_patterns = { "vendor", "^.git/" },
      --   }))
      -- end, { desc = "Telescope: Live grep (rg)" })

      -- LSP commands through Telescope - These supercede the ones defined in lspconfig.lua
      -- Show symbols for the current document
      nnoremap("<leader>sd", builtin.lsp_document_symbols, { desc = "LSP: Document symbols" })
      nnoremap("<leader>sw", builtin.lsp_dynamic_workspace_symbols, { desc = "LSP: Workspace symbols" })

      nnoremap("gi", builtin.lsp_implementations, { desc = "LSP: Go to implementations" })
      nnoremap("gr", builtin.lsp_references, { desc = "LSP: Go to references" })

      -- Edit dotfiles
      nnoremap("<leader>ed", function()
        local dotfilesPath = vim.env.DOTFILES
        if dotfilesPath == "" then
          print("[editDotfiles] $DOTFILES is not configured")
          return
        end
        require('telescope.builtin').find_files({
          shorten_path = false,
          cwd = dotfilesPath,
          prompt_title = "~ dotfiles ~",
          hidden = true,
        })
      end, { desc = "Telescope: Edit dotfiles" })

      nnoremap("<leader>h", builtin.help_tags, { desc = "Telescope: help" })
    end
  }
}
