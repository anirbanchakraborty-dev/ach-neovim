return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    name = "folkeTokyonight",
    opts = function()
      local transparent = true
      local bg = "#011628"
      local bg_dark = "#011423"
      local bg_highlight = "#143652"
      local bg_search = "#0A64AC"
      local bg_visual = "#275378"
      local fg = "#CBE0F0"
      local fg_dark = "#B4D0E9"
      local fg_gutter = "#627E97"
      local border = "#547998"

      return {
        on_colors = function(colors)
          colors.bg = transparent and colors.none or bg
          colors.bg_dark = transparent and colors.none or bg_dark
          colors.bg_float = transparent and colors.none or bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = transparent and colors.none or bg_dark
          colors.bg_statusline = transparent and colors.none or bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end,

        style = "night",
        styles = {
          comments = { italic = true },
          floats = transparent and "transparent" or "dark",
          keywords = { italic = false },
          sidebars = transparent and "transparent" or "dark",
        },
        transparent = transparent,
      }
    end,
    priority = 1000,
    config = function(_, opts)
      local tokyonight = require("tokyonight")
      tokyonight.setup(opts)
      vim.cmd.colorscheme("tokyonight-moon")
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#547998", bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  },
}
