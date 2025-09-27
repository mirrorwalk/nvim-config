return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            'saghen/blink.cmp',
            {
                "folke/lazydev.nvim",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            vim.lsp.config('*', { capabilities = capabilities })

            vim.lsp.config('nil_ls', {
                settings = {
                    ['nil'] = {
                        formatting = {
                            command = { 'alejandra', '-q' },
                        },
                    },
                },
            })

            vim.lsp.enable('nil_ls')

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local c = vim.lsp.get_client_by_id(args.data.client_id)
                    if not c then return end

                    if vim.bo.filetype == "lua" then
                        -- Format the current buffer on save
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
                            end,
                        })
                    end
                    vim.keymap.set("n", "<M-d>", vim.diagnostic.setqflist)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
                    vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
                    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
                end,
            })

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true
            })
        end,
    }
}
