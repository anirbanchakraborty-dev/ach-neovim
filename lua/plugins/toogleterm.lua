-- Relative Path: lua/plugins/toogleterm.lua
-- Plugin Repo: https://github.com/akinsho/toggleterm.nvim
--
-- This file configures 'toggleterm.nvim' for managing
-- floating and split terminal windows.

-- Load your centralized icons
local icons = require("configs.all_the_icons")

return {
    "akinsho/toggleterm.nvim",

    -- Define keymaps for toggleterm
    keys = function()
        return {
            {
                -- Keymap to toggle a horizontal split terminal
                "<leader>st",
                "<cmd>ToggleTerm direction=horizontal<CR>",
                desc = icons.ui.toggle_on .. " [t]oggle",
            },
            {
                -- Keymap to kill the process in the active toggleterm
                "<leader>sk",
                "<cmd>ToggleTermKill<CR>",
                desc = icons.dap.terminate .. " [k]ill",
            },
            {
                -- Keymap to toggle (hide/show) the terminal *from* terminal mode
                "<Esc><Esc>",
                "<cmd>ToggleTerm<CR>",
                mode = "t", -- This keymap only works in Terminal-mode
                desc = "Toggle Terminal",
            },
            {
                -- Keymap to toggle a custom floating 'lazygit' terminal
                "<leader>gl",
                "<cmd>lua _LAZYGIT_TOGGLE()<CR>",
                desc = icons.git.lazygit .. " [l]azygit",
            },
        }
    end,

    -- 'opts' table passes configuration to the setup function
    opts = {
        -- Set the default direction for new terminals to 'horizontal'
        direction = "horizontal",
        -- 'hidden = true' allows terminals (like lazygit) to be persistent
        hidden = true,
        -- Do not close the terminal window when the process exits
        close_on_exit = false,
        -- Add a dimmed background to inactive terminal windows
        shade_terminals = true,
    },

    -- 'config' function runs after the plugin is loaded
    config = function(_, opts)
        -- Run the standard setup with the options from the 'opts' table
        require("toggleterm").setup(opts)

        -- === Custom LazyGit Terminal ===
        -- Load the Terminal object from the plugin
        local Terminal = require("toggleterm.terminal").Terminal

        -- Create a new, persistent terminal instance for lazygit
        local lazygit = Terminal:new({
            cmd = "lazygit",        -- The command to run
            hidden = true,          -- Keep it persistent
            direction = "float",    -- Make this one a float
            float_opts = {
                border = "rounded", -- Use a rounded border
            },
        })

        -- Define a global function that the '<leader>gl' keymap can call
        -- This is necessary to toggle the specific 'lazygit' instance
        function _LAZYGIT_TOGGLE()
            lazygit:toggle()
        end
    end,
}
