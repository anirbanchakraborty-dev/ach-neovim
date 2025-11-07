-- Relative Path: lua/plugins/lualine.lua
-- Plugin Repo: https://github.com/nvim-lualine/lualine.nvim
--
-- This file configures the 'lualine.nvim' plugin, which provides the statusline.

return {
	"nvim-lualine/lualine.nvim",
	-- Load late, as it's just UI
	event = "VeryLazy",
	-- Depends on devicons for file icons
	dependencies = { "nvim-tree/nvim-web-devicons" },

	-- 'opts' function defines the Lualine configuration
	opts = function()
		-- Load your centralized icons
		local icons = require("configs.all_the_icons")

		-- Helper function to get the foreground color from an existing highlight group.
		-- This is used to make Lualine's colors match the colorscheme's
		-- diagnostic and diff colors.
		local function hl_fg(group)
			-- Safely get the highlight group
			local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
			if not ok or not hl or not hl.fg then
				return nil
			end
			local fg = hl.fg
			-- Convert the color number to a hex string if needed
			if type(fg) == "number" then
				return string.format("#%06x", fg)
			end
			return fg
		end

		-- A local color palette for the custom theme
		local c = {
			bg = "#011628",
			bg_dark = "#011423",
			fg = "#CBE0F0",
			fg_dark = "#B4D0E9",
			teal = "#64c3ff",
			blue = "#0A64AC",
			magenta = "#ae81ff",
			pink = "#ff5874",
			orange = "#ff9e64",
			green = "#3CCF91",
			red = "#ff6c6b",
		}

		-- Definition for the custom Lualine theme
		local theme = {
			-- Inactive windows have a muted, transparent background
			inactive = {
				a = { fg = c.fg_dark, bg = "none" },
				b = { fg = c.fg_dark, bg = "none" },
				c = { fg = c.fg_dark, bg = "none" },
			},
			-- Colors for Insert mode
			insert = {
				a = { fg = c.bg, bg = c.green, gui = "bold" },
				b = { bg = "none" },
				c = { bg = "none" },
			},
			-- Colors for Normal mode
			normal = {
				a = { fg = c.bg, bg = c.teal, gui = "bold" },
				b = { bg = "none" },
				c = { bg = "none" },
			},
			-- Colors for Replace mode
			replace = {
				a = { fg = c.bg, bg = c.pink, gui = "bold" },
				b = { bg = "none" },
				c = { bg = "none" },
			},
			-- Colors for Visual mode
			visual = {
				a = { fg = c.bg, bg = c.magenta, gui = "bold" },
				b = { bg = "none" },
				c = { bg = "none" },
			},
		}

		-- === Lualine Component Definitions ===

		-- 1. Mode component
		local mode = {
			"mode",
			-- Add the Neovim icon before the mode name
			fmt = function(str)
				return icons.editors.neovim .. " " .. str
			end,
		}

		-- 2. Git Branch component
		local branch = { "branch", icon = { icons.git.branch, color = { fg = c.teal } } }

		-- 3. Git Diff component
		local diff = {
			"diff",
			-- Set icons for diff symbols
			symbols = {
				added = icons.git.added .. " ",
				modified = icons.git.modified .. " ",
				removed = icons.git.removed .. " ",
			},
			-- Use the 'hl_fg' helper to match colorscheme
			diff_color = {
				added = { fg = hl_fg("DiffAdd") or c.teal },
				modified = { fg = hl_fg("DiffChange") or c.orange },
				removed = { fg = hl_fg("DiffDelete") or c.pink },
			},
		}

		-- 4. Diagnostics component
		local diagnostics = {
			"diagnostics",
			sections = { "error", "warn", "info", "hint" },
			-- Set icons for diagnostic symbols
			symbols = {
				error = icons.diagnostics.error .. " ",
				warn = icons.diagnostics.warn .. " ",
				info = icons.diagnostics.info .. " ",
				hint = icons.diagnostics.hint .. " ",
			},
			-- Use the 'hl_fg' helper to match colorscheme
			diagnostics_color = {
				error = { fg = hl_fg("DiagnosticError") or c.pink },
				warn = { fg = hl_fg("DiagnosticWarn") or c.orange },
				info = { fg = hl_fg("DiagnosticInfo") or c.teal },
				hint = { fg = hl_fg("DiagnosticHint") or c.blue },
			},
		}

		-- === Custom Helper Functions for Components ===

		-- Helper function to detect the OS and return the correct icon
		local function os_icon()
			local sys = vim.loop.os_uname().sysname:lower()
			if sys:match("darwin") or sys:match("mac") then
				return icons.os.macos
			elseif sys:match("linux") then
				return icons.os.linux
			elseif sys:match("windows") then
				return icons.os.windows
			else
				return icons.os.unix or ""
			end
		end

		-- Helper function to get and format a list of active LSP clients
		local function lsp_info()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if not clients or #clients == 0 then
				return ""
			end
			local names = {}
			for _, client in ipairs(clients) do
				table.insert(names, client.name)
			end
			return table.concat(names, ", ")
		end

		-- Safely load lazy.status to check for plugin updates
		local ok_lazy, lazy_status = pcall(require, "lazy.status")

		-- Helper to format the OS icon with the 'Normal' highlight group
		local function os_colored_icon()
			return string.format("%%#Normal#%s", os_icon())
		end

		-- Advanced helper function to create a custom filename component
		-- This combines the file icon, filename, and file state (modified/readonly)
		local function filename_with_icon()
			local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
			local fname = vim.fn.expand("%:t")
			if fname == "" then
				return ""
			end

			-- Get file icon and color from nvim-web-devicons
			local ext = vim.fn.expand("%:e")
			local icon, icon_color = devicons_ok and devicons.get_icon_color(fname, ext, { default = true })

			-- Determine file state (readonly, modified, or normal)
			local file_state_icon
			local file_state_color
			if not vim.bo.modifiable or vim.bo.readonly then
				file_state_icon = icons.files.readonly
				file_state_color = c.pink
			elseif vim.bo.modified then
				file_state_icon = icons.files.modified
				file_state_color = c.orange
			else
				file_state_icon = icons.files.normal
				file_state_color = c.teal
			end

			-- Set dynamic highlight groups for the icons
			vim.api.nvim_set_hl(0, "LualineFileIcon", { fg = icon_color, bg = "none" })
			vim.api.nvim_set_hl(0, "LualineFileState", { fg = file_state_color, bg = "none" })

			-- Return the formatted string using the dynamic highlights
			return table.concat({
				"%#LualineFileIcon#" .. icon,
				"%#Normal# " .. fname,
				" %#LualineFileState#" .. file_state_icon,
				"%#Normal#",
			})
		end

		-- === Main Lualine Options Table ===
		return {
			options = {
				-- Use empty separators for a cleaner, gapless look
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				-- Use a global statusline
				globalstatus = true,
				-- Apply the custom theme defined above
				theme = theme,
				icons_enabled = true,
				-- Disable lualine in specific buffers
				disabled_filetypes = {
					statusline = { "alpha", "dashboard", "snacks_dashboard" },
				},
				always_divide_middle = false,
			},
			-- Define the layout of the statusline
			sections = {
				lualine_a = { mode },
				lualine_b = { branch },
				lualine_c = {
					diff,
					-- Use the custom filename function
					{
						filename_with_icon,
						padding = { left = 1, right = 0 },
						type = "custom",
					},
				},
				lualine_x = {
					diagnostics,
					{ lsp_info }, -- Use the custom LSP info function
					-- Conditionally show Lazy updates
					ok_lazy
							and {
								function()
									return icons.vendors.lazy .. " " .. lazy_status.updates()
								end,
								cond = lazy_status.has_updates,
								color = { fg = c.orange },
							}
						or nil,
					{ "filetype", icon_only = true },
				},
				lualine_y = {},
				lualine_z = {
					{ os_colored_icon, padding = { left = 1, right = 1 } },
					{ "location", padding = { left = 1, right = 1 } },
					{ "progress", padding = { left = 1, right = 1 } },
				},
			},
		}
	end,

	-- 'config' function runs after 'opts' to apply the setup
	config = function(_, opts)
		-- 'laststatus = 3' enables the global statusline
		vim.opt.laststatus = 3
		-- Safely require and set up lualine
		local ok, lualine = pcall(require, "lualine")
		if ok then
			lualine.setup(opts)
		end
	end,
}
