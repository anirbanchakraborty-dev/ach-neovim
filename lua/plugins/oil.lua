return {
  "stevearc/oil.nvim",
  opts = {
    columns = {
      "icon",
      "size",
    },
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      natural_order = true,
      case_insensitive = true,
      is_always_hidden = function(name, _)
        return name == ".DS_Store" or name == "thumbs.db"
      end,
    },
    delete_to_trash = true,
    float = {
      border = "rounded",
      padding = 2,
    },
    keymaps = {
      ["<Esc>"] = { "actions.close", mode = "n" },
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },

  keys = function()
    local icons = require("configs.all_the_icons")

    local function pad(icon, text)
      return (icon or "") .. " " .. text
    end

    return {
      {
        "<leader>ef",
        "<cmd>Oil --float<CR>",
        desc = (icons.ui.float) .. " [f]loat",
      },
      {
        "<leader>eq",
        function()
          if vim.bo.filetype == "oil" then
            vim.cmd("close")
          else
            vim.notify(pad(icons.ui.warning, "Not in an Oil buffer"), vim.log.levels.WARN)
          end
        end,
        desc = icons.ui.quit .. " [q]uit",
      },
    }
  end,
}
