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
            {
                'stevearc/conform.nvim',
                opts = {},
            },
            {
                "mason-org/mason-lspconfig.nvim",
                opts = {},
                dependencies = {
                    { "mason-org/mason.nvim", opts = {} },
                    "neovim/nvim-lspconfig",
                },
            },
        },
        config = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    nix = { "alejandra", "injected" },
                },
            })

            require("mason").setup()
            local mason_registry = require("mason-registry")
            if not mason_registry.is_installed("shfmt") then
                mason_registry.get_package("shfmt"):install()
            end
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "bashls"
                }
            })


            vim.lsp.config('*', { capabilities = capabilities })

            local flake_path = vim.fn.expand("~/.config/nixos")

            vim.lsp.config('nixd', {
                capabilities = capabilities,
                settings = {
                    ['nixd'] = {
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
                            nixos = {
                                expr = string.format(
                                    "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.%s.options",
                                    vim.uv.os_gethostname()
                                )
                            },
                        },
                    },
                },
            })
            vim.lsp.enable('nixd')

            vim.lsp.config('gdscript', {
                capabilities = capabilities,
            })
            vim.lsp.enable('gdscript')

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
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
                    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
                    vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format)
                    -- vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol)
                    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
                    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = 1, float = true }) end)
                    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
                    vim.keymap.set("n", "<leader>ff", function()
                        conform.format({ async = true, lsp_fallback = true })
                    end)
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
