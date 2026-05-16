return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      explorer = {
        -- your explorer configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        autoClose = true,
      },
      picker = {
        actions = {
          toggle_preview_wrap = function(picker)
            local preview = picker.preview
            local win = preview and preview.win

            if type(win) == "table" then
              win = win.win or win.id or win.winid
            end

            if type(win) == "number" and vim.api.nvim_win_is_valid(win) then
              vim.wo[win].wrap = not vim.wo[win].wrap
              vim.notify("Preview wrap: " .. tostring(vim.wo[win].wrap))
            end
          end,
          toggle_preview_focus = function(picker)
            local current = picker:current_win()

            if current == "preview" then
              picker:focus("list")
            else
              picker:focus("preview")
            end
          end,
        },
        win = {
          input = {
            keys = {
              ["<A-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
              ["<A-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
              ["<A-z>"] = { "toggle_preview_wrap", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<A-h>"] = "preview_scroll_left",
              ["<A-l>"] = "preview_scroll_right",
              ["<A-z>"] = "toggle_preview_wrap",
            },
          },
        },
      },
    },
  },
}
