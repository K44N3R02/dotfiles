-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Adjust auto-relative-line
-- translated this, for reference
--
-- https://jeffkreeftmeijer.com/vim-number/
-- vim.cmd([[
-- augroup NumberToggle
--   autocmd!
--   autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
--   autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
-- augroup END
-- ]])
local auto_relative_number_group = vim.api.nvim_create_augroup('auto-relative-number', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  desc = 'Set relative line numbers when focused and in normal mode',
  group = auto_relative_number_group,
  pattern = '*',
  callback = function()
    if vim.opt.number and vim.api.nvim_get_mode().mode ~= 'i' then
      vim.wo.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  desc = 'Unset relative numbers when leaving focus or normal mode',
  group = auto_relative_number_group,
  pattern = '*',
  callback = function()
    if vim.opt.number then
      vim.wo.relativenumber = false
    end
  end,
})

-- Autoformat C code
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Format C files on save with clang-format',
  group = vim.api.nvim_create_augroup('clang-format-autoformat', { clear = true }),
  pattern = '*.c,*.h',
  callback = function()
    vim.cmd 'ClangFormat'
  end,
})

local c_linux_kernel_tabs = vim.api.nvim_create_augroup('c-linux-kernel-tabs', { clear = true })

-- Tab length to 8 spaces for C files
-- Set tab length to 8 spaces for C files
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set tab length to 8 spaces for C files',
  group = c_linux_kernel_tabs,
  pattern = 'c',
  callback = function()
    vim.opt.tabstop = 8 -- Number of spaces that a <Tab> counts for
    vim.opt.softtabstop = 8 -- Number of spaces that a <Tab> counts for while editing
    vim.opt.shiftwidth = 8 -- Number of spaces to use for each step of (auto)indent
    vim.opt.expandtab = false -- Use actual tab characters instead of spaces
  end,
})

-- Tab length to 8 spaces for Makefile
-- Set tab length to 8 spaces for Makefile
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set tab length to 8 spaces for Makefile',
  group = c_linux_kernel_tabs,
  pattern = 'make',
  callback = function()
    vim.opt.tabstop = 8 -- Number of spaces that a <Tab> counts for
    vim.opt.softtabstop = 8 -- Number of spaces that a <Tab> counts for while editing
    vim.opt.shiftwidth = 8 -- Number of spaces to use for each step of (auto)indent
    vim.opt.expandtab = false -- Use actual tab characters instead of spaces
  end,
})
