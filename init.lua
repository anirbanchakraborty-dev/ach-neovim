-- Relative Path: init.lua
--
-- This is the main entry point for the Neovim configuration.
-- It loads all other core configuration files.

-- Load icon settings for plugins and UI elements
require("configs.all_the_icons")

-- Load core key mappings (shortcuts)
require("configs.basic_keymaps")

-- Load core Neovim settings (options)
require("configs.basic_options")

-- Load auto-commands (automation for specific events)
require("configs.basic_auto_commands")

-- Load the 'lazy.nvim' plugin manager and its configuration
require("configs.lazy_plugin_manager_configuration")
