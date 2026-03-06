local function apply_black_background()
	local black = "#000000"
	local indent_fg = "#4a4a4a"
	local scope_fg = "#8a8a8a"

	-- Core
	vim.api.nvim_set_hl(0, "Normal", { bg = black })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = black })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = black })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = black })
	vim.api.nvim_set_hl(0, "SignColumn", { bg = black })
	vim.api.nvim_set_hl(0, "MsgArea", { bg = black })
	vim.api.nvim_set_hl(0, "FoldColumn", { bg = black })
	vim.api.nvim_set_hl(0, "LineNr", { bg = black })
	vim.api.nvim_set_hl(0, "CursorLineNr", { bg = black })

	-- Neo-tree
	vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = black })
	vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = black })
	vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = black })

	-- Telescope
	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = black })
	vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = black })
	vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = black })
	vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = black })
	vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = black })
	vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = black })
	vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = black })
	vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = black })

	-- Indent guides on black background
	vim.api.nvim_set_hl(0, "Whitespace", { fg = indent_fg, bg = black })
	vim.api.nvim_set_hl(0, "IblIndent", { fg = indent_fg, bg = black })
	vim.api.nvim_set_hl(0, "IblScope", { fg = scope_fg, bg = black, bold = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = apply_black_background,
})

apply_black_background()
