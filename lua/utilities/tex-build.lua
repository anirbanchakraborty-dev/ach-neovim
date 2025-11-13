-- lua/utilities/tex-build.lua
-- Smart LaTeX build system using latexmk for automatic compilation

local M = {}

-- Import the centralized icons table
local icons = require("basic_configurations.all_the_icons")

-- Compilation log buffer and window
local log_buf = nil
local log_win = nil

-- Create or show the compilation log window
local function show_log_window()
	-- Create buffer if it doesn't exist
	if not log_buf or not vim.api.nvim_buf_is_valid(log_buf) then
		log_buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_option(log_buf, "buftype", "nofile")
		vim.api.nvim_buf_set_option(log_buf, "swapfile", false)
		vim.api.nvim_buf_set_option(log_buf, "bufhidden", "hide")
		vim.api.nvim_buf_set_name(log_buf, "LaTeX Build Log")
	end

	-- Clear previous content
	vim.api.nvim_buf_set_lines(log_buf, 0, -1, false, {})

	-- Create split window at bottom if not open
	if not log_win or not vim.api.nvim_win_is_valid(log_win) then
		vim.cmd("botright 15split")
		log_win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(log_win, log_buf)
		vim.api.nvim_win_set_option(log_win, "wrap", false)
		vim.api.nvim_win_set_option(log_win, "number", false)
		vim.api.nvim_win_set_option(log_win, "relativenumber", false)

		-- Return to previous window
		vim.cmd("wincmd p")
	end
end

