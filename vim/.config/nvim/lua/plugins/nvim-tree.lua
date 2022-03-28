local nvimtree = require('nvim-tree')

nvimtree.setup({
  auto_close = true,
  update_focused_file = {
    enable      = true,
    update_cwd  = false,
    ignore_list = {}
  },
}
)
