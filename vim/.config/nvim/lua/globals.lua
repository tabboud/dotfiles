-- globals that I expect will always be available

-- P makes it easy to print out a Lua table
P = function(v)
  print(vim.inspect(v))
  return v
end


-- Light_mode returns whether light mode settings should be applied
-- by reading the $LIGHT_MODE environment variable.
LightMode = function()
  return os.getenv("LIGHT_MODE") == "true" and true or false
end
