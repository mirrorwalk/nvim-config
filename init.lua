require("config")
require("lspconfig").lua_ls.setup({})
require'lspconfig'.html.setup{
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    --  filetypes = { "html", "svelte" }
}
require'lspconfig'.tailwindcss.setup{
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    root_dir = require('lspconfig').util.root_pattern('tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js', 'postcss.config.ts'),
    filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte"}
}
require'lspconfig'.eslint.setup{
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" }
}
require'lspconfig'.elixirls.setup({
    cmd = { "elixir-ls" },
})
require'lspconfig'.gleam.setup({})
require'lspconfig'.gopls.setup({
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
})
require'lspconfig'.zls.setup({
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
})
require'lspconfig'.jsonls.setup({})
require'lspconfig'.ts_ls.setup({})
require'lspconfig'.svelte.setup({})
--require'lspconfig'.clangd.setup({
--  cmd = {
--      "clangd",
--      "--compile-commands-dir=build",
--      "--header-insertion=iwyu",
--      "-I", "/nix/store
--})
require'lspconfig'.clangd.setup({});

vim.diagnostic.config({
    virtual_text = {
        enabled = true
    }
})

local autocmd = vim.api.nvim_create_autocmd
autocmd('LspAttach', {
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    end
})

autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

autocmd({ "FileChangedShellPost" }, {
  command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None',
  pattern = { "*" },
})

autocmd({ "BufWritePre" }, {
    pattern = { "*.ex", "*.exs", "*.gleam" },
    callback = function()
        vim.lsp.buf.format({ async = true })
    end
})

