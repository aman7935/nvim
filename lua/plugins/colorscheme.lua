return {
	-- {
	-- 	"ellisonleao/gruvbox.nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("gruvbox")
	-- 	end,
	-- },

	-- {
	-- 	"gmr458/vscode_modern_theme.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("vscode_modern").setup({
	-- 			cursorline = true,
	-- 			transparent_background = false,
	-- 			nvim_tree_darker = true,
	-- 		})
	-- 		vim.cmd.colorscheme("vscode_modern")
	-- 	end,
	-- },

	-- {
	-- 	"nvim-lualine/lualine.nvim",
	-- 	dependencies = {
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- 	opts = {
	-- 		theme = "gruvbox",
	-- 	},
	-- },
	{
		"wtfox/jellybeans.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true, -- respect terminal/Nvim default background
		},
		config = function(_, opts)
			require("jellybeans").setup(opts)
			vim.cmd.colorscheme("jellybeans")
		end,
	},
}
