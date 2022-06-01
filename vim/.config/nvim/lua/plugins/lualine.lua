-- Return the total word count for a search
local function getWords()
  return tostring(vim.fn.wordcount().words)
end

local function searchCount()
    local count = vim.fn.searchcount({maxcount = 100 })
    local current = tostring(count.current)
    local total = tostring(count.total)
    return "[" .. current .. "/" .. total ..  "]"
end

-- Attempt to mimic the search count help found in ":h searchcount"
-- To clear the last search pattern run 'let @/ = ""' (see :h n or :h last-pattern)
local function vimSearchCount()
    local count = vim.fn.searchcount({maxcount = 100, recompute = 1 })
    if next(count) == nil then
        return ""
    end

    if count.incomplete == 1 then
        return "search: timed out"
    end
    if count.incomplete == 2 then
        return "search: max count exceeded"
    end

    local searchValue = vim.fn.getreg("/")
    local ret = string.format("/%s [%d/%d]", searchValue, count.current, count.total)
    return ret
end

local function vimLSearchCount()
    return vim.api.nvim_call_function("LastSearchCount")
end

require('lualine').setup {
    options = {
        theme = 'jellybeans'
    },
    sections = {
        lualine_c = {'filename', vimSearchCount },
        -- lualine_c = {vimLSearchCount },
        -- lualine_c = {'filename'},
        lualine_x = { 'filetype' }
    },
}
