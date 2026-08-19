return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	lazy = false,
	enabled = true, -- mini.indentscope handles block highlighting now, but ibl provides persistent guides
	opts = {
		indent = {
			char = "│", -- visible indent guides
			tab_char = "│",
			highlight = { "IblIndent" },
		},
		scope = {
			enabled = true,
			char = "│", -- visible scope column
			show_start = true, -- mark where the scope begins
			show_end = true, -- mark where the scope ends
			highlight = { "IblScope" },
		},
	},
	config = function(_, opts)
		-- Make sure highlights exist and are visible on all themes
		vim.api.nvim_set_hl(0, "IblScope", { fg = "#ffffff", bold = true })
		vim.api.nvim_set_hl(0, "IblIndent", { fg = "#4a4a4a" })

		-- Use Treesitter extmarks to highlight the current scope (block under cursor)
		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

		require("ibl").setup(opts)
	end,
}
