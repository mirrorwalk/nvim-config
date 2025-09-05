return {
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim", -- Bridges Mason with lspconfig
            "hrsh7th/cmp-nvim-lsp",              -- For capabilities
            "neovim/nvim-lspconfig",             -- For lspconfig
        },
        config = function()
            local lspconfig = require("lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            -- Global diagnostic config
            vim.diagnostic.config({
                virtual_text = { enabled = true }
            })

            -- Shared capabilities and on_attach
            local capabilities = cmp_nvim_lsp.default_capabilities()
            local function on_attach(client, bufnr)
                local opts = { buffer = bufnr }
                -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
                vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
                vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
                vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)
                vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format() end)
            end

            require("mason").setup({})

            local mlsp = require("mason-lspconfig")
            mlsp.setup({
                ensure_installed = {
                    "lua_ls",
                    "html",
                    "tailwindcss",
                    "eslint",
                    "elixirls",
                    "gopls",
                    "zls",
                    "jsonls",
                    "ts_ls",
                    "svelte",
                    "clangd",
                },
                -- automatic_enable = false,
            })

            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            format = {
                                enable = true,
                                defaultConfig = {
                                    indent_style = "space",
                                    indent_size = "2",
                                },
                            },
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                library = {
                                    vim.env.VIMRUNTIME .. "/lua",
                                },
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
                html = {},
                tailwindcss = {
                    root_dir = lspconfig.util.root_pattern('tailwind.config.js', 'tailwind.config.ts',
                        'postcss.config.js', 'postcss.config.ts'),
                    filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" }
                },
                eslint = {
                    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" }
                },
                elixirls = {
                    cmd = { "elixir-ls" },
                },
                gopls = {
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                                unusedwrite = true,
                                useany = true,
                                shadow = true,
                                nilness = true,
                                printf = true,
                                shift = true,
                                simplifycompositelit = true,
                                simplifyrange = true,
                                simplifyslice = true,
                                sortslice = true,
                                testinggoroutine = true,
                                unreachable = true,
                                unsafeptr = true,
                                unusedvariable = true,
                            },
                            staticcheck = true,
                            gofumpt = true,
                            usePlaceholders = true,
                            completeUnimported = true,
                            deepCompletion = true,
                            matcher = "Fuzzy",
                            experimentalPostfixCompletions = true,
                            hoverKind = "FullDocumentation",
                            linkTarget = "pkg.go.dev",
                            vulncheck = "Imports",
                        },
                    },
                },
                zls = {
                    settings = {
                        zls = {
                            enable_inlay_hints = true,
                            enable_snippets = true,
                            warn_style = true,
                            enable_ast_check_diagnostics = true,
                            enable_build_on_save = true,
                            enable_autofix = true,
                            enable_import_embedfile_argument_completions = true,
                            inlay_hints_show_variable_type_hints = true,
                            inlay_hints_show_parameter_name = true,
                            inlay_hints_show_builtin = true,
                            inlay_hints_exclude_single_argument = true,
                            inlay_hints_hide_redundant_param_names = false,
                            inlay_hints_hide_redundant_param_names_last_token = false,
                            enable_semantic_tokens = "full",
                            operator_completions = true,
                            include_at_in_builtins = false,
                            max_detail_shown = 20,
                            skip_std_references = false,
                            prefer_ast_check_as_child_process = true,
                            highlight_global_var_declarations = false,
                            dangerous_comptime_experiments_do_not_enable = false,
                            completion_label_details = true
                        }
                    }
                },
                jsonls = {},
                ts_ls = {},
                svelte = {},
                clangd = {},
                nil_ls = {
                    settings = {
                        ["nil"] = {
                            formatting = {
                                command = { "alejandra"},
                            },
                        },
                    },
                },
            }

            local shared_opts = {
                capabilities = capabilities,
                on_attach = on_attach,
            }

            for server, opts in pairs(servers) do
                vim.lsp.config(server, vim.tbl_deep_extend("force", shared_opts, opts))
            end

            for _, server in ipairs(mlsp.get_installed_servers()) do
                vim.lsp.enable(server)
            end
        end,
    },
}
