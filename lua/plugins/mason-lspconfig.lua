return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
    },
    opts = function()
        local function pick_ts_server_name()
            local ok, configs = pcall(require, "lspconfig.configs")
            if ok then
                if configs.ts_ls then
                    return "ts_ls"
                end
                if configs.tsserver then
                    return "tsserver"
                end
            end
            return "tsserver"
        end

        local ts_server_name = pick_ts_server_name()

        local ensure_installed = {
            "lua_ls",
            "basedpyright",
            (ts_server_name == "ts_ls") and "ts_ls" or nil,
        }

        ensure_installed = vim.tbl_filter(function(value)
            return value ~= nil
        end, ensure_installed)

        return {
            ensure_installed = ensure_installed,
            automatic_installation = true,
        }
    end,
}

