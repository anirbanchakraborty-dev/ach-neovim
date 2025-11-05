return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdate", "TSInstall", "TSUninstall" },

  opts = {
    auto_install = true,
    ensure_installed = {
      "markdown",
      "markdown_inline",
      "latex",
      "lua",
      "python",
      "vimdoc",
    },
    sync_install = false,

    highlight = { enable = true },
    indent = { enable = true },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = "<TAB>",
        node_decremental = "<S-TAB>",
      },
    },
  },

  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldlevel = 99
  end,
}
