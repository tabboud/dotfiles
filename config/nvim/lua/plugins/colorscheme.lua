-- colorscheme.lua
require('github-theme').setup({
  options = {
    transparent = true,
  }
})

-- Highlight overrides applied on top of any colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("dotfiles_colorscheme", { clear = true }),
  callback = function()
    -- Ensure the currently selected search item is a different color than all other search results
    vim.api.nvim_set_hl(0, "CurSearch", { fg = "#262627", bg = "#ff7c6b" })
    -- Red window separators so splits are easy to see
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#ff0000", bg = "none" })
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ff0000", bg = "none" })
  end,
})

---Returns whether light mode is selected in $HOME/.theme.
---@return boolean
local function is_light_mode()
  local file = io.open(os.getenv("HOME") .. "/.theme", "r")
  if not file then
    return false
  end
  local content = file:read("*line")
  file:close()
  return content == "light"
end

local light_mode = is_light_mode()
local colorscheme = light_mode and "github_light" or "github_dark_dimmed"
vim.o.background = light_mode and "light" or "dark"
if not pcall(vim.cmd.colorscheme, colorscheme) then
  print("colorscheme '" .. colorscheme .. "' not found, using default")
  vim.cmd.colorscheme("default")
end
