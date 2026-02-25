vim.g.mapleader = " "

local k = vim.keymap.set
k("n", "<leader>w", ":w<CR>")
k("n", "<leader>qa", ":qa!<CR>")

local opts = { noremap = true, silent = true }

k("n", "<C-h>", "<C-w>h", opts)
k("n", "<C-j>", "<C-w>j", opts)
k("n", "<C-k>", "<C-w>k", opts)
k("n", "<C-l>", "<C-w>l", opts)

-- Insert mode movement
k("n", "<C-h>", "<C-w>h", opts)
k("n", "<C-j>", "<C-w>j", opts)
k("n", "<C-k>", "<C-w>k", opts)
k("n", "<C-l>", "<C-w>l", opts)

k("n", "qq", function()
	require("conform").format({ async = true })
end, { desc = "Format file" })

k("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { silent = true, desc = "Clear search highlights" })

-- DAP (Debugging)
k("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
k("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue" })
k("n", "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step Into" })
k("n", "<leader>do", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Step Over" })
k("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Terminate Debugger" })
k("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", { desc = "Open REPL" })

-- Neotest (Testing)
k("n", "<leader>tr", "<cmd>lua require('neotest').run.run()<CR>", { desc = "Run nearest test" })
k("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = "Run current file" })
k("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<CR>", { desc = "Toggle test summary" })
k("n", "<leader>to", "<cmd>lua require('neotest').output_panel.toggle()<CR>", { desc = "Toggle test output" })
k("n", "<leader>td", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", { desc = "Debug nearest test" })


-- Python Tools
k("n", "<leader>cv", "<cmd>VenvSelect<cr>", { desc = "Select VirtualEnv" })

-- Explorer (netrw)
k("n", "<leader>x", function()
	if vim.bo.filetype == "netrw" then
		vim.cmd("Rexplore")
	else
		vim.cmd("Ex")
	end
end, { desc = "Toggle Explorer" })
