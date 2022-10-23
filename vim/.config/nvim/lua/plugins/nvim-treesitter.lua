local M = {}

local options = {
  -- list of available parsers
  ensure_installed = { 'go', 'json', 'yaml' },

  highlight = {
    -- false disables the entire extension
    enable = true,
    disable = { 'vim' },
  },
}


function M.setup()
  local ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
  if not ok then
    print("nvim-treesitter.configs not found, skipping setup")
    return
  end
  treesitter_configs.setup(options)
end

return M
