-- Relative Path: lua/configs/basic_keymaps.lua
--
-- This file defines core key mappings (shortcuts) for Neovim.

-- Set the global leader key to Space.
-- This is the primary prefix for custom commands.
vim.g.mapleader = " "

-- Set the local leader key to Backslash.
-- This is often used for buffer-specific or plugin-specific mappings.
vim.g.maplocalleader = "\\"

-- Import the centralized icons table
local icons = require("configs.all_the_icons")

-- Create a local alias for vim.keymap.set for brevity
local map = vim.keymap.set

-- === Window Navigation ===
-- Use Ctrl + h/j/k/l to move between split windows

-- Go to the window on the left
map("n", "<C-h>", "<C-w>h", { desc = icons.nav.arrow_left .. " go to left window" })
-- Go to the window below
map("n", "<C-j>", "<C-w>j", { desc = icons.nav.arrow_down .. " go to lower window" })
-- Go to the window above
map("n", "<C-k>", "<C-w>k", { desc = icons.nav.arrow_up .. " go to upper window" })
-- Go to the window on the right
map("n", "<C-l>", "<C-w>l", { desc = icons.nav.arrow_right .. " go to right window" })

-- === Window Management ===

-- Split the current window vertically
map("n", "<leader>wv", "<C-w>v", { desc = icons.ui.window .. " split [v]ertical" })
-- Split the current window horizontally
map("n", "<leader>wh", "<C-w>s", { desc = icons.ui.window .. " split [h]orizontal" })
-- Make all split windows equal in size
map("n", "<leader>we", "<C-w>=", { desc = icons.ui.window .. " split [e]qual" })
-- Close the current window
map("n", "<leader>wc", "<C-w>c", { desc = icons.ui.close .. " split [c]lose" })

-- === Buffer Navigation ===

-- Go to the previous buffer
map("n", "<leader>bp", ":bprevious<CR>", { desc = icons.tabs.tab_previous .. " goto [p]revious" })
-- Go to the next buffer
map("n", "<leader>bn", ":bnext<CR>", { desc = icons.tabs.tab_next .. " goto [n]ext" })
-- Close (delete) the current buffer
map("n", "<leader>bc", ":bdelete<CR>", { desc = icons.ui.delete .. " [c]lose" })

-- === File Operations ===

-- Save the current file (works in multiple modes)
map({ "i", "v", "n" }, "<leader>fs", "<cmd>w<cr><esc>", { desc = icons.files.save .. " [s]ave" })
-- Reload the current file from disk
map("n", "<leader>fr", "<cmd>source %<cr>", { desc = icons.ui.refresh .. " [r]eload current file" })

-- === Utility ===

-- Quit Neovim (save all and quit)
map("n", "<leader>q", "<cmd>qa<cr>", { desc = icons.ui.quit .. " [q]uit neovim" })

-- === Text and Formatting ===

-- Indent selected lines to the left (Visual/Select mode)
map({ "v" }, "<leader>il", "<gv", { desc = icons.nav.arrow_left .. " [l]eft" })
-- Indent selected lines to the right (Visual/Select mode)
map({ "v" }, "<leader>ir", ">gv", { desc = icons.nav.arrow_right .. " [r]ight" })
-- Select all text in the buffer
map("n", "<leader>fa", "ggVG", { desc = icons.ui.clipboard_text .. " select [a]ll" })
-- Auto-indent the entire file
map("n", "<leader>fi", "gg=G", { desc = icons.lsp.formatting .. " auto-[i]ndent entire file" })

-- === GitHub Repo Creation ===

-- This function prompts the user for a repository name
-- and then runs the 'gh repo create' command in a
-- floating terminal.
local function create_github_repo()
	-- 1. Prompt the user for the repo name
	local repo_name = vim.fn.input("Enter GitHub Repo Name: ")

	-- 2. Check if the user cancelled the input
	if repo_name == "" or repo_name == nil then
		print("Cancelled repo creation.")
		return
	end

	-- 3. Construct the 'gh' command
	--    This uses the user's input, sets it to public, and uses the current directory
	local gh_cmd = string.format("gh repo create %s --public --source=.", repo_name)

	-- 4. Construct the ToggleTerm command to run the 'gh' command
	--    We use a float so the user can interact with 'gh' prompts.
	local term_cmd = string.format("ToggleTerm cmd='%s' direction=float", gh_cmd)

	-- 5. Execute the ToggleTerm command
	vim.cmd(term_cmd)
end

-- Keymap to run the repo creation function
map("n", "<leader>gc", create_github_repo, { desc = icons.vendors.github .. " [c]reate GitHub Repo" })
