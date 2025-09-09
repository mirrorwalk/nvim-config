return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', {})
        vim.keymap.set('n', '<leader>fz', builtin.current_buffer_fuzzy_find)
        vim.keymap.set("n", "<space>fh", builtin.help_tags)


        require('telescope').setup {
            extensions = {
                fzf = {}
            },
            pickers = {
                find_files = {
                    theme = "ivy"
                }
            }
        }

        require('telescope').load_extension('fzf')
    end,
}
