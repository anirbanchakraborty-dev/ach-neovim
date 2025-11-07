-- Relative Path: lua/plugins/tokyonight.lua
-- Plugin Repo: https://github.com/folke/tokyonight.nvim
--
-- This file configures the 'tokyonight.nvim' colorscheme.

return {
	{
		"folke/tokyonight.nvim",
		-- 'lazy = false' ensures the colorscheme loads on startup
		lazy = false,
		-- 'name' is used to give this plugin a unique name
		name = "folkeTokyonight",
		-- 'priority = 1000' makes sure this loads before other plugins
		priority = 1000,

		-- 'opts' function defines the configuration with custom colors
		opts = function()
			-- === Customization Flags ===
			-- Set to 'true' to enable a transparent background
			local transparent = false

			-- === Custom Color Palette ===
			-- These hex codes define your personal color overrides
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
				-- 'style = "night"' selects one of the default theme variants
				style = "moon",
				-- 'transparent = true' enables the transparent background
				transparent = transparent,

				-- 'styles' table fine-tunes specific elements
				styles = {
					comments = { italic = true },
					keywords = { italic = false },
					-- Set sidebars (like file explorers) to be transparent
					sidebars = transparent and "transparent" or "dark",
					-- Set floating windows (like LSP hover) to be transparent
					floats = transparent and "transparent" or "dark",
				},

				-- 'on_colors' is a function that runs to override
				-- the default theme colors with your custom palette.
				on_colors = function(colors)
					-- Use transparent background if 'transparent' flag is true
					colors.bg = transparent and colors.none or bg
					colors.bg_dark = transparent and colors.none or bg_dark
					colors.bg_float = transparent and colors.none or bg_dark
					colors.bg_sidebar = transparent and colors.none or bg_dark
					colors.bg_statusline = transparent and colors.none or bg_dark

					-- Apply custom non-transparent colors
					colors.bg_highlight = bg_highlight
					colors.bg_popup = bg_dark
					colors.bg_search = bg_search
					colors.bg_visual = bg_visual
					colors.border = border
					colors.fg = fg
					colors.fg_dark = fg_dark
					colors.fg_float = fg
					colors.fg_gutter = fg_gutter
					colors.fg_sidebar = fg_dark
				end,
			}
		end,

		-- 'config' function runs after 'opts' to apply the setup
		config = function(_, opts)
			local tokyonight = require("tokyonight")
			-- Run the plugin's setup function with your options
			tokyonight.setup(opts)
			-- Load the 'tokyonight-moon' variant of the colorscheme
			vim.cmd.colorscheme("tokyonight-moon")

			-- === Manual Highlight Overrides ===
			-- These are applied *after* the theme is loaded
			-- Set FloatBorder to your custom border color
			vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#547998", bg = "none" })
			-- Ensure float backgrounds are transparent
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end,
	},
}
