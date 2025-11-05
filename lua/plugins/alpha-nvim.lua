return {
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        local icons = require("configs.all_the_icons")

        dashboard.section.header.val = {
            [[                                                                                 ]],
            [[                             █████╗  ██████╗██╗  ██╗                             ]],
            [[                            ██╔══██╗██╔════╝██║  ██║                             ]],
            [[                            ███████║██║     ███████║                             ]],
            [[                            ██╔══██║██║     ██╔══██║                             ]],
            [[                            ██║  ██║╚██████╗██║  ██║                             ]],
            [[                            ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝                             ]],
            [[                                                                                 ]],
            [[                              ANIRBAN CHAKRABORTY                              ]],
            [[                                                                                 ]],
            [[                ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗               ]],
            [[                ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║               ]],
            [[                ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║               ]],
            [[                ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║               ]],
            [[                ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║               ]],
            [[                ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝               ]],
            [[                                                                                 ]],
        }

        dashboard.section.buttons.val = {
            dashboard.button("f", icons.files.file .. "  " .. icons.nav.separator .. " Find file",
                function() require("fzf-lua").files() end),
            dashboard.button("r", icons.ui.history .. "  " .. icons.nav.separator .. " Recent File(s)",
                function() require("fzf-lua").oldfiles() end),
            dashboard.button("c", icons.ui.settings .. "  " .. icons.nav.separator .. " Show NeoVim Configs",
                function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end),
            dashboard.button("k", icons.ui.history .. "  " .. icons.nav.separator .. " Show Keymaps",
                function() require("fzf-lua").keymaps() end),
            dashboard.button("q", icons.ui.quit .. "  " .. icons.nav.separator .. " Quit NeoVim", "<cmd>qa<cr>"),
        }

        alpha.setup(dashboard.opts)
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
}
