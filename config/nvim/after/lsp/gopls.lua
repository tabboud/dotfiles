-- gopls settings: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
return {
  settings = {
    gopls = {
      usePlaceholders = true,
      gofumpt = false,
      staticcheck = false,
      analyses = {
        shadow = false,
        unusedparams = false,
        nilness = true,
        unusedwrite = true,
        useany = true,
      },
      codelenses = {
        gc_details = false,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = false,
        compositeLiteralFields = true,
        compositeLiteralTypes = false,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true
      },
    },
  },
}
