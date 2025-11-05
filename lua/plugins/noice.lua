return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},

	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			lsp_doc_border = true,
		},
	},

	keys = function()
		local icons = require("configs.all_the_icons")
		return {
			{ "<leader>n", "", desc = icons.ui.bolt .. " [n]oice" },
			{
				"<leader>nl",
				function()
					require("noice").cmd("last")
				end,
				desc = icons.time.clock .. " [l]ast message",
			},
			{
				"<leader>nh",
				function()
					require("noice").cmd("history")
				end,
				desc = icons.nav.history_back .. " [h]istory",
			},
			{
				"<leader>na",
				function()
					require("noice").cmd("all")
				end,
				desc = icons.files.file .. " [a]ll messages",
			},
			{
				"<leader>nd",
				function()
					require("noice").cmd("dismiss")
				end,
				desc = icons.ui.close .. " [d]ismiss all",
			},
			{
				"<leader>np",
				function()
					require("noice").cmd("pick")
				end,
				desc = icons.ui.search .. " [p]icker",
			},
		}
	end,

	config = function(_, opts)
		local ok_notify, notify = pcall(require, "notify")
		if ok_notify then
			notify.setup({
				background_colour = "#1a1b26",
				stages = "fade_in_slide_out",
				timeout = 3000,
			})
			vim.notify = notify
		end

		require("noice").setup(opts)

		local function refresh_noice_colors()
			local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
			local border = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
			local title = vim.api.nvim_get_hl(0, { name = "Title" })
			local function hex(n)
				return type(n) == "number" and string.format("#%06x", n) or n
			end
			local fg = hex(title.fg or normal.fg or "#c0caf5")
			local bg = hex(normal.bg or "none")
			local border_fg = hex(border.fg or "#565f89")
			vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = bg, fg = fg })
			vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = border_fg })
			vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = fg, bold = true })
			vim.api.nvim_set_hl(0, "NoiceCmdlinePrompt", { fg = fg, bold = true })
			vim.api.nvim_set_hl(0, "NoiceLspProgressTitle", { fg = fg, bold = true })
		end

		refresh_noice_colors()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("NoiceThemeAdapt", { clear = true }),
			callback = refresh_noice_colors,
		})
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				require("noice").cmd("dismiss")
			end,
		})
	end,
}
