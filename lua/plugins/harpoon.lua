return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    menu = { width = vim.api.nvim_win_get_width(0) - 4, },
    settings = { save_on_toggle = true, },
  }
}
