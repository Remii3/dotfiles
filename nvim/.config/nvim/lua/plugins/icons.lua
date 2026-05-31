return {
  "nvim-mini/mini.icons",
  opts = function()
    local old_get = require("mini.icons").get

    require("mini.icons").get = function(category, name)
      if category == "file" then
        if name:match("%.spec%.ts$") then
          return "󰂖", "MiniIconsAzure"
        end

        if name:match("%.controller%.ts$") then
          return "󰡱", "MiniIconsBlue"
        end

        if name:match("%.service%.ts$") then
          return "󰚲", "MiniIconsYellow"
        end

        if name:match("%.module%.ts$") then
          return "󰚲", "MiniIconsRed"
        end

        if name:match("%.ts$") then
          return "󰛦", "MiniIconsBlue"
        end
      end

      return old_get(category, name)
    end
  end,
}
