return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
        maxPreload = 2000,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
}
