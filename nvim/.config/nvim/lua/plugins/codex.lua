return {
  "kkrampis/codex.nvim",
  lazy = true,
  cmd = { "Codex", "CodexToggle" },

  keys = {
    {
      "<leader>ag",
      function()
        require("codex").toggle()
      end,
      desc = "Codex: Toggle",
      mode = { "n", "t" },
    },
  },

  opts = {
    keymaps = {
      toggle = nil,
      quit = "<C-q>",
    },

    border = "rounded",

    -- Claude-like: panel po prawej zamiast popupu
    panel = true,

    -- jak wolisz popup, zmień panel = false
    width = 0.38,
    height = 0.8,

    model = nil,
    autoinstall = true,

    -- false = normalny terminal, lepsze do interaktywnego Codex CLI
    use_buffer = false,
  },

  config = function(_, opts)
    require("codex").setup(opts)

    -- wygodne wyjście z terminal mode, jak w wielu setupach AI/terminalowych
    vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {
      desc = "Exit terminal mode",
    })

    -- szybkie zamknięcie Codexa z terminala
    vim.keymap.set("t", "<C-q>", function()
      require("codex").toggle()
    end, {
      desc = "Codex: Close",
    })
  end,
}
