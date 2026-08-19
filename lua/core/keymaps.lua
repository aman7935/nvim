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

k("n", "<leader>ss", function()
	local p = session_path()
	vim.fn.mkdir(vim.fn.fnamemodify(p, ":h"), "p")
	vim.cmd("mksession! " .. p)
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

-- Traditional File Explorer (netrw)
k("n", "<leader>e", function()
	if vim.bo.filetype == "netrw" then
		vim.cmd("Rexplore")
	else
		vim.cmd("Ex")
	end
end, { desc = "Toggle netrw" })

