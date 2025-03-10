-- globals that I expect will always be available

-- P makes it easy to print out a Lua table
P = function(v)
  print(vim.inspect(v))
  return v
end

-- Light_mode returns whether light mode settings should be applied
-- by reading the $HOME/.theme file
IsLightMode = function()
  local file = io.open(os.getenv("HOME") .. "/.theme", "r")
  if not file then
    return false
  end
  local content = file:read("*line")
  file:close()
  return content == "light"
end
