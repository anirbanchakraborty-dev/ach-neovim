vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local icons = require("configs.all_the_icons")
local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", { desc = icons.nav.arrow_left .. " go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = icons.nav.arrow_down .. " go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = icons.nav.arrow_up .. " go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = icons.nav.arrow_right .. " go to right window" })

-- map("n", "<leader>w", "", { desc = icons.ui.window .. " [w]indow" })
map("n", "<leader>wv", "<C-w>v", { desc = icons.ui.window .. " split [v]ertical" })
map("n", "<leader>wh", "<C-w>s", { desc = icons.ui.window .. " split [h]orizontal" })
map("n", "<leader>we", "<C-w>=", { desc = icons.ui.window .. " split [e]qual" })
map("n", "<leader>wc", "<C-w>c", { desc = icons.ui.close .. " split [c]lose" })

-- map("n", "<leader>b", "", { desc = icons.tabs.tab .. " [b]uffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = icons.tabs.tab_previous .. " goto [p]revious" })
map("n", "<leader>bn", ":bnext<CR>", { desc = icons.tabs.tab_next .. " goto [n]ext" })
map("n", "<leader>bc", ":bdelete<CR>", { desc = icons.ui.delete .. " [c]lose" })

-- map("n", "<leader>f", "", { desc = icons.files.file .. " [f]ile" })
map({ "i", "x", "n", "s" }, "<leader>fs", "<cmd>w<cr><esc>", { desc = icons.files.save .. " [s]ave" })
map("n", "<leader>fr", "<cmd>source %<cr>", { desc = icons.ui.refresh .. " [r]eload current file" })

map("n", "<leader>q", "<cmd>qa<cr>", { desc = icons.ui.quit .. " [q]uit neovim" })

-- map("n", "<leader>t", "", { desc = icons.ui.text .. " [t]ext" })
map({ "v", "x" }, "<leader>tl", "<gv", { desc = icons.nav.arrow_left .. " indent [l]eft" })
map({ "v", "x" }, "<leader>tr", ">gv", { desc = icons.nav.arrow_right .. " indent [r]ight" })
map("n", "<leader>fa", "ggVG", { desc = icons.ui.clipboard_text .. " select [a]ll" })
map("n", "<leader>fi", "gg=G", { desc = icons.lsp.formatting .. " auto-[i]ndent entire file" })
