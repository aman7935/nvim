local autocmd = vim.api.nvim_create_autocmd

-- Notify LSP servers about new/changed files so imports/completions update without restart.
local function notify_lsp_watchers(bufnr, change_type)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return
	end

	local uri = vim.uri_from_fname(name)
	for _, client in ipairs(vim.lsp.get_clients()) do
		if not (client.supports_method and client:supports_method("workspace/didChangeWatchedFiles")) then
			goto continue
		end

		local ok = pcall(function()
			client:notify("workspace/didChangeWatchedFiles", {
				changes = { { uri = uri, type = change_type } },
			})
		end)
		if not ok and client.supports_method and client:supports_method("workspace/didChangeWatchedFiles") then
			pcall(function()
				client:notify("workspace/didChangeWatchedFiles", {
					changes = { { uri = uri, type = change_type } },
				})
			end)
		end

		::continue::
	end
end

local function refresh_python_workspace()
	for _, client in ipairs(vim.lsp.get_clients()) do
		if client.name == "basedpyright" or client.name == "pyright" then
			pcall(function()
				client:notify("workspace/didChangeConfiguration", {
					settings = client.config.settings or {},
				})
			end)
		end
	end
end

autocmd("BufNewFile", {
	callback = function(args)
		vim.b[args.buf]._lsp_notify_created = true
	end,
})

autocmd("BufWritePost", {
	callback = function(args)
			if vim.b[args.buf]._lsp_notify_created then
				vim.b[args.buf]._lsp_notify_created = nil
				notify_lsp_watchers(args.buf, 1) -- Created
				notify_lsp_watchers(args.buf, 2) -- Changed (helps some servers refresh imports)
			vim.defer_fn(function()
				if vim.api.nvim_buf_is_valid(args.buf) then
					notify_lsp_watchers(args.buf, 2)
				end
			end, 250)
			else
				notify_lsp_watchers(args.buf, 2) -- Changed
			end

			if vim.bo[args.buf].filetype == "python" then
				vim.defer_fn(refresh_python_workspace, 120)
			end
		end,
})
