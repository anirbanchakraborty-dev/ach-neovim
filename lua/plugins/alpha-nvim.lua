-- Relative Path: lua/plugins/alpha-nvim.lua
-- Plugin Repo: https://github.com/goolord/alpha-nvim
--
-- This file configures the 'alpha-nvim' plugin, which provides
-- a customizable start screen (dashboard) for Neovim.

return {
	-- The plugin's repository name
	"goolord/alpha-nvim",

	-- Dependencies required by this plugin
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- Used to display icons on the dashboard
	},

	-- The 'config' function runs after the plugin is loaded
	config = function()
		-- Load the 'alpha' plugin
		local alpha = require("alpha")
		-- Load the pre-built 'dashboard' theme
		local dashboard = require("alpha.themes.dashboard")
		-- Load your centralized icons
		local icons = require("basic_configurations.all_the_icons")

		-- === Header ===
		-- Set the 'header' section to a custom ASCII art logo
		dashboard.section.header.val = {
			[[                                                                                 ]],
			[[                             █████╗  ██████╗██╗  ██╗                             ]],
			[[                            ██╔══██╗██╔════╝██║  ██║                             ]],
			[[                            ███████║██║     ███████║                             ]],
			[[                            ██╔══██║██║     ██╔══██║                             ]],
			[[                            ██║  ██║╚██████╗██║  ██║                             ]],
			[[                            ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝                             ]],
			[[                                                                                 ]],
			[[                              ANIRBAN CHAKRABORTY                              ]],
			[[                                                                                 ]],
			[[                ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗               ]],
			[[                ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║               ]],
			[[                ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║               ]],
			[[                ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║               ]],
			[[                ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║               ]],
			[[                ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝               ]],
			[[                                                                                 ]],
		}

		-- === Buttons ===
		-- Define the interactive buttons for the dashboard
		dashboard.section.buttons.val = {
			-- Button 'f': Find file (using fzf-lua)
			dashboard.button("f", icons.files.file .. "  " .. icons.nav.separator .. " Find file", function()
				require("fzf-lua").files()
			end),

			-- Button 'r': Find recent files (using fzf-lua)
			dashboard.button("r", icons.ui.history .. "  " .. icons.nav.separator .. " Recent File(s)", function()
				require("fzf-lua").oldfiles()
			end),

			-- Button 'c': Find config files (using fzf-lua, scoped to config dir)
			dashboard.button(
				"c",
				icons.ui.settings .. "  " .. icons.nav.separator .. " Show NeoVim Configs",
				function()
					require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
				end
			),

			-- Button 'k': Show keymaps (using fzf-lua)
			dashboard.button("k", icons.ui.history .. "  " .. icons.nav.separator .. " Show Keymaps", function()
				require("fzf-lua").keymaps()
			end),

			-- Button 'q': Quit Neovim
			dashboard.button("q", icons.ui.quit .. "  " .. icons.nav.separator .. " Quit NeoVim", "<cmd>qa<cr>"),
		}

		-- === Setup ===
		-- Apply the modified dashboard configuration to alpha
		alpha.setup(dashboard.opts)

		-- === Autocommand ===
		-- Disable folding specifically for the 'alpha' filetype
		-- This prevents the ASCII art header from being folded
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
