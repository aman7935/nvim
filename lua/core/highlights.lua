-- Keep a few foreground tweaks for indent guides without overriding the background.
local function set_custom_highlights()
	-- Transparent background
	vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })

	local indent_fg = "#4a4a4a"
	local cursorline_nr = "#ffd75f"
	local scope_fg = cursorline_nr

	vim.api.nvim_set_hl(0, "Whitespace", { fg = indent_fg })
	vim.api.nvim_set_hl(0, "IblIndent", { fg = indent_fg })
	vim.api.nvim_set_hl(0, "IblScope", { fg = scope_fg, bold = true })
	vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = scope_fg })
	vim.api.nvim_set_hl(0, "MiniIndentscopePrefix", { fg = indent_fg })
	-- Outline matching brackets instead of filling the background
	vim.api.nvim_set_hl(0, "MatchParen", { fg = cursorline_nr, bg = "NONE", underline = true, bold = true })
	-- Emphasize current line and column with a subtle background
	vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2d2d2d" })
	vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#2d2d2d" })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = cursorline_nr, bold = true })

	-- Telescope transparency
	local telescope_groups = {
		"TelescopeNormal",
		"TelescopeBorder",
		"TelescopePromptNormal",
		"TelescopePromptBorder",
		"TelescopeResultsNormal",
		"TelescopeResultsBorder",
		"TelescopePreviewNormal",
		"TelescopePreviewBorder",
	}
	for _, group in ipairs(telescope_groups) do
		vim.api.nvim_set_hl(0, group, { bg = "none" })
	end

	-- Green StatusLine
	local green = "#899c5a" -- Jellybeans green
	local dark = "#151515"  -- Jellybeans dark
	vim.api.nvim_set_hl(0, "StatusLine", { fg = dark, bg = green, bold = true })
	vim.api.nvim_set_hl(0, "StatusLineNC", { fg = green, bg = dark })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_custom_highlights,
})

set_custom_highlights()
