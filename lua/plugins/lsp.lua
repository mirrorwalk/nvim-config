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

            -- vim.lsp.config('nil_ls', {
            --     capabilities = capabilities,
            --     settings = {
            --         ['nil'] = {
            --             formatting = {
            --                 command = { 'alejandra', '-q' },
            --             },
            --         },
            --     },
            -- })

            vim.lsp.config('nixd', {
                capabilities = capabilities,
                settings = {
                    ['nixd'] = {
                        formatting = {
                            command = { 'alejandra', '-q' },
                        },
                        nixpkgs = {
                            expr = "import <nixpkgs> { }",
                        },
                        options = {
                            home_manager = {
                                expr = string.format(
                                    "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.%s.options.home-manager.users.type.getSubOptions []",
                                    vim.uv.os_gethostname()
                                )
                            },
                        },
                    },
                },
            })
            vim.lsp.enable('nixd')

            vim.lsp.config('zls', {
                settings = {
                    ['zls'] = {
                        enable_snippets = true,
                        enable_ast_check_diagnostics = true,
                        enable_autofix = true,
                        enable_import_embedfile_argument_completions = true,
                        warn_style = true,
                        highlight_global_var_declarations = true,
                        dangerous_comptime_experiments_do_not_enable = false,
                        skip_std_references = false,
                        prefer_ast_check_as_child_process = true,
                    },
                },
            })

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
