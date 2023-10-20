local dotfiles_group = vim.api.nvim_create_augroup("dotfiles", { clear = true })

-- Briefly highlight the copied text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = dotfiles_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

-- Set colorscheme for Diffview separate from other tabs
vim.api.nvim_create_autocmd('ColorScheme', {
  group = dotfiles_group,
  pattern = '*',
  callback = function()
    -- https://www.reddit.com/r/neovim/comments/rxbbug/how_do_i_override_a_colorschemes_highlight_in_a/
  end,
})

-- Run gofmt/gofmpt, import packages automatically on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('setGoFormatting', { clear = true }),
  pattern = '*.go',
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 2000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end

    vim.lsp.buf.format()
  end
})
