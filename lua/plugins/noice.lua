-- Relative Path: lua/plugins/noice.lua
-- Plugin Repo: https://github.com/folke/noice.nvim
--
-- This file configures 'noice.nvim', a plugin to replace
-- the Neovim command line and message UI.

return {
	"folke/noice.nvim",
	-- Load this plugin late, as it's a UI element
	event = "VeryLazy",
	-- 'nui.nvim' is required for UI components
	-- 'nvim-notify' is often used as a dependency or backend
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},

	opts = {
		-- Configure how Noice interacts with the LSP
		lsp = {
			-- Override Neovim's default LSP UI functions
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
		-- Use pre-configured presets for common setups
		presets = {
			bottom_search = true, -- Show search count at the bottom
			command_palette = true, -- Enable the command palette
			long_message_to_split = true, -- Split long messages into new windows
			lsp_doc_border = true, -- Add borders to LSP documentation
		},
	},

	-- Define keymaps for Noice
	keys = function()
		local icons = require("basic_configurations.all_the_icons")
		return {
			-- which-key group header
			{ "<leader>n", "", desc = icons.ui.bolt .. " [n]oice" },
			-- Show the last message
			{
				"<leader>nl",
				function()
					require("noice").cmd("last")
				end,
				desc = icons.time.clock .. " [l]ast message",
			},
			-- Show the message history
			{
				"<leader>nh",
				function()
					require("noice").cmd("history")
				end,
				desc = icons.nav.history_back .. " [h]istory",
			},
			-- Show all messages
			{
				"<leader>na",
				function()
					require("noice").cmd("all")
				end,
				desc = icons.files.file .. " [a]ll messages",
			},
			-- Dismiss all notifications
			{
				"<leader>nd",
				function()
					require("noice").cmd("dismiss")
				end,
				desc = icons.ui.close .. " [d]ismiss all",
			},
			-- Show the message picker
			{
				"<leader>np",
				function()
					require("noice").cmd("pick")
				end,
				desc = icons.ui.search .. " [p]icker",
			},
		}
	end,

	-- 'config' function runs after the plugin is loaded
	config = function(_, opts)
		-- This block sets up 'nvim-notify'
		local ok_notify, notify = pcall(require, "notify")
		if ok_notify then
			notify.setup({
				background_colour = "#1a1b26",
				stages = "fade_in_slide_out",
				timeout = 3000,
			})
			-- It then sets 'vim.notify' to use 'nvim-notify'
			vim.notify = notify
		end

		-- This line sets up 'noice.nvim'
		require("noice").setup(opts)

		-- This function dynamically sets Noice's colors
		-- to match the currently loaded colorscheme.
		local function refresh_noice_colors()
			-- Get highlight groups from the active colorscheme
			local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
			local border = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
			local title = vim.api.nvim_get_hl(0, { name = "Title" })

			-- Helper to convert color numbers to hex strings
			local function hex(n)
				return type(n) == "number" and string.format("#%06x", n) or n
			end

			-- Determine colors, with fallbacks
			local fg = hex(title.fg or normal.fg or "#c0caf5")
			local bg = hex(normal.bg or "none")
			local border_fg = hex(border.fg or "#565f89")

			-- Apply the dynamic colors to Noice's UI elements
			vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = bg, fg = fg })
			vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = border_fg })
			vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = fg, bold = true })
			vim.api.nvim_set_hl(0, "NoiceCmdlinePrompt", { fg = fg, bold = true })
			vim.api.nvim_set_hl(0, "NoiceLspProgressTitle", { fg = fg, bold = true })
		end

		-- Run the color refresh function once on setup
		refresh_noice_colors()

		-- Create an autocommand to re-run the color refresh
		-- every time the colorscheme is changed.
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("NoiceThemeAdapt", { clear = true }),
			callback = refresh_noice_colors,
		})

		-- Create an autocommand to dismiss startup messages
		-- (like "press ENTER") when Neovim finishes loading.
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				require("noice").cmd("dismiss")
			end,
		})
	end,
}
