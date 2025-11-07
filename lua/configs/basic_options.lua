-- Relative Path: lua/configs/basic_options.lua
--
-- This file sets core Neovim options (settings).
-- These are the equivalent of 'set <option>' in .vimrc.

-- Add Homebrew's binary path (for tools like rg, fd, etc. on Apple Silicon)
vim.env.PATH = "/opt/homebrew/bin:" .. vim.env.PATH

-- Create a local alias for vim.opt for brevity
local opt = vim.opt
-- Import the centralized icons table
local icons = require("configs.all_the_icons")

-- === UI and Appearance ===

-- Show line numbers
opt.number = true
-- Highlight the line the cursor is on
opt.cursorline = true
-- Wrap long lines
opt.wrap = true
-- Hide the command bar at the bottom (recommended for plugins like noice.nvim)
opt.cmdheight = 0
-- Enable 24-bit RGB colors
opt.termguicolors = true
-- Always show the sign column (for diagnostics, git signs) to prevent UI shifting
opt.signcolumn = "yes"
-- Briefly highlight matching brackets
opt.showmatch = true
-- Hide the default mode indicator (e.g., --INSERT--) as lualine will handle this
opt.showmode = false
-- Show all characters, do not conceal (e.g., '*' for bold in markdown)
opt.conceallevel = 0
-- Prompt for confirmation when closing a modified file
opt.confirm = true
-- Enable smoother scrolling
opt.smoothscroll = true
-- Wrap lines at word boundaries instead of mid-word
opt.linebreak = true

-- === Completion ===

-- Configure the behavior of the built-in completion menu
opt.completeopt = "menu,menuone,noinsert,noselect"

-- === Window and Split Management ===

-- New horizontal splits will open below the current window
opt.splitbelow = true
-- New vertical splits will open to the right of the current window
opt.splitright = true

-- === Indentation and Tabs ===

-- Number of spaces a <Tab> character represents
opt.tabstop = 2
-- Number of spaces to use for auto-indentation (<< and >>)
opt.shiftwidth = 2
-- Number of spaces to insert when pressing <Tab>
opt.softtabstop = 2
-- Use spaces instead of actual tab characters
opt.expandtab = true
-- Enable smart indentation based on file type
opt.smartindent = true
-- Copy the indentation from the previous line when starting a new line
opt.autoindent = true

-- === Behavior and Editing ===

-- Allow backspace to delete over auto-indent, end-of-line, and start of insert
opt.backspace = "indent,eol,start"
-- Use 'ripgrep' (rg) as the program for the :grep command
opt.grepprg = "rg --vimgrep"
-- Define the format of the output from 'rg' so Neovim can parse it
opt.grepformat = "%f:%l:%c:%m"
-- Show find/replace previews live as you type, without splitting the window
opt.inccommand = "nosplit"
-- Attempt to keep the view (cursor position) static when jumping
opt.jumpoptions = "view"
-- Set default spell-checking language to English
opt.spelllang = { "en" }
-- Disable concealing for built-in markdown syntax (related to conceallevel=0)
vim.g.markdown_recommended_style = 0
-- Automatically re-read a file if it was changed outside of Neovim
opt.autoread = true

-- === Search ===

-- Ignore case when searching
opt.ignorecase = true
-- ...unless the search pattern contains an uppercase letter
opt.smartcase = true
-- Do not persistently highlight all search matches
opt.hlsearch = false
-- Show search matches incrementally as you type
opt.incsearch = true

-- === Backup, Swap, and Undo ===

-- Do not create backup files
opt.backup = false
-- Do not create backup files even during writes
opt.writebackup = false
-- Do not create swap files (.swp)
opt.swapfile = false
-- Enable persistent undo (saving undo history between sessions)
opt.undofile = true

-- === Persistent Undo Directory ===

-- Define the path for storing undo files
local undodir = vim.fn.expand("~/.local/share/nvim/undodir")
-- Set the undo directory option
opt.undodir = undodir
-- Create the directory if it doesn't already exist
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

-- === Advanced Options ===

-- Configure diff behavior: use a vertical split, patience algorithm, and linematch
opt.diffopt:append({ "vertical", "algorithm:patience", "linematch:60" })
-- Add '-' to the list of keyword characters (so 'foo-bar' is one word)
opt.iskeyword:append("-")
-- Add '**' to the path, allowing :find to search all subdirectories
opt.path:append("**")
-- Make selections "inclusive" (includes the last character)
opt.selection = "inclusive"
-- Enable mouse support in all modes
opt.mouse = "a"
-- Use right-click to extend selection
opt.mousemodel = "extend"
-- Set file encoding to UTF-8
opt.encoding = "UTF-8"
-- Sync with system clipboard, unless in an SSH session
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"

-- === Command-line Completion (Wildmenu) ===

-- Enable the command-line completion menu
opt.wildmenu = true
-- Set completion behavior: show longest common string, then list all matches
opt.wildmode = "longest:full,full"
-- Ignore case when completing paths/commands
opt.wildignorecase = true

-- === UI Characters ===

-- Set custom characters for UI elements using the loaded icons
opt.fillchars = {
	foldopen = icons.ui.foldopen,
	foldclose = icons.ui.foldclose,
	fold = icons.ui.fold,
	foldsep = icons.ui.foldsep,
	diff = icons.ui.diff,
	eob = icons.ui.eob, -- End-of-buffer character
}
