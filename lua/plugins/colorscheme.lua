local colorschemes = {
    "tokyonight",
    "cyberdream",
    "catppuccin",
    "aura-dark",
}

local current_index = 1

local function switch_colorscheme()
    current_index = current_index % #colorschemes + 1
    local next_colorscheme = colorschemes[current_index]

    vim.cmd([[colorscheme ]] .. next_colorscheme)

    vim.notify("Colorscheme switched to: " .. next_colorscheme, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('SwitchColorscheme', switch_colorscheme, {})

vim.keymap.set('n', '<leader>ccs', ':SwitchColorscheme<CR>', { noremap = true, silent = true })

return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('tokyonight').setup({ transparent = true })
            -- vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('cyberdream').setup({
                transparent = true,
                italic_comments = true,
                hide_fillchars = true,
                borderless_pickers = true,
                terminal_colors = true,
                saturation = 1.2,
                extensions = {
                    telescope = true,
                    cmp = true,
                    lazy = true,
                    treesitter = true,
                    treesittercontext = true,
                },
            })
            -- vim.cmd([[colorscheme cyberdream]])
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                transparent_background = true,
                float = {
                    transparent = true,
                    solid = false,
                },
            })
        end,
    },
    {
        "baliestri/aura-theme",
        lazy = false,
        priority = 1000,
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
            vim.cmd([[colorscheme aura-dark]])
        end
    }
}
