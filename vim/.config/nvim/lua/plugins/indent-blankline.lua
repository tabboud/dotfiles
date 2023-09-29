local M = {}

local options = {
  enabled = true,
  exclude = {
    buftypes = { "terminal", "nofile" },
    filetypes = {
      "help",
      "startify",
      "dashboard",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "text",
    },
  },
  indent = {
    char = "▏",
  },
  scope = {
    show_start = false,
  },
}

function M.setup()
  local ok, ibl = pcall(require, 'ibl')
  if not ok then
    print("indent_blanklines could not be required, skipping setup")
    return
  end
  ibl.setup(options)
end

return M
