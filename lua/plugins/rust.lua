return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	lazy = false, -- This plugin is already lazy
	dependencies = {
		"williamboman/mason.nvim", -- ensure mason is available before configuring dap
	},
	ft = "rust",
	config = function()
		local dap_adapter

		local ok, mason_registry = pcall(require, "mason-registry")
		if ok then
			local has_pkg, codelldb = pcall(mason_registry.get_package, "codelldb")
			if has_pkg and codelldb and codelldb.get_install_path then
				if not codelldb:is_installed() then
					vim.notify("mason package 'codelldb' is not installed; Rust DAP disabled", vim.log.levels.WARN)
				else
					local extension_path = codelldb:get_install_path() .. "/extension/"
					local codelldb_path = extension_path .. "adapter/codelldb"
					local liblldb_path = extension_path
						.. "lldb/lib/liblldb."
						.. (vim.loop.os_uname().sysname == "Darwin" and "dylib" or "so")
					dap_adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path)
				end
			else
				vim.notify("mason package 'codelldb' not available; Rust DAP disabled", vim.log.levels.WARN)
			end
		else
			vim.notify("mason-registry not available; Rust DAP disabled", vim.log.levels.WARN)
		end

		local rustacean_opts = {
			server = {
				on_attach = function(_, bufnr)
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
		}

		if dap_adapter then
			rustacean_opts.dap = { adapter = dap_adapter }
		end

		vim.g.rustaceanvim = rustacean_opts
	end,
}
