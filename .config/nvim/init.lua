-- # Options
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- vim.g.have_nerd_font = true

vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '81'
vim.opt.mouse = 'a'
vim.opt.mousescroll = 'ver:0,hor:0'
vim.opt.breakindent = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'
vim.opt.scrolloff = 8
vim.opt.linebreak = true
vim.opt.guicursor = 'a:block,r-cr:hor20,o:hor50,i-ci:blinkwait700-blinkoff400-blinkon250'
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undofile = true

-- # Plugins
vim.pack.add {
    -- file management
    { src = 'https://github.com/stevearc/oil.nvim',               name = 'oil.nvim' },
    -- snippets
    { src = 'https://github.com/L3MON4D3/LuaSnip',                name = 'LuaSnip' },
    -- better search
    { src = 'https://github.com/nvim-lua/plenary.nvim',           name = 'plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim',   name = 'telescope.nvim' },
    -- LSP
    { src = 'https://github.com/neovim/nvim-lspconfig',           name = 'nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim',            name = 'mason.nvim' },
    { src = 'https://github.com/seblyng/roslyn.nvim',             name = 'roslyn.nvim' },
    -- visual
    { src = 'https://github.com/rose-pine/neovim',                name = 'rosepine' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim',         name = 'gitsigns.nvim' },
    -- for integrate with my tmux config
    { src = 'https://github.com/christoomey/vim-tmux-navigator',  name = 'vim-tmux-navigator' },
    { src = 'https://github.com/tpope/vim-obsession',             name = 'vim-obsession' },
    -- enhancing text edit operators and text objects
    { src = 'https://github.com/nvim-mini/mini.surround',         name = 'mini.surround' },
    { src = 'https://github.com/nvim-mini/mini.ai',               name = 'mini.ai' },
}

local rosepine = require('rose-pine')
rosepine.setup {
    styles = {
        bold = true,
        italic = false,
        transparency = true,
    },
    highlight_groups = {
        Pmenu = { bg = 'surface' },
        PmenuSel = { bg = 'overlay', fg = 'text' },
        PmenuSbar = { bg = 'surface' },
        PmenuThumb = { bg = 'muted' },
        NormalFloat = { bg = 'surface' },
        FloatBorder = { bg = 'surface', fg = 'highlight_med' },
    }
}
vim.cmd [[colorscheme rose-pine-moon]]

local oil = require('oil')
oil.setup()

local telescope = require('telescope')
telescope.setup()

local luasnip = require('luasnip')
luasnip.setup({ enable_autosnippets = true })
require('luasnip.loaders.from_snipmate').load({ paths = '~/.config/nvim/snippets/' })

local mason = require('mason')
mason.setup({
    registries = { "github:crashdummyy/mason-registry", "github:mason-org/mason-registry" },
})

-- https://www.reddit.com/r/neovim/comments/1l8bo8y/comment/mx5qi6c/
local roslyn = require('roslyn')
roslyn.setup()

vim.lsp.enable {
    'lua_ls',
    'roslyn',
    'clangd',
    'rust_analyzer',
    'basedpyright',
}

vim.o.autocomplete = true
vim.o.completeopt = 'menuone,noselect,popup,fuzzy'
vim.o.pumheight = 8

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-autocomplete', { clear = true }),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, {
                autotrigger = true
            })
        end
    end,
})

local mini_surround = require('mini.surround')
mini_surround.setup {}

local mini_ai = require('mini.ai')
mini_ai.setup {}

-- # Keymaps
vim.keymap.set({ 'n' }, '<esc>', '<cmd>nohlsearch<cr>')
vim.keymap.set({ 'n' }, '<C-d>', '<C-d>zz')
vim.keymap.set({ 'n' }, '<C-u>', '<C-u>zz')
vim.keymap.set({ 'n' }, 'n', 'nzz')
vim.keymap.set({ 'n' }, 'N', 'Nzz')
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set({ 'i', 'v', 'x' }, '<C-c>', '<esc>')
vim.keymap.set({ 'n' }, '<leader>z', '<cmd>update<cr><cmd>source<cr>')
vim.keymap.set({ 'n' }, '<leader>s', '<cmd>e #<cr>')

