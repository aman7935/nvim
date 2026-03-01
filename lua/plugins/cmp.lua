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
		local types = require("cmp.types")
		local has_luasnip, luasnip = pcall(require, "luasnip")
		if has_luasnip then
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").lazy_load({
				paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
			})
		end

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

		local sources = {
			has_luasnip and { name = "luasnip", priority = 1000 } or nil,
			{ name = "nvim_lsp", priority = 900 },
			{ name = "path", priority = 700 },
			{ name = "buffer", priority = 500 },
			{ name = "emoji", priority = 300 },
		}
		sources = vim.tbl_filter(function(value)
			return value ~= nil
		end, sources)

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,noinsert",
				autocomplete = {
					cmp.TriggerEvent.InsertEnter,
					cmp.TriggerEvent.TextChanged,
				},
			},
			snippet = {
				expand = function(args)
					if has_luasnip then
						luasnip.lsp_expand(args.body)
					end
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
			sources = cmp.config.sources(sources),
			experimental = { ghost_text = true },
			sorting = {
				priority_weight = 2,
				comparators = {
					function(entry1, entry2)
						local kind1 = entry1:get_kind()
						local kind2 = entry2:get_kind()
						local priorities = {
							[types.lsp.CompletionItemKind.Snippet] = 100,
							[types.lsp.CompletionItemKind.Function] = 90,
							[types.lsp.CompletionItemKind.Method] = 85,
							[types.lsp.CompletionItemKind.Constructor] = 80,
						}
						local p1 = priorities[kind1] or 0
						local p2 = priorities[kind2] or 0
						if p1 ~= p2 then
							return p1 > p2
						end
					end,
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
