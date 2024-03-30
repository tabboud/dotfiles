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
  if file == nil then
    vim.notify(
      'Error running IsLightMode(). Ensure the file, "$HOME/.theme", exists and contains the current theme ("dark" or "light")',
      vim.log.levels.ERROR, {})
    return false
  end
  local content = file:read("*a")
  file:close()
  return content == "light" and true or false
end
