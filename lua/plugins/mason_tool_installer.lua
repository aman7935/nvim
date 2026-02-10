return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		ensure_installed = {
			"ruff",
			"debugpy",
			"prettier",
			"stylua",
			"google-java-format",
			"ktlint",

			-- LSP servers (Mason names)
			"lua-language-server",
			"pyright",
			"ruff",
			"typescript-language-server",
			"kotlin-language-server",
			"jdtls",
		},
		auto_update = true,
		run_on_start = true,
	},
}
