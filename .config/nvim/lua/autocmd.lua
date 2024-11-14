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
