vim.g.mapleader = " "

local k = vim.keymap.set
k("n", "<leader>w", ":w<CR>")
k("n", "<leader>q", ":q<CR>")

local opts = { noremap = true, silent = true }

k("n", "<C-h>", "<C-w>h", opts)
k("n", "<C-j>", "<C-w>j", opts)
k("n", "<C-k>", "<C-w>k", opts)
k("n", "<C-l>", "<C-w>l", opts)

k("n", "qq", function()
	require("conform").format({ async = true })
end, { desc = "Format file" })
