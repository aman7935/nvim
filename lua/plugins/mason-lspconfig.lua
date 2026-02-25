return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
    },
    opts = {
        ensure_installed = {
            "lua_ls",
            "pyright",
            "basedpyright",
            "ts_ls",
            "kotlin_language_server",
            "jdtls",
        },
        automatic_installation = true,
    },
}
