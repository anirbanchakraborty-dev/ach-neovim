-- Relative Path: lua/plugins/mini-packages.lua
-- Plugin Repo: https://github.com/echasnovski/mini.nvim
--
-- This file bundles and configures various plugins from the 'mini.nvim' suite.

-- Load your centralized icons
local icons = require("configs.all_the_icons")

return {
	-- === Mini.comment ===
	-- Fast and simple commenting plugin
	{ "echasnovski/mini.comment", opts = {} },

	-- === Mini.pairs ===
	-- Auto-pairs for brackets, quotes, etc.
	{ "echasnovski/mini.pairs", opts = {} },

	-- === Mini.cursorword ===
	-- Automatically highlights the word under the cursor
	{ "echasnovski/mini.cursorword", opts = {} },

	-- === Mini.hipatterns ===
	-- Highlights specific regex patterns, like TODO, FIXME, etc.
	{
		"echasnovski/mini.hipatterns",
		opts = function()
			local hipatterns = require("mini.hipatterns")
			-- Define custom highlight groups for specific patterns
			vim.api.nvim_set_hl(0, "MiniHipatternsWarn", { fg = "#011423", bg = "#ff9e64", bold = true })
			vim.api.nvim_set_hl(0, "MiniHipatternsOk", { fg = "#011423", bg = "#50fa7b", bold = true })

			return {
				-- Define the patterns to match
				highlighters = {
					-- Critical items
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					fix = { pattern = "%f[%w]()FIX()%f[%W]", group = "MiniHipatternsFixme" },
					fixit = { pattern = "%f[%w]()FIXIT()%f[%W]", group = "MiniHipatternsFixme" },
					bug = { pattern = "%f[%w]()BUG()%f[%W]", group = "MiniHipatternsFixme" },
					issue = { pattern = "%f[%w]()ISSUE()%f[%W]", group = "MiniHipatternsFixme" },
					error = { pattern = "%f[%w]()ERROR()%f[%W]", group = "MiniHipatternsFixme" },
					failed = { pattern = "%f[%w]()FAILED()%f[%W]", group = "MiniHipatternsFixme" },
					fail = { pattern = "%f[%w]()FAIL()%f[%W]", group = "MiniHipatternsFixme" },

					-- Hacks or temporary code
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					temp = { pattern = "%f[%w]()TEMP()%f[%W]", group = "MiniHipatternsHack" },
					workaround = { pattern = "%f[%w]()WORKAROUND()%f[%W]", group = "MiniHipatternsHack" },

					-- Todos
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },

					-- Warnings (using the custom group)
					warn = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsWarn" },
					warning = { pattern = "%f[%w]()WARNING()%f[%W]", group = "MiniHipatternsWarn" },
					xxx = { pattern = "%f[%w]()XXX()%f[%W]", group = "MiniHipatternsWarn" },

					-- Informational
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
					info = { pattern = "%f[%w]()INFO()%f[%W]", group = "MiniHipatternsNote" },
					hint = { pattern = "%f[%w]()HINT()%f[%W]", group = "MiniHipatternsNote" },

					-- Success (using the custom group)
					ok = { pattern = "%f[%w]()OK()%f[%W]", group = "MiniHipatternsOk" },
					passed = { pattern = "%f[%w]()PASSED()%f[%W]", group = "MiniHipatternsOk" },
					success = { pattern = "%f[%w]()SUCCESS()%f[%W]", group = "MiniHipatternsOk" },

					-- Built-in highlighter for hex color codes
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			}
		end,
	},

	-- === Mini.indentscope ===
	-- Shows indentation levels and scope borders
	{
		"echasnovski/mini.indentscope",
		dependencies = {
			{
				"lukas-reineke/indent-blankline.nvim",
				main = "ibl",
				opts = {
					indent = {
						char = icons.nav.vertical_bar,
					},
					scope = {
						enabled = false,
					},
				},
			},
		},
		opts = {
			-- Set the character to use for the indent line
			symbol = icons.nav.vertical_bar,
			-- 'draw' is what you want
			draw = {
				-- Draw lines at the start of the scope
				delay = 0,
				-- Use a bar for the active line
				active = { symbol = icons.nav.vertical_bar },
			},
			options = {
				try_as_border = true,
				border = "both", -- Show top and bottom lines for the current scope
			},
		},
		-- 'init' runs before the plugin is loaded
		init = function()
			-- Set the color for the indent line
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#627E97" })
			-- Autocommand to disable in certain filetypes
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
				-- This logic is inverted (see suggestions)
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},

	-- === Mini.trailspace ===
	-- Highlights and trims trailing whitespace
	{
		"echasnovski/mini.trailspace",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
		-- Add a keymap to trim whitespace
		keys = function()
			local icons = require("configs.all_the_icons")
			return {
				{
					"<leader>rw",
					function()
						require("mini.trailspace").trim()
					end,
					desc = icons.ui.whitespace .. " [w]hitespace trim",
				},
			}
		end,
	},
}
