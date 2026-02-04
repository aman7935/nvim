return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
		"nvimtools/none-ls.nvim",
	},
	config = function()
		vim.diagnostic.config({
			virtual_text = { prefix = "●", spacing = 2 },
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = { border = "rounded", source = "always" },
		})

		local signs = { Error = "", Warn = "", Hint = "", Info = "" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities.textDocument.completion.completionItem.resolveSupport = {
			properties = { "documentation", "detail", "additionalTextEdits" },
		}
		capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

		local on_attach = function(client, bufnr)
			local opts = { buffer = bufnr, silent = true, noremap = true }
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
			vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
		end

		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			},
			pyright = { settings = { python = { analysis = { typeCheckingMode = "basic" } } } },
			ts_ls = {},
			kotlin_language_server = {},
			jdtls = {
				cmd = { "jdtls" },
				root_dir = require("lspconfig.util").root_pattern(".git", "build.gradle", "pom.xml"),
			},
		}

		for name, config in pairs(servers) do
			config.capabilities = capabilities
			config.on_attach = on_attach

			if vim.lsp.config then
				vim.lsp.config(name, config)
			else
				require("lspconfig")[name].setup(config)
			end
		end

		local ok, null_ls = pcall(require, "null-ls")
		if ok then
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.black,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						local opts = { buffer = bufnr, silent = true, noremap = true }
						vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
					end
				end,
			})
		end

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end,
}
