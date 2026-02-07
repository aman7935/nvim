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
        "abecodes/tabout.nvim",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local tabout = require("tabout")

        require("luasnip.loaders.from_vscode").lazy_load()

        tabout.setup({
            tabkey = "<Tab>",
            backwards_tabkey = "<S-Tab>",
            act_as_tab = true,
            completion = true,
            ignore_beginning = true,
            enable_backwards = true,
        })

        local function tab_complete()
            if cmp.visible() then
                return cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                return luasnip.expand_or_jump()
            elseif tabout.tabout() then
                return ""
            else
                return "\t"
            end
        end

        local function shift_tab_complete()
            if cmp.visible() then
                return cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                return luasnip.jump(-1)
            elseif tabout.tabout({ backwards = true }) then
                return ""
            else
                return "\b"
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
