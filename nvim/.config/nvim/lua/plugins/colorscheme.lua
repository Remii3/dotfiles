return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
      transparent = true,
      on_colors = function(c)
        c.burgund = "#f00000"
      end,
      on_highlights = function(hl, c)
        -- KEYWORDS: róż / fiolet
        hl.Keyword = { fg = c.magenta }
        hl["@keyword"] = { fg = c.magenta }
        hl["@keyword.function"] = { fg = c.magenta }
        hl["@keyword.return"] = { fg = c.magenta }

        -- FUNCTIONS: niebieskie
        hl.Function = { fg = c.blue }
        hl["@function"] = { fg = c.blue }
        hl["@function.call"] = { fg = c.blue }
        hl["@constructor"] = { fg = c.blue }

        -- METHODS: jaśniejszy niebieski/cyjan, inny niż zwykłe funkcje
        hl["@function.method"] = { fg = c.cyan }
        hl["@function.method.call"] = { fg = c.cyan }
        hl["@method"] = { fg = c.cyan }
        hl["@method.call"] = { fg = c.cyan }
        hl["@lsp.type.method"] = { fg = c.cyan }

        -- TYPES: wszystkie typy na niebiesko-szare
        hl.Type = { fg = "#8aadf4" }
        hl["@type"] = { fg = "#8aadf4" }
        hl["@type.builtin"] = { fg = "#8aadf4" }
        hl["@lsp.type.type"] = { fg = "#8aadf4" }
        hl["@lsp.type.class"] = { fg = "#8aadf4" }
        hl["@lsp.type.interface"] = { fg = "#8aadf4" }
        hl["@lsp.type.enum"] = { fg = "#8aadf4" }
        hl["@lsp.type.typeParameter"] = { fg = "#8aadf4" }

        -- PROPERTIES / MEMBERS: turkus
        hl["@property"] = { fg = c.teal }
        hl["@field"] = { fg = c.teal }
        hl["@variable.member"] = { fg = c.teal }
        hl["@lsp.type.property"] = { fg = c.teal }

        -- PARAMETERS: pomarańcz
        hl["@variable.parameter"] = { fg = c.orange }
        hl["@parameter"] = { fg = c.orange }
        hl["@lsp.type.parameter"] = { fg = c.orange }

        -- VARIABLES: zwykły tekst
        hl.Identifier = { fg = c.fg }
        hl["@variable"] = { fg = c.fg }
        hl["@lsp.type.variable"] = { fg = c.fg }

        -- CONSTANTS / BUILTINS: fiolet
        hl.Constant = { fg = c.magenta }
        hl["@constant"] = { fg = c.magenta }
        hl["@constant.builtin"] = { fg = c.magenta }
        hl["@variable.builtin"] = { fg = c.magenta }

        -- STRINGS: zielone
        hl.String = { fg = c.green }
        hl["@string"] = { fg = c.green }

        -- COMMENTS
        hl.Comment = { fg = c.comment, italic = true }
        hl["@method"] = { fg = c.burgund }
        hl["@function.method.call"] = { fg = "#89ddff" }
        hl["@lsp.type.method"] = { fg = c.burgund }
      end,
    },
  },
}
