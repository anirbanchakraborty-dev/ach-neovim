-- Place this at the top of the file
local icons = require("configs.all_the_icons")

return {
    "akinsho/toggleterm.nvim",

    -- We use a function for keys to load the icons
    keys = function()
        return {
            {
                "<leader>st",
                -- This command will toggle a horizontal split terminal
                "<cmd>ToggleTerm direction=horizontal<CR>",
                desc = icons.ui.toggle_on .. " [t]oggle"
            },

            -- ⭐️ 1. KEYMAP TO "KILL" THE PROCESS ⭐️
            -- This works from Normal-mode
            {
                "<leader>sk",
                "<cmd>ToggleTermKill<CR>",
                desc = icons.dap.terminate .. " [k]ill"
            },

            -- ⭐️ 2. KEYMAP TO "MINIMIZE" (TOGGLE) ⭐️
            -- The <t> means this keymap only works in Terminal-mode
            {
                "<Esc><Esc>", -- You can change <C-x> to <Esc><Esc> or another key
                "<cmd>ToggleTerm<CR>",
                mode = "t",
                desc = "Toggle Terminal"
            },
            {
                "<leader>gl",
                "<cmd>lua _LAZYGIT_TOGGLE()<CR>",
                desc = icons.git.lazygit .. " [l]azygit"
            },
        }
    end,

    -- This is where we pass options to the setup function
    opts = {
        -- Set the default terminal to be a horizontal split
        direction = "horizontal",
        hidden = true,
        close_on_exit = false,
        shade_terminals = true,
    },

    -- This function calls the setup, passing in your `opts`
    config = function(_, opts)
        -- Run the default setup
        require("toggleterm").setup(opts)

        -- ⭐️ 2. THIS IS THE CODE YOU FOUND ⭐️
        -- We define the persistent lazygit terminal here.
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({
            cmd = "lazygit",
            hidden = true,
            direction = "float", -- Make sure it's a float
            float_opts = {
                border = "rounded",
            },
        })

        -- ⭐️ 3. DEFINE THE GLOBAL FUNCTION ⭐️
        -- This function will be called by your keymap.
        function _LAZYGIT_TOGGLE()
            lazygit:toggle()
        end
    end,
}
