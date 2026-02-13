return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
		"hrsh7th/cmp-emoji",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		require("luasnip.loaders.from_vscode").lazy_load()

		local function escape_pair()
			local closers = { ")", "]", "}", ">", "'", '"', "`", "," }
			local line = vim.api.nvim_get_current_line()
			local row, col = unpack(vim.api.nvim_win_get_cursor(0))
			local next_char = line:sub(col + 1, col + 1)
			for _, closer in ipairs(closers) do
				if next_char == closer then
					vim.api.nvim_win_set_cursor(0, { row, col + 1 })
					return true
				end
			end
			return false
		end

		local function tab_complete(fallback)
			-- Prioritize tabbing out of pairs before completion navigation so
			-- the behavior is consistent across filetypes (e.g. Python/Lua).
			if escape_pair() then
				-- successfully jumped to closing character
			elseif cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end

		local function shift_tab_complete(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(tab_complete, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(shift_tab_complete, { "i", "s" }),
				["<Esc>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.abort()
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "emoji" },
			}),
			experimental = { ghost_text = true },
			sorting = {
				priority_weight = 2,
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
		})
	end,
}
