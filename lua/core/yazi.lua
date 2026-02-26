local M = {}

local state = {
	win = nil,
	buf = nil,
	chooser = nil,
	cwd_file = nil,
	active_root = nil,
	last_by_root = {},
}

local yazi_xdg_config_home = vim.fn.stdpath("config") .. "/xdg"

local function get_project_root(path)
	local normalized = vim.fn.fnamemodify(path, ":p")
	local root = nil
	if vim.fs and vim.fs.root then
		root = vim.fs.root(normalized, { ".git" })
	end
	return vim.fn.fnamemodify(root or vim.fn.getcwd(), ":p")
end

local function cleanup()
	if state.chooser and vim.fn.filereadable(state.chooser) == 1 then
		vim.fn.delete(state.chooser)
	end
	if state.cwd_file and vim.fn.filereadable(state.cwd_file) == 1 then
		vim.fn.delete(state.cwd_file)
	end
	state.chooser = nil
	state.cwd_file = nil
end

local function close_window()
	if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
		pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
	end
	state.win = nil
	state.buf = nil
end

local function open_toggle_window()
	state.buf = vim.api.nvim_create_buf(false, true)

	local width = math.max(math.floor(vim.o.columns * 0.9), 60)
	local height = math.max(math.floor(vim.o.lines * 0.85), 20)
	local col = math.max(math.floor((vim.o.columns - width) / 2), 0)
	local row = math.max(math.floor((vim.o.lines - height) / 2) - 1, 0)

	state.win = vim.api.nvim_open_win(state.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
		noautocmd = true,
	})

	vim.bo[state.buf].bufhidden = "wipe"
	vim.bo[state.buf].buflisted = false
	vim.wo[state.win].winblend = 0
	vim.wo[state.win].winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder"
end

function M.open(start_entry)
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_set_current_win(state.win)
		return
	end

	local current_file = vim.fn.expand("%:p")
	local fallback = current_file
	if fallback == "" then
		fallback = (vim.uv or vim.loop).cwd()
	end

	cleanup()
	state.chooser = vim.fn.tempname()
	state.cwd_file = vim.fn.tempname()

	open_toggle_window()

	state.active_root = get_project_root(start_entry or fallback)
	local project_state = state.last_by_root[state.active_root] or {}
	state.last_by_root[state.active_root] = project_state

	local entry = start_entry
	if not entry or entry == "" then
		-- Prefer the file currently open in Neovim (including startup-restored file),
		-- then fall back to yazi's remembered location for this project.
		if current_file ~= "" and vim.fn.filereadable(current_file) == 1 then
			entry = current_file
		elseif project_state.last_file and vim.fn.filereadable(project_state.last_file) == 1 then
			entry = project_state.last_file
		elseif project_state.last_dir and vim.fn.isdirectory(project_state.last_dir) == 1 then
			entry = project_state.last_dir
		else
			entry = fallback
		end
	end
	if vim.fn.isdirectory(entry) == 0 and vim.fn.filereadable(entry) == 0 then
		entry = (vim.uv or vim.loop).cwd()
	end

	local job_id = vim.fn.termopen({ "yazi", entry, "--chooser-file=" .. state.chooser, "--cwd-file=" .. state.cwd_file }, {
		env = {
			XDG_CONFIG_HOME = yazi_xdg_config_home,
		},
		on_exit = function()
			vim.schedule(function()
				local root = state.active_root or get_project_root((vim.uv or vim.loop).cwd())
				local project_state_inner = state.last_by_root[root] or {}
				state.last_by_root[root] = project_state_inner

				local selected = {}
				if state.chooser and vim.fn.filereadable(state.chooser) == 1 then
					selected = vim.fn.readfile(state.chooser)
				end
				if state.cwd_file and vim.fn.filereadable(state.cwd_file) == 1 then
					local cwd_lines = vim.fn.readfile(state.cwd_file)
					if #cwd_lines > 0 and cwd_lines[1] ~= "" and vim.fn.isdirectory(cwd_lines[1]) == 1 then
						project_state_inner.last_dir = vim.fn.fnamemodify(cwd_lines[1], ":p")
					end
				end

				close_window()
				cleanup()
				state.active_root = nil

				if #selected > 0 and selected[1] ~= "" then
					local first = vim.fn.fnamemodify(selected[1], ":p")
					local selected_root = get_project_root(first)
					local selected_state = state.last_by_root[selected_root] or {}
					state.last_by_root[selected_root] = selected_state

					if vim.fn.isdirectory(first) == 1 then
						selected_state.last_dir = first
						selected_state.last_file = nil
						M.open(first)
						return
					end

					selected_state.last_dir = vim.fn.fnamemodify(first, ":h")
					selected_state.last_file = first
					pcall(vim.cmd, "edit " .. vim.fn.fnameescape(first))
					for i = 2, #selected do
						if selected[i] ~= "" and vim.fn.isdirectory(selected[i]) == 0 then
							vim.cmd("badd " .. vim.fn.fnameescape(vim.fn.fnamemodify(selected[i], ":p")))
						end
					end
				end
			end)
		end,
	})

	vim.keymap.set("t", "<Esc>", function()
		if job_id and job_id > 0 then
			vim.api.nvim_chan_send(job_id, "\27")
		end
	end, { buffer = state.buf, silent = true, desc = "Send Esc to yazi" })

	vim.keymap.set("t", "<leader>x", function()
		M.toggle()
	end, { buffer = state.buf, silent = true, desc = "Toggle Yazi Explorer" })

	vim.cmd("startinsert")
end

function M.toggle()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		close_window()
		cleanup()
		return
	end
	M.open()
end

return M
