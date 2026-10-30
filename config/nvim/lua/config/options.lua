local opt = vim.opt

opt.synmaxcol = 120 -- disable syntax highlighting after # of chars
opt.textwidth = 120 -- wrap line after configured # of chars
opt.tabstop = 4 -- visible width of tabs
opt.softtabstop = 4 -- edit as if the tabs are the configured # of chars wide
opt.shiftwidth = 4 -- number of spaces to use for indent and unindent
opt.shiftround = true -- round indent to a multiple of 'shiftwidth'
opt.expandtab = true
opt.mouse = "a" -- set mouse mode to all modes
opt.writebackup = false -- don't backup the file while editing
opt.swapfile = false -- don't create swap files for new buffers
opt.showmode = false -- don't show the vim mode (normal, insert, etc)

-- Appearance
opt.termguicolors = true
opt.guicursor =
  "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
opt.scrolloff = 3 -- set # of lines to the cursors - when moving vertical
opt.confirm = true -- prompt to save, rather than raise an error
opt.cursorline = true -- enable the cursorline
opt.number = true -- show line numbers
opt.relativenumber = true -- show relative numbers
opt.wrap = false -- don't wrap lines by default
opt.linebreak = true -- set soft wrapping
opt.showbreak = "↪" -- shown at the start of wrapped lines
opt.smartindent = true
opt.updatetime = 300 -- wait configured ms before updating
opt.signcolumn = "yes" -- always show the sign column
opt.fixendofline = false -- Do not include new line at end of file
opt.timeoutlen = 500

-- Code folding
opt.foldlevelstart = 99
opt.foldnestmax = 10 -- deepest fold is 10 levels
opt.foldenable = false -- don't fold by default

-- Search
opt.ignorecase = true -- case insensitive searching
opt.smartcase = true -- case-sensitive if expresson contains a capital letter
opt.lazyredraw = true -- don't redraw while executing macros
opt.showmatch = true -- show matching brackets
opt.pumheight = 20 -- pop up menu height
opt.clipboard = { "unnamedplus" }
opt.listchars = {
  tab = "→ ",
  eol = "¬",
  trail = "⋅",
  extends = "❯",
  precedes = "❮",
}
