return {
    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            require('tokyonight').setup({ transparent = true })
            -- vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- load the colorscheme here
            require('cyberdream').setup({ transparent = true })
            vim.cmd([[colorscheme cyberdream]])
        end,
    }
}
