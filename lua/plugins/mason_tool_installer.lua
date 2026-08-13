return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	event = "VeryLazy",
	opts = {
		ensure_installed = {
			-- Formatters / Linters
			"ruff",
			"debugpy",
			"prettier",
			"stylua",
			"ktlint",
			"clang-format",
			"bear",

			-- LSP servers (Mason names)
			"lua-language-server",
			"basedpyright",
			"typescript-language-server",
			"rust-analyzer",
			"kotlin-language-server",
			"codelldb",
			"clangd",
		},
		auto_update = false,
		run_on_start = true,
	},
}
