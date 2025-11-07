-- Relative Path: lua/plugins/render-markdown.lua
-- Plugin Repo: https://github.com/MeanderingProgrammer/render-markdown.nvim
--
-- This file configures 'render-markdown.nvim', which "renders"
-- markdown elements (like bold, italics, LaTeX) in the buffer
-- so they look like the final output.

return {
    "MeanderingProgrammer/render-markdown.nvim",

    -- Dependencies:
    -- 'nvim-treesitter' is required for parsing the markdown
    -- 'nvim-web-devicons' is used for icons
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },

    -- Type hints for the Lua LSP (e.g., lua_ls)
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
        -- Specify which modes to render in.
        -- This notably excludes 'i' (Insert mode), so text
        -- reverts to raw markdown while you are typing.
        render_modes = { "n", "c", "t" },

        -- Enable rendering for bullet points
        bullet = { enabled = true },

        -- Enable rendering for HTML tags
        html = {
            enabled = true,
            -- By setting conceal to false, HTML comments ()
            -- will remain visible.
            comment = { conceal = false },
        },

        -- Enable rendering for LaTeX expressions (e.g., $...$ or $$...$$)
        latex = {
            enabled = true,
            -- Specify the external tool to use for rendering LaTeX.
            -- 'pylatexenc' is a popular choice.
            renderer = "pylatexenc",
        },
    },
}
