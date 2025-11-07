-- Relative Path: lua/plugins/blink.lua
-- Plugin Repo: https://github.com/saghen/blink.cmp
--
-- This file configures 'blink.cmp', a performant, batteries-included
-- completion plugin written partially in Rust.

return {
	"saghen/blink.cmp",

	-- Specifies the command to run after installing to build the Rust component
	-- build = "cargo build --release",

	-- Lock the plugin to version 1.x for stability
	version = "1.*",
	-- Lock the prebuilt binary to version v0.14.0 for stability
	-- prebuilt_binaries = { force_version = "v0.14.0" },

	-- This plugin depends on snippet definitions
	dependencies = { "rafamadriz/friendly-snippets" },

	-- 'opts' function lazy-loads the configuration
	opts = function()
		-- Type annotation for 'blink.cmp' configuration
		---@module "blink.cmp"
		---@type blink.cmp.Config

		local opts = {
			-- Configure key mappings for the completion menu
			keymap = {
				preset = "default",                   -- Start with default keybindings
				-- Custom overrides:
				["<C-Z>"] = { "accept", "fallback" }, -- Accept suggestion or fallback
				["<Tab>"] = { "snippet_forward", "fallback" }, -- Jump forward in snippet or fallback
				["<S-Tab>"] = { "snippet_backward", "fallback" }, -- Jump backward in snippet or fallback
				["<CR>"] = { "accept", "fallback" },  -- Accept suggestion or fallback
			},

			-- Configure visual appearance
			appearance = {
				-- Specify 'mono' if you use a Nerd Font Mono (monospaced)
				nerd_font_variant = "mono",
			},

			-- Configure completion sources
			sources = {
				-- Define the default sources to use and their order
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- Configure the completion menu, ghost text, and documentation
			completion = {
				menu = { border = "single" }, -- Use a single-line border for the menu
				ghost_text = { enabled = true }, -- Show inline "ghost text" suggestions
				documentation = {
					auto_show = true, -- Automatically show documentation for items
					auto_show_delay_ms = 250, -- Wait 250ms before showing
					window = {
						border = "single", -- Use a single-line border for docs
						desired_min_width = 30, -- Set a minimum width
					},
				},
			},

			-- Configure the fuzzy matching engine
			fuzzy = {
				-- Prioritize the fast Rust implementation
				implementation = "prefer_rust",
			},
		}

		return opts
	end,

	-- The 'config' function runs after 'opts' and sets up the plugin
	config = function(_, opts)
		require("blink-cmp").setup(opts)
	end,
}
