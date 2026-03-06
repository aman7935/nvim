return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		opts = {
			ensure_installed = {
				"lua",
				"vim",
				"bash",
				"javascript",
				"typescript",
				"tsx",
				"python",
				"kotlin",
				"java",
				"json",
				"yaml",
				"toml",
				"html",
				"css",
				"dockerfile",
			},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			autotag = { enable = true },
		},
		config = function(_, opts)
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if ok then
				configs.setup(opts)
			end
		end,
	},
}
