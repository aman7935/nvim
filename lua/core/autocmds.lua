local autocmd = vim.api.nvim_create_autocmd

autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			vim.schedule(function()
				require("persistence").load()
			end)
		end
	end,
})

-- Notify LSP servers about new/changed files so imports/completions update without restart.
local function notify_lsp_watchers(bufnr, change_type)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return
	end

	local uri = vim.uri_from_fname(name)
	for _, client in ipairs(vim.lsp.get_clients()) do
		if client.supports_method("workspace/didChangeWatchedFiles") then
			client.notify("workspace/didChangeWatchedFiles", {
				changes = { { uri = uri, type = change_type } },
			})
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
		else
			notify_lsp_watchers(args.buf, 2) -- Changed
		end
	end,
})
