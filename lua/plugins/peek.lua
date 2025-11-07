-- Relative Path: lua/plugins/peek.lua
-- Plugin Repo: https://github.com/toppair/peek.nvim
--
-- This file configures 'peek.nvim', a markdown previewer
-- that uses Deno and a webview.

-- Load your centralized icons
local icons = require("basic_configurations.all_the_icons")

return {
	"toppair/peek.nvim",

	-- Lazy-load this plugin only when a markdown file is opened
	ft = { "markdown" },

	-- Specifies the Deno command to build the plugin on install/update
	build = "deno task --quiet build:fast",

	-- 'config' function runs after the plugin is loaded
	config = function()
		-- Setup peek with default options.
		-- Using an empty setup {} will default to 'app = "webview"',
		-- which is the recommended cross-platform backend.
		require("peek").setup({})
	end,

	-- Keymaps for which-key
	keys = {
		{
			"<leader>fp",
			function()
				require("peek").open()
			end,
			desc = icons.files.pdf .. " [p]review",
		},
		{
			"<leader>fx",
			function()
				require("peek").close()
			end,
			desc = icons.ui.close .. " [x]close",
		},
		{
			"<leader>fe",
			function()
				-- resolve file paths
				local file = vim.api.nvim_buf_get_name(0)
				local cwd = vim.fn.fnamemodify(file, ":h")
				local name = vim.fn.fnamemodify(file, ":t")
				local output = vim.fn.fnamemodify(file, ":r") .. ".pdf"

				local cmd = string.format(
					"pandoc -f gfm %s -o %s --pdf-engine=xelatex -V monofont='FiraCode Nerd Font Mono' -V geometry='margin=1.5cm'",
					name,
					output
				)

				-- run asynchronously instead of `vim.cmd("! ...")`
				vim.fn.jobstart(cmd, {
					cwd = cwd,
					on_exit = function(_, code)
						local notify = function(msg, level)
							if pcall(require, "noice") then
								require("noice").notify(msg, level)
							else
								vim.notify(msg, level)
							end
						end

						if code == 0 then
							notify(string.format("%s  PDF exported:\n%s", icons.ui.success_circle, output))
						else
							notify(string.format("%s  PDF export failed", icons.ui.error_circle), vim.log.levels.ERROR)
						end
					end,
				})
			end,
			desc = icons.files.export .. " [e]xport",
		},
	},
}
