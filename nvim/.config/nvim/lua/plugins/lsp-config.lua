return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    opts.servers.html = {
      filetypes = {
        "html",
        "eruby",
      },
    }
    opts.servers.tailwindcss = {
      filetypes = {
        "html",
        "vue",
        "javascriptreact",
        "typescriptreact",
      },
    }
    opts.servers.eslint = {
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
    }
    local vue_language_server_path = vim.fn.stdpath("data")
      .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
    opts.servers.vtsls = {
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
                configNamespace = "typescript",
              },
            },
          },
        },
      },
    }
  end,
}
