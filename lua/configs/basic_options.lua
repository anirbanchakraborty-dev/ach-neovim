-- Tell Neovim where Homebrew installs things
vim.env.PATH = "/opt/homebrew/bin:" .. vim.env.PATH

local
opt = vim.opt
local icons = require("configs.all_the_icons")

opt.number = true
opt.cursorline = true
opt.wrap = true
opt.cmdheight = 0
opt.termguicolors = true
opt.signcolumn = "yes"
opt.showmatch = true
opt.showmode = false
opt.conceallevel = 0
opt.confirm = true
opt.smoothscroll = true
opt.linebreak = true
opt.completeopt = "menu,menuone,noinsert,noselect"

opt.splitbelow = true
opt.splitright = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

opt.backspace = "indent,eol,start"
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.spelllang = { "en" }
vim.g.markdown_recommended_style = 0
opt.autoread = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.autoread = true

local undodir = vim.fn.expand("~/.local/share/nvim/undodir")
opt.undodir = undodir
if vim.fn.isdirectory(undodir) == 0 then vim.fn.mkdir(undodir, "p") end

opt.diffopt:append({ "vertical", "algorithm:patience", "linematch:60" })
opt.iskeyword:append("-")
opt.path:append("**")
opt.selection = "inclusive"
opt.mouse = "a"
opt.mousemodel = "extend"
opt.encoding = "UTF-8"
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"

opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildignorecase = true

opt.fillchars = {
    foldopen = icons.ui.foldopen,
    foldclose = icons.ui.foldclose,
    fold = icons.ui.fold,
    foldsep = icons.ui.foldsep,
    diff = icons.ui.diff,
    eob = icons.ui.eob,
}
