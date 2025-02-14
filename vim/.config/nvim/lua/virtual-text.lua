-- V3: Use an extmark that persists.
-- This only pins to one line though and doesn't stick around
local api = vim.api

local bnr = vim.fn.bufnr('%')
local ns_id = api.nvim_create_namespace('demo')

local line_num = 5
local col_num = 5

local opts = {
  end_line = 10,
  id = 1,
  virt_text = { { "vendor", "@comment.warning" } },
  -- virt_text_pos = 'eol',
  virt_text_pos = 'right_align',
  -- virt_text_win_col = 20,
}

-- api.nvim_buf_set_extmark(bnr, ns_id, line_num, col_num, opts)

-- V4: Use a notification
-- This works well, but notifications are duplicated and this clobbers the notification history.
-- Only works for specific patterns, but really we want it configurable ignored files.
-- for example, non-vendored but module files in /../go/pkg/mod/../ are not found
-- Similar to the warning of "changing a read-only [RO] file"
local dont_edit_group = vim.api.nvim_create_augroup("dont_edit_group", { clear = true })
-- notify for vendor files
vim.api.nvim_create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  pattern = "*/vendor/*",
  group = dont_edit_group,
  callback = function()
    vim.notify_once("Vendor file", vim.log.levels.WARN, {})
  end,
})
vim.api.nvim_create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  pattern = "*/internal/generated/*",
  group = dont_edit_group,
  callback = function()
    vim.notify_once("Generated file", vim.log.levels.WARN, {})
  end,
})
