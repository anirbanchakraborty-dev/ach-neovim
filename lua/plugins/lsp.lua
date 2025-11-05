return {
	-- LSP CORE -------------------------------------------------------------
	{

		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"saghen/blink.cmp",
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
						{ path = "${3rd}/plenary.nvim", words = { "plenary" } },
						{ path = "${3rd}/nvim-treesitter", words = { "vim.treesitter" } },
					},
				},
			},
			{
				"j-hui/fidget.nvim",
				opts = {
					notification = {
						override_vim_notify = true,
					},
				},
			},
		},
		opts = {
			on_attach = function(client, bufnr)
				local icons = require("configs.all_the_icons")
				local keymap = vim.keymap.set
				local opts = { buffer = bufnr }

				keymap("n", "<leader>lh", vim.lsp.buf.hover, { desc = icons.lsp.hover .. "[h]over", buffer = bufnr })
				keymap(
					"n",
					"<leader>lr",
					vim.lsp.buf.rename,
					{ desc = icons.lsp.rename .. " [r]ename", buffer = bufnr }
				)

				keymap(
					"n",
					"<leader>ld",
					"",
					{ desc = icons.diagnostics.diagnostic .. " [d]iagnostics", buffer = bufnr }
				)

				keymap(
					"n",
					"<leader>lds",
					vim.diagnostic.open_float,
					{ desc = icons.diagnostics.code_lens .. " [s]how", buffer = bufnr }
				)

				keymap("n", "<leader>ldp", vim.diagnostic.goto_prev, { desc = "[p]revious", buffer = bufnr })
				keymap("n", "<leader>ldn", vim.diagnostic.goto_next, { desc = "[n]ext", buffer = bufnr })
			end,

			-- Your existing servers
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
							diagnostics = { globals = { "vim" } },
							workspace = {
								checkThirdParty = false,
								library = vim.api.nvim_get_runtime_file("", true),
							},
						},
					},
				},
				pyright = {},
				ruff = {},
				marksman = {},
				texlab = {
					settings = {
						texlab = {
							-- Tell texlab to use chktex for linting
							chktex = {
								onOpenAndSave = true,
							},
							-- Enable linting on save
							lintOnSave = true,
						},
					},
				},
			},
		},
		config = function(_, opts)
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Merge capabilities into each server's settings
			if opts.servers then
				for server_name, server_opts in pairs(opts.servers) do
					if server_opts then
						-- ⭐️ This line automatically merges our new on_attach function
						server_opts.on_attach = opts.on_attach
						server_opts.capabilities =
							vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
					end
				end
			end

			local icons = require("configs.all_the_icons")
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

	-- MASON CORE (Installer) ---------------------------------------------------
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		event = "VeryLazy",
		opts = function(_, opts)
			local icons = require("configs.all_the_icons")
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

	-- MASON ↔ LSP (Glue) -------------------------------------------------------
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = { "lua_ls", "ruff", "pyright", "marksman", "texlab" },
			automatic_installation = true,
		},
	},

	-- MASON TOOL INSTALLER (Linters, Formatters, etc.) -------------------------
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = { "stylua", "luacheck", "prettier", "latexindent" },
			auto_update = true,
			run_on_start = true,
		},
	},

	-- AUTO-FORMATTING ----------------------------------------------------------
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>c",
				"",
				desc = require("configs.all_the_icons").lsp.code_action .. " [c]onform",
				mode = { "n", "v" },
			},
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				desc = require("configs.all_the_icons").lsp.formatting .. " [f]ormat",
				mode = { "n", "v" },
			},
		},
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					python = { "ruff_format" },
					lua = { "stylua" },
					markdown = { "prettier" },
					tex = { "latexindent" },
				},
				format_after_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
}
