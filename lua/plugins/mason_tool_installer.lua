return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		ensure_installed = {
			-- Formatters / Linters
			"ruff",
			"debugpy",
			"prettier",
			"stylua",

			-- LSP servers (Mason names)
			"lua-language-server",
			"basedpyright",
			"typescript-language-server",
		},
		auto_update = true,
		run_on_start = true,
	},
}

