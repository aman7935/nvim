return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		scope = { enabled = false },
	},
	config = function(_, opts)
		local highlight = {
			"IblIndent",
			"IblScope",
		}
		for _, hl in ipairs(highlight) do
			vim.api.nvim_set_hl(0, hl, { link = "Whitespace" })
		end
		require("ibl").setup(opts)
	end,
}