-- Append text to log buffer
local function log_append(text)
	if log_buf and vim.api.nvim_buf_is_valid(log_buf) then
		local lines = vim.split(text, "\n")
		local current_lines = vim.api.nvim_buf_get_lines(log_buf, 0, -1, false)
		vim.api.nvim_buf_set_lines(log_buf, #current_lines, #current_lines, false, lines)

		-- Auto-scroll to bottom if window is valid
		if log_win and vim.api.nvim_win_is_valid(log_win) then
			local line_count = vim.api.nvim_buf_line_count(log_buf)
			vim.api.nvim_win_set_cursor(log_win, { line_count, 0 })
		end
	end
end

-- Close the log window
local function close_log_window()
	if log_win and vim.api.nvim_win_is_valid(log_win) then
		vim.api.nvim_win_close(log_win, true)
		log_win = nil
	end
end

-- Get the current buffer's file path
local function get_current_file()
	return vim.api.nvim_buf_get_name(0)
end

-- Find the root tex file by searching for \documentclass
local function find_root_tex(current_file)
	local current_dir = vim.fn.fnamemodify(current_file, ":h")

	-- First check if current file is the root
	local current_content = vim.fn.readfile(current_file)
	for _, line in ipairs(current_content) do
		if line:match("^%s*\\documentclass") then
			return current_file
		end
	end

	-- Look for magic comment in current file: % !TEX root = main.tex or %! TEX root = main.tex
	for _, line in ipairs(current_content) do
		-- Match both "% !TEX root" and "%! TEX root" and "%!TEX root"
		local root_match = line:match("^%%+%s*!?%s*TEX%s+root%s*=%s*(.+)")
		if root_match then
			root_match = vim.trim(root_match)
			-- Handle relative paths from current file's directory
			local root_file
			if root_match:match("^/") or root_match:match("^%a:") then
				-- Absolute path
				root_file = root_match
			else
				-- Relative path - resolve from current file's directory
				root_file = vim.fn.simplify(current_dir .. "/" .. root_match)
			end

			if vim.fn.filereadable(root_file) == 1 then
				return root_file
			else
				vim.notify("Magic comment points to: " .. root_file, vim.log.levels.WARN)
				vim.notify("But file doesn't exist or isn't readable!", vim.log.levels.ERROR)
			end
		end
	end

	-- Search for root tex file in current directory
	local tex_files = vim.fn.glob(current_dir .. "/*.tex", false, true)
	for _, file in ipairs(tex_files) do
		local content = vim.fn.readfile(file)
		for _, line in ipairs(content) do
			if line:match("^%s*\\documentclass") then
				return file
			end
		end
	end

	-- Search in parent directory (common for chapter files)
	local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
	if parent_dir ~= current_dir then
		tex_files = vim.fn.glob(parent_dir .. "/*.tex", false, true)
		for _, file in ipairs(tex_files) do
			local content = vim.fn.readfile(file)
			for _, line in ipairs(content) do
				if line:match("^%s*\\documentclass") then
					return file
				end
			end
		end
	end

	vim.notify("Could not find root tex file with \\documentclass!", vim.log.levels.ERROR)
	vim.notify("Add this to the top of your chapter file: % !TEX root = main.tex", vim.log.levels.WARN)
	return nil
end

-- Detect which engine to use from the tex file
local function detect_engine(tex_file)
	local content = vim.fn.readfile(tex_file)

	for _, line in ipairs(content) do
		-- Check for magic comments first (highest priority)
		if line:match("%%+%s*!TEX%s+program%s*=%s*xelatex") or line:match("%%+%s*!TEX%s+TS%-program%s*=%s*xelatex") then
			return "xelatex"
		end
		if
			line:match("%%+%s*!TEX%s+program%s*=%s*lualatex")
			or line:match("%%+%s*!TEX%s+TS%-program%s*=%s*lualatex")
		then
			return "lualatex"
		end
		if
			line:match("%%+%s*!TEX%s+program%s*=%s*pdflatex")
			or line:match("%%+%s*!TEX%s+TS%-program%s*=%s*pdflatex")
		then
			return "pdflatex"
		end

		-- Check for packages that require XeLaTeX
		if line:match("\\usepackage%s*%[?.*%]?%s*{.-fontspec.-}") or line:match("\\usepackage%s*{fontspec}") then
			return "xelatex"
		end
		if line:match("\\usepackage%s*{polyglossia}") then
			return "xelatex"
		end
	end

	-- Default to pdflatex
	return "pdflatex"
end

-- Main build function using latexmk
function M.build()
	local current_file = get_current_file()

	if not current_file:match("%.tex$") then
		vim.notify("Not a TeX file", vim.log.levels.WARN)
		return
	end

	-- Find root tex file
	local root_tex = find_root_tex(current_file)
	if not root_tex then
		show_log_window()
		log_append("=== LaTeX Build Started ===\n")
		log_append("Time: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n")
		log_append(icons.diagnostics.error .. " Could not find root TeX file\n")
		vim.notify("Could not find root TeX file", vim.log.levels.ERROR)
		return
	end

	local tex_dir = vim.fn.fnamemodify(root_tex, ":h")
	local tex_base = vim.fn.fnamemodify(root_tex, ":t:r")
	local tex_filename = vim.fn.fnamemodify(root_tex, ":t")
	local pdf_file = tex_dir .. "/" .. tex_base .. ".pdf"

	-- Detect engine
	local engine = detect_engine(root_tex)

	-- Build latexmk command
	-- -pdf: generate PDF using pdflatex (default)
	-- -pdflatex/-xelatex/-lualatex: specify the engine
	-- -interaction=nonstopmode: don't stop on errors
	-- -file-line-error: show file and line for errors
	-- -synctex=1: generate synctex file for PDF sync
	local engine_flag = "-pdf" -- default for pdflatex
	if engine == "xelatex" then
		engine_flag = "-xelatex"
	elseif engine == "lualatex" then
		engine_flag = "-lualatex"
	end

	local cmd = string.format(
		"cd %s && latexmk %s -interaction=nonstopmode -file-line-error -synctex=1 %s",
		vim.fn.shellescape(tex_dir),
		engine_flag,
		vim.fn.shellescape(tex_filename)
	)

	-- Execute latexmk
	local output = vim.fn.system(cmd)
	local exit_code = vim.v.shell_error

	-- Only show log window and details if there's an error
	if exit_code ~= 0 then
		show_log_window()
		log_append("=== LaTeX Build Started ===\n")
		log_append("Time: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n")
		log_append(icons.ui.check .. " Root file: " .. tex_filename .. "\n")
		log_append(icons.ui.check .. " Directory: " .. tex_dir .. "\n")
		log_append(icons.ui.check .. " Detected engine: " .. engine .. "\n\n")
		log_append("=== Running latexmk ===\n")
		log_append("Command: latexmk " .. engine_flag .. " " .. tex_filename .. "\n\n")

		-- Filter output to show only important information
		local filtered_lines = {}
		for line in output:gmatch("[^\r\n]+") do
			-- Show latexmk rules being run
			if
				line:match("^Latexmk:")
				or line:match("^Run number")
				or line:match("^Running")
				or line:match("biber")
				or line:match("bibtex")
				or line:match("makeindex")
				or line:match("makeglossaries")
				-- Show errors and warnings
				or line:match("^!")
				or line:match("Error")
				or line:match("Warning")
				or line:match("Undefined")
				-- Show summary
				or line:match("Success")
				or line:match("failed")
			then
				table.insert(filtered_lines, line)
			end
		end

		if #filtered_lines > 0 then
			log_append(table.concat(filtered_lines, "\n") .. "\n\n")
		end

		log_append(icons.diagnostics.error .. " Build failed with exit code: " .. exit_code .. "\n")
		log_append("\nFull output:\n" .. output .. "\n")
		vim.notify("Build failed - check log window", vim.log.levels.ERROR)
		return
	end

	-- Build succeeded
	vim.notify("Build complete!", vim.log.levels.INFO)

	-- Check if PDF was generated
	if vim.fn.filereadable(pdf_file) ~= 1 then
		vim.notify("PDF was not generated", vim.log.levels.WARN)
		return
	end

	-- Open PDF
	local open_cmd
	if vim.fn.has("mac") == 1 then
		open_cmd = "open"
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open"
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "start"
	end

	if open_cmd then
		vim.fn.system(open_cmd .. " " .. vim.fn.shellescape(pdf_file) .. " 2>/dev/null &")
		vim.notify("Opening PDF: " .. vim.fn.fnamemodify(pdf_file, ":t"), vim.log.levels.INFO)
	else
		vim.notify("Don't know how to open PDF on this system", vim.log.levels.WARN)
	end
end

-- Clean auxiliary files using latexmk
function M.clean()
	local current_file = get_current_file()

	if not current_file:match("%.tex$") then
		vim.notify("Not a TeX file", vim.log.levels.WARN)
		return
	end

	-- Find root tex file
	local root_tex = find_root_tex(current_file)
	if not root_tex then
		root_tex = current_file
	end

	local tex_dir = vim.fn.fnamemodify(root_tex, ":h")
	local tex_filename = vim.fn.fnamemodify(root_tex, ":t")

	-- Use latexmk -c to clean auxiliary files (keeps PDF)
	-- Use latexmk -C to clean everything including PDF
	local cmd = string.format("cd %s && latexmk -c %s", vim.fn.shellescape(tex_dir), vim.fn.shellescape(tex_filename))

	local output = vim.fn.system(cmd)
	local exit_code = vim.v.shell_error

	if exit_code == 0 then
		vim.notify("Cleaned auxiliary files", vim.log.levels.INFO)
	else
		vim.notify("Failed to clean files", vim.log.levels.ERROR)
	end
end

-- View PDF function
function M.view()
	local current_file = get_current_file()

	if not current_file:match("%.tex$") then
		vim.notify("Not a TeX file", vim.log.levels.WARN)
		return
	end

	-- Find root tex file
	local root_tex = find_root_tex(current_file)
	if not root_tex then
		root_tex = current_file
	end

	local tex_dir = vim.fn.fnamemodify(root_tex, ":h")
	local tex_base = vim.fn.fnamemodify(root_tex, ":t:r")
	local pdf_file = tex_dir .. "/" .. tex_base .. ".pdf"

	if vim.fn.filereadable(pdf_file) ~= 1 then
		vim.notify("PDF not found: " .. pdf_file, vim.log.levels.WARN)
		return
	end

	local open_cmd
	if vim.fn.has("mac") == 1 then
		open_cmd = "open"
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open"
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "start"
	end

	if open_cmd then
		vim.fn.system(open_cmd .. " " .. vim.fn.shellescape(pdf_file) .. " 2>/dev/null &")
	else
		vim.notify("Don't know how to open PDF on this system", vim.log.levels.ERROR)
	end
end

return M

