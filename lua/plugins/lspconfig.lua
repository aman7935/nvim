return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		vim.diagnostic.config({
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
		end

		local function pick_ts_server_name()
			local ok, configs = pcall(require, "lspconfig.configs")
			if ok then
				if configs.ts_ls then
					return "ts_ls"
				end
				if configs.tsserver then
					return "tsserver"
				end
			end
			return "tsserver"
		end

		local function root_dir_with(patterns)
			return function(fname)
				if vim.fs and vim.fs.root then
					return vim.fs.root(fname, patterns)
				end
				return vim.fn.getcwd()
			end
		end

		local ts_server_name = pick_ts_server_name()

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
				before_init = function(_, config)
					local venv_path = config.root_dir .. "/.venv/bin/python"
					if vim.loop.fs_stat(venv_path) then
						config.settings = config.settings or {}
						config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, {
							pythonPath = venv_path,
						})
					end
				end,
			},
			ruff = {},
			[ts_server_name] = {
				root_dir = root_dir_with({
					"package.json",
					"tsconfig.json",
					"jsconfig.json",
					".git",
				}),
			},
		}

		for name, config in pairs(servers) do
			config.capabilities = capabilities
			config.on_attach = on_attach

			if vim.lsp.config then
				vim.lsp.config(name, config)
				if vim.lsp.enable then
					vim.lsp.enable(name)
				end
			else
				require("lspconfig")[name].setup(config)
			end
		end
	end,
}

