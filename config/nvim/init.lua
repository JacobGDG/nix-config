require("set")
require("lazy_init")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})
local focus_group = augroup('FocusGroup', {})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 1000,
        })
    end,
})

autocmd({"BufEnter", "FocusGained", "InsertLeave"}, {
    group = focus_group,
    pattern = "*",
    command = "set relativenumber",
  })
autocmd({"BufLeave", "FocusLost", "InsertEnter"}, {
    group = focus_group,
    pattern = "*",
    command = "set norelativenumber",
  })
