return {
	"ibhagwan/fzf-lua",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },

	keys = function()
		local icons = require("configs.all_the_icons")

		return {
			{
				"<leader>ff",
				function()
					require("fzf-lua").files()
				end,
				desc = icons.files.file .. " [f]ind files",
			},
			{
				"<leader>fc",
				function()
					require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = icons.ui.settings .. " [c]onfig files",
			},
			{
				"<leader>fg",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = icons.ui.search .. " [g]rep project",
			},
			{
				"<leader>fb",
				function()
					require("fzf-lua").buffers()
				end,
				desc = icons.tabs.tab .. " [b]uffers",
			},
			{
				"<leader>fh",
				function()
					require("fzf-lua").help_tags()
				end,
				desc = icons.ui.info .. " [h]elp tags",
			},
			{
				"<leader>fk",
				function()
					require("fzf-lua").keymaps()
				end,
				desc = icons.ui.keyboard .. " [k]eymaps",
			},
			{
				"<leader>fo",
				function()
					require("fzf-lua").oldfiles()
				end,
				desc = icons.ui.history .. " [o]ld files",
			},
			{
				"<leader>fC",
				function()
					require("fzf-lua").commands()
				end,
				desc = icons.ui.command .. " [C]ommands",
			},

			{
				"<leader>fl",
				"",
				desc = icons.lsp.lsp .. " [l]sp",
			},
			{
				"<leader>flc",
				function()
					require("fzf-lua").lsp_code_actions()
				end,
				desc = icons.lsp.code_action .. " [c]ode actions",
			},
			{
				"<leader>fld",
				function()
					require("fzf-lua").lsp_definitions()
				end,
				desc = icons.lsp.logo .. " go to [d]efinition",
			},
			{
				"<leader>fli",
				function()
					require("fzf-lua").lsp_implementations()
				end,
				desc = icons.lsp.logo .. " go to [i]mplementation",
			},
			{
				"<leader>flr",
				function()
					require("fzf-lua").lsp_references()
				end,
				desc = icons.lsp.rename .. " find [r]eferences",
			},

			{
				"<leader>fd",
				"",
				desc = icons.diagnostics.diagnostic .. " [d]iagnostics",
			},
			{
				"<leader>fdd",
				function()
					require("fzf-lua").diagnostics_document()
				end,
				desc = icons.diagnostics.error .. " [d]ocument diagnostics",
			},
			{
				"<leader>fdw",
				function()
					require("fzf-lua").diagnostics_workspace()
				end,
				desc = icons.diagnostics.warn .. " [w]orkspace diagnostics",
			},
			{
				"<leader>fdl",
				function()
					vim.diagnostic.open_float()
				end,
				desc = icons.diagnostics.info .. " [l]ine diagnostics",
			},

			{
				"<leader>fs",
				"",
				desc = icons.lsp.symbols .. " [s]ymbols",
			},
			{
				"<leader>fsd",
				function()
					require("fzf-lua").lsp_document_symbols()
				end,
				desc = icons.lsp.symbols .. " [d]ocument symbols",
			},
			{
				"<leader>fsw",
				function()
					require("fzf-lua").lsp_workspace_symbols()
				end,
				desc = icons.lsp.symbols .. " [w]orkspace symbols",
			},

			{
				"<leader>fg",
				"",
				desc = icons.git.git .. " [g]it",
			},
			{
				"<leader>fgs",
				function()
					require("fzf-lua").git_status()
				end,
				desc = icons.git.git .. " [s]tatus",
			},
			{
				"<leader>fgc",
				function()
					require("fzf-lua").git_commits()
				end,
				desc = icons.git.commit .. " [c]ommits",
			},
		}
	end,

	opts = {},

	-- ⭐️ THIS IS THE FIX ⭐️
	-- It registers fzf-lua as the default UI for vim.ui.select
	config = function(_, opts)
		require("fzf-lua").setup(opts)
		require("fzf-lua").register_ui_select() -- Correct function name
	end,
}
