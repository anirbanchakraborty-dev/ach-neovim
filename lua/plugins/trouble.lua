-- Place this at the top of the file
local icons = require("configs.all_the_icons")

return {
    "folke/trouble.nvim",
    -- We'll use cmd and keys to lazy-load
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    keys = function()
        return {
            -- Main toggle
            {
                "<leader>tt",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = icons.ui.toggle_on .. " [t]oggle"
            },
            -- LSP References
            {
                "<leader>tl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = icons.lsp.references .. " [l]sp"
            },
            { "<leader>ts", "<cmd>Trouble symbols toggle<cr>", desc = icons.lsp.symbols .. " [s]ymbols" },
        }
    end,

    opts = {
        -- Use your devicons
        use_diagnostic_signs = true,
        focus = true,
    },
}
