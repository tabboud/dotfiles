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

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Ensure the currently selected search item is a different color than all other search results
    vim.api.nvim_set_hl(0, "CurSearch", { fg = "#262627", bg = "#ff7c6b" })
  end
})

-- Simple LSP Progress notification
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    local client_id = ev.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    if not client then
      return
    end

    vim.notify(string.format('%s: %s', client.name, vim.lsp.status()), vim.log.levels.INFO, {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        notif.icon = ev.data.params.value.kind == "end" and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

-- Configure abbreviations
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local comment_string = vim.bo.commentstring
    -- Remove any format strings and trim spaces
    comment_string = comment_string:gsub("%%s", ""):gsub("^%s*(.-)%s*$", "%1")
    -- Create the buffer local abbreviations with the appropriate comment string
    local todo_text = string.format("iabbrev <buffer> todo %s TODO(tabboud):", comment_string)
    local tda_text = string.format("iabbrev <buffer> tda %s TDA:", comment_string)
    vim.cmd(todo_text)
    vim.cmd(tda_text)
  end
})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = dotfiles_group,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = dotfiles_group,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd "redraw"
    end
  end,
})
