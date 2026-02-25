local M = {}

local state = {
	win = nil,
	buf = nil,
	chooser = nil,
	cwd_file = nil,
	last_dir = nil,
	last_file = nil,
}

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

function M.open(start_entry)
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_set_current_win(state.win)
		return
	end

	cleanup()
	state.chooser = vim.fn.tempname()
	state.cwd_file = vim.fn.tempname()

	vim.cmd("enew")
	state.win = vim.api.nvim_get_current_win()
	state.buf = vim.api.nvim_get_current_buf()

	vim.bo[state.buf].bufhidden = "wipe"
	vim.bo[state.buf].buflisted = false

	local entry = start_entry
	if not entry or entry == "" then
		if state.last_file and vim.fn.filereadable(state.last_file) == 1 then
			entry = state.last_file
		else
			entry = state.last_dir
		end
	end
	if not entry or entry == "" then
		entry = vim.fn.expand("%:p")
	end
	if entry == "" then
		entry = (vim.uv or vim.loop).cwd()
	elseif vim.fn.isdirectory(entry) == 0 and vim.fn.filereadable(entry) == 0 then
		entry = (vim.uv or vim.loop).cwd()
	end

  local job_id = vim.fn.termopen({ "yazi", entry, "--chooser-file=" .. state.chooser, "--cwd-file=" .. state.cwd_file }, {
    on_exit = function()
      vim.schedule(function()
				local selected = {}
				if state.chooser and vim.fn.filereadable(state.chooser) == 1 then
					selected = vim.fn.readfile(state.chooser)
				end
				if state.cwd_file and vim.fn.filereadable(state.cwd_file) == 1 then
					local cwd_lines = vim.fn.readfile(state.cwd_file)
					if #cwd_lines > 0 and cwd_lines[1] ~= "" and vim.fn.isdirectory(cwd_lines[1]) == 1 then
						state.last_dir = vim.fn.fnamemodify(cwd_lines[1], ":p")
					end
				end

				close_window()
				cleanup()

				if #selected > 0 and selected[1] ~= "" then
					local first = vim.fn.fnamemodify(selected[1], ":p")
					if vim.fn.isdirectory(first) == 1 then
						state.last_dir = first
						state.last_file = nil
						M.open(first)
						return
					end

					state.last_dir = vim.fn.fnamemodify(first, ":h")
					state.last_file = first
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
