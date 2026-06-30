return {
	"neovim/nvim-lspconfig",
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "kotlin",
			callback = function()
				vim.keymap.set("n", "<leader>r", function()
					vim.cmd("w")
					local out = vim.fn.system("cd " .. vim.fn.expand("%:p:h") .. " && kotlinc " .. vim.fn.expand("%:t") .. " -include-runtime -d /tmp/out.jar 2>&1 && java -jar /tmp/out.jar")
					vim.cmd("split __Kotlin_Output__")
					vim.fn.setline(1, vim.split(out, "\n"))
					vim.cmd("setlocal buftype=nofile nobuflisted bufhidden=wipe")
				end, { buffer = true, desc = "Run Kotlin file" })
			end,
		})
		local ok_cmp, cmp_capabilities = pcall(require, "cmp_nvim_lsp")
		local capabilities = ok_cmp and cmp_capabilities.default_capabilities()
			or vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.resolveSupport = {
			properties = { "documentation", "detail", "additionalTextEdits" },
		}

		vim.lsp.config("kotlin_language_server", {
			cmd = { "kotlin-language-server" },
			filetypes = { "kotlin" },
			root_markers = {
				"settings.gradle",
				"settings.gradle.kts",
				"build.xml",
				"pom.xml",
				"build.gradle",
				"build.gradle.kts",
			},
			capabilities = capabilities,
			init_options = { storagePath = vim.fn.expand("~") .. "/.cache/kotlin-lsp" },
			settings = {
				kotlin = {
					compiler = {
						jvm = {
							target = "17",
						},
					},
				},
			},
		})
		vim.lsp.enable("kotlin_language_server")
	end,
}
