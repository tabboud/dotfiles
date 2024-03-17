local icons = require("icons").lualine
local ok, lsp_status = pcall(require, 'lsp-status')
if ok then
  lsp_status.register_progress()
end

-- projectName returns the name of the containing directory (or project).
local project_name = function()
  local project = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  return string.format("%s %s", icons.Folder, project)
end

-- get_lsp_status returns the current status of the LSP server.
-- If progress messages are available, then they will be shown in real-time, otherwise
-- just the currently attached LSP server will be shown or 'none' if none are attached.
-- Progress messages are retrieved from https://github.com/nvim-lua/lsp-status.nvim
-- via the "lsp-status.status_progress()" method, which is configured to be attached
-- in lspconfig's "on_attach" callback.
local get_lsp_status = function()
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.attached_buffers[vim.api.nvim_get_current_buf()] then
      local msgs_ok, progress_msg = pcall(function() return require('lsp-status').status_progress() end)
      if msgs_ok and progress_msg ~= '' then
        -- show LSP progress message if available
        return string.format("%s LSP: %s ", icons.Lsp, progress_msg)
      end
      -- fallback to just the currently attached LSP server
      return string.format("%s LSP: %s ", icons.Lsp, client.name)
    end
  end
  -- no clients attached
  return string.format("%s LSP: none ", icons.Lsp)
end

-- Show the current search count
local search_count = function()
  if vim.v.hlsearch == 0 then
    return ''
  end

  local result = vim.fn.searchcount { maxcount = 999, timeout = 500 }
  local denominator = math.min(result.total, result.maxcount)
  return string.format('%s [%d/%d]', icons.Search, result.current, denominator)
end

-- Show test results
-- TODO: Only load this if neotest is loaded, otherwise this loads neotest/neotest-go
local neotest_status = function()
  local status_ok, neotest = pcall(require, "neotest")
  if not status_ok then
    return ""
  end
  local adapters = neotest.state.adapter_ids()
  if #adapters > 0 then
    local status = neotest.state.status_counts(adapters[1], {
      buffer = vim.api.nvim_buf_get_name(0),
    })
    local sections = {
      {
        sign = "",
        count = status.failed,
        base = "NeotestFailed",
        tag = "test_fail",
      },
      {
        sign = "",
        count = status.running,
        base = "NeotestRunning",
        tag = "test_running",
      },
      {
        sign = "",
        count = status.passed,
        base = "NeotestPassed",
        tag = "test_pass",
      },
    }

    local result = {}
    for _, section in ipairs(sections) do
      if section.count > 0 then
        table.insert(
          result,
          "%#"
          .. section.base
          .. "#"
          .. section.sign
          .. " "
          .. section.count
        )
      end
    end

    return table.concat(result, " ")
  end
  return ""
end

require('lualine').setup {
  options = {
    theme = IsLightMode() and "onelight" or "jellybeans",
    component_separators = { left = icons.ComponentSeparator, right = icons.ComponentSeparator },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { "branch" },
    lualine_b = { "diff" },
    lualine_c = { search_count, neotest_status },
    lualine_x = { get_lsp_status, "diagnostics" },
    lualine_y = {},
    lualine_z = { project_name },
  },
  inactive_sections = {
    lualine_a = { "filename" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}
