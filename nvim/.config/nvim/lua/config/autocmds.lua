-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("QuitPre", {
  desc = "Close Snacks Explorer when quitting the last editor window",
  callback = function()
    if not _G.Snacks or not Snacks.picker then
      return
    end

    local explorers = Snacks.picker.get({ source = "explorer" })
    if #explorers == 0 then
      return
    end

    local current_win = vim.api.nvim_get_current_win()
    local editor_wins = vim.tbl_filter(function(win)
      if vim.api.nvim_win_get_config(win).relative ~= "" then
        return false
      end

      local filetype = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
      return not vim.startswith(filetype, "snacks_picker_") and not vim.startswith(filetype, "snacks_layout_")
    end, vim.api.nvim_tabpage_list_wins(0))

    if #editor_wins == 1 and editor_wins[1] == current_win then
      for _, explorer in ipairs(explorers) do
        explorer:close()
      end

      vim.schedule(function()
        vim.cmd("quit")
      end)
    end
  end,
})
