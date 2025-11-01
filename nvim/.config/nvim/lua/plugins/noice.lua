return {
  "folke/noice.nvim",
  opts = function(_, opts)
    opts.views = {
      cmdline_popup = {
        position = {
          row = "40%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
    }
  end,
}
