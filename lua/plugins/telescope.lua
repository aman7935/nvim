return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          winblend = 0,
          mappings = {
            i = {
              ["<C-v>"] = function()
                local clipboard = vim.fn.getreg("+"):gsub("\n", "")
                vim.api.nvim_put({ " " .. clipboard }, "c", false, true)
              end,
            },
            n = {
              ["p"] = function()
                local clipboard = vim.fn.getreg("+"):gsub("\n", "")
                vim.api.nvim_put({ " " .. clipboard }, "c", false, true)
              end,
            },
          },
        },
      })

    end,
  },
}
