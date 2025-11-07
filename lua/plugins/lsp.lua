-- Relative Path: lua/plugins/lsp.lua
-- Plugin Repo: https://github.com/neovim/nvim-lspconfig
--
-- This file bundles all LSP-related plugins into a single specification
-- for lazy.nvim. It includes lspconfig, mason (installer), and conform (formatter).

return {
	-- === LSP Core Client ===
	{
		"neovim/nvim-lspconfig",
		-- Load LSP on file read/new file
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Mason: Installs and manages LSP servers
			"mason-org/mason.nvim",
			-- mason-lspconfig: Glues Mason to lspconfig
			"mason-org/mason-lspconfig.nvim",
			-- blink.cmp: Provides completion capabilities
			"saghen/blink.cmp",
			{
				-- lazydev: Provides type definitions for your Neovim config (Lua)
				"folke/lazydev.nvim",
				ft = "lua", -- Load only for Lua files
				opts = {
					-- Define libraries to help 'lua_ls' understand plugin APIs
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
						{ path = "${3rd}/plenary.nvim", words = { "plenary" } },
						{ path = "${3rd}/nvim-treesitter", words = { "vim.treesitter" } },
					},
				},
			},
			{
				-- fidget: Shows LSP progress (e.g., "Starting server...")
				"j-hui/fidget.nvim",
				opts = {
					notification = {
						override_vim_notify = true, -- Let fidget handle notify messages
					},
				},
			},
		},
		-- 'opts' tables are lazy-loaded configurations
		opts = {
			-- 'on_attach' is a crucial function that runs *every time*
			-- an LSP server attaches to a buffer.
			on_attach = function(client, bufnr)
				local icons = require("basic_configurations.all_the_icons")
				local keymap = vim.keymap.set
				local opts = { buffer = bufnr } -- Apply keymaps to this buffer only

				-- Show signature help (e.g., function arguments)
				keymap("n", "<leader>lh", vim.lsp.buf.hover, { desc = icons.lsp.hover .. "[h]over", buffer = bufnr })
				-- Rename symbol under cursor
				keymap(
					"n",
					"<leader>lr",
					vim.lsp.buf.rename,
					{ desc = icons.lsp.rename .. " [r]ename", buffer = bufnr }
				)

				-- which-key group for diagnostics
				keymap(
					"n",
					"<leader>ld",
					"",
					{ desc = icons.diagnostics.diagnostic .. " [d]iagnostics", buffer = bufnr }
				)
				-- Show line diagnostics in a floating window
				keymap(
					"n",
					"<leader>lds",
					vim.diagnostic.open_float,
					{ desc = icons.diagnostics.code_lens .. " [s]how", buffer = bufnr }
				)
				-- Go to the previous diagnostic
				keymap("n", "<leader>ldp", vim.diagnostic.goto_prev, { desc = "[p]revious", buffer = bufnr })
				-- Go to the next diagnostic
				keymap("n", "<leader>ldn", vim.diagnostic.goto_next, { desc = "[n]ext", buffer = bufnr })
			end,

			-- List of LSP servers to configure
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
							diagnostics = { globals = { "vim" } }, -- Tell ls 'vim' is a global
							workspace = {
								checkThirdParty = false,
								-- Help ls find Neovim's runtime files
								library = vim.api.nvim_get_runtime_file("", true),
							},
						},
					},
				},
				pyright = {}, -- Python
				ruff = {}, -- Python (linting/formatting)
				marksman = {}, -- Markdown
				texlab = { -- LaTeX
					settings = {
						texlab = {
							chktex = {
								onOpenAndSave = true, -- Use chktex for linting
							},
							lintOnSave = true,
						},
					},
				},
				-- ADD THE BASH LANGUAGE SERVER
				bashls = {
					-- Tell the server to attach to these filetypes
					filetypes = { "sh", "zsh", "zshrc", "basic" },
				},
			},
		},
		-- 'config' function runs after 'opts' to finalize setup
		config = function(_, opts)
			-- Get completion capabilities from blink.cmp
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- This loop automatically applies the 'on_attach' function and
			-- 'capabilities' to *every* server defined in the 'servers' table.
			if opts.servers then
				for server_name, server_opts in pairs(opts.servers) do
					if server_opts then
						server_opts.on_attach = opts.on_attach
						server_opts.capabilities =
							vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
					end
				end
			end

			-- Set the icons for diagnostics (errors, warnings, etc.)
			local icons = require("basic_configurations.all_the_icons")
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
						[vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
						[vim.diagnostic.severity.INFO] = icons.diagnostics.info,
						[vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
					},
				},
			})
		end,
	},

	-- === Mason (Installer) ===
	{
		"mason-org/mason.nvim",
		cmd = "Mason", -- Lazy-load until :Mason is run
		event = "VeryLazy",
		opts = function(_, opts)
			local icons = require("basic_configurations.all_the_icons")
			-- Configure the Mason UI
			opts.ui = {
				border = "rounded",
				icons = {
					package_installed = icons.ui.success_circle,
					package_pending = icons.nav.arrow_right,
					package_uninstalled = icons.ui.error_circle,
				},
			}
		end,
	},

	-- === Mason-LSPConfig (Glue) ===
	{
		"mason-org/mason-lspconfig.nvim",
		-- Must depend on both mason and lspconfig
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			-- List of LSPs to auto-install via Mason
			ensure_installed = { "lua_ls", "ruff", "pyright", "marksman", "texlab", "bashls" },
			-- Enable automatic installation
			automatic_installation = true,
		},
	},

	-- === Mason Tool Installer (Linters, Formatters) ===
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			-- List of non-LSP tools to auto-install
			ensure_installed = { "stylua", "prettier", "latexindent", "shellcheck", "shfmt" },
			auto_update = true,
			run_on_start = true,
		},
	},

	-- === Auto-Formatting ===
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		keys = {
			{
				-- Keymap to trigger manual formatting
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				desc = require("basic_configurations.all_the_icons").lsp.formatting .. " [f]ormat",
				mode = { "n", "v" },
			},
		},
		config = function()
			local conform = require("conform")
			conform.setup({
				-- Map filetypes to their corresponding formatters
				formatters_by_ft = {
					python = { "ruff_format" },
					lua = { "stylua" },
					markdown = { "prettier" },
					tex = { "latexindent" },
					-- ADD FORMATTERS FOR SHELL SCRIPTS
					sh = { "shfmt" },
					zsh = { "shfmt" },
				},
				-- Enable auto-formatting on save
				format_after_save = {
					timeout_ms = 500,
					lsp_fallback = true, -- Use LSP formatter if conform fails
				},
			})
		end,
	},
}
