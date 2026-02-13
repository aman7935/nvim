return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason-lspconfig.nvim",
        "nvimtools/none-ls.nvim",
    },
    config = function()
        vim.diagnostic.config({
            virtual_text = { prefix = "●", spacing = 2 },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "",
                    [vim.diagnostic.severity.WARN] = "",
                    [vim.diagnostic.severity.HINT] = "",
                    [vim.diagnostic.severity.INFO] = "",
                },
            },
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = { border = "rounded", source = "always" },
        })

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = { "documentation", "detail", "additionalTextEdits" },
        }
        capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true, noremap = true }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
            vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
        end

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            },
            pyright = {
                on_init = function(client)
                    local venv = vim.fn.finddir(".venv", client.config.root_dir .. ";")
                    if venv ~= "" then
                        client.config.settings.python.pythonPath = venv .. "/bin/python"
                    end
                end,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            },
            ruff = {},
            ts_ls = {},
            kotlin_language_server = {},
            jdtls = {
                cmd = { "jdtls" },
                root_dir = require("lspconfig.util").root_pattern(".git", "build.gradle", "pom.xml"),
            },
        }

        for name, config in pairs(servers) do
            config.capabilities = capabilities
            config.on_attach = on_attach

            if vim.lsp.config then
                vim.lsp.config(name, config)
            else
                require("lspconfig")[name].setup(config)
            end
        end

        local ok, null_ls = pcall(require, "null-ls")
        if ok then
            null_ls.setup({
                sources = {
                },
                on_attach = function(client, bufnr)
                    if client:supports_method("textDocument/formatting") then
                        local opts = { buffer = bufnr, silent = true, noremap = true }
                        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
                    end
                end,
            })
        end

        -- Removed default format on save to avoid conflicts with conform.nvim
        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --     pattern = "*",
        --     callback = function()
        --         vim.lsp.buf.format({ async = false })
        --     end,
        -- })
    end,
}
