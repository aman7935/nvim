return {
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History (Current File)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview File History (Repo)" },
      { "<leader>gx", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        use_icons = true,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
      })
    end,
  },
}
