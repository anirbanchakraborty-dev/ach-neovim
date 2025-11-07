-- lua/utilities/keymap-export.lua
local M = {}

local mode_names = {
	n = "Normal",
	v = "Visual",
	i = "Insert",
	t = "Terminal",
}

-- Category mapping based on <leader>x prefix
local categories = {
	b = "Buffers",
	c = "Code / Formatting",
	e = "Explorer / Navigation",
	f = "FZF / Search",
	g = "Git",
	i = "Indent / Editing",
	l = "LSP",
	n = "Notifications / Noice",
	q = "Quit / Session",
	r = "Refactor / Remove",
	s = "Shell / Terminal",
	t = "Trouble / Diagnostics",
	w = "Window Management",
}

---------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------

-- Lua doesn't have table sorted-pairs; add our own
local function spairs(t)
	local keys = vim.tbl_keys(t)
	table.sort(keys)
	local index = 0
	return function()
		index = index + 1
		return keys[index], t[keys[index]]
	end
end

-- Detect only user-defined mappings
local function is_user_mapping(map)
	if not map.desc or map.desc == "" then
		return false
	end
	if map.rhs and map.rhs:match("<Plug>") then
		return false
	end
	if map.rhs and map.rhs:match(":help") then
		return false
	end
	return true
end

-- Format key (`<leader>` → "leader x")
local function normalize_key(lhs)
	return lhs:gsub("<leader>", "<leader>"):gsub("%s+", "leader "):gsub("^%s*(.-)%s*$", "%1")
end

---------------------------------------------------------------------
-- Export Function
---------------------------------------------------------------------

-- Remove icons / emoji (non-ASCII)
local function strip_icons(str)
	-- keep ASCII 32–126
	return str:gsub("[^\32-\126]", "")
end

function M.export_markdown()
	local leader = vim.g.mapleader or " "
	local grouped = {}

	for _, mode in ipairs({ "n", "v" }) do -- only export Normal + Visual
		for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
			if is_user_mapping(map) then
				-- only leader-based mappings
				if map.lhs:find("^" .. leader) then
					local key = normalize_key(map.lhs)
					local desc = strip_icons(map.desc)

					local prefix = key:match("^leader%s*(%w)")
					local category = categories[prefix] or "Misc"

					grouped[category] = grouped[category] or {}
					table.insert(grouped[category], {
						key = key,
						mode = mode_names[mode],
						desc = desc,
					})
				end
			end
		end
	end

	-- write to file
	local dump_path = vim.fn.getcwd() .. "/Keymaps.md"
	local f = io.open(dump_path, "w")

	for category, maps in spairs(grouped) do
		table.sort(maps, function(a, b)
			return a.key < b.key
		end)

		f:write("## " .. category .. "\n\n")
		f:write("| Key | Mode | Description |\n")
		f:write("|-----|------|-------------|\n")

		for _, m in ipairs(maps) do
			f:write(string.format("| `%s` | %s | %s |\n", m.key, m.mode, m.desc))
		end

		f:write("\n")
	end

	f:close()
	vim.notify("Exported ONLY leader keymaps → Keymaps.md", vim.log.levels.INFO)
end

return M
