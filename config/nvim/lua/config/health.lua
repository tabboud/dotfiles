-- Custom Health Checks
--
-- Run `:checkhealth config`

local M = {}

function M.check()
  vim.health.start("Checking requirements")
  vim.health.info("Neovim Version: v" .. tostring(vim.version()))

  local programs = {
    { cmd = "git", type = "error", msg = "Used for core functionality such as plugin management" },
    { cmd = "rg", type = "warn", msg = "Used for Snacks picker grep" },
    { cmd = "fd", type = "error", msg = "Used for Snacks picker files" },
    { cmd = "npm", type = "error", msg = "Used by Mason for vim-language-server and yaml-language-server" },
    { cmd = "gh", type = "error", msg = "Used for :GH commands" },
    { cmd = "go", type = "error", msg = "Required to install Go tooling via Mason" },
    { cmd = "tree-sitter", type = "error", msg = "Required for nvim-treesitter" },
    { cmd = "cargo", type = "error", msg = "Cargo and rust are required to run ':BlinkCmp build'" },
  }

  for _, program in ipairs(programs) do
    if vim.fn.executable(program.cmd) == 1 then
      vim.health.ok(("`%s` is installed: %s"):format(program.cmd, program.msg))
    else
      vim.health[program.type](("`%s` is not installed: %s"):format(program.cmd, program.msg))
    end
  end
end

return M
