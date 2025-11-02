-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>z", "<cmd>NoNeckPain<CR>", { desc = "Toggle No neck pain" })
vim.keymap.set("n", "<leader>;", function()
  require("snacks").dashboard.open()
end, opts)
