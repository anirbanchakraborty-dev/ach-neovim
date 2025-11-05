local icons = require("configs.all_the_icons")

return {
  { "echasnovski/mini.comment",    opts = {} },
  { "echasnovski/mini.pairs",      opts = {} },
  { "echasnovski/mini.cursorword", opts = {} },
  {
    "echasnovski/mini.hipatterns",
    opts = function()
      local hipatterns = require("mini.hipatterns")
      vim.api.nvim_set_hl(0, "MiniHipatternsWarn", { fg = "#011423", bg = "#ff9e64", bold = true })
      vim.api.nvim_set_hl(0, "MiniHipatternsOk", { fg = "#011423", bg = "#50fa7b", bold = true })

      return {
        highlighters = {
          fixme      = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          fix        = { pattern = '%f[%w]()FIX()%f[%W]', group = 'MiniHipatternsFixme' },
          fixit      = { pattern = '%f[%w]()FIXIT()%f[%W]', group = 'MiniHipatternsFixme' },
          bug        = { pattern = '%f[%w]()BUG()%f[%W]', group = 'MiniHipatternsFixme' },
          issue      = { pattern = '%f[%w]()ISSUE()%f[%W]', group = 'MiniHipatternsFixme' },
          error      = { pattern = '%f[%w]()ERROR()%f[%W]', group = 'MiniHipatternsFixme' },
          failed     = { pattern = '%f[%w]()FAILED()%f[%W]', group = 'MiniHipatternsFixme' },
          fail       = { pattern = '%f[%w]()FAIL()%f[%W]', group = 'MiniHipatternsFixme' },

          hack       = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          temp       = { pattern = '%f[%w]()TEMP()%f[%W]', group = 'MiniHipatternsHack' },
          workaround = { pattern = '%f[%w]()WORKAROUND()%f[%W]', group = 'MiniHipatternsHack' },

          todo       = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },

          warn       = { pattern = '%f[%w]()WARN()%f[%W]', group = 'MiniHipatternsWarn' },
          warning    = { pattern = '%f[%w]()WARNING()%f[%W]', group = 'MiniHipatternsWarn' },
          xxx        = { pattern = '%f[%w]()XXX()%f[%W]', group = 'MiniHipatternsWarn' },

          note       = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
          info       = { pattern = '%f[%w]()INFO()%f[%W]', group = 'MiniHipatternsNote' },
          hint       = { pattern = '%f[%w]()HINT()%f[%W]', group = 'MiniHipatternsNote' },

          ok         = { pattern = '%f[%w]()OK()%f[%W]', group = 'MiniHipatternsOk' },
          passed     = { pattern = '%f[%w]()PASSED()%f[%W]', group = 'MiniHipatternsOk' },
          success    = { pattern = '%f[%w]()SUCCESS()%f[%W]', group = 'MiniHipatternsOk' },

          hex_color  = hipatterns.gen_highlighter.hex_color(),
        },
      }
    end,
  },
  {
    "echasnovski/mini.indentscope",
    dependencies = {
      {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
          indent = {
            char = icons.nav.vertical_bar,
          },
          scope = {
            enabled = false,
          },
        },
      },
    },
    opts = {
      symbol = icons.nav.vertical_bar,
      symbol_active = icons.nav.vertical_bar,
      options = {
        try_as_border = true,
        border = 'both', -- Show top and bottom of scope
      },
    },
    init = function()
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#627E97" })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = false
        end,
      })
    end,
  },
  {
    "echasnovski/mini.trailspace",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = function()
      local icons = require("configs.all_the_icons")
      return {
        -- { "<leader>t",  "",                                               desc = icons.ui.text .. " [t]ext" },
        { "<leader>fw", function() require("mini.trailspace").trim() end, desc = icons.ui.whitespace .. " [w]hitespace trim" },
      }
    end,
  },
}
