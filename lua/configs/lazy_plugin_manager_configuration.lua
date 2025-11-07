-- Relative Path: lua/configs/lazy_plugin_manager_configuration.lua
-- Plugin Repo: https://github.com/folke/lazy.nvim
--
-- This file handles the setup and configuration of the 'lazy.nvim' plugin manager.

-- Define the path where lazy.nvim should be installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- === Bootstrap lazy.nvim ===
-- Check if lazy.nvim is already installed at the defined path
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	-- If not installed, define the repository URL
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"

	-- Clone the 'stable' branch of lazy.nvim with a shallow clone
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none", -- Shallow clone to save space
		"--branch=stable", -- Use the stable branch
		lazyrepo,
		lazypath,
	})

	-- If the clone command failed, show an error message
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		-- Wait for user input before exiting
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Add lazy.nvim to the runtime path (rtp)
-- This makes 'require("lazy")' possible
vim.opt.rtp:prepend(lazypath)

-- === Configure lazy.nvim ===
-- Call the main setup function for lazy
require("lazy").setup({
	-- 'spec' defines where to find your plugin specifications (your 'lua/plugins/' directory)
	spec = { import = "plugins" },

	-- Configure installation behavior
	install = {
		-- Try to load one of these colorschemes after installation
		colorscheme = { "tokyonight-moon", "habamax" },
	},

	-- Configure plugin update checking
	checker = {
		enabled = true, -- Check for updates automatically
		notify = false, -- Do not notify about updates on startup
	},

	-- Configure detection of changes to your config
	change_detection = {
		enabled = true, -- Automatically check if the config has changed
		notify = false, -- Do not notify about changes, just apply them
	},

	-- Configuration for Lua rocks (external Lua dependencies)
	rocks = {
		enabled = false, -- Disable automatic rock management
		hererocks = false, -- Disable 'hererocks'
	},

	-- Configure the 'lazy.nvim' user interface
	ui = {
		wrap = true, -- Wrap text in the 'lazy' UI
		border = "rounded", -- Use rounded borders for the UI windows
	},
})
