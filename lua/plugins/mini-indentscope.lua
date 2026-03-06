return {
	"echasnovski/mini.indentscope",
	enabled = false,
	version = false, -- wait for next release to use 'main' branch
	event = "VeryLazy",
	opts = {
		-- symbol = "▏",
		symbol = "│",
		options = { try_as_border = true },
	},
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"help",
				"alpha",
				"dashboard",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,
}
