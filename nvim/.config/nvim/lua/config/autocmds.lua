-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.filetype.add({
  filename = {
    [".env"] = "dotenv",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
})

vim.treesitter.language.register("bash", "dotenv")

local function configure_dotenv_buffer(buf)
  local filename = vim.fs.basename(vim.api.nvim_buf_get_name(buf))
  if not filename:match("^%.env[%w_.-]*$") then
    return
  end

  vim.bo[buf].filetype = "dotenv"
  vim.bo[buf].commentstring = "# %s"

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, name = "bashls" })) do
    vim.lsp.buf_detach_client(buf, client.id)
  end
  vim.diagnostic.reset(nil, buf)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = { ".env", ".env.*" },
  callback = function(event)
    configure_dotenv_buffer(event.buf)
  end,
})

for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) then
    configure_dotenv_buffer(buf)
  end
end

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local snacks_windows = {}
    local floating_windows = {}
    local windows = vim.api.nvim_list_wins()
    for _, w in ipairs(windows) do
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(w) })
      if filetype:match("snacks_") ~= nil then
        table.insert(snacks_windows, w)
      elseif vim.api.nvim_win_get_config(w).relative ~= "" then
        table.insert(floating_windows, w)
      end
    end
    if 1 == #windows - #floating_windows - #snacks_windows then
      -- Should quit, so we close all Snacks windows.
      for _, w in ipairs(snacks_windows) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
})
