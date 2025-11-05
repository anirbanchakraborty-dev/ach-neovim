return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile" },

  config = function()
    local rd = require("rainbow-delimiters")

    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rd.strategy["global"],
        vim = rd.strategy["local"],
      },
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
      },
      priority = {
        [""] = 110,
        lua = 210,
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterOrange",
        "RainbowDelimiterYellow",
        "RainbowDelimiterGreen",
        "RainbowDelimiterCyan",
        "RainbowDelimiterBlue",
        "RainbowDelimiterViolet",
      },
    }

    local set = vim.api.nvim_set_hl
    set(0, "RainbowDelimiterRed", { fg = "#e86671" })
    set(0, "RainbowDelimiterOrange", { fg = "#d19a66" })
    set(0, "RainbowDelimiterYellow", { fg = "#e5c07b" })
    set(0, "RainbowDelimiterGreen", { fg = "#98c379" })
    set(0, "RainbowDelimiterCyan", { fg = "#56b6c2" })
    set(0, "RainbowDelimiterBlue", { fg = "#61afef" })
    set(0, "RainbowDelimiterViolet", { fg = "#c678dd" })
  end,
}
