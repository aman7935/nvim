return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{ [[<C-\>]], "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Toggle Terminal" },
		{ "<C-/>", "<cmd>ToggleTerm direction=float<cr>", mode = { "n", "t" }, desc = "Toggle Floating Terminal" },
		-- Some terminals send <C-_> for <C-/>
		{ "<C-_>", "<cmd>ToggleTerm direction=float<cr>", mode = { "n", "t" }, desc = "Toggle Floating Terminal" },
		{ "<leader>tt", "<cmd>ToggleTerm direction=horizontal<cr>", mode = "n", desc = "Toggle Horizontal Terminal" },
	},
	opts = {
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
		open_mapping = [[<C-\>]],
		hide_numbers = true,
		shade_terminals = true,
		shading_factor = 2,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		close_on_exit = true,
		float_opts = {
			border = "curved",
			winblend = 0,
			highlights = {
				border = "Normal",
				background = "Normal",
			},
		},
		on_open = function(term)
			vim.cmd("setlocal bufhidden=hide")
			vim.cmd("setlocal nobuflisted")
			vim.cmd("startinsert")
		end,
	},
}
