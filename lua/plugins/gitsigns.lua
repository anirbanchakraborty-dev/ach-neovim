-- Relative Path: lua/plugins/gitsigns.lua
-- Plugin Repo: https://github.com/lewis6991/gitsigns.nvim
--
-- This file configures 'gitsigns.nvim' for showing Git diff markers
-- in the sign column and provides keymaps for hunk operations.

-- Import the centralized icons table
local icons = require("configs.all_the_icons")

return {
	"lewis6991/gitsigns.nvim",

	-- Load the plugin on file events for efficiency
	event = { "BufReadPre", "BufNewFile" },

	-- 'keys' function defines keymaps for gitsigns
	keys = function()
		return {
			-- === Hunk Navigation ===
			-- Jump to the next Git hunk (change)
			{
				"]h",
				function()
					require("gitsigns").next_hunk({ navigation_message = false })
				end,
				desc = "Next Hunk",
			},
			-- Jump to the previous Git hunk
			{
				"[h",
				function()
					require("gitsigns").prev_hunk({ navigation_message = false })
				end,
				desc = "Previous Hunk",
			},

			-- === Hunk Actions ===
			-- Stage the current hunk
			{
				"<leader>gs",
				function()
					require("gitsigns").stage_hunk()
				end,
				desc = icons.git.stage_hunk .. " [s]tage hunk",
			},
			-- Revert (reset) the current hunk
			{
				"<leader>gr",
				function()
					require("gitsigns").reset_hunk()
				end,
				desc = icons.git.reset_hunk .. " [r]eset hunk",
			},
			-- Preview the changes in the current hunk in a float
			{
				"<leader>gp",
				function()
					require("gitsigns").preview_hunk()
				end,
				desc = icons.git.diff_this .. " [p]review hunk",
			},

			-- === Git Utilities ===
			-- Show the Git blame for the current line
			{
				"<leader>gb",
				function()
					require("gitsigns").blame_line({ full = true })
				end,
				desc = icons.git.blame_line .. " [b]lame line",
			},
			-- Show a diff of the current file against the Git index
			{
				"<leader>gd",
				function()
					require("gitsigns").diffthis()
				end,
				desc = icons.git.compare .. " [d]iff this",
			},
			-- Stage all changes in the current buffer
			{
				"<leader>gS",
				function()
					require("gitsigns").stage_buffer()
				end,
				desc = icons.git.staged .. " [S]tage buffer",
			},
			-- Revert all changes in the current buffer
			{
				"<leader>gR",
				function()
					require("gitsigns").reset_buffer()
				end,
				desc = icons.git.revert .. " [R]eset buffer",
			},
		}
	end,

	-- 'opts' table passes configuration to the plugin's setup function
	opts = {
		-- Configure the icons used in the sign column
		signs = {
			add = { text = icons.git.added },
			change = { text = icons.git.modified },
			delete = { text = icons.git.removed },
			topdelete = { text = icons.git.removed },
			changedelete = { text = icons.git.modified },
		},

		-- Enable virtual text for inline blame information
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 500, -- Wait 500ms before showing the blame
		},
	},
}
