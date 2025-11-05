local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_yank_group,
  pattern = "*",
  callback = function()
    vim.hl.on_yank({
      higroup = "IncSearch",
      timeout = 400,
    })
  end,
})

local cursor = vim.api.nvim_create_augroup("RestoreCursor", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = cursor,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" or vim.bo[args.buf].filetype == "commit" then return end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lines then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

local check = vim.api.nvim_create_augroup("AutoChecktime", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = check,
  callback = function()
    if vim.bo.buftype == "" then vim.cmd.checktime() end
  end,
})

local spell = vim.api.nvim_create_augroup("WrapSpell", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = spell,
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

local json = vim.api.nvim_create_augroup("JsonConceal", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = json,
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

local mkdir = vim.api.nvim_create_augroup("AutoMkdir", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = mkdir,
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    local dir = vim.fn.fnamemodify(file, ":p:h")
    if dir and not vim.loop.fs_stat(dir) then vim.fn.mkdir(dir, "p") end
  end,
})
