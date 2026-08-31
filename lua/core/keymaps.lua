vim.g.mapleader = " "

local k = vim.keymap.set
k("n", "<leader>w", ":w<CR>")
k("n", "<leader>qa", ":qa!<CR>")

local opts = { noremap = true, silent = true }

k("n", "<C-h>", "<C-w>h", opts)
k("n", "<C-j>", "<C-w>j", opts)
k("n", "<C-k>", "<C-w>k", opts)
k("n", "<C-l>", "<C-w>l", opts)

k("n", "qq", function()
	require("conform").format({ async = true })
end, { desc = "Format file" })

k("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { silent = true, desc = "Clear search highlights" })

-- Python Tools
k("n", "<leader>cv", "<cmd>VenvSelect<cr>", { desc = "Select VirtualEnv" })

-- Session (mksession)
local function session_path()
	local dir = vim.fn.getcwd():gsub("/", "__")
	return vim.fn.stdpath("data") .. "/session/" .. dir .. ".vim"
end

local function save_session()
	local p = session_path()
	vim.fn.mkdir(vim.fn.fnamemodify(p, ":h"), "p")
	vim.cmd("mksession! " .. p)
end

k("n", "<leader>ss", function()
	save_session()
	print("Session saved")
end, { desc = "Save Session" })

k("n", "<leader>sr", function()
	local p = session_path()
	if vim.fn.filereadable(p) == 1 then
		vim.cmd("source " .. p)
		print("Session restored")
	else
		print("No session found for this project")
	end
end, { desc = "Restore Session" })

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			local p = session_path()
			if vim.fn.filereadable(p) == 1 then
				vim.cmd("silent! source " .. p)
				vim.cmd("doautocmd ColorScheme")
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
						vim.api.nvim_buf_call(buf, function()
							vim.cmd("silent! filetype detect")
							vim.cmd("silent! syntax on")
						end)
					end
				end
			end
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		save_session()
	end,
})

-- Traditional File Explorer (netrw)
k("n", "<leader>e", function()
	if vim.bo.filetype == "netrw" then
		vim.cmd("Rexplore")
	else
		vim.cmd("Ex")
	end
end, { desc = "Toggle netrw" })

