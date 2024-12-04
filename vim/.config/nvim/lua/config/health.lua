-- Custom Health Checks
--
-- Run `:checkhealth config`

local M = {}

local health = vim.health

function M.check()
  vim.health.start("Checking requirements")
  vim.health.info("Neovim Version: v" .. vim.fn.matchstr(vim.fn.execute "version", "NVIM v\\zs[^\n]*"))

  local programs = {
    {
      cmd = { "git" },
      type = "error",
      msg = "Used for core functionality such as updater and plugin management",
    },
    {
      cmd = { "rg" },
      type = "warn",
      msg = "Used for Telescope",
    },
    {
      cmd = { "fd" },
      type = "error",
      msg = "Used for Telescope",
    },
  }

  for _, program in ipairs(programs) do
    local name = table.concat(program.cmd, "/")
    local found = false
    for _, cmd in ipairs(program.cmd) do
      if vim.fn.executable(cmd) == 1 then
        name = cmd
        if not program.extra_check or program.extra_check(program) then found = true end
        break
      end
    end

    if found then
      vim.health.ok(("`%s` is installed: %s"):format(name, program.msg))
    else
      vim.health[program.type](("`%s` is not installed: %s"):format(name, program.msg))
    end
  end
end

return M
