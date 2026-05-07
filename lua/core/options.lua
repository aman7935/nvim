local o = vim.opt

o.number = true
o.relativenumber = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true
o.wrap = false
o.termguicolors = true
o.scrolloff = 5
o.signcolumn = "yes"
o.cursorline = true
-- o.cursorcolumn = true
o.cursorlineopt = "both" -- highlight line and number for cursor position
o.clipboard = "unnamedplus"
o.sidescrolloff = 8
o.lazyredraw = false
o.ttyfast = true
o.list = true
o.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

-- JS/TS/JSON use 2-space indentation (industry standard)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact", "json", "jsonc" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

-- Netrw Configuration

vim.g.netrw_liststyle = 3 -- tree view (standard for many)
vim.g.netrw_browse_split = 0 -- open in same window
