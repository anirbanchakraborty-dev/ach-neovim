return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	priority = 1000,
	dependencies = { "nvim-tree/nvim-web-devicons" },

	-- 'opts' function ONLY returns the options table
	opts = function()
		local icons = require("configs.all_the_icons")

		local opts = {
			preset = "helix",
			icons = {
				breadcrumb = icons.nav.breadcrumb,
				separator = icons.nav.separator,
				rules = false,
				mappings = false,
			},
			win = { border = "rounded" },
			show_help = false,
			show_keys = true,
			disable = { buftypes = { "terminal" } },
		}
		return opts
	end,

	-- 'config' function runs the setup AND registers the keys
	config = function(_, opts)
		local wk = require("which-key")

		-- 1. Setup which-key FIRST
		wk.setup(opts)

		-- 2. NOW register groups AFTER setup
		local icons = require("configs.all_the_icons")
		wk.add({
			{ "<leader>b", group = icons.tabs.tab .. " [b]uffer" },
			{ "<leader>c", group = icons.lsp.code_action .. " [c]onform", mode = { "v", "n" } },
			{ "<leader>e", group = icons.files.explorer .. " [e]xplorer" },
			{ "<leader>f", group = icons.files.file .. " [f]ile/[f]zf", mode = { "v", "n" } },
			{ "<leader>g", group = icons.git.git .. " [g]it" },
			{ "<leader>i", group = icons.ui.indent .. " [i]ndent", mode = "v" },
			{ "<leader>l", group = icons.lsp.logo .. " [l]sp" },
			{ "<leader>n", group = icons.ui.bolt .. " [n]oice" },
			{ "<leader>q", group = icons.ui.quit .. " [q]uit" },
			{ "<leader>r", group = icons.ui.cut .. " [r]emove" },
			{ "<leader>s", group = icons.dap.repl .. " [s]hell" },
			{ "<leader>t", group = icons.ui.whitespace .. " [t]rouble" },
			{ "<leader>w", group = icons.ui.window .. " [w]indow" },
		})
	end,
}
