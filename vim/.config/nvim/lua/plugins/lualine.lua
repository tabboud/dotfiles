-- searchCount returns the index of the last-pattern search term along with the total search count.
-- The output will be as follows: '/searchTerm [current/total]'
-- To clear the last search pattern run 'let @/ = ""' (see :h last-pattern)
local function searchCount()
    local searchTerm = vim.fn.getreg("/")
    local count = vim.fn.searchcount({maxcount = 100, recompute = 1 })
    if next(count) == nil or count.total == 0 then
        return "[0/0]"
    end

    if count.incomplete == 1 then
        return "[?/?]"
    end
    if count.incomplete == 2 then
        if count.total > count.maxcount and count.current > count.maxcount then
            return string.format("/%s [>%d/>%d]", searchTerm, count.current, count.total)
        end
        if count.total > count.maxcount then
            return string.format("/%s [%d/>%d]", searchTerm, count.current, count.total)
        end
    end

    return string.format("/%s [%d/%d]", searchTerm, count.current, count.total)
end

require('lualine').setup {
    options = {
        theme = 'jellybeans'
    },
    sections = {
        lualine_c = {'filename', searchCount },
        lualine_x = { 'filetype' }
    },
}
