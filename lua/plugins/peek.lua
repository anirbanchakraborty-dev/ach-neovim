-- FIX: Move this line to the top, outside the 'return' block
local icons = require("configs.all_the_icons")

return {
    "toppair/peek.nvim",
    ft = { "markdown" },
    build = "deno task --quiet build:fast",

    config = function()
        -- The 'icons' variable is already available,
        -- but you don't need it here anyway.
        require("peek").setup({
            -- 'app = "webview"' is the default and is what solves your Safari issue.
        })
    end,

    -- Keymaps for which-key
    keys = {
        {
            "<leader>fp",
            function() require("peek").open() end,
            -- This will now work correctly
            desc = icons.files.pdf .. " [p]review"
        },
        {
            "<leader>fc",
            function() require("peek").close() end,
            -- This will now work correctly
            desc = icons.ui.close .. " [c]lose"
        },
        {
            "<leader>fe",
            -- This pandoc command is 100% correct!
            "<cmd>!pandoc '%:p' -o '%:r.pdf'<CR>",
            desc = icons.files.export .. " [e]xport"
        }
    }
}
