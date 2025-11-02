return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = {
      yaml = { "yamlfmt" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      javascript = { "prettier" },
      json = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      lua = { "stylua" },
      sh = { "shfmt" },
      markdown = { "prettier" },
      ruby = { "rubocop" },
      eruby = { "erb-formatter" },
      ["_"] = { "prettier" },
    }
    opts.formatters["erb-formatter"] = {
      command = "erb-format",
      args = { "--stdin-filename", "$FILENAME" },
      stdin = true,
    }
  end,
}
