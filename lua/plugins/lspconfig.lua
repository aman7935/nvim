return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		pcall(vim.diagnostic.config, {
			virtual_text = { prefix = "●", spacing = 2 },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = { border = "rounded", source = "always" },
		})

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
			vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, opts)
			vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)

			if client.name == "vtsls" then
				vim.keymap.set("n", "<leader>co", function()
					client.request("workspace/executeCommand", {
						command = "typescript.organizeImports",
						arguments = { vim.api.nvim_buf_get_name(0) },
					})
				end, { buffer = bufnr, desc = "Organize Imports" })

				vim.keymap.set("n", "<leader>cm", function()
					client.request("workspace/executeCommand", {
						command = "typescript.addMissingImports",
						arguments = { vim.api.nvim_buf_get_name(0) },
					})
				end, { buffer = bufnr, desc = "Add Missing Imports" })

				vim.keymap.set("n", "<leader>cu", function()
					client.request("workspace/executeCommand", {
						command = "typescript.removeUnused",
						arguments = { vim.api.nvim_buf_get_name(0) },
					})
				end, { buffer = bufnr, desc = "Remove Unused Imports" })

				vim.keymap.set("n", "<leader>cf", function()
					client.request("workspace/executeCommand", {
						command = "typescript.fixAll",
						arguments = { vim.api.nvim_buf_get_name(0) },
					})
				end, { buffer = bufnr, desc = "Fix All Problems" })

				vim.keymap.set("n", "gs", function()
					client.request("workspace/executeCommand", {
						command = "typescript.goToSourceDefinition",
						arguments = { vim.api.nvim_buf_get_name(0), vim.lsp.util.make_position_params().position },
					})
				end, { buffer = bufnr, desc = "Go to Source Definition" })
			end
		end

		local function root_dir_with(patterns)
			return function(fname)
				if vim.fs and vim.fs.root then
					return vim.fs.root(fname, patterns)
				end
				return vim.fn.getcwd()
			end
		end

		local servers = {
			lua_ls = {
				autostart = false,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			},
			basedpyright = {
				root_dir = root_dir_with({
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"pyrightconfig.json",
					".git",
				}),
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
							autoImportCompletions = true,
							indexing = true,
						},
					},
					basedpyright = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
							autoImportCompletions = true,
							indexing = true,
						},
					},
				},
before_init = function(params, config)
	local root = config.root_dir or vim.loop.cwd()

	local venv_path = root .. "/.venv/bin/python"

	if vim.uv.fs_stat(venv_path) then
		config.settings = config.settings or {}

		config.settings.python = vim.tbl_deep_extend(
			"force",
			config.settings.python or {},
			{
				pythonPath = venv_path,
			}
		)
	end
end,
			},
			ruff = {},
			vtsls = {
				root_dir = root_dir_with({
					"package.json",
					"tsconfig.json",
					"jsconfig.json",
					".git",
				}),
				settings = {
					complete_function_calls = true,
					vtsls = {
						autoUseWorkspaceTsdk = true,
						experimental = {
							completion = {
								enableServerSidePolyfills = true,
							},
						},
					},
					javascript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							autoImports = true,
						},
						inlayHints = {
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							autoImports = true,
						},
						inlayHints = {
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
				},
			},
		}

		for name, config in pairs(servers) do
			if name ~= "kotlin_language_server" then
				local ok, config_def = pcall(require, "lspconfig.configs." .. name)
				if ok and config_def and config_def.default_config then
					config = vim.tbl_deep_extend("force", config_def.default_config, config)
				end
			end

			config.capabilities = capabilities
			config.on_attach = on_attach

			-- The new vim.lsp.config API expects root_dir to be a function with
			-- signature (bufnr, on_dir) instead of the old (fname) -> string.
			-- Wrap old-style functions so they work with the new async API.
			if type(config.root_dir) == "function" then
				local orig = config.root_dir
				config.root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					if fname and fname ~= "" then
						on_dir(orig(fname, bufnr))
					end
				end
			end


			vim.lsp.config(name, config)
			if config.autostart ~= false then
				vim.lsp.enable(name)
			end
		end
	end,
}
