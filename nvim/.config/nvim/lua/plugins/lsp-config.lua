return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      html = {
        filetypes = {
          "html",
          "eruby",
        },
      },
      tailwindcss = {
        filetypes = {
          "html",
          "vue",
          "javascriptreact",
          "typescriptreact",
        },
      },
      eslint = {
        settings = {
          format = false,
          run = "onSave",
        },
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
      },
      vtsls = {
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
      },
    },
  },
}
