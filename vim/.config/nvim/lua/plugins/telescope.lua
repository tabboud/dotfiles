return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Allow neovim core to fill the telescope picker (e.g. lua vim.lsp.buf.code_action())
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      local telescope = require('telescope')
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      local themes = require('telescope.themes')
      local trouble = require("trouble.sources.telescope")

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
            -- entry_maker = gen_from_quickfix(),
          },
          lsp_implementations = themes.get_ivy {
            trim_text = false,
            -- entry_maker = gen_from_quickfix(),

            -- see for below: https://github.com/nvim-telescope/telescope.nvim/issues/2606#issuecomment-1641220136
            -- disable_coordinates = true,
            -- path_display = { 'truncate' },
          },
        },
        extensions = {
          -- requires the 'nvim-telescope/telescope-ui-select.nvim' plugin
          ["ui-select"] = {
            require("telescope.themes").get_dropdown()
          },
        }
      })

      -- Load extensions (must come after the setup function)
      require("telescope").load_extension("ui-select")

      -- Configure keymaps
      local builtin = require('telescope.builtin')
      local ignore_patterns = { file_ignore_patterns = { "%_test.go", "%_mocks.go" } }
      local map = function(lhs, rhs, opts)
        vim.keymap.set("n", lhs, rhs, opts)
      end

      map("<leader>h", builtin.help_tags, { desc = "Telescope: help" })
      -- fuzzy search current buffer
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      map("<leader><Enter>", "<cmd>lua require('telescope.builtin').buffers({previewer=false})<CR>",
        { desc = "Telescope: List open buffers" })
      map("<leader>p", function()
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
      map("<leader>rg", builtin.live_grep)
      map("rg", function()
        require('telescope.builtin').live_grep(themes.get_ivy({
          prompt_title = " Live grep (rg) ",
          -- file_ignore_patterns = { "vendor", "^.git/" },
          file_ignore_patterns = { "vendor", "^.git/", "%_test.go", "%_mocks.go" },
        }))
      end, { desc = "Telescope: Live grep (rg)" })

      -- LSP commands through Telescope - These supercede the ones defined in lspconfig.lua
      -- Show symbols for the current document
      map("<leader>sd", builtin.lsp_document_symbols, { desc = "LSP: Document symbols" })
      map("<leader>sw", builtin.lsp_dynamic_workspace_symbols, { desc = "LSP: Workspace symbols" })
      map("gi", builtin.lsp_implementations, { desc = "LSP: Go to implementations" })
      map("gr", builtin.lsp_references, { desc = "LSP: Go to references" })
      map("<leader>gr", function()
        builtin.lsp_references({
          file_ignore_patterns = { "vendor", "^.git/", "%_test.go", "%_mocks.go" },
        })
      end, { desc = "LSP: Go to references ignoring test files" })

      -- Edit dotfiles in a new tab page
      map("<leader>ed", function()
        local dotfilesPath = vim.env.DOTFILES
        if dotfilesPath == "" then
          print("[editDotfiles] $DOTFILES is not configured")
          return
        end

        vim.cmd('tabedit')
        require('telescope.builtin').find_files({
          shorten_path = false,
          cwd = dotfilesPath,
          prompt_title = "dotfiles",
          hidden = true,
        })
      end, { desc = "Telescope: Edit dotfiles" })
    end
  }
}
