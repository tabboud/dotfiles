-- globals that I expect will always be available

-- P makes it easy to print out a Lua table
P = function(v)
  print(vim.inspect(v))
  return v
end
