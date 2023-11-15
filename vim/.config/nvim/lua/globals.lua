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

-- Watch theme file and change colorscheme
-- TODO: Update lualine colors
local w = vim.loop.new_fs_event()
local function on_change(err, fname, status)
  -- Do work...
  if IsLightMode() then
    print("is light mode")
    vim.cmd.colorscheme('github_light')
    -- vim.cmd [[set background=light]]
  else
    print("is dark mode")
    vim.cmd.colorscheme('darcula-solid')
    -- vim.cmd [[set background=dark]]
  end
  -- Debounce: stop/start.
  w:stop()
  ToggleThemeOnChange()
end

ToggleThemeOnChange = function()
  w:start(os.getenv("HOME") .. "/.theme", {}, vim.schedule_wrap(function(...)
    on_change(...)
  end))
end
