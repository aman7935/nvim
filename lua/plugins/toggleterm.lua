return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local Terminal = require("toggleterm.terminal").Terminal
		local toggleterm = require("toggleterm")

		-- Allow hidden buffers globally (needed to ignore open terminals on quit)
		vim.o.hidden = true

		-- Setup toggleterm
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
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = { border = "Normal", background = "Normal" },
			},
			-- Hide buffers and unlist to avoid blocking quit
			on_open = function(term)
				vim.cmd("setlocal bufhidden=hide")
				vim.cmd("setlocal nobuflisted")
				vim.cmd("startinsert")
			end,
		})

		-- Floating terminal
		local float_term = Terminal:new({ direction = "float", hidden = true })
		function _float_toggle()
			float_term:toggle()
		end

		-- Horizontal terminal
		local horiz_term = Terminal:new({ direction = "horizontal", hidden = true })
		function _horiz_toggle()
			horiz_term:toggle()
		end

		-- Keymaps
		-- Exit insert mode in terminal
		vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
		-- Toggle floating terminal
		vim.api.nvim_set_keymap("n", "<C-/>", "<cmd>lua _float_toggle()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", "<C-/>", "<cmd>lua _float_toggle()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", "<C-_>", "<cmd>lua _float_toggle()<CR>", { noremap = true, silent = true })
		-- Toggle horizontal terminal
		vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>lua _horiz_toggle()<CR>", { noremap = true, silent = true })

		-- Automatically close floating terminals on Esc like VS Code
		vim.api.nvim_create_autocmd("BufLeave", {
			pattern = "*",
			callback = function()
				if float_term:is_open() and vim.bo.buftype == "terminal" then
					float_term:close()
				end
			end,
		})

		-- Force-close all toggleterm terminals on exit (prevent E948)
		-- Force- all toggleterm terminals on exit (prevent E948)
		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function()
				for _, term in ipairs(Terminal.get_all()) do
					if term:is_open() and term.job_id then
						vim.fn.jobstop(term.job_id) -- force kill job
						pcall(term.close, term) -- close buffer safely
					end
				end
			end,
		})
	end,
}
