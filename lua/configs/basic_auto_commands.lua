-- Relative Path: lua/configs/basic_auto_commands.lua
--
-- This file defines custom autocommands for event-based automation.

-- === Highlight Yanked Text ===
-- Create an augroup to hold the yank-highlighting autocommand
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})

-- Register an autocommand that triggers after text is yanked (copied)
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	pattern = "*", -- Apply to all file types
	callback = function()
		-- Use the built-in 'vim.hl.on_yank' to flash the yanked region
		vim.hl.on_yank({
			higroup = "IncSearch", -- Use the same highlight group as incremental search
			timeout = 400, -- Duration of the flash in milliseconds
		})
	end,
})

-- === Restore Cursor Position ===
-- Create an augroup for cursor restoration logic
local cursor = vim.api.nvim_create_augroup("RestoreCursor", { clear = true })

-- Register an autocommand that triggers after a buffer is read (opened)
vim.api.nvim_create_autocmd("BufReadPost", {
	group = cursor,
	callback = function(args)
		-- THIS IS THE NEW LINE YOU MUST ADD:
		local bo = vim.bo[args.buf]

		-- Stop if this is a special buffer (like a plugin UI) or a git commit message
		if bo.buftype ~= "" or bo.filetype == "commit" then
			return
		end

		-- Get the position of the '"' mark (last cursor position)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local lines = vim.api.nvim_buf_line_count(args.buf)

		-- If the mark is valid (line > 0 and within the file's line count)
		if mark[1] > 0 and mark[1] <= lines then
			-- Attempt to set the cursor to that position
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- === Auto-reload Buffers ===
-- Create an augroup for checking file changes on disk
local check = vim.api.nvim_create_augroup("AutoChecktime", { clear = true })

-- Register an autocommand to run when Neovim gains focus or terminals close
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = check,
	callback = function()
		-- If we are in a normal buffer, run :checktime
		-- This reloads the file if it has been changed externally
		if vim.bo.buftype == "" then
			vim.cmd.checktime()
		end
	end,
})

-- === Filetype-Specific Settings ===
-- Create an augroup for text-file-specific settings
local spell = vim.api.nvim_create_augroup("WrapSpell", { clear = true })

-- Register an autocommand that triggers when a file's type is set
vim.api.nvim_create_autocmd("FileType", {
	group = spell,
	-- Apply only to these file types
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		-- Enable line wrapping for this buffer
		vim.opt_local.wrap = true
		-- Enable spell checking for this buffer
		vim.opt_local.spell = true
	end,
})

-- Create an augroup for JSON-specific settings
local json = vim.api.nvim_create_augroup("JsonConceal", { clear = true })

-- Register an autocommand for JSON file types
vim.api.nvim_create_autocmd("FileType", {
	group = json,
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		-- Ensure concealing is disabled for JSON files
		vim.opt_local.conceallevel = 0
	end,
})

-- === Auto-create Directories ===
-- Create an augroup for directory creation logic
local mkdir = vim.api.nvim_create_augroup("AutoMkdir", { clear = true })

-- Register an autocommand to run just before writing a buffer
vim.api.nvim_create_autocmd("BufWritePre", {
	group = mkdir,
	callback = function(event)
		-- Stop if this is a remote file (e.g., scp://)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end

		-- Get the full, real path of the file being saved
		local file = vim.uv.fs_realpath(event.match) or event.match
		-- Get the directory part of that path
		local dir = vim.fn.fnamemodify(file, ":p:h")

		-- If the directory is valid and does not exist
		if dir and not vim.loop.fs_stat(dir) then
			-- Create the directory recursively
			vim.fn.mkdir(dir, "p")
		end
	end,
})
