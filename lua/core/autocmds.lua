local autocmd = vim.api.nvim_create_autocmd

-- Auto-open netrw if no arguments are provided
autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			vim.cmd("Explore")
		end
	end,
})
