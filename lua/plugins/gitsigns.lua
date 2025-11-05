-- Place this at the top of the file
local icons = require("configs.all_the_icons")

return {
    "lewis6991/gitsigns.nvim",

    -- This plugin is event-driven, so we'll load it
    -- when you open a file.
    event = { "BufReadPre", "BufNewFile" },

    -- We use a function for keys to load the icons
    keys = function()
        return {
            -- Hunk Navigation
            {
                "]h",
                function() require("gitsigns").next_hunk({ navigation_message = false }) end,
                desc = "Next Hunk"
            },
            {
                "[h",
                function() require("gitsigns").prev_hunk({ navigation_message = false }) end,
                desc = "Previous Hunk"
            },

            -- Hunk Actions (grouped under <leader>g)

            {
                "<leader>gs",
                function() require("gitsigns").stage_hunk() end,
                desc = icons.git.stage_hunk .. " [s]tage hunk"
            },
            {
                "<leader>gr",
                function() require("gitsigns").reset_hunk() end,
                desc = icons.git.reset_hunk .. " [r]eset hunk"
            },
            {
                "<leader>gp",
                function() require("gitsigns").preview_hunk() end,
                desc = icons.git.diff_this .. " [p]review hunk"
            },

            -- Blame
            {
                "<leader>gb",
                function() require("gitsigns").blame_line({ full = true }) end,
                desc = icons.git.blame_line .. " [b]lame line"
            },

            -- Other useful gitsigns commands
            {
                "<leader>gd",
                function() require("gitsigns").diffthis() end,
                desc = icons.git.compare .. " [d]iff this"
            },
            {
                "<leader>gS",
                function() require("gitsigns").stage_buffer() end,
                desc = icons.git.staged .. " [S]tage buffer"
            },
            {
                "<leader>gR",
                function() require("gitsigns").reset_buffer() end,
                desc = icons.git.revert .. " [R]eset buffer"
            },
        }
    end,

    opts = {
        -- Use your icons for the signs
        signs = {
            add = { text = icons.git.added },
            change = { text = icons.git.modified },
            delete = { text = icons.git.removed },
            topdelete = { text = icons.git.removed },
            changedelete = { text = icons.git.modified },
        },

        -- This shows the blame info for the current line
        -- after 500ms of delay
        current_line_blame = true,
        current_line_blame_opts = {
            delay = 500,
        },
    },
}
