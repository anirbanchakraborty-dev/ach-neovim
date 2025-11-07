return {
  "HiPhish/rainbow-delimiters.nvim",

  -- Load the plugin when a file is opened
  event = { "BufReadPost", "BufNewFile" },

  -- Add Treesitter as an explicit dependency
  dependencies = { "nvim-treesitter/nvim-treesitter" },

  -- Set the global variable
  init = function()
    -- Get the plugin's strategy functions (safe to require here)
    local rd = require("rainbow-delimiters")

    -- 'init' runs BEFORE the plugin loads, so 'vim.g' is set in time
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
  end,

  -- 'config' will now only handle the color definitions
  config = function()
    -- This code runs *after* the plugin has loaded
    -- and after 'init' has run.
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
