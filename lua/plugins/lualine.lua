return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  opts = function()
    local icons = require("configs.all_the_icons")

    local function hl_fg(group)
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
      if not ok or not hl or not hl.fg then
        return nil
      end
      local fg = hl.fg
      if type(fg) == "number" then
        return string.format("#%06x", fg)
      end
      return fg
    end

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

    local theme = {
      inactive = {
        a = { fg = c.fg_dark, bg = "none" },
        b = { fg = c.fg_dark, bg = "none" },
        c = { fg = c.fg_dark, bg = "none" },
      },
      -- I've added b and c sections to all modes to stop the background "spread" --
      insert = {
        a = { fg = c.bg, bg = c.green, gui = "bold" },
        b = { bg = "none" },
        c = { bg = "none" },
      },
      normal = {
        a = { fg = c.bg, bg = c.teal, gui = "bold" },
        b = { bg = "none" },
        c = { bg = "none" },
      },
      replace = {
        a = { fg = c.bg, bg = c.pink, gui = "bold" },
        b = { bg = "none" },
        c = { bg = "none" },
      },
      visual = {
        a = { fg = c.bg, bg = c.magenta, gui = "bold" },
        b = { bg = "none" },
        c = { bg = "none" },
      },
    }

    local mode = {
      "mode",
      fmt = function(str)
        return icons.editors.neovim .. " " .. str
      end,
    }

    local branch = { "branch", icon = { icons.git.branch, color = { fg = c.teal } } }

    local diff = {
      "diff",
      symbols = {
        added = icons.git.added .. " ",
        modified = icons.git.modified .. " ",
        removed = icons.git.removed .. " ",
      },
      diff_color = {
        added = { fg = hl_fg("DiffAdd") or c.teal },
        modified = { fg = hl_fg("DiffChange") or c.orange },
        removed = { fg = hl_fg("DiffDelete") or c.pink },
      },
    }

    local diagnostics = {
      "diagnostics",
      sections = { "error", "warn", "info", "hint" },
      symbols = {
        -- I've fixed the syntax error on this line (removed the extra dot) --
        error = icons.diagnostics.error .. " ",
        warn = icons.diagnostics.warn .. " ",
        info = icons.diagnostics.info .. " ",
        hint = icons.diagnostics.hint .. " ",
      },
      diagnostics_color = {
        error = { fg = hl_fg("DiagnosticError") or c.pink },
        warn = { fg = hl_fg("DiagnosticWarn") or c.orange },
        info = { fg = hl_fg("DiagnosticInfo") or c.teal },
        hint = { fg = hl_fg("DiagnosticHint") or c.blue },
      },
    }

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

    local ok_lazy, lazy_status = pcall(require, "lazy.status")

    local function os_colored_icon()
      return string.format("%%#Normal#%s", os_icon())
    end

    local function filename_with_icon()
      local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
      local fname = vim.fn.expand("%:t")
      if fname == "" then
        return ""
      end

      local ext = vim.fn.expand("%:e")
      local icon, icon_color = devicons_ok and devicons.get_icon_color(fname, ext, { default = true })

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

      vim.api.nvim_set_hl(0, "LualineFileIcon", { fg = icon_color, bg = "none" })
      vim.api.nvim_set_hl(0, "LualineFileState", { fg = file_state_color, bg = "none" })

      return table.concat({
        "%#LualineFileIcon#" .. icon,
        "%#Normal# " .. fname,
        " %#LualineFileState#" .. file_state_icon,
        "%#Normal#",
      })
    end

    return {
      options = {
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        theme = theme,
        icons_enabled = true,
        disabled_filetypes = {
          -- I'VE REMOVED "oil" FROM THIS LIST --
          statusline = { "alpha", "dashboard", "snacks_dashboard" },
        },
        always_divide_middle = false,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { branch },
        lualine_c = {
          diff,
          {
            filename_with_icon,
            padding = { left = 1, right = 0 },
            type = "custom",
          },
        },
        lualine_x = {
          diagnostics,
          { lsp_info },
          ok_lazy and {
            function()
              return icons.vendors.lazy .. " " .. lazy_status.updates()
            end,
            cond = lazy_status.has_updates,
            color = { fg = c.orange },
          } or nil,
          -- { "encoding" },
          { "filetype", icon_only = true },
        },
        lualine_y = {},
        lualine_z = {
          { os_colored_icon, padding = { left = 1, right = 1 } },
          { "location",      padding = { left = 1, right = 1 } },
          { "progress",      padding = { left = 1, right = 1 } },
        },
      },
    }
  end,

  config = function(_, opts)
    vim.opt.laststatus = 3
    local ok, lualine = pcall(require, "lualine")
    if ok then
      lualine.setup(opts)
    end
  end,
}