vim.keymap.set({ 'n' }, '<leader>q', '<cmd>copen<cr>')
for i = 1, 4 do
    vim.keymap.set({ 'n' }, '<leader>' .. i, ':cc ' .. i .. '<cr>')
end

vim.keymap.set({ 'n' }, '<leader>a', function()
    vim.fn.setqflist(
        { {
            filename = vim.fn.expand('%'),
            lnum = vim.fn.line('.'),
            col = 1,
            text = vim.fn.getline(vim.fn.line('.')):gsub('^%s+', '')
        } },
        'a')
end, { desc = 'Add current line to quickfix list' })

vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('qf', { clear = true }),
    callback = function()
        if vim.bo.buftype == 'quickfix' then
            vim.keymap.set({ 'n' }, '<leader>q', '<cmd>cclose<cr>', { buffer = true })
            vim.keymap.set({ 'n' }, 'dd', function()
                local idx = vim.fn.line('.')
                local qflist = vim.fn.getqflist()
                table.remove(qflist, idx)
                vim.fn.setqflist(qflist, 'r')
            end, { buffer = true })
            vim.keymap.set({ 'n' }, 'x', function()
                vim.fn.setqflist({}, 'r')
            end, { buffer = true })
        end
    end
})

vim.keymap.set({ 'n' }, '-', '<cmd>Oil<cr>')

vim.keymap.set({ 'n' }, '<leader>lf', vim.lsp.buf.format)
vim.keymap.set({ 'n' }, '<leader>la', vim.lsp.buf.code_action)

vim.keymap.set({ 'i' }, '<C-e>', function() luasnip.expand_or_jump(1) end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-l>', function() luasnip.jump(1) end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-h>', function() luasnip.jump(-1) end, { silent = true })

local builtin = require('telescope.builtin')
vim.keymap.set({ 'n' }, '<leader><leader>', builtin.buffers)
vim.keymap.set({ 'n' }, '<leader>ff', builtin.find_files)
vim.keymap.set({ 'n' }, '<leader>fg', builtin.live_grep)
vim.keymap.set({ 'n' }, '<leader>f?', builtin.man_pages)
vim.keymap.set({ 'n' }, '<leader>fl', builtin.quickfix)
vim.keymap.set({ 'n' }, '<leader>fr', builtin.resume)
vim.keymap.set({ 'n' }, '<leader>f/', builtin.current_buffer_fuzzy_find)
vim.keymap.set({ 'n' }, '<leader>fo', function()
    builtin.lsp_document_symbols({ symbols = { 'function', 'method' } })
end)

-- Autocommands

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

-- Autoformat C code
vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Format C and C++ files on save with clang-format',
    group = vim.api.nvim_create_augroup('clang-format-autoformat', { clear = true }),
    pattern = '*.c,*.h,*.cpp,*.hpp,*.cc,*.hh',
    callback = function()
        vim.lsp.buf.format()
    end,
})

local c_linux_kernel_tabs = vim.api.nvim_create_augroup('c-linux-kernel-tabs', { clear = true })

-- Tab length to 8 spaces for C files
-- Set tab length to 8 spaces for C files
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    desc = 'Set tab length to 8 spaces for C and C++ files',
    group = c_linux_kernel_tabs,
    pattern = '*.{c,cpp,h,hpp,cc,hh}',
    callback = function()
        vim.bo.tabstop = 8       -- Number of spaces that a <Tab> counts for
        vim.bo.softtabstop = 8   -- Number of spaces that a <Tab> counts for while editing
        vim.bo.shiftwidth = 8    -- Number of spaces to use for each step of (auto)indent
        vim.bo.expandtab = false -- Use actual tab characters instead of spaces
    end,
})

-- Tab length to 8 spaces for Makefile
-- Set tab length to 8 spaces for Makefile
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    desc = 'Set tab length to 8 spaces for Makefile',
    group = c_linux_kernel_tabs,
    pattern = '*/Makefile',
    callback = function()
        vim.bo.tabstop = 8       -- Number of spaces that a <Tab> counts for
        vim.bo.softtabstop = 8   -- Number of spaces that a <Tab> counts for while editing
        vim.bo.shiftwidth = 8    -- Number of spaces to use for each step of (auto)indent
        vim.bo.expandtab = false -- Use actual tab characters instead of spaces
    end,
})
