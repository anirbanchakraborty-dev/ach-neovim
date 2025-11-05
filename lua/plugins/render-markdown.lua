return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
        render_modes = { "n", "c", "t" },
        bullet = { enabled = true },
        html = {
            enabled = true,
            comment = { conceal = false, },
        },
        latex = {
            -- This enables the latex rendering
            enabled = true,
            -- You can choose the external tool to use
            -- Options: "libtexprintf", "pylatexenc"
            renderer = "pylatexenc",
        },
    },
}
