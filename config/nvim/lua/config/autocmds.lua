local dotfiles_group = vim.api.nvim_create_augroup("dotfiles", { clear = true })

-- Briefly highlight the copied text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = dotfiles_group,
  callback = function()
    vim.hl.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

-- Simple LSP Progress notification
vim.api.nvim_create_autocmd("LspProgress", {
  group = dotfiles_group,
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    vim.notify(string.format('%s: %s', client.name, vim.lsp.status()), vim.log.levels.INFO, {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        notif.icon = ev.data.params.value.kind == "end" and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

-- Configure abbreviations
vim.api.nvim_create_autocmd("FileType", {
  group = dotfiles_group,
  callback = function()
    -- Remove any format strings and trim spaces
    local comment_string = vim.trim((vim.bo.commentstring:gsub("%%s", "")))
    -- Create the buffer local abbreviations with the appropriate comment string
    vim.cmd(string.format("iabbrev <buffer> todo %s TODO(tabboud):", comment_string))
    vim.cmd(string.format("iabbrev <buffer> tda %s TDA:", comment_string))
  end
})

-- Relative line numbers only in the focused window while not in insert mode
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  group = dotfiles_group,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  group = dotfiles_group,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd "redraw"
    end
  end,
})

-- Warn when opening files that should not be edited by hand
for pattern, msg in pairs({
  ["*/vendor/*"] = "Vendor file",
  ["*/internal/generated/*"] = "Generated file",
}) do
  vim.api.nvim_create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
    group = dotfiles_group,
    pattern = pattern,
    callback = function()
      vim.notify_once(msg, vim.log.levels.WARN)
    end,
  })
end
