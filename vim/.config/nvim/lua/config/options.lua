local opt = vim.opt
local env = vim.env

-- " Insert a TODO line by typing "todo<space>"
-- TODO(tabboud): use 'commentstring' to insert the correct comment
vim.cmd [[iabbrev todo // TODO(tabboud):]]
vim.cmd [[iabbrev tda // TDA:]]

opt.synmaxcol = 120     -- disable syntax highlighting after # of chars
opt.textwidth = 120     -- wrap line after configured # of chars
opt.tabstop = 4         -- visible width of tabs
opt.softtabstop = 4     -- edit as if the tabs are the configured # of chars wide
opt.shiftwidth = 4      -- number of spaces to use for indent and unindent
opt.shiftround = true   -- round indent to a multiple of 'shiftwidth'
opt.expandtab = true
opt.mouse = "a"         -- set mouse mode to all modes
opt.backup = false      -- don't use backup files
opt.writebackup = false -- don't backup the file while editing
opt.swapfile = false    -- don't create swap files for new buffers
opt.updatecount = 0     -- don't write swap files after some number of updates
opt.showmode = false    -- don't show the vim mode (normal, insert, etc)

-- Appearance
opt.termguicolors = true
opt.guicursor =
"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
opt.scrolloff = 3 -- set # of lines to the cursors - when moving vertical
opt.confirm = true -- prompt to save, rather than raise an error
opt.shell = env.SHELL
opt.cmdheight = 1 -- bottom command bar height
opt.modeline = true -- enable modeline to get per-file settings (i.e. # vim:syntax=bash)
opt.cursorline = true -- enable the cursorline
opt.number = true -- show line numbers
opt.relativenumber = true -- show relative numbers
opt.wrap = false -- don't wrap lines by default
opt.linebreak = true -- set soft wrapping
opt.showbreak = "…" -- show ellipsis at breaking
opt.autoindent = true -- automatically set indent of new line
opt.smartindent = true
opt.updatetime = 300 -- wait configured ms before updating
opt.signcolumn = "yes" -- always show the sign column

-- Coloring
local lightMode = IsLightMode()
local colorscheme = lightMode and 'github_light' or 'github_dark_dimmed'
local background = lightMode and 'light' or 'dark'
if not pcall(vim.cmd.colorscheme, colorscheme) then
  print("colorscheme '" .. colorscheme .. "' not found, using default")
  vim.cmd.colorscheme('default')
end
opt.background = background


-- Code folding
-- Enable nvim-treesitter code folding if available
if pcall(require, 'nvim-treesitter') then
  opt.foldmethod = "expr"
  opt.foldexpr = "nvim_treesitter#foldexpr()"
end
opt.foldlevelstart = 99
opt.foldnestmax = 10   -- deepest fold is 10 levels
opt.foldenable = false -- don't fold by default
opt.foldlevel = 1

-- Error bells
opt.errorbells = false
opt.visualbell = true
opt.timeoutlen = 500

-- Search
opt.ignorecase = true -- case insensitive searching
opt.smartcase = true  -- case-sensitive if expresson contains a capital letter
opt.hlsearch = true   -- highlight search results
opt.incsearch = true  -- set incremental search, like modern browsers
opt.lazyredraw = true -- don't redraw while executing macros
opt.magic = true      -- set magic on, for regular expressions
opt.showmatch = true  -- show matching brackets
opt.pumheight = 20    -- pop up menu height

opt.clipboard = { "unnamedplus" }

-- disabled to allow cmp-cmdline to use a popup window
-- opt.wildmode = { -- complete files like a shell
--   "list",
--   "longest"
-- }
-- opt.wildmenu=true
opt.showbreak = "↪"
opt.listchars = {
  tab = "→ ",
  eol = "¬",
  trail = "⋅",
  extends = "❯",
  precedes = "❮"
}
