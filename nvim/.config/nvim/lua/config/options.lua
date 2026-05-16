-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.clipboard = {
  name = "WslClipboard",
  copy = {
    ["+"] = { "clip.exe" },
    ["*"] = { "clip.exe" },
  },
  paste = {
    ["+"] = {
      "/mnt/c/Windows/System32/WindowsPowerShell/v1.0///powershell.exe",
      "-c",
      '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    ["*"] = {
      "/mnt/c/Windows/System32/WindowsPowerShell/v1.0///powershell.exe",
      "-c",
      '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
  },
  cache_enabled = false,
}
