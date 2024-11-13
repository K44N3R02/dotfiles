return {
    "https://github.com/nvimtools/none-ls.nvim",
    config = function ()
        local null_ls = require("null-ls")
        null_ls.setup {
            sources = {
                -- python
                null_ls.builtins.formatting.black.with {
                    extra_args = { "--line-length=80" }
                },
            }
        }
    end
}
