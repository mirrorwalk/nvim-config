local autocmd = vim.api.nvim_create_autocmd

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

autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        vim.wo.number = true          -- Enable absolute line numbers
        vim.wo.relativenumber = true  -- Enable relative line numbers
    end,
})
