-- Relative Path: lua/plugins/oil.lua
-- Plugin Repo: https://github.com/stevearc/oil.nvim
--
-- This file configures 'oil.nvim', a file explorer that
-- mimics Vim motions for file operations (a "Vi-like" explorer).

return {
	"stevearc/oil.nvim",

	-- Configuration options for 'oil.nvim'
	opts = {
		-- Columns to display in the 'oil' buffer
		columns = {
			"icon", -- File icon (requires nvim-web-devicons)
			"size", -- File size
		},
		-- Do not prompt for confirmation on simple actions
		skip_confirm_for_simple_edits = true,
		-- Options for how files are listed
		view_options = {
			show_hidden = true, -- Show hidden files (e.g., .gitignore)
			natural_order = true, -- Sort files "naturally" (e.g., 1, 2, 10)
			case_insensitive = true, -- Ignore case when sorting
			-- Function to always hide specific system junk files
			is_always_hidden = function(name, _)
				return name == ".DS_Store" or name == "thumbs.db"
			end,
		},
		-- Send deleted files to the system trash instead of permanently deleting
		delete_to_trash = true,
		-- Configuration for the floating window
		float = {
			border = "rounded",
			padding = 2,
		},
		-- Keymaps that are active *only* inside the 'oil' buffer
		keymaps = {
			-- This map is redundant (see suggestions)
			["<Esc>"] = { "actions.close", mode = "n" },
		},
	},

	-- 'oil.nvim' needs 'nvim-web-devicons' to show file icons
	dependencies = { "nvim-tree/nvim-web-devicons" },

	-- Global keymaps to open or interact with 'oil'
	keys = function()
		local icons = require("basic_configurations.all_the_icons")

		-- -- Helper function to format the notify message
		-- local function pad(icon, text)
		--   return (icon or "") .. " " .. text
		-- end

		return {
			-- Keymap to open 'oil' in a floating window
			{
				"<leader>ef",
				"<cmd>Oil --float<CR>",
				desc = icons.ui.float .. " [f]loat",
			},
			-- Keymap to close the 'oil' buffer
			{
				"<leader>eq",
				function()
					-- Check if the current buffer is an 'oil' buffer
					if vim.bo.filetype == "oil" then
						vim.cmd("close")
					else
						-- If not, show a warning
						-- vim.notify(pad(icons.ui.warning, "Not in an Oil buffer"), vim.log.levels.WARN)
						vim.notify(
							"Not in an Oil buffer",
							vim.log.levels.WARN,
							{ icon = icons.ui.warning, title = "Oil" }
						)
					end
				end,
				desc = icons.ui.quit .. " [q]uit",
			},
		}
	end,
}
