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

-- DAP (Debugging)
-- Python Tools
k("n", "<leader>cv", "<cmd>VenvSelect<cr>", { desc = "Select VirtualEnv" })

-- Explorer (yazi in current window)
k("n", "<leader>x", function()
	require("core.yazi").toggle()
end, { desc = "Toggle Yazi Explorer" })
