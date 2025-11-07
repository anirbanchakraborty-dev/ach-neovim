-- Relative Path: lua/plugins/fzf-lua.lua
-- Plugin Repo: https://github.com/ibhagwan/fzf-lua
--
-- This file configures 'fzf-lua', a plugin that provides a fast,
-- fzf-powered fuzzy finder UI for Neovim.

return {
	"ibhagwan/fzf-lua",

	-- 'lazy = false' ensures this plugin loads on startup.
	-- This is often desired for a primary fuzzy finder
	-- so that vim.ui.select can be overridden immediately.
	lazy = false,

	-- Depends on 'nvim-web-devicons' to show icons in the fzf results
	dependencies = { "nvim-tree/nvim-web-devicons" },

	-- Define keymaps using the 'keys' table for lazy-loading
	keys = function()
		-- Load your centralized icons
		local icons = require("basic_configurations.all_the_icons")

		return {
			-- === File/Buffer ===
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
					-- Search for files, but only within your Neovim config directory
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
				"<leader>fo",
				function()
					require("fzf-lua").oldfiles()
				end,
				desc = icons.ui.history .. " [o]ld files",
			},

			-- === Neovim/Help ===
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
				"<leader>fC",
				function()
					require("fzf-lua").commands()
				end,
				desc = icons.ui.command .. " [C]ommands",
			},

			-- === LSP ===
			-- which-key group header for LSP
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

			-- === Diagnostics ===
			-- which-key group header for Diagnostics
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
					-- Use the built-in float, as fzf isn't needed for a single line
					vim.diagnostic.open_float()
				end,
				desc = icons.diagnostics.info .. " [l]ine diagnostics",
			},

			-- === Symbols ===
			-- which-key group header for Symbols
			{
				"<leader>fS",
				"",
				desc = icons.lsp.symbols .. " [S]ymbols",
			},
			{
				"<leader>fSd",
				function()
					require("fzf-lua").lsp_document_symbols()
				end,
				desc = icons.lsp.symbols .. " [d]ocument symbols",
			},
			{
				"<leader>fSw",
				function()
					require("fzf-lua").lsp_workspace_symbols()
				end,
				desc = icons.lsp.symbols .. " [w]orkspace symbols",
			},

			-- === Git ===
			-- which-key group header for Git
			{
				"<leader>fG",
				"",
				desc = icons.git.git .. " [G]it",
			},
			{
				"<leader>fGs",
				function()
					require("fzf-lua").git_status()
				end,
				desc = icons.git.git .. " [s]tatus",
			},
			{
				"<leader>fGc",
				function()
					require("fzf-lua").git_commits()
				end,
				desc = icons.git.commit .. " [c]ommits",
			},
		}
	end,

	-- 'opts' table (empty) - fzf-lua will use its default settings
	opts = {},

	-- 'config' function runs after the plugin is loaded
	config = function(_, opts)
		-- Run the main setup function with the provided 'opts'
		require("fzf-lua").setup(opts)
		-- Register fzf-lua as the default UI for 'vim.ui.select'
		-- This makes other plugins use fzf for selection menus
		require("fzf-lua").register_ui_select()
	end,
}
