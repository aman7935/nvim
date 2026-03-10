return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	lazy = false, -- This plugin is already lazy
	ft = "rust",
	config = function()
		local mason_registry = require("mason-registry")
		local codelldb = mason_registry.get_package("codelldb")
		local extension_path = codelldb:get_install_path() .. "/extension/"
		local codelldb_path = extension_path .. "adapter/codelldb"
		local liblldb_path = extension_path .. "lsp/lib/liblldb.so"
		-- If you are on macOS, the path would be:
		-- local liblldb_path = extension_path .. "lsp/lib/liblldb.dylib"

		vim.g.rustaceanvim = {
			server = {
				on_attach = function(client, bufnr)
					-- Add keymaps or other on_attach logic here
					local opts = { buffer = bufnr, silent = true, noremap = true }
					vim.keymap.set("n", "<leader>ca", function()
						vim.cmd.RustLsp("codeAction")
					end, opts)
					vim.keymap.set("n", "K", function()
						vim.cmd.RustLsp("hover")
					end, opts)
				end,
				default_settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							runBuildScripts = true,
						},
						checkOnSave = {
							allFeatures = true,
							command = "clippy",
						},
						procMacro = {
							enable = true,
							ignored = {
								["async-trait"] = { "async_trait" },
								["napi-derive"] = { "napi" },
								["async-recursion"] = { "async_recursion" },
							},
						},
					},
				},
			},
			dap = {
				adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
			},
		}
	end,
}
