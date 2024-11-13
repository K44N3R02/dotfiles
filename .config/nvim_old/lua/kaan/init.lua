require("kaan.remap")
require("kaan.set")
require("kaan.lazy_init")

-- smart relative numbers
-- https://jeffkreeftmeijer.com/vim-number/
vim.cmd([[
augroup NumberToggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END
]])

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local whitespace_group = augroup('WhitespaceGroup', {})
local yank_group = augroup('HighlightYank', {})

-- Highlight yanked selection
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- Clear whitespace before saving
autocmd({"BufWritePre"}, {
    group = whitespace_group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
