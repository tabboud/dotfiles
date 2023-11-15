-- globals that I expect will always be available

-- P makes it easy to print out a Lua table
P = function(v)
  print(vim.inspect(v))
  return v
end


-- Light_mode returns whether light mode settings should be applied
-- by reading the $HOME/.theme file
LightMode = function()
  local file = assert(io.open(os.getenv("HOME") .. "/.theme", "r"), "Failed to open theme for reading")
  local content = assert(file:read("*a"), "Failed to read theme file")
  assert(file:close(), "Failed to close theme file")
  return content == "light" and true or false
end
