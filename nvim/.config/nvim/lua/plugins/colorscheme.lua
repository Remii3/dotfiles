return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({
        style = "dark",
        transparent = true,
      })
      vim.cmd.colorscheme("vscode")
    end,
  },
}
