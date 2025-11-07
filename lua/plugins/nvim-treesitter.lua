-- Relative Path: lua/plugins/nvim-treesitter.lua
-- Plugin Repo: https://github.com/nvim-treesitter/nvim-treesitter
--
-- This file configures 'nvim-treesitter', which provides advanced
-- syntax parsing for highlighting, indentation, folding, and more.

return {
  "nvim-treesitter/nvim-treesitter",

  -- Run ':TSUpdate' after installing to download parsers
  build = ":TSUpdate",

  -- Load the plugin when a file is opened
  event = { "BufReadPost", "BufNewFile" },

  -- Make Treesitter commands available
  cmd = { "TSUpdate", "TSInstall", "TSUninstall" },

  opts = {
    -- Automatically install new parsers when needed
    auto_install = true,

    -- List of parsers to ensure are installed
    ensure_installed = {
      "markdown",
      "markdown_inline", -- For fenced code blocks in markdown
      "latex",
      "lua",
      "python",
      "vimdoc", -- For Neovim help files
      "html",
      "comment",
    },

    -- Do not block Neovim startup while installing parsers
    sync_install = false,

    -- === Core Modules ===

    -- Enable Treesitter-powered syntax highlighting
    highlight = { enable = true },

    -- Enable Treesitter-powered indentation
    indent = { enable = true },

    -- Configure 'incremental selection'
    -- This allows you to visually select expanding blocks of code
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<Enter>",   -- Start selection
        node_incremental = "<Enter>", -- Expand selection
        scope_incremental = "<TAB>",  -- Expand to a larger scope
        node_decremental = "<S-TAB>", -- Shrink selection
      },
    },
  },

  -- 'config' function runs after the plugin is set up
  config = function(_, opts)
    -- Run the main Treesitter setup
    require("nvim-treesitter.configs").setup(opts)

    -- === Treesitter Folding ===
    -- Set the folding method to 'expression'
    vim.opt.foldmethod = "expr"
    -- Define the expression to be Treesitter's folding function
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    -- Set the default fold level to 99, which means
    -- all folds will be open by default when a file is loaded.
    vim.opt.foldlevel = 99
  end,
}
