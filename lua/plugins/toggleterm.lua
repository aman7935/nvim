return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = "ToggleTerm",
	keys = {
		{ "<C-/>", mode = { "n", "t" } },
		{ "<C-_>", mode = "t" },
		{ "<leader>tt", mode = "n" },
		{ "<leader>ll", mode = { "n", "t" } },
	},
	config = function()
		local Terminal = require("toggleterm.terminal").Terminal
		local toggleterm = require("toggleterm")
		local lazygit_return_win = nil
		local lazygit_return_buf = nil
		vim.o.hidden = true
		toggleterm.setup({
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			close_on_exit = true,
			float_opts = { border = "curved", winblend = 0, highlights = { border = "Normal", background = "Normal" } },
			on_open = function(term)
				vim.cmd("setlocal bufhidden=hide")
				vim.cmd("setlocal nobuflisted")
				vim.cmd("startinsert")
			end,
		})
		local float_term = Terminal:new({ direction = "float", hidden = true })
		function _float_toggle()
			float_term:toggle()
		end

		local horiz_term = Terminal:new({ direction = "horizontal", hidden = true })
		function _horiz_toggle()
			horiz_term:toggle()
		end

		local lazygit = Terminal:new({
			cmd = "lazygit",
			direction = "float",
			hidden = true,
			close_on_exit = true,
			on_open = function(term)
				vim.cmd("startinsert")
				vim.keymap.set("t", "<Esc>", function()
					if term.job_id and term.job_id > 0 then
						vim.api.nvim_chan_send(term.job_id, "\27")
					end
				end, { buffer = term.bufnr, silent = true, desc = "Send Esc to lazygit" })
			end,
			on_close = function()
				vim.schedule(function()
					if lazygit_return_win and vim.api.nvim_win_is_valid(lazygit_return_win) then
						vim.api.nvim_set_current_win(lazygit_return_win)
					elseif lazygit_return_buf and vim.api.nvim_buf_is_valid(lazygit_return_buf) then
						local wins = vim.fn.win_findbuf(lazygit_return_buf)
						if #wins > 0 and vim.api.nvim_win_is_valid(wins[1]) then
							vim.api.nvim_set_current_win(wins[1])
						end
					end

					if vim.bo.buftype == "terminal" then
						vim.cmd("startinsert")
						vim.defer_fn(function()
							if vim.bo.buftype == "terminal" and vim.api.nvim_get_mode().mode:sub(1, 1) ~= "t" then
								vim.api.nvim_input("a")
							end
						end, 15)
					end

					lazygit_return_win = nil
					lazygit_return_buf = nil
				end)
			end,
		})
		function _lazygit_toggle()
			if vim.bo.buftype == "terminal" then
				lazygit_return_win = vim.api.nvim_get_current_win()
				lazygit_return_buf = vim.api.nvim_get_current_buf()
			else
				lazygit_return_win = nil
				lazygit_return_buf = nil
			end
			lazygit:toggle()
		end

		vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<C-/>", "<cmd>lua _float_toggle()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", "<C-/>", "<cmd>lua _float_toggle()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", "<C-_>", "<cmd>lua _float_toggle()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>lua _horiz_toggle()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>ll", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", "<leader>ll", [[<C-\><C-n><cmd>lua _lazygit_toggle()<CR>]], { noremap = true, silent = true })
		vim.api.nvim_create_autocmd("BufLeave", {
			pattern = "*",
			callback = function()
				if float_term:is_open() and vim.bo.buftype == "terminal" then
					float_term:close()
				end
			end,
		})
		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function()
				local ok, terminal_module = pcall(require, "toggleterm.terminal")
				if not ok then return end
				for _, term in ipairs(terminal_module.get_all()) do
					if term:is_open() and term.job_id then
						vim.fn.jobstop(term.job_id)
						pcall(term.close, term)
					end
				end
			end,
		})
	end,
}
