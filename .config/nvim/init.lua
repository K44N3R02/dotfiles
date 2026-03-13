-- # Options
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- vim.g.have_nerd_font = true

vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.mouse = 'a'
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
vim.opt.winborder = 'rounded'
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undofile = true

-- # Plugins
vim.pack.add {
    { src = 'https://github.com/rose-pine/neovim',                name = 'rosepine' },
    { src = 'https://github.com/stevearc/oil.nvim',               name = 'oil.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig',           name = 'nvim-lspconfig' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', name = 'nvim-treesitter' },
    { src = 'https://github.com/mason-org/mason.nvim',            name = 'mason.nvim' },
    { src = 'https://github.com/Saghen/blink.cmp',                name = 'blink.cmp' },
    { src = 'https://github.com/L3MON4D3/LuaSnip',                name = 'LuaSnip' },
    { src = 'https://github.com/danymat/neogen',                  name = 'neogen' },
    { src = 'https://github.com/nvim-lua/plenary.nvim',           name = 'plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim',   name = 'telescope.nvim' },

    { src = 'https://github.com/mfussenegger/nvim-dap',           name = 'nvim-dap' },

    -- Creates a beautiful debugger UI
    { src = 'https://github.com/rcarriga/nvim-dap-ui',            name = 'nvim-dap-ui' },

    -- Required dependency for nvim-dap-ui
    { src = 'https://github.com/nvim-neotest/nvim-nio',           name = 'nvim-nio' },

    -- Installs the debug adapters for you
    { src = 'https://github.com/jay-babu/mason-nvim-dap.nvim',    name = 'mason-nvim-dap.nvim' },

    -- Show values inline while debugging
    { src = 'https://github.com/theHamsta/nvim-dap-virtual-text', name = 'nvim-dap-virtual-text' },

    { src = 'https://github.com/seblyng/roslyn.nvim',             name = 'roslyn.nvim' },
    { src = 'https://github.com/tpope/vim-obsession',            name = 'vim-obsession' },
}

local rosepine = require('rose-pine')
rosepine.setup {
    styles = {
        bold = true,
        italic = false,
        transparency = true,
    },
}
vim.cmd 'colorscheme rose-pine-moon'

local oil = require('oil')
oil.setup()

local telescope = require('telescope')
telescope.setup()


local treesitter = require('nvim-treesitter')
local treesitter_configs = require('nvim-treesitter.configs')
treesitter.setup()
treesitter_configs.setup({
    highlight = { enable = false },
})

local luasnip = require('luasnip')
luasnip.setup({ enable_autosnippets = true })
require('luasnip.loaders.from_lua').load({ paths = '~/.config/nvim-new/snippets/' })

local neogen = require('neogen')
neogen.setup({
    snippet_engine = 'luasnip',
    languages = {
        cs = { template = { annotation_convention = 'xmldoc' } },
        c = {
            template = {
                annotation_convention = 'kerneldoc',
                kerneldoc = {
                    { nil,                "/**" },
                    { nil,                " * %s() - $1",  { type = { "func" } } },
                    { "parameters",       " * @%s: $1" },
                    { "vararg",           " * @...: $1" },
                    { nil,                " *\n * $1\n *" },
                    { nil,                " * Context: $1" },
                    { "return_statement", " * Return: $1" },
                    { nil,                " */" },
                }
            }
        },
    },
})

local blink = require('blink.cmp')
blink.setup({
    keymap = { preset = 'default' },
    appearance = { nerd_font_variant = 'mono' },
    fuzzy = { implementation = 'lua' },
    completion = {
        accept = {
            dot_repeat = true,
            auto_brackets = { enabled = false },
        },
        menu = {
            draw = {
                columns = { { 'label', gap = 1 }, { 'kind', gap = 1 }, { 'source_name' } },
                components = {
                    source_name = {
                        width = { max = 30 },
                        text = function(ctx) return '[' .. ctx.source_name .. ']' end,
                        highlight = 'BlinkCmpSource',
                    },
                },
            },
        },
        documentation = { auto_show = true },
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
    snippets = { preset = 'luasnip' },
})

local mason = require('mason')
mason.setup({
    registries = { "github:crashdummyy/mason-registry", "github:mason-org/mason-registry" },
})

-- https://www.reddit.com/r/neovim/comments/1l8bo8y/comment/mx5qi6c/
local roslyn = require('roslyn')
roslyn.setup()

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- vim.lsp.config('omnisharp', {
--     cmd = { 'omnisharp-mono', '--languageserver', '--hostPID', tostring(vim.fn.getpid()) },
--     capabilities = capabilities,
-- })

vim.lsp.enable {
    'lua_ls',
    'roslyn',
    'clangd',
    'rust_analyzer',
}

local dap = require 'dap'
local dapui = require 'dapui'

require('nvim-dap-virtual-text').setup {}

-- https://terminalprogrammer.com/neovim-setup-for-zig#heading-debugger
dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb',
    name = 'lldb',
}

dap.configurations.zig = {
    {
        type = 'lldb',
        request = 'launch',
        name = 'Launch File',
        program = '${workspaceFolder}/zig-out/bin/zox',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
}

dap.configurations.c = {
    {
        type = 'lldb',
        request = 'launch',
        name = 'Launch File',
        stopOnEntry = false,
        args = {},
    },
}

require('mason-nvim-dap').setup {
    -- Makes a best effort to setup the various debuggers with
    -- reasonable debug configurations
    automatic_installation = true,

    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    handlers = {},

    -- You'll need to check that you have the required things installed
    -- online, please don't ask me how to install them :)
    ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
    },
}

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
dapui.setup {
    -- Set icons to characters that are more likely to work in every terminal.
    --    Feel free to remove or use ones that you like more! :)
    --    Don't feel like these are good choices.
    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    controls = {
        icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
        },
    },
}

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

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

