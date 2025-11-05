return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	priority = 1000,
	dependencies = { "nvim-tree/nvim-web-devicons" },

	opts = function()
		local icons = require("configs.all_the_icons")
		local wk = require("which-key")

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

		wk.add({
			{ "<leader>b", group = icons.tabs.tab .. " [b]uffer" },
			{ "<leader>c", group = icons.lsp.code_action .. " [c]onform" },
			{ "<leader>t", group = icons.diagnostics.diagnostic .. " [t]rouble" },
			{ "<leader>e", group = icons.files.explorer .. " [e]xplorer" },
			{ "<leader>f", group = icons.files.file .. " [f]ile/[f]zf" },
			{ "<leader>g", group = icons.git.git .. " [g]it" },
			{ "<leader>l", group = icons.lsp.logo .. " [l]sp" },
			{ "<leader>n", group = icons.ui.bolt .. " [n]oice" },
			{ "<leader>q", group = icons.ui.quit .. " [q]uit" },
			{ "<leader>s", group = icons.dap.repl .. " [s]hell" },
			{ "<leader>w", group = icons.ui.window .. " [w]indow" },
		})

		return opts
	end,

	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
	end,
}
