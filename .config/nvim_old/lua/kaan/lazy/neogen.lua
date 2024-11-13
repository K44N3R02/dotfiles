return {
    "danymat/neogen",
    dependencies = {
        "L3MON4D3/LuaSnip",
    },
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*",
    config = function()
        local ng = require('neogen')
        ng.setup {
            snippet_engine = "luasnip"
        }
        vim.keymap.set("n", "<leader>nn", function() ng.generate() end)
    end
}
