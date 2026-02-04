return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		ensure_installed = {
			"black",
			"prettier",
			"stylua",
			"google-java-format",
			"ktlint",

			-- LSP servers (Mason names)
			"lua-language-server",
			"pyright",
			"typescript-language-server",
			"kotlin-language-server",
			"jdtls",
		},
		auto_update = true,
		run_on_start = true,
	},
}
