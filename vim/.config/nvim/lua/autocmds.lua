local api = vim.api

local dotfiles = api.nvim_create_augroup("dotfiles", { clear = true })

-- Jump to last known position on BufReadPost for all files
api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  group = dotfiles,
  callback = function()
    local ft = vim.opt_local.filetype:get()
    -- don't apply to git messages
    if (ft:match('commit') or ft:match('rebase')) then
      return
    end
    -- get position of last saved edit
    local markpos = api.nvim_buf_get_mark(0, '"')
    local line = markpos[1]
    local col = markpos[2]
    -- if in range, go there
    if (line > 1) and (line <= api.nvim_buf_line_count(0)) then
      api.nvim_win_set_cursor(0, { line, col })
    end
  end
})
