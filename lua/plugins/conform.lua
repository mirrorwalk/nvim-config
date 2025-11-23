return {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                nix = { "alejandra", "injected" },
                sh = { "shfmt" },
            },
        })

        -- vim.keymap.set("n", "<leader>ff", function()
        --     conform.format({ async = true, lsp_fallback = true })
        -- end)
    end,
}
