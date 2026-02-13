return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-v>"] = function()
                local clipboard = vim.fn.getreg("+"):gsub("\n", "")
                vim.api.nvim_put({ clipboard }, "c", false, true)
              end,
            },
            n = {
              ["p"] = function()
                local clipboard = vim.fn.getreg("+"):gsub("\n", "")
                vim.api.nvim_put({ clipboard }, "c", false, true)
              end,
            },
          },
        },
      })

      local b = require("telescope.builtin")
      local k = vim.keymap.set
      k("n", "<leader>ff", b.find_files)
      k("n", "<leader>fg", b.live_grep)
      k("n", "<leader>fb", b.buffers)
    end,
  },
}
