-- User commands

vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update()
end, {})

---Returns the current buffer's cwd-relative path and line, formatted as "path:line".
---@return string
local function current_file_and_line()
  local filepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  return string.format("%s:%s", filepath, vim.fn.line("."))
end

-- Custom 'gh' commands
vim.api.nvim_create_user_command("GH", function()
  if vim.fn.executable("gh") == 0 then
    vim.notify("'gh' executable not found", vim.log.levels.ERROR)
    return
  end

  vim.ui.select(
    {
      {
        name = "View Repo",
        callback = function()
          vim.fn.system({ "gh", "repo", "view", "--web" })
        end,
      },
      {
        name = "View PR",
        callback = function()
          vim.ui.input({ prompt = "Enter PR #: " }, function(input)
            if input == nil or input == "" then
              return
            end
            vim.fn.system({ "gh", "pr", "view", "--web", input })
          end)
        end,
      },
      {
        name = "Browse the current buffer in GH",
        callback = function()
          local file_and_line = current_file_and_line()
          vim.notify("Opening " .. file_and_line .. " in the browser")
          vim.fn.system({ "gh", "browse", file_and_line })
        end,
      },
      {
        name = "Permalink current line",
        callback = function()
          local commit = vim.trim(vim.fn.system({ "git", "rev-parse", "HEAD" }))
          local out = vim.fn.system({ "gh", "browse", current_file_and_line(), "--no-browser", "--commit=" .. commit })
          vim.fn.setreg("+", vim.trim(out))
          vim.notify("Copied permalink")
        end,
      },
    },
    {
      prompt = "Select a GH command: ",
      format_item = function(cmd)
        return cmd.name
      end,
    },
    function(choice)
      if choice then
        choice.callback()
      end
    end
  )
end, {})
