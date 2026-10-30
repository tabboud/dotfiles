vim.keymap.set("n", "<leader>tt", function() require("go").ToggleTest(false) end,
  { buffer = true, desc = "Go: Toggle Go test" })
