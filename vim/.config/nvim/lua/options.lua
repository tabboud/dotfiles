local opt = vim.opt
local env = vim.env

-- " Insert a TODO line by typing "todo<space>"
vim.cmd [[iabbrev todo // TODO(tabboud): ]]
vim.cmd [[iabbrev tda // TDA: ]]

opt.synmaxcol = 120 -- disable syntax highlighting after # of chars
opt.textwidth = 120 -- wrap line after configured # of chars
opt.colorcolumn = "120" -- draw a cursorline at # of chars
opt.tabstop = 4 -- visible width of tabs
opt.softtabstop = 4 -- edit as if the tabs are the configured # of chars wide
opt.shiftwidth = 4 -- number of spaces to use for indent and unindent
opt.shiftround = true -- round indent to a multiple of 'shiftwidth'
opt.expandtab = true
opt.mouse = "a" -- set mouse mode to all modes
opt.backup = false -- don't use backup files
opt.writebackup = false -- don't backup the file while editing
opt.swapfile = false -- don't create swap files for new buffers
opt.updatecount = 0 -- don't write swap files after some number of updates
opt.showmode = false -- don't show the vim mode (normal, insert, etc)

-- Appearance
opt.background = "dark" -- Use a dark background by default
opt.termguicolors = true
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
opt.scrolloff = 8 -- set # of lines to the cursors - when moving vertical
opt.confirm = true -- prompt to save, rather than raise an error
opt.shell = env.SHELL
opt.cmdheight = 1 -- bottom command bar height
opt.modeline = true -- enable modeline to get per-file settings (i.e. # vim:syntax=bash)
opt.cursorline = true -- enable the cursorline
opt.number = true -- show line numbers
opt.wrap = false -- don't wrap lines by default
opt.linebreak = true -- set soft wrapping
opt.showbreak = "…" -- show ellipsis at breaking
opt.autoindent = true -- automatically set indent of new line
opt.smartindent = true
opt.updatetime = 300 -- wait configured ms before updating
opt.signcolumn = "yes" -- always show the sign column

-- Coloring
-- TODO: colorscheme depends on a plugin so this should be moved to the plugin config
vim.cmd [[colorscheme forestbones ]]

-- Code folding
-- TODO: This needs to be set in the treesitter config instead
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 99
opt.foldnestmax = 10 -- deepest fold is 10 levels
opt.foldenable = false -- don't fold by default
opt.foldlevel = 1

-- Error bells
opt.errorbells = false
opt.visualbell = true
opt.timeoutlen = 500

-- Search
opt.ignorecase = true -- case insensitive searching
opt.smartcase = true -- case-sensitive if expresson contains a capital letter
opt.hlsearch = true -- highlight search results
opt.incsearch = true -- set incremental search, like modern browsers
opt.lazyredraw = true -- don't redraw while executing macros
opt.magic = true -- set magic on, for regular expressions
opt.showmatch = true -- show matching brackets
opt.pumheight = 20 -- pop up menu height
-- This is not really needed for cmp anymore. See https://github.com/hrsh7th/nvim-cmp/discussions/941
-- TODO: Test removing it and see if anything conflicts
-- noselect is useful for not selecting a first entry in the cmp completion window
-- By "select" this means "foo|<Tab>" would not immediately insert the first completed item, but instead wait
-- for you to press <Tab>
opt.completeopt = { "menu", "menuone", "noselect" }

opt.backspace = { -- make backspace behave in a sane manner
  "indent",
  "eol,start"
}
opt.clipboard = { -- use the system clipboard
  "unnamed",
  "unnamedplus"
}

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
