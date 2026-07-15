return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              preferences = { importModuleSpecifier = "non-relative" },
              inlayHints = {
                enumMemberValues = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = "none" },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                variableTypes = { enabled = false },
              },
            },
            javascript = {
              preferences = {
                importModuleSpecifier = "non-relative",
              },
            },
          },
        },
        eslint = {
          settings = {
            run = "onSave",
          },
        },
      },
    },
  },
}
