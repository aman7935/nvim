return {
  {
    "nvim-telescope/telescope.nvim",
    dependecies = {"nvim-lua/plenary.nvim"},
    config = function()
        local b = require("telescope.builtin")
        local k = vim.keymap.set
        k('n', '<leader>ff', b.find_files)
        k('n', '<leader>fg', b.live_grep)
        k('n', '<leader>fb', b.buffers)
    end

  }
}