vim.keymap.set({ 'n' }, '<leader>A', function()
    vim.fn.setqflist(
        { {
            filename = vim.fn.expand('%'),
            lnum = 1,
            col = 1,
            text = vim.fn.expand('%')
        } },
        'a')
end, { desc = 'Add current file to quickfix list' })

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

vim.keymap.set({ 'v', 'x' }, '<leader>a', function()
    local lnum = math.min(vim.fn.line('.'), vim.fn.line('v'))
    vim.fn.setqflist(
        { {
            filename = vim.fn.expand('%'),
            lnum = lnum,
            col = 1,
            text = vim.fn.getline(lnum):gsub('^%s+', '')
        } },
        'a')
end, { desc = 'Add current block\'s first line to quickfix list' })

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

vim.keymap.set({ 'n' }, '<leader>ld', neogen.generate)

local builtin = require('telescope.builtin')
vim.keymap.set({ 'n' }, '<leader><leader>', builtin.buffers)
vim.keymap.set({ 'n' }, '<leader>ff', builtin.find_files)
vim.keymap.set({ 'n' }, '<leader>fg', builtin.live_grep)
vim.keymap.set({ 'n' }, '<leader>f?', builtin.man_pages)
vim.keymap.set({ 'n' }, '<leader>fl', builtin.quickfix)
vim.keymap.set({ 'n' }, '<leader>fr', builtin.resume)
vim.keymap.set({ 'n' }, '<leader>f/', builtin.current_buffer_fuzzy_find)
vim.keymap.set({ 'n' }, '<leader>fo', builtin.lsp_document_symbols)

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
        vim.bo.tabstop = 8   -- Number of spaces that a <Tab> counts for
        vim.bo.softtabstop = 8 -- Number of spaces that a <Tab> counts for while editing
        vim.bo.shiftwidth = 8 -- Number of spaces to use for each step of (auto)indent
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
        vim.bo.tabstop = 8   -- Number of spaces that a <Tab> counts for
        vim.bo.softtabstop = 8 -- Number of spaces that a <Tab> counts for while editing
        vim.bo.shiftwidth = 8 -- Number of spaces to use for each step of (auto)indent
        vim.bo.expandtab = false -- Use actual tab characters instead of spaces
    end,
})

