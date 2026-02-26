local autocmd = vim.api.nvim_create_autocmd

local state_file = vim.fn.stdpath("state") .. "/last-file-by-root.json"
local last_file_by_root = {}
local state_dirty = false

local function load_state()
	if vim.fn.filereadable(state_file) ~= 1 then
		return
	end

	local ok_read, lines = pcall(vim.fn.readfile, state_file)
	if not ok_read or not lines or #lines == 0 then
		return
	end

	local ok_decode, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
	if ok_decode and type(decoded) == "table" then
		last_file_by_root = decoded
	end
end

local function save_state()
	if not state_dirty then
		return
	end

	local ok_encode, encoded = pcall(vim.json.encode, last_file_by_root)
	if not ok_encode or not encoded then
		return
	end

	pcall(vim.fn.writefile, { encoded }, state_file)
end

local function get_project_root(path)
	local normalized = vim.fn.fnamemodify(path, ":p")
	local root = nil
	if vim.fs and vim.fs.root then
		root = vim.fs.root(normalized, { ".git" })
	end
	return vim.fn.fnamemodify(root or vim.fn.getcwd(), ":p")
end

local function is_trackable_file(bufnr)
	if vim.bo[bufnr].buftype ~= "" then
		return false
	end

	local name = vim.api.nvim_buf_get_name(bufnr)
	return name ~= "" and vim.fn.filereadable(name) == 1
end

load_state()

autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() ~= 0 then
			return
		end

		if vim.g.started_with_stdin == 1 then
			return
		end

		local restored = false
		local ok_persistence, persistence = pcall(require, "persistence")
		if ok_persistence and persistence and type(persistence.load) == "function" then
			pcall(persistence.load)
			restored = vim.fn.line2byte("$") ~= -1 and vim.api.nvim_buf_get_name(0) ~= ""
		end

		if restored then
			return
		end

		local root = get_project_root(vim.fn.getcwd())
		local last_file = last_file_by_root[root]
		if not last_file or vim.fn.filereadable(last_file) ~= 1 then
			return
		end

		vim.schedule(function()
			pcall(vim.cmd, "silent edit " .. vim.fn.fnameescape(last_file))
		end)
	end,
})

autocmd("BufEnter", {
	callback = function(args)
		if not is_trackable_file(args.buf) then
			return
		end

		local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ":p")
		local root = get_project_root(file)
		if last_file_by_root[root] ~= file then
			last_file_by_root[root] = file
			state_dirty = true
		end
	end,
})

autocmd("VimLeavePre", {
	callback = function()
		save_state()
	end,
})

-- Refresh syntax/treesitter after restoring a session so split buffers keep proper colors.
autocmd("User", {
	pattern = "PersistenceLoadPost",
	callback = function()
		vim.schedule(function()
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == "" then
					local name = vim.api.nvim_buf_get_name(bufnr)
					if name ~= "" then
						pcall(vim.api.nvim_buf_call, bufnr, function()
							vim.cmd("silent! filetype detect")
							vim.cmd("silent! syntax enable")
						end)

						if vim.treesitter and vim.treesitter.start then
							pcall(vim.treesitter.start, bufnr)
						end
					end
				end
			end
		end)
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
