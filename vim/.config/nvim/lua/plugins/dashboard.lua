local group = vim.api.nvim_create_augroup("Startup", { clear = true })
vim.api.nvim_create_autocmd("FileType", { group = group, pattern = "startup", command = "setlocal list&" })

local in_git_repo = function()
  return Snacks.git.get_root() ~= nil
end

local terminal_cmds = function()
  local cmds = {
    {
      icon = " ",
      title = "Git Status",
      cmd = "git --no-pager diff --stat -B -M -C",
      height = 10,
    },
  }
  return vim.tbl_map(function(cmd)
    return vim.tbl_extend("force", {
      pane = 2,
      section = "terminal",
      enabled = in_git_repo,
      padding = 1,
      ttl = 5 * 60,
      indent = 3,
    }, cmd)
  end, cmds)
end

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = true,
      row = nil,
      col = nil,
      preset = {
        ---@type snacks.dashboard.Item[]
        keys = {
          {
            icon = " ",
            key = "f",
            desc = "Find File",
            action = function()
              if in_git_repo() then
                Snacks.picker.git_files()
              else
                Snacks.picker.files()
              end
            end
          },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "d",
            desc = "Dotfiles",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.getenv('DOTFILES'), hidden=true})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys",   gap = 1, padding = 1 },
        -- terminal_cmds(),
        { section = "startup" },
      },
    },
  },
}
