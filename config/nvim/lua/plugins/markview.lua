-- markview.lua
require('markview').setup()

-- Toggles markview rendering for the current buffer
local toggle = Snacks.toggle({
  name = "Markview",
  get = function()
    local state = require("markview.state").get_buffer_state(vim.api.nvim_get_current_buf(), false)
    return state ~= nil and state.enable == true
  end,
  set = function(state)
    vim.cmd("Markview " .. (state and "enable" or "disable"))
  end,
})
toggle:map("<leader>tm")
toggle:map("<leader>m")
