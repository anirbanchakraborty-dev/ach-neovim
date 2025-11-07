-- Relative Path: init.lua
--
-- This is the main entry point for the Neovim configuration.
-- It loads all other core configuration files.

-- Load icon settings for plugins and UI elements
require("basic_configurations.all_the_icons")

-- Load core key mappings (shortcuts)
require("basic_configurations.basic_keymaps")

-- Load core Neovim settings (options)
require("basic_configurations.basic_options")

-- Load auto-commands (automation for specific events)
require("basic_configurations.basic_auto_commands")

-- Load the 'lazy.nvim' plugin manager and its configuration
require("basic_configurations.lazy_plugin_manager_configuration")
