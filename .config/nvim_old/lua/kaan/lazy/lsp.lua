return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function ()
        require('fidget').setup({})
        -- To make snippets work, define capabilities
        local cmp_lsp = require('cmp_nvim_lsp')
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )
        -- :help lsp-zero-guide:integrate-with-mason-nvim
        require('mason').setup()
        require('mason-lspconfig').setup {
            ensure_installed = { "lua_ls", "rust_analyzer", "gopls", "julials" },
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                    }
                end,

                lua_ls = function ()
                    -- https://github.com/neovim/neovim/issues/21686#issuecomment-1522446128
                    require('lspconfig').lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                -- Tell the lsp which version of Lua you are using
                                -- (Most likely LuaJIT in the case of NeoVim
                                runtime = { version = 'LuaJIT', },
                                -- Get the lsp to recognize `vim` global
                                diagnostics = { globals = { 'vim', 'require' }, },
                                -- Make the lsp aware of NeoVim runtime files
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                },
                                telemetry = { enable = false, },
                            },
                        }
                    })
                end -- lua_ls

            }, -- handlers
        } -- mason-lspconfig

        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup {
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function (args)
                    require('luasnip').lsp_expand(args.body)
                end
            },
            window = {
                -- completion = cmp.config.window.bordered()
                -- documentation = cmp.config.window.bordered()
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-r>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<Tab>'] = cmp.mapping.confirm { select = true },
                ['<C-v>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-Space>'] = cmp.mapping.complete(),
            },
            sources = cmp.config.sources(
                {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
                {
                    { name = 'buffer', },
                }
            ),
        } -- cmp.config

        vim.diagnostic.config({
            virtual_text = true,
            update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        }) -- vim.diagnostic.config
    end -- config
}
