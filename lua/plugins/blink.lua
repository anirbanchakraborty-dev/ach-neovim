return {
	"saghen/blink.cmp",
	build = "cargo build --release",
	version = "1.*",
	dependencies = { "rafamadriz/friendly-snippets" },

	opts = function()
		local icons = require("configs.all_the_icons")

		---@module "blink.cmp"
		---@type blink.cmp.Config

		local opts = {
			keymap = {
				preset = "default",
				["<C-Z>"] = { "accept", "fallback" },
				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				["<CR>"] = { "accept", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			completion = {
				menu = { border = "single" },
				ghost_text = { enabled = true },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					window = {
						border = "single",
						desired_min_width = 30,
					},
				},
			},

			fuzzy = {
				implementation = "prefer_rust",
				prebuilt_binaries = { force_version = "v0.14.0" },
			},
		}

		return opts
	end,

	config = function(_, opts)
		require("blink-cmp").setup(opts)
	end,
}
