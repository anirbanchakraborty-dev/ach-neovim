-- Relative Path: lua/plugins/trouble.lua
-- Plugin Repo: https://github.com/folke/trouble.nvim
--
-- This file configures 'trouble.nvim', a UI plugin to
-- display diagnostics, references, and symbols in a pretty list.

-- Load your centralized icons
local icons = require("configs.all_the_icons")

return {
	"folke/trouble.nvim",

	-- Lazy-load the plugin until the 'Trouble' command is run
	cmd = "Trouble",

	-- Depends on devicons for icons in the list
	dependencies = { "nvim-tree/nvim-web-devicons" },

	-- Define keymaps to toggle different 'trouble' modes
	keys = function()
		return {
			-- Toggle the diagnostics list
			{
				"<leader>tt",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = icons.ui.toggle_on .. " [t]oggle",
			},
			-- Toggle the LSP references list
			{
				"<leader>tl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = icons.lsp.references .. " [l]sp",
			},
			-- Toggle the document symbols list
			{
				"<leader>ts",
				"<cmd>Trouble symbols toggle<cr>",
				desc = icons.lsp.symbols .. " [s]ymbols",
			},
		}
	end,

	-- 'opts' table passes configuration to the setup function
	opts = {
		-- Use devicons for file types
		use_diagnostic_signs = true,
		-- Automatically focus the 'trouble' window when it opens
		focus = true,
	},
}
