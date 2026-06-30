return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      lua = { "stylua" },
      kotlin = { "ktlint" },
      rust = { "rustfmt" },
    },

    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
    formatters = {
      ktlint = {
        require_cwd = true,
      },
    },
  },
}
